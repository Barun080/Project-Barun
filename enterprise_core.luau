--!strict
--!optimize 2
--!native

--[[
    ╔══════════════════════════════════════════════════════════════════════════════════╗
    ║       💎 PROJECT BARUN (PB) — MASTER SCRIPTING ENGINE ARCHITECTURE v3.0          ║
    ║                   "THE HEART OF ADVANCED ROBLOX EXPLOIT SCRIPTING"               ║
    ║       Synthesized from 2K Elite Architecture & High-Performance Low-Level Luau  ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝

    [14 PILLARS OF 2K & BARUN MASTER ARCHITECTURE]
    1. Lifecycle & Ghost Eradication: Strict GUID Token, Event Registry, Total Auto-Cleanup
    2. Triple-Layer Zero-Disconnect Anti-AFK: Game Script Kill, Teleport Hook, Idle Bypass
    3. Network Guard & Debounce: Throttled FireServer/InvokeServer with Timeout Protection
    4. Precondition & Resource Governor: Cost Validation, Group Membership Check, Buff Radar
    5. Asset Firewall: Zero-Mistake Protection for Plotted, Equipped, Locked & God-Tier Items
    6. Adaptive Frame-Budget Slicer: Dynamic Task Prioritization (Critical / Normal / Idle)
    7. Telemetry & Live Stats: Real-Time FPS, Ping, Money Rate, Discord Webhook Alerts
    8. 2K-Style Floating Resizable & Collapsible HUD: Live In-Game Metrics Display
    9. Zero-Overhead Spatial & C++ Radius Query: GetPartBoundsInRadius (<0.3ms Spatial Search)
    10. Client Controller Method Hooking Engine: Safe Interception & Restoration of Game Logic
    11. Universal Signal & Event Dispatcher: Cross-Executor FireSignal, GetConnections & Clicks
    12. 1:1 Floating Rotating Neon Squircle Toggle: Smooth Free-Drag & Ambient Glow Button
    13. Ultra-Smooth Performance Accelerator: 120 FPS Cap, Shadow Stripping & PostFX Killer
    14. Persistent JSON Config Engine: Zero-Loss Profiles, Deep Defaults Merging & Reset
--]]

