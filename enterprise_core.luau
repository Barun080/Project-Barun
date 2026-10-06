--!strict
--!optimize 2
--!native

--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║      💎 PROJECT BARUN (PB) ENTERPRISE CORE ARCHITECTURE (LUAU v2.5)      ║
    ║        Engineered by cook45 for clack with Mimi Low-Level Engine         ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [CORE ARCHITECTURAL PILLARS]
    1. Adaptive Smart Slicing: Dynamic Frame-Budgeting with Priority Queues (Critical/Normal/Idle)
    2. Zero-Leak Weak Registry: Ephemeral Instance caching with __mode = "kv" metatables
    3. Transactional Token Lifecycle: ACID-like State Machine (Pending -> Committed | RolledBack)
    4. Resilient GamePass Cache: TTL Eviction + Live In-Session Re-evaluation & Hook Fallback
]]

local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer: Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ═══════════════════════════════════════════════════════════════════════════
-- TYPE DEFINITIONS
-- ═══════════════════════════════════════════════════════════════════════════

export type Priority = "Critical" | "Normal" | "Idle"

export type SliceTask = {
    Id: string,
    Priority: Priority,
    Callback: () -> (),
    CreatedAt: number,
    Deadline: number?,
}

export type TokenStatus = "Pending" | "Committed" | "RolledBack"

export type Transaction<T> = {
    Id: string,
    Status: TokenStatus,
    CreatedAt: number,
    Data: T,
    PreviousState: T?,
    Commit: (self: Transaction<T>) -> boolean,
    Rollback: (self: Transaction<T>, reason: string?) -> boolean,
}

export type GamePassCacheEntry = {
    HasPass: boolean,
    ExpiresAt: number,
    LastEvaluated: number,
}

export type EngineConfig = {
    BaseFrameBudget: number,        -- Target ms budget on 60 FPS (e.g., 0.006s = 6ms)
    MinFrameBudget: number,         -- Floor budget under heavy lag (e.g., 0.001s = 1ms)
    MaxFrameBudget: number,         -- Ceiling budget on 120+ FPS (e.g., 0.010s = 10ms)
    TargetFrameTime: number,        -- 1 / 60 = 0.01666s
    GamePassCacheTTL: number,       -- Cache duration in seconds before re-checking
    ModuleWeakRegistryMode: string, -- "__mode" for cache tables ("k" or "kv")
}

-- ═══════════════════════════════════════════════════════════════════════════
-- CONFIGURATION & ENVIRONMENT
-- ═══════════════════════════════════════════════════════════════════════════

