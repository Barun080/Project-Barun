--!strict
--!optimize 2
--!native

--[[
    ╔══════════════════════════════════════════════════════════════════════════════════╗
    ║       💎 PROJECT BARUN (PB) — MASTER SCRIPTING ENGINE ARCHITECTURE v3.0          ║
    ║                   "THE HEART OF ADVANCED ROBLOX EXPLOIT SCRIPTING"               ║
    ║       Synthesized from 2K Elite Architecture & High-Performance Low-Level Luau  ║
    ╚══════════════════════════════════════════════════════════════════════════════════╝

    [7 PILLARS OF 2K & BARUN ENGINE]
    1. Lifecycle & Ghost Eradication: Strict GUID Token, Event Registry, Total Auto-Cleanup
    2. Triple-Layer Zero-Disconnect Anti-AFK: Game Script Kill, Teleport Hook, Idle Bypass
    3. Network Guard & Debounce: Throttled FireServer/InvokeServer with Timeout Protection
    4. Precondition & Resource Governor: Cost Validation, Group Membership Check, Buff Radar
    5. Asset Firewall: Zero-Mistake Protection for Plotted, Equipped, Locked & God-Tier Items
    6. Adaptive Frame-Budget Slicer: Dynamic Task Prioritization (Critical / Normal / Idle)
    7. Telemetry & Live HUD Engine: Real-Time FPS, Ping, Money Rate, Webhook & Floating HUD
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
        local parentGui = (gethui and gethui()) or CoreGui or LP:FindFirstChild("PlayerGui")
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
-- 9. MASTER EXPORT
-- ═══════════════════════════════════════════════════════════════════════════════
Core.Lifecycle      = Lifecycle
Core.Defense        = Defense
Core.NetworkGuard   = NetworkGuard
Core.Precondition   = Precondition
Core.AssetFirewall  = AssetFirewall
Core.Slicer         = Slicer
Core.Telemetry      = Telemetry
Core.FloatingHUD    = FloatingHUD

-- ออโต้เริ่มต้นระบบ Anti-AFK แบบมาตรฐานทันทีที่โหลดโมดูล
Defense.Initialize()

print("[Project Barun Core] 💎 Master Scripting Architecture Engine v3.0 Online & Ready.")
return Core