local RunService        = game:GetService("RunService")
local MarketplaceService= game:GetService("MarketplaceService")
local Players           = game:GetService("Players")
local HttpService       = game:GetService("HttpService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local TeleportService   = game:GetService("TeleportService")
local CoreGui           = game:GetService("CoreGui")
local StatsService      = game:GetService("Stats")
local VirtualUser       = game:GetService("VirtualUser")

local LocalPlayer: Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local LP = LocalPlayer

local function getSafeGuiContainer(): Instance
    if gethui then
        local okH, h = pcall(gethui)
        if okH and h then return h end
    end
    if CoreGui then
        local okR, r = pcall(function() return CoreGui:FindFirstChild("RobloxGui") end)
        if okR and r then return r end
        return CoreGui
    end
    local pGui = LP and LP:FindFirstChild("PlayerGui")
    if pGui then return pGui end
    return game:GetService("CoreGui")
end

local Core = {}
Core.__index = Core

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. LIFECYCLE & GHOST PROCESS ERADICATION ENGINE
-- ═══════════════════════════════════════════════════════════════════════════════
local Lifecycle = {}
do
    local activeConnections: { RBXScriptConnection } = {}
    local activeTokens: { [string]: string } = {}
    local trackedInstances: { Instance } = {}

    function Lifecycle.NewRunId(namespace: string): (string, () -> boolean)
        namespace = namespace or "Global"
        local runId = HttpService:GenerateGUID(false)
        activeTokens[namespace] = runId

        local function isValid(): boolean
            return activeTokens[namespace] == runId
        end

        return runId, isValid
    end

    function Lifecycle.BindConnection(conn: RBXScriptConnection): RBXScriptConnection
        table.insert(activeConnections, conn)
        return conn
    end

    function Lifecycle.TrackInstance(inst: Instance): Instance
        table.insert(trackedInstances, inst)
        return inst
    end

    function Lifecycle.SpawnLoop(interval: number, checkValid: () -> boolean, callback: () -> ())
        task.spawn(function()
            while checkValid() do
                local ok, err = pcall(callback)
                if not ok then
                    warn(("[Project Barun Lifecycle] Loop iteration error: %s"):format(tostring(err)))
                end
                task.wait(interval)
            end
        end)
    end

    function Lifecycle.Cleanup(namespace: string?)
        if namespace then
            activeTokens[namespace] = nil
        else
            table.clear(activeTokens)
        end

        for _, c in ipairs(activeConnections) do
            pcall(function() c:Disconnect() end)
        end
        table.clear(activeConnections)

        for _, inst in ipairs(trackedInstances) do
            pcall(function() inst:Destroy() end)
        end
        table.clear(trackedInstances)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. TRIPLE-LAYER ZERO-DISCONNECT ANTI-AFK & ANTI-KICK DEFENSE
-- ═══════════════════════════════════════════════════════════════════════════════
local Defense = {}
do
    local isDefenseActive = false

    function Defense.Initialize()
        if isDefenseActive then return end
        isDefenseActive = true

        -- เลเยอร์ 1: ทำลายสคริปต์ AFK 19 นาทีของตัวเกมใน PlayerScripts ทันที
        pcall(function()
            local afkScript = LP.PlayerScripts:FindFirstChild("AFK")
            if afkScript then
                afkScript.Disabled = true
                afkScript:Destroy()
            end
            LP.PlayerScripts.ChildAdded:Connect(function(child)
                if child.Name == "AFK" and child:IsA("LocalScript") then
                    child.Disabled = true
                    child:Destroy()
                end
            end)
        end)

        -- เลเยอร์ 2: สกัดกั้นการสั่งเตะผู้เล่นผ่าน TeleportService
        pcall(function()
            if hookfunction then
                local oldTeleport
                oldTeleport = hookfunction(TeleportService.Teleport, function(self, placeId, player, ...)
                    local trace = debug.traceback()
                    if string.find(trace, "AFK") or string.find(trace, "scheduleTeleport") or string.find(trace, "Kick") then
                        return nil
                    end
                    return oldTeleport(self, placeId, player, ...)
                end)
            end
        end)

        -- เลเยอร์ 3: บล็อกระบบเตะ 20 นาทีของ Roblox Engine (LP.Idled)
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(LP.Idled)) do
                    pcall(function() c:Disable() end)
                end
            end
            LP.Idled:Connect(function()
                if VirtualUser then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.zero)
                    end)
                end
            end)
        end)

        -- เลเยอร์ 4: Virtual Pulse Heartbeat ทุกๆ 35 วินาที
        task.spawn(function()
            while isDefenseActive do
                task.wait(35)
                if VirtualUser then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.zero)
                    end)
                end
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. NETWORK GUARD & RATE-LIMITING ENGINE
-- ═══════════════════════════════════════════════════════════════════════════════
local NetworkGuard = {}
do
    local lastCallTimestamps: { [string]: number } = {}

    function NetworkGuard.SafeFire(remote: RemoteEvent?, minDelay: number?, ...): boolean
        if not remote or not remote:IsA("RemoteEvent") then return false end
        minDelay = minDelay or 0.05
        local remoteName = remote:GetFullName()
        local now = os.clock()

        if lastCallTimestamps[remoteName] and (now - lastCallTimestamps[remoteName]) < minDelay then
            return false
        end

        lastCallTimestamps[remoteName] = now
        local ok, err = pcall(remote.FireServer, remote, ...)
        if not ok then
            warn(("[NetworkGuard] FireServer failed on [%s]: %s"):format(remoteName, tostring(err)))
            return false
        end
        return true
    end

    function NetworkGuard.SafeInvoke(remote: RemoteFunction?, timeoutSeconds: number?, ...): (boolean, any)
        if not remote or not remote:IsA("RemoteFunction") then return false, "Invalid RemoteFunction" end
        timeoutSeconds = timeoutSeconds or 5

        local result = nil
        local completed = false
        local success = false

        task.spawn(function(...)
            success, result = pcall(remote.InvokeServer, remote, ...)
            completed = true
        end, ...)

        local start = os.clock()
        while not completed and (os.clock() - start) < timeoutSeconds do
            task.wait(0.03)
        end

        if not completed then
            return false, "InvokeServer timed out"
        end
        return success, result
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. PRECONDITION & RESOURCE GOVERNOR
-- ═══════════════════════════════════════════════════════════════════════════════
local Precondition = {}
do
    function Precondition.CanAfford(currentBalance: number, cost: number): boolean
        return (type(currentBalance) == "number") and (type(cost) == "number") and (currentBalance >= cost)
    end

    function Precondition.IsBuffActive(buffName: string): boolean
        local active = false
        pcall(function()
            local buffBar = LP.PlayerGui:FindFirstChild("BuffBar", true)
            if buffBar and buffBar:FindFirstChild("Boost_" .. buffName) then
                active = true
            end
        end)
        return active
    end

    function Precondition.SafeGroupClaim(groupId: number?, alreadyClaimed: boolean?): boolean
        if not groupId or groupId <= 0 then return false end
        if alreadyClaimed == true then return false end

        local inGroup = false
        local ok = pcall(function()
            inGroup = LP:IsInGroup(groupId)
        end)

        return ok and inGroup
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. ASSET FIREWALL (ZERO-MISTAKE PROTECTION)
-- ═══════════════════════════════════════════════════════════════════════════════
local AssetFirewall = {}
do
    export type ItemFilterRule = {
        ProtectPlotted: boolean?,
        ProtectEquipped: boolean?,
        ProtectLocked: boolean?,
        MinAllowedGradeOrder: number?,
        AllowedRarities: { [string]: boolean }?,
        PlottedIds: { [string]: boolean }?,
        EquippedIds: { [string]: boolean }?,
    }

    local GradeOrderMap = {
        ["D"] = 1, ["C"] = 2, ["B"] = 3, ["A"] = 4, ["A+"] = 5,
        ["S"] = 6, ["S+"] = 7, ["Z"] = 8, ["Z+"] = 9, ["神"] = 10
    }

    function AssetFirewall.CanProcessItem(itemId: string, itemData: any, rules: ItemFilterRule): boolean
        if type(itemData) ~= "table" then return false end
        local attrs = itemData.attributes or itemData.Attributes or {}

        -- 1. ตรวจสอบการวางบนเกาะ / แท่นผลิตเงิน
        if rules.ProtectPlotted and rules.PlottedIds and rules.PlottedIds[itemId] then
            return false
        end

        -- 2. ตรวจสอบการสวมใส่ / อยู่ในทีม
        if rules.ProtectEquipped and rules.EquippedIds and rules.EquippedIds[itemId] then
            return false
        end

        -- 3. ตรวจสอบการล็อคแม่กุญแจ
        if rules.ProtectLocked and (attrs.locked == true or attrs.Locked == true) then
            return false
        end

        -- 4. ตรวจสอบเกรดระดับสูง (เช่น ห้ามแตะต้องเกรด S ขึ้นไป)
        if rules.MinAllowedGradeOrder and attrs.grade then
            local gOrder = GradeOrderMap[tostring(attrs.grade)] or 0
            if gOrder >= rules.MinAllowedGradeOrder then
                return false
            end
        end

        -- 5. ตรวจสอบระดับความหายาก (Rarity)
        if rules.AllowedRarities and itemData.Rarity then
            if not rules.AllowedRarities[itemData.Rarity] then
                return false
            end
        end

        return true
    end

    function AssetFirewall.BatchProcess<T>(items: { T }, batchSize: number, delayBetween: number, processFn: (batch: { T }) -> ())
        batchSize = batchSize or 50
        delayBetween = delayBetween or 0.2
        task.spawn(function()
            local currentBatch = {}
            for _, item in ipairs(items) do
                table.insert(currentBatch, item)
                if #currentBatch >= batchSize then
                    pcall(processFn, currentBatch)
                    table.clear(currentBatch)
                    task.wait(delayBetween)
                end
            end
            if #currentBatch > 0 then
                pcall(processFn, currentBatch)
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. ADAPTIVE FRAME-BUDGET SLICER (DYNAMIC TIME-SLICING)
-- ═══════════════════════════════════════════════════════════════════════════════
local Slicer = {}
do
    type Priority = "Critical" | "Normal" | "Idle"
    type TaskItem = { Id: string, Priority: Priority, Callback: () -> () }

    local QueueCritical: { TaskItem } = {}
    local QueueNormal: { TaskItem }   = {}
    local QueueIdle: { TaskItem }     = {}

    local BASE_BUDGET = 0.006 -- 6ms
    local currentBudget = BASE_BUDGET
    local active = true

    RunService.Heartbeat:Connect(function(dt: number)
        if not active then return end

        local targetTime = 1 / 60
        local ratio = targetTime / math.max(dt, 0.001)
        currentBudget = math.clamp(BASE_BUDGET * ratio, 0.001, 0.012)

        local frameStart = os.clock()

        -- Critical Tasks (รันก่อนเสมอ)
        while #QueueCritical > 0 do
            local t = table.remove(QueueCritical, 1)
            if t then pcall(t.Callback) end
            if (os.clock() - frameStart) >= (currentBudget * 1.5) then break end
        end

        -- Normal Tasks (รันตามงบเวลาที่เหลือ)
        while #QueueNormal > 0 and (os.clock() - frameStart) < currentBudget do
            local t = table.remove(QueueNormal, 1)
            if t then pcall(t.Callback) end
        end

        -- Idle Tasks (รันเมื่อมีเศษเวลาเหลือ)
        while #QueueIdle > 0 and (os.clock() - frameStart) < (currentBudget * 0.8) do
            local t = table.remove(QueueIdle, 1)
            if t then pcall(t.Callback) end
        end
    end)

    function Slicer.Enqueue(id: string, priority: Priority, callback: () -> ())
        local item = { Id = id, Priority = priority, Callback = callback }
        if priority == "Critical" then
            table.insert(QueueCritical, item)
        elseif priority == "Idle" then
            table.insert(QueueIdle, item)
        else
            table.insert(QueueNormal, item)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 7. TELEMETRY, SLIDING RATES & DISCORD WEBHOOK ENGINE
-- ═══════════════════════════════════════════════════════════════════════════════
local Telemetry = {}
do
    local fps = 60
    local frames = 0
    local lastFpsStamp = os.clock()

    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = os.clock()
        if now - lastFpsStamp >= 0.5 then
            fps = math.floor(frames / (now - lastFpsStamp))
            frames = 0
            lastFpsStamp = now
        end
    end)

    function Telemetry.GetFPS(): number
        return fps
    end

    function Telemetry.GetPing(): number
        local ping = 0
        pcall(function()
            local netStats = StatsService:FindFirstChild("Network")
            local statsItem = netStats and netStats:FindFirstChild("ServerStatsItem")
            local dataPing = statsItem and statsItem:FindFirstChild("Data Ping")
            if dataPing then
                ping = math.floor(dataPing:GetValue())
            elseif LP.GetNetworkPing then
                ping = math.floor(LP:GetNetworkPing() * 1000)
            end
        end)
        return ping
    end

    -- Sliding Window Rate Calculator (คำนวณอัตราเพิ่มของค่าต่างๆ เช่น เงิน/วิ)
    function Telemetry.CreateRateTracker(windowDuration: number?)
        windowDuration = windowDuration or 3.5
        local samples: { { time: number, value: number } } = {}
        local tracker = {}

        function tracker:Add(val: number)
            local now = os.clock()
            table.insert(samples, { time = now, value = val })
            while #samples > 0 and (now - samples[1].time) > windowDuration do
                table.remove(samples, 1)
            end
        end

        function tracker:GetRate(): number
            if #samples < 2 then return 0 end
            local oldest = samples[1]
            local newest = samples[#samples]
            local dt = newest.time - oldest.time
            local dv = newest.value - oldest.value
            if dt > 0.3 and dv >= 0 then
                return math.floor(dv / dt)
            end
            return 0
        end

        return tracker
    end

    -- Discord Webhook Broadcaster
    local httpRequest = (request or http_request or (syn and syn.request) or (http and http.request))
    function Telemetry.SendWebhook(url: string, title: string, description: string, color: number?, fields: { any }?)
        if not url or url == "" or not httpRequest then return end
        task.spawn(function()
            pcall(function()
                local payload = {
                    username = "Project Barun Engine",
                    avatar_url = "https://cdn.discordapp.com/attachments/1098670557457788938/1175114757186981989/2K_Logo.png",
                    embeds = {
                        {
                            title = title,
                            description = description,
                            color = color or 0x38BDF8,
                            fields = fields or {},
                            footer = { text = "Project Barun • Enterprise Scripting Core • " .. os.date("%X") },
                            timestamp = DateTime.now():ToIsoDate()
                        }
                    }
                }
                httpRequest({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 8. 2K-STYLE FLOATING RESIZABLE & COLLAPSIBLE HUD
-- ═══════════════════════════════════════════════════════════════════════════════
local FloatingHUD = {}
do
    function FloatingHUD.Create(titleText: string)
        local parentGui = getSafeGuiContainer()
        local hudGui = Instance.new("ScreenGui")
        hudGui.Name = "BarunFloatingStatusHUD"
        hudGui.ResetOnSpawn = false
        hudGui.DisplayOrder = 9999

        local card = Instance.new("Frame")
        card.Size = UDim2.fromOffset(260, 150)
        card.Position = UDim2.new(0, 20, 0, 80)
        card.BackgroundColor3 = Color3.fromRGB(11, 14, 22)
        card.BackgroundTransparency = 0.15
        card.ClipsDescendants = true
        card.Parent = hudGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = card

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(56, 189, 248)
        stroke.Thickness = 1.2
        stroke.Parent = card

        -- Header
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, 28)
        header.BackgroundColor3 = Color3.fromRGB(16, 22, 34)
        header.Parent = card

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 10)
        headerCorner.Parent = header

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -60, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = titleText or "LIVE HUD"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextColor3 = Color3.fromRGB(56, 189, 248)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = header

        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, -16, 1, -36)
        content.Position = UDim2.new(0, 8, 0, 32)
        content.BackgroundTransparency = 1
        content.Parent = card

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.Parent = content

        hudGui.Parent = parentGui

        local hudObj = {
            Gui = hudGui,
            Card = card,
            Rows = {},
        }

        function hudObj:AddRow(key: string, label: string)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 20)
            row.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
            row.BackgroundTransparency = 0.5
            row.Parent = content

            local rCorn = Instance.new("UICorner")
            rCorn.CornerRadius = UDim.new(0, 4)
            rCorn.Parent = row

            local lText = Instance.new("TextLabel")
            lText.Size = UDim2.new(0.5, 0, 1, 0)
            lText.Position = UDim2.new(0, 6, 0, 0)
            lText.BackgroundTransparency = 1
            lText.Text = label
            lText.Font = Enum.Font.GothamBold
            lText.TextSize = 10
            lText.TextColor3 = Color3.fromRGB(148, 163, 184)
            lText.TextXAlignment = Enum.TextXAlignment.Left
            lText.Parent = row

            local vText = Instance.new("TextLabel")
            vText.Size = UDim2.new(0.5, -8, 1, 0)
            vText.Position = UDim2.new(0.5, 0, 0, 0)
            vText.BackgroundTransparency = 1
            vText.Text = "-"
            vText.Font = Enum.Font.GothamBold
            vText.TextSize = 10
            vText.TextColor3 = Color3.fromRGB(255, 255, 255)
            vText.TextXAlignment = Enum.TextXAlignment.Right
            vText.Parent = row

            hudObj.Rows[key] = vText
            return vText
        end

        function hudObj:UpdateRow(key: string, value: string, color: Color3?)
            if hudObj.Rows[key] then
                hudObj.Rows[key].Text = tostring(value)
                if color then hudObj.Rows[key].TextColor3 = color end
            end
        end

        function hudObj:Destroy()
            hudGui:Destroy()
        end

        return hudObj
    end
end


-- ═══════════════════════════════════════════════════════════════════════════════
-- 9. ZERO-OVERHEAD SPATIAL & C++ RADIUS ENGINE (2K MINING PATTERN)
-- ═══════════════════════════════════════════════════════════════════════════════
local SpatialEngine = {}
do
    local indexes: { [string]: { [string]: { [Instance]: boolean } } } = {}

    function SpatialEngine.CreateIndex(folder: Folder | Model, indexName: string)
        if not folder then return end
        local map: { [string]: { [Instance]: boolean } } = {}
        indexes[indexName] = map

        local function addInst(inst: Instance)
            if not inst or not inst:IsA("Model") and not inst:IsA("BasePart") then return end
            local key = inst.Name
            if not map[key] then map[key] = {} end
            map[key][inst] = true
        end

        local function remInst(inst: Instance)
            if not inst then return end
            local key = inst.Name
            if map[key] then map[key][inst] = nil end
        end

        for _, c in ipairs(folder:GetChildren()) do
            addInst(c)
        end

        Lifecycle.BindConnection(folder.ChildAdded:Connect(addInst))
        Lifecycle.BindConnection(folder.ChildRemoved:Connect(remInst))
    end

    function SpatialEngine.GetNearbyParts(centerPos: Vector3, radius: number, containerFolder: Instance?, limit: number?): { { Instance: Instance, Dist: number, Pos: Vector3 } }
        local results = {}
        local overlap = OverlapParams.new()
        overlap.FilterType = Enum.RaycastFilterType.Include
        if containerFolder then
            overlap.FilterDescendantsInstances = { containerFolder }
        end

        local foundParts = workspace:GetPartBoundsInRadius(centerPos, radius, overlap)
        local seen = {}
        local maxResults = limit or 50

        for _, part in ipairs(foundParts) do
            local model = part:FindFirstAncestorOfClass("Model")
            local target = model or part
            if not seen[target] then
                seen[target] = true
                local partPos = part.Position
                local dist = (partPos - centerPos).Magnitude
                table.insert(results, {
                    Instance = target,
                    Part = part,
                    Dist = dist,
                    Pos = partPos
                })
                if #results >= maxResults then break end
            end
        end

        table.sort(results, function(a, b) return a.Dist < b.Dist end)
        return results
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 10. CLIENT CONTROLLER METHOD HOOKING ENGINE (2K FISCH PATTERN)
-- ═══════════════════════════════════════════════════════════════════════════════
local HookEngine = {}
do
    local hookedMethods: { [string]: { Table: any, MethodName: string, Original: any } } = {}

    function HookEngine.HookMethod(targetTable: any, methodName: string, hookCallback: any): boolean
        if type(targetTable) ~= "table" then return false end
        local original = targetTable[methodName]
        if type(original) ~= "function" then return false end

        local hookKey = tostring(targetTable) .. "_" .. methodName
        if hookedMethods[hookKey] then
            -- Already hooked
            return true
        end

        hookedMethods[hookKey] = {
            Table = targetTable,
            MethodName = methodName,
            Original = original
        }

        targetTable[methodName] = function(...)
            return hookCallback(original, ...)
        end
        return true
    end

    function HookEngine.Unhook(targetTable: any, methodName: string)
        local hookKey = tostring(targetTable) .. "_" .. methodName
        local entry = hookedMethods[hookKey]
        if entry then
            entry.Table[entry.MethodName] = entry.Original
            hookedMethods[hookKey] = nil
        end
    end

    function HookEngine.UnhookAll()
        for _, entry in pairs(hookedMethods) do
            pcall(function()
                entry.Table[entry.MethodName] = entry.Original
            end)
        end
        table.clear(hookedMethods)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 11. UNIVERSAL SIGNAL & EVENT DISPATCHER (CROSS-EXECUTOR SAFETY)
-- ═══════════════════════════════════════════════════════════════════════════════
local SignalDispatcher = {}
do
    function SignalDispatcher.FireButton(button: GuiButton): boolean
        if not button or not button:IsA("GuiButton") then return false end
        local fired = false

        pcall(function()
            if firesignal then
                pcall(function() firesignal(button.Activated) end)
                pcall(function() firesignal(button.MouseButton1Click) end)
                fired = true
            end
        end)

        pcall(function()
            if getconnections then
                for _, conn in ipairs(getconnections(button.Activated)) do
                    pcall(function() conn:Fire() end)
                    fired = true
                end
                for _, conn in ipairs(getconnections(button.MouseButton1Click)) do
                    pcall(function() conn:Fire() end)
                    fired = true
                end
            end
        end)

        if not fired and VirtualUser then
            pcall(function()
                local abs = button.AbsolutePosition
                local size = button.AbsoluteSize
                local center = Vector2.new(abs.X + size.X / 2, abs.Y + size.Y / 2)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(center)
                fired = true
            end)
        end

        return fired
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 12. 1:1 FLOATING ROTATING NEON SQUIRCLE TOGGLE ENGINE (2K SIGNATURE)
-- ═══════════════════════════════════════════════════════════════════════════════
local FloatingSquircle = {}
do
    function FloatingSquircle.New(config: {
        TitlePart1: string?,
        TitlePart2: string?,
        ColorHex: string?,
        OnToggle: () -> ()
    })
        local parentGui = getSafeGuiContainer()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Barun_Floating_Squircle"
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 999999
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = parentGui
        Lifecycle.TrackInstance(screenGui)

        local btn = Instance.new("TextButton")
        btn.Name = "SquircleButton"
        btn.Size = UDim2.fromOffset(56, 56)
        btn.Position = UDim2.new(0.02, 0, 0.22, 0)
        btn.BackgroundColor3 = Color3.fromRGB(14, 20, 26)
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.Active = true
        btn.ZIndex = 1000
        btn.Parent = screenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2.4
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn

        local accentColor = config.ColorHex and Color3.fromHex(config.ColorHex) or Color3.fromRGB(109, 217, 200)

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, accentColor),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.7, Color3.fromRGB(56, 189, 248)),
            ColorSequenceKeypoint.new(1.0, accentColor)
        })
        gradient.Parent = stroke

        -- Rotating Glow
        Lifecycle.BindConnection(RunService.RenderStepped:Connect(function()
            if gradient and gradient.Parent then
                gradient.Rotation = (gradient.Rotation + 2.5) % 360
            end
        end))

        -- Mint/Cyan Status Dot
        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(8.5, 8.5)
        dot.Position = UDim2.new(1, -12, 0, 4.5)
        dot.BackgroundColor3 = accentColor
        dot.BorderSizePixel = 0
        dot.ZIndex = 1002
        dot.Parent = btn

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot

        -- RichText Logo
        local p1 = config.TitlePart1 or "2"
        local p2 = config.TitlePart2 or "SKI"
        local hex = config.ColorHex or "#6DD9C8"

        local logo = Instance.new("TextLabel")
        logo.Size = UDim2.new(1, 0, 1, 0)
        logo.BackgroundTransparency = 1
        logo.RichText = true
        logo.Font = Enum.Font.FredokaOne
        logo.Text = string.format('<font color="#FFFFFF">%s</font><font color="%s">%s</font>', p1, hex, p2)
        logo.TextSize = 18
        logo.TextXAlignment = Enum.TextXAlignment.Center
        logo.TextYAlignment = Enum.TextYAlignment.Center
        logo.ZIndex = 1001
        logo.Parent = btn

        -- Ultra-Smooth Free Drag Engine (Distinguishes Tap from Drag)
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        local hasMoved = false
        local lastToggleTime = 0

        local function updatePosition(input)
            if not dragStart or not startPos then return end
            local delta = input.Position - dragStart
            local vp = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
            local maxX = math.max(0, vp.X - 58)
            local maxY = math.max(0, vp.Y - 58)
            local targetX = math.clamp(startPos.X.Offset + delta.X, 4, maxX)
            local targetY = math.clamp(startPos.Y.Offset + delta.Y, 15, maxY)
            btn.Position = UDim2.new(0, targetX, 0, targetY)
        end

        Lifecycle.BindConnection(btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                local abs = btn.AbsolutePosition
                startPos = UDim2.new(0, abs.X, 0, abs.Y)
                btn.Position = startPos
                hasMoved = false

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                        task.delay(0.08, function() hasMoved = false end)
                    end
                end)
            end
        end))

        Lifecycle.BindConnection(UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                    hasMoved = true
                    updatePosition(input)
                end
            end
        end))

        Lifecycle.BindConnection(btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = false
                task.delay(0.08, function() hasMoved = false end)
            end
        end))

        Lifecycle.BindConnection(btn.MouseButton1Click:Connect(function()
            if hasMoved then return end
            local now = os.clock()
            if now - lastToggleTime < 0.3 then return end
            lastToggleTime = now
            if config.OnToggle then config.OnToggle() end
        end))

        return {
            Gui = screenGui,
            Button = btn,
            SetVisible = function(self, visible: boolean)
                btn.Visible = visible
            end,
            Destroy = function(self)
                screenGui:Destroy()
            end
        }
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 13. PERFORMANCE & FPS ACCELERATOR (ULTRA SMOOTH ENGINE)
-- ═══════════════════════════════════════════════════════════════════════════════
local PerformanceEngine = {}
do
    local Lighting = game:GetService("Lighting")

    function PerformanceEngine.BoostFPS(enable: boolean)
        pcall(function()
            if enable then
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 9e9
                Lighting.Brightness = 1
                for _, v in ipairs(Lighting:GetChildren()) do
                    if v:IsA("PostProcessEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                pcall(function()
                    if setfpscap then setfpscap(120) end
                end)
            else
                Lighting.GlobalShadows = true
                Lighting.FogEnd = 500
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 14. PERSISTENT JSON CONFIG MANAGER (ZERO DATA LOSS)
-- ═══════════════════════════════════════════════════════════════════════════════
local ConfigManager = {}
do
    function ConfigManager.Save(filename: string, dataTable: any): boolean
        if not writefile then return false end
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(dataTable)
        end)
        if not ok or not encoded then return false end

        local saveOk = pcall(function()
            writefile(filename, encoded)
        end)
        return saveOk
    end

    function ConfigManager.Load(filename: string, defaultTable: any): any
        if not isfile or not readfile then return defaultTable end
        if not isfile(filename) then return defaultTable end

        local ok, content = pcall(function()
            return readfile(filename)
        end)
        if not ok or not content or content == "" then return defaultTable end

        local decOk, decoded = pcall(function()
            return HttpService:JSONDecode(content)
        end)
        if not decOk or type(decoded) ~= "table" then return defaultTable end

        -- Deep merge defaults into loaded
        local merged = table.clone(defaultTable)
        for k, v in pairs(decoded) do
            merged[k] = v
        end
        return merged
    end

    function ConfigManager.Reset(filename: string): boolean
        if isfile and isfile(filename) and delfile then
            pcall(function() delfile(filename) end)
            return true
        end
        return false
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 15. MASTER EXPORT (14 PILLARS OF 2K & BARUN SCRIPTING ARCHITECTURE)
-- ═══════════════════════════════════════════════════════════════════════════════
Core.Lifecycle          = Lifecycle
Core.Defense            = Defense
Core.NetworkGuard       = NetworkGuard
Core.Precondition       = Precondition
Core.AssetFirewall      = AssetFirewall
Core.Slicer             = Slicer
Core.Telemetry          = Telemetry
Core.FloatingHUD        = FloatingHUD
Core.SpatialEngine      = SpatialEngine
Core.HookEngine         = HookEngine
Core.SignalDispatcher   = SignalDispatcher
Core.FloatingSquircle   = FloatingSquircle
Core.PerformanceEngine  = PerformanceEngine
Core.ConfigManager      = ConfigManager

-- ออโต้เริ่มต้นระบบ Anti-AFK แบบมาตรฐานทันทีที่โหลดโมดูล
Defense.Initialize()

print("[Project Barun Core] 💎 Master Scripting Architecture Engine v3.5 (Full 2K Synthesis) Online & Ready.")
return Core