local Config: EngineConfig = {
    BaseFrameBudget = 0.006,        -- 6ms
    MinFrameBudget = 0.001,         -- 1ms
    MaxFrameBudget = 0.012,         -- 12ms
    TargetFrameTime = 1 / 60,       -- 16.6ms
    GamePassCacheTTL = 60,          -- 60s live TTL
    ModuleWeakRegistryMode = "kv",  -- Ephemeral garbage-collected references
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 1. MEMORY LEAK PREVENTION (WEAK METATABLES & MODULE REGISTRY)
-- ═══════════════════════════════════════════════════════════════════════════

local WeakRegistry = {}
do
    local moduleCache: { [any]: any } = {}
    setmetatable(moduleCache, { __mode = Config.ModuleWeakRegistryMode })

    local instanceCache: { [Instance]: any } = {}
    setmetatable(instanceCache, { __mode = "k" }) -- Key-weak ensures instance release on Destroy

    function WeakRegistry.RegisterModule<T>(key: any, moduleData: T): T
        moduleCache[key] = moduleData
        return moduleData
    end

    function WeakRegistry.GetModule(key: any): any?
        return moduleCache[key]
    end

    function WeakRegistry.BindToInstance<T>(instance: Instance, stateData: T): T
        instanceCache[instance] = stateData
        return stateData
    end

    function WeakRegistry.GetInstanceBinding(instance: Instance): any?
        return instanceCache[instance]
    end

    function WeakRegistry.PurgeCollected()
        -- Metatable handles collection automatically, explicit collection pass trigger
        task.defer(function()
            collectgarbage("step", 100)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 2. ADAPTIVE SMART SLICING WITH PRIORITY QUEUES
-- ═══════════════════════════════════════════════════════════════════════════

local AdaptiveSlicer = {}
do
    local QueueCritical: { SliceTask } = {}
    local QueueNormal: { SliceTask }   = {}
    local QueueIdle: { SliceTask }     = {}

    local currentFrameBudget = Config.BaseFrameBudget
    local running = true

    -- Adaptive budget regulator: dynamically scales based on real-time deltaTime
    RunService.Heartbeat:Connect(function(dt: number)
        if not running then return end

        -- If frame time exceeds normal 60fps budget (heavy lag or thermal throttle), shrink budget
        local deltaRatio = Config.TargetFrameTime / math.max(dt, 0.0001)
        if deltaRatio < 0.85 then
            -- Severe frame drop: clamp down to floor budget to alleviate stutter
            currentFrameBudget = math.clamp(Config.BaseFrameBudget * deltaRatio, Config.MinFrameBudget, Config.BaseFrameBudget)
        elseif deltaRatio > 1.05 then
            -- High performance (e.g. 120hz or 144hz unlocked): allocate more slice headroom
            currentFrameBudget = math.clamp(Config.BaseFrameBudget * deltaRatio, Config.BaseFrameBudget, Config.MaxFrameBudget)
        else
            currentFrameBudget = Config.BaseFrameBudget
        end

        local frameStartTime = os.clock()

        -- Priority 1: Critical Tasks (Executed first, guaranteed execution)
        while #QueueCritical > 0 do
            local taskItem = table.remove(QueueCritical, 1)
            if taskItem then
                local ok, err = pcall(taskItem.Callback)
                if not ok then
                    warn(("[2SKI Slicer] Critical task [%s] panicked: %s"):format(taskItem.Id, tostring(err)))
                end
            end
            -- Yield only if critical exceeded 1.5x max budget
            if (os.clock() - frameStartTime) >= (currentFrameBudget * 1.5) then
                break
            end
        end

        -- Priority 2: Normal Tasks (Runs within adaptive slice budget)
        while #QueueNormal > 0 and (os.clock() - frameStartTime) < currentFrameBudget do
            local taskItem = table.remove(QueueNormal, 1)
            if taskItem then
                local ok, err = pcall(taskItem.Callback)
                if not ok then
                    warn(("[2SKI Slicer] Normal task [%s] panicked: %s"):format(taskItem.Id, tostring(err)))
                end
            end
        end

        -- Priority 3: Idle / Deferred Tasks (Runs strictly on residual budget)
        while #QueueIdle > 0 and (os.clock() - frameStartTime) < (currentFrameBudget * 0.9) do
            local taskItem = table.remove(QueueIdle, 1)
            if taskItem then
                local ok, err = pcall(taskItem.Callback)
                if not ok then
                    warn(("[2SKI Slicer] Idle task [%s] panicked: %s"):format(taskItem.Id, tostring(err)))
                end
            end
        end
    end)

    function AdaptiveSlicer.Enqueue(id: string, priority: Priority, callback: () -> (), deadline: number?): string
        local taskObj: SliceTask = {
            Id = id,
            Priority = priority,
            Callback = callback,
            CreatedAt = os.clock(),
            Deadline = deadline,
        }

        if priority == "Critical" then
            table.insert(QueueCritical, taskObj)
        elseif priority == "Idle" then
            table.insert(QueueIdle, taskObj)
        else
            table.insert(QueueNormal, taskObj)
        end

        return id
    end

    function AdaptiveSlicer.GetMetrics()
        return {
            CurrentBudgetMs = currentFrameBudget * 1000,
            PendingCritical = #QueueCritical,
            PendingNormal = #QueueNormal,
            PendingIdle = #QueueIdle,
        }
    end

    function AdaptiveSlicer.Destroy()
        running = false
        table.clear(QueueCritical)
        table.clear(QueueNormal)
        table.clear(QueueIdle)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 3. TRANSACTIONAL TOKEN LIFECYCLE & RECONCILIATION
-- ═══════════════════════════════════════════════════════════════════════════

local TokenManager = {}
do
    local activeTransactions: { [string]: Transaction<any> } = {}
    local activeTokens: { [string]: number } = {}

    -- Deep clone for state snapshots
    local function cloneState<T>(orig: T): T
        if type(orig) ~= "table" then return orig end
        local copy = {}
        for k, v in pairs(orig :: any) do
            copy[k] = cloneState(v)
        end
        return copy :: any
    end

    function TokenManager.CreateTransaction<T>(id: string, initialData: T): Transaction<T>
        local txn: Transaction<T> = {
            Id = id,
            Status = "Pending",
            CreatedAt = os.clock(),
            Data = initialData,
            PreviousState = cloneState(initialData),
            Commit = function(self)
                if self.Status ~= "Pending" then
                    warn(("[TokenManager] Cannot commit transaction [%s] in status: %s"):format(self.Id, self.Status))
                    return false
                end
                self.Status = "Committed"
                self.PreviousState = nil
                activeTransactions[self.Id] = nil
                return true
            end,
            Rollback = function(self, reason)
                if self.Status ~= "Pending" then
                    warn(("[TokenManager] Cannot rollback transaction [%s] in status: %s"):format(self.Id, self.Status))
                    return false
                end
                self.Status = "RolledBack"
                if self.PreviousState ~= nil then
                    self.Data = cloneState(self.PreviousState)
                end
                warn(("[TokenManager] Transaction [%s] RolledBack: %s"):format(self.Id, tostring(reason or "Manual abort")))
                activeTransactions[self.Id] = nil
                return true
            end,
        }

        activeTransactions[id] = txn
        return txn
    end

    function TokenManager.GetTransaction(id: string): Transaction<any>?
        return activeTransactions[id]
    end

    function TokenManager.GenerateToken(namespace: string): (number, () -> boolean)
        local token = os.clock()
        activeTokens[namespace] = token

        local function isValid(): boolean
            return activeTokens[namespace] == token
        end

        return token, isValid
    end

    function TokenManager.InvalidateNamespace(namespace: string)
        activeTokens[namespace] = nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 4. RESILIENT LIVE GAMEPASS CACHE & HOOK
-- ═══════════════════════════════════════════════════════════════════════════

local GamePassManager = {}
do
    local passCache: { [number]: GamePassCacheEntry } = {}
    local simulatedPasses: { [number]: boolean } = {}

    function GamePassManager.SetSimulatedPass(passId: number, state: boolean)
        simulatedPasses[passId] = state
        -- Invalidate cached entry so it reads simulated immediately
        passCache[passId] = nil
    end

    function GamePassManager.UserOwnsPassAsync(passId: number, bypassCache: boolean?): boolean
        -- 1. Check Developer / GamePass Hook Simulation
        if simulatedPasses[passId] ~= nil then
            return simulatedPasses[passId]
        end

        local now = os.clock()
        local cached = passCache[passId]

        -- 2. Validate TTL Cache
        if not bypassCache and cached and now < cached.ExpiresAt then
            return cached.HasPass
        end

        -- 3. Live Marketplace Query with Defensive pcall
        local ownsPass = false
        local success, result = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, passId)
        end)

        if success and type(result) == "boolean" then
            ownsPass = result
        else
            -- Fallback to last known cached state if network failed
            if cached then
                warn(("[GamePassManager] Marketplace query failed for [%d], falling back to cached state"):format(passId))
                ownsPass = cached.HasPass
            else
                warn(("[GamePassManager] Marketplace query failed for [%d] and no cache available"):format(passId))
                ownsPass = false
            end
        end

        -- 4. Store fresh TTL Cache Entry
        passCache[passId] = {
            HasPass = ownsPass,
            ExpiresAt = now + Config.GamePassCacheTTL,
            LastEvaluated = now,
        }

        return ownsPass
    end

    function GamePassManager.InvalidatePass(passId: number)
        passCache[passId] = nil
    end

    function GamePassManager.FlushAll()
        table.clear(passCache)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 5. PUBLIC CORE INTERFACE
-- ═══════════════════════════════════════════════════════════════════════════

local Core = {
    Config = Config,
    Registry = WeakRegistry,
    Slicer = AdaptiveSlicer,
    Tokens = TokenManager,
    GamePass = GamePassManager,
}

print("[Project Barun Core] ⚡ Enterprise Data-Driven Engine v2.5 Initialized Successfully.")
return Core
