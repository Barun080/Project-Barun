-- ==============================================================================
-- 🚀 PROJECT BARUN — UNIVERSAL MCP BRIDGE LOADER (PC & ANDROID EMULATOR HYBRID)
-- ==============================================================================
-- ออกแบบมาเพื่อรองรับ 100% ทั้ง:
--   • PC Native (Roblox Player / Solara / Wave / Swift / Celery / MacSploit / etc.)
--   • Android Emulator (LDPlayer / MuMu / BlueStacks / Nox / MEmu)
--   • Mobile Executors (Delta / Codex / Arceus X / Vega X / Fluxus Android / Hydrogen)
--   • Hotspot & Wi-Fi LAN / Bridge Network
-- ==============================================================================

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ParentTarget = (gethui and gethui()) or CoreGui or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui"))

-- ==========================================
-- 📱 PLATFORM & EXECUTOR AUTO-DETECTION
-- ==========================================
local PlatformInfo = (function()
    local isTouch = UserInputService.TouchEnabled
    local isKeyboard = UserInputService.KeyboardEnabled
    local isMouse = UserInputService.MouseEnabled

    local execName = "Unknown"
    pcall(function()
        if identifyexecutor then
            execName = tostring(identifyexecutor())
        elseif getexecutorname then
            execName = tostring(getexecutorname())
        end
    end)

    local execLower = execName:lower()
    local isKnownMobileExec = execLower:find("delta")
        or execLower:find("codex")
        or execLower:find("arceus")
        or execLower:find("vega")
        or execLower:find("fluxus")
        or execLower:find("hydrogen")
        or execLower:find("cubix")
        or execLower:find("neptune")

    -- ตรวจสอบว่าเป็น Android Emulator / Mobile หรือ PC
    local isEmulatorOrMobile = isKnownMobileExec or (isTouch and not isKeyboard) or (isTouch and isMouse and not isKeyboard)

    return {
        IsMobileOrEmulator = isEmulatorOrMobile,
        ExecutorName       = execName,
        PlatformTag        = isEmulatorOrMobile and "EMULATOR/MOBILE" or "PC",
    }
end)()

-- ==========================================
-- ⚙️ CONFIGURATION & TUNING
-- ==========================================
local CONFIG = {
    -- พอร์ตที่ MCP Server ใช้งาน (ปกติ 16385 และ 16384)
    PORTS = { 16385, 16384 },

    -- รายการ Host Candidates สำหรับ Android Emulator (เชื่อมต่อไปยัง PC Host ผ่าน NAT Gateway / LAN IP)
    EMULATOR_HOSTS = {
        getgenv().CustomMCPHost,
        getgenv().TargetMCPHost,
        "10.0.2.2",                       -- Default NAT Gateway (LDPlayer / BlueStacks 5 / MuMu 12 / Android AVD)
        "172.20.10.13",                   -- Host PC Wi-Fi LAN IP (เครือข่ายปัจจุบันของคอม)
        "192.168.137.1",                  -- Windows Mobile Hotspot Default Gateway
        "10.0.3.2",                       -- Genymotion NAT Gateway
        "172.17.100.2",                   -- Nox Player NAT Gateway
        "192.168.75.1",                   -- MuMu Player NEMU NAT Gateway
        "127.0.0.1",                      -- เผื่อกรณีรันบน PC หรือใช้ Port-Forwarding ใน Emulator
        "localhost",
        "192.168.1.100",
        "192.168.1.50",
    },

    -- รายการ Host Candidates สำหรับ PC Native
    PC_HOSTS = {
        getgenv().CustomMCPHost,
        getgenv().TargetMCPHost,
        "127.0.0.1",                      -- Localhost IPv4 (ไวที่สุดบนคอม)
        "localhost",                      -- Localhost Hostname
        "172.20.10.13",                   -- Host PC Wi-Fi LAN IP
        "10.0.2.2",                       -- เผื่อจำลองเส้นทาง
        "192.168.1.100",
    },

    FAST_PROBE_WAIT  = 0.9,               -- Timeout ต่อการ Probe Endpoint (วินาที)
    MAX_PROBE_ROUNDS = 50,                -- จำนวนรอบในการพยายามเชื่อมต่อ
    RETRY_DELAY      = 0.5,               -- หน่วงเวลาระหว่างรอบสแกน (วินาที)
    SHOW_NOTIFY      = true,              -- แสดง In-Game Toast
    ENABLE_HUD       = true,              -- แสดงปุ่ม Glass HUD บนจอ (ลากได้ รองรับสัมผัส/เมาส์)
    ENABLE_WATCHDOG  = true,              -- ตรวจสอบและ Reconnect อัตโนมัติเมื่อหลุด

    -- ⚡ OPTIMIZATIONS (ป้องกันเกมหน่วง/หลุด)
    OPTIMIZATIONS = {
        DisableDecompMapping = true,      -- ข้าม initial decompile mapping (ลดแลค 100%)
        ScriptMappingWorkers = 6,         -- จำนวน worker thread ไม่ให้กิน CPU
        FailedResyncInterval = 45,        -- รอบ resync สคริปต์ที่ล้มเหลว (วินาที)
        SafeWebSocketForMobile = true,    -- ปิด WebSocket บน Mobile เพื่อหลีกเลี่ยง JNI Crash/Freeze
    }
}

-- ==========================================
-- 🛡️ APPLY OPTIMIZATIONS TO GENENV
-- ==========================================
if CONFIG.OPTIMIZATIONS.DisableDecompMapping then
    getgenv().DisableInitialScriptDecompMapping = true
end
if CONFIG.OPTIMIZATIONS.ScriptMappingWorkers then
    getgenv().MCP_ScriptMappingWorkers = CONFIG.OPTIMIZATIONS.ScriptMappingWorkers
end
if CONFIG.OPTIMIZATIONS.FailedResyncInterval then
    getgenv().MCP_FailedScriptResyncInterval = CONFIG.OPTIMIZATIONS.FailedResyncInterval
end

-- ป้องกัน WebSocket Crash (ตรวจจับว่า Executor รองรับ WebSocket จริงหรือไม่ ป้องกัน "WebSocket client is not available")
if getgenv().DisableWebSocket == nil then
    local wsWorks = false
    if typeof(WebSocket) == "table" and typeof(WebSocket.connect) == "function" then
        local probeOk, probeRes = pcall(function()
            return WebSocket.connect("ws://127.0.0.1:1")
        end)
        -- ถ้า error ระบุว่า "not available" แสดงว่า Executor ปิดระบบ WebSocket ไว้
        if probeOk or (not probeOk and not tostring(probeRes):lower():find("not available")) then
            wsWorks = not PlatformInfo.IsMobileOrEmulator -- ถ้าเป็น Mobile/Emulator แนะนำให้ปิดเพื่อกันค้าง
        end
    end
    if not wsWorks then
        getgenv().DisableWebSocket = true -- บังคับใช้ HTTP Polling ซึ่งเสถียร 100% บนทุก Executor/Emulator
    end
end

-- ==========================================
-- 🌐 UNIVERSAL REQUEST POLYFILL (FOR MOBILE & PC)
-- ==========================================
local rawRequest = (typeof(request) == "function" and request)
    or (typeof(http_request) == "function" and http_request)
    or (typeof(syn) == "table" and typeof(syn.request) == "function" and syn.request)
    or (typeof(http) == "table" and typeof(http.request) == "function" and http.request)
    or (typeof(fluxus) == "table" and typeof(fluxus.request) == "function" and fluxus.request)

local function universalRequest(options)
    options = options or {}
    local url = options.Url or options.url
    local method = (options.Method or options.method or "GET"):upper()
    local headers = options.Headers or options.headers or {}
    local body = options.Body or options.body
    local timeout = options.Timeout or options.timeout or 5

    if rawRequest then
        local payload = {
            Url = url,
            url = url,
            Method = method,
            method = method,
            Headers = headers,
            headers = headers,
            Body = body,
            body = body,
            Timeout = timeout,
            timeout = timeout,
        }

        local ok, res = pcall(rawRequest, payload)
        if ok and type(res) == "table" then
            local rBody = res.Body or res.body or ""
            local rCode = res.StatusCode or res.status_code or (res.Success and 200 or 500)
            if type(rCode) == "string" then rCode = tonumber(rCode) or 200 end

            res.Body = rBody
            res.body = rBody
            res.StatusCode = rCode
            res.status_code = rCode
            res.Success = (rCode >= 200 and rCode < 300)
            return res
        end
    end

    -- Fallback สำหรับ GET ผ่าน game:HttpGet
    if game and typeof(game.HttpGet) == "function" and method == "GET" and url then
        local ok, resText = pcall(function() return game:HttpGet(url) end)
        if ok and type(resText) == "string" then
            return {
                Success = true,
                StatusCode = 200,
                status_code = 200,
                Body = resText,
                body = resText,
                Headers = {},
            }
        end
    end

    return {
        Success = false,
        StatusCode = 500,
        status_code = 500,
        Body = "",
        body = "",
        Headers = {},
    }
end

-- ฝังฟังก์ชันเข้า Global Env เพื่อให้ connector.luau ใช้งานได้ทันทีโดยไม่เออเร่อ
getgenv().request = universalRequest
getgenv().http_request = universalRequest

-- ฟังก์ชันดึง script.luau ที่เสถียรที่สุด
local function safeHttpGet(url, timeoutSec)
    local res = universalRequest({
        Url = url,
        Method = "GET",
        Timeout = timeoutSec or 2,
        Headers = {
            ["Cache-Control"] = "no-cache",
        }
    })

    if res and res.StatusCode == 200 and type(res.Body) == "string" and #res.Body > 20 then
        return true, res.Body
    end

    -- ลองตรงผ่าน game:HttpGet อีกครั้งถ้า request ยังไม่ได้ผล
    if game and typeof(game.HttpGet) == "function" then
        local ok, raw = pcall(function() return game:HttpGet(url) end)
        if ok and type(raw) == "string" and #raw > 20 then
            return true, raw
        end
    end

    return false, "Connection failed or empty body"
end

-- ==========================================
-- 📢 NOTIFICATION & SLEEK GLASS HUD
-- ==========================================
local function notify(title, text, duration, icon)
    if not CONFIG.SHOW_NOTIFY then return end
    pcall(function()
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {
            Title = title or "MCP Bridge",
            Text = text or "",
            Duration = duration or 3,
            Icon = icon or "rbxassetid://10888375286",
        })
    end)
end

-- Glass HUD UI Controller
local HUD = {
    Gui = nil,
    Pill = nil,
    Dot = nil,
    StatusLabel = nil,
    SubLabel = nil,
}

local function setupHUD()
    if not CONFIG.ENABLE_HUD or HUD.Gui then return end

    pcall(function()
        local old = ParentTarget:FindFirstChild("PB_MCP_StatusHUD")
        if old then old:Destroy() end

        local screen = Instance.new("ScreenGui")
        screen.Name = "PB_MCP_StatusHUD"
        screen.ResetOnSpawn = false
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(screen) end
        end)
        screen.Parent = ParentTarget
        HUD.Gui = screen

        -- Floating Pill Frame
        local pill = Instance.new("TextButton")
        pill.Name = "StatusPill"
        pill.Size = UDim2.fromOffset(220, 36)
        pill.Position = UDim2.new(1, -235, 0, PlatformInfo.IsMobileOrEmulator and 45 or 15)
        pill.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
        pill.BackgroundTransparency = 0.15
        pill.Text = ""
        pill.AutoButtonColor = false
        pill.Active = true
        pill.Parent = screen
        HUD.Pill = pill

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = pill

        local stroke = Instance.new("UIStroke")
        stroke.Name = "Stroke"
        stroke.Color = Color3.fromRGB(56, 65, 96)
        stroke.Thickness = 1.2
        stroke.Parent = pill

        -- Glowing Dot Indicator
        local dot = Instance.new("Frame")
        dot.Name = "StatusDot"
        dot.Size = UDim2.fromOffset(8, 8)
        dot.Position = UDim2.new(0, 14, 0.5, -4)
        dot.BackgroundColor3 = Color3.fromRGB(245, 158, 11) -- Yellow scanning
        dot.BorderSizePixel = 0
        dot.Parent = pill
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        HUD.Dot = dot

        -- Status Title
        local lbl = Instance.new("TextLabel")
        lbl.Name = "Title"
        lbl.Size = UDim2.new(1, -35, 0, 16)
        lbl.Position = UDim2.new(0, 28, 0, 3)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = "MCP: Scanning..."
        lbl.TextColor3 = Color3.fromRGB(240, 245, 255)
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = pill
        HUD.StatusLabel = lbl

        -- Subtitle Info (Platform & Target)
        local sub = Instance.new("TextLabel")
        sub.Name = "Subtitle"
        sub.Size = UDim2.new(1, -35, 0, 14)
        sub.Position = UDim2.new(0, 28, 0, 18)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham
        sub.Text = string.format("%s • %s", PlatformInfo.PlatformTag, PlatformInfo.ExecutorName)
        sub.TextColor3 = Color3.fromRGB(130, 145, 175)
        sub.TextSize = 9.5
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Parent = pill
        HUD.SubLabel = sub

        -- Touch & Mouse Draggable Support
        local dragging = false
        local dragStart, startPos
        pill.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = pill.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                pill.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        -- Tap to Reconnect or Refresh
        pill.MouseButton1Click:Connect(function()
            if not dragging then
                if getgenv().MCP and getgenv().MCP.Reload then
                    notify("MCP Bridge", "Manual Reloading initiated...", 2)
                    task.spawn(getgenv().MCP.Reload)
                end
            end
        end)
    end)
end

local function updateHUD(state, title, subtitle)
    if not HUD.Pill then return end
    pcall(function()
        if state == "connecting" then
            HUD.Dot.BackgroundColor3 = Color3.fromRGB(245, 158, 11) -- Amber
            HUD.Pill.Stroke.Color = Color3.fromRGB(80, 70, 40)
        elseif state == "connected" then
            HUD.Dot.BackgroundColor3 = Color3.fromRGB(52, 211, 153) -- Mint Green
            HUD.Pill.Stroke.Color = Color3.fromRGB(34, 197, 94)
        elseif state == "failed" then
            HUD.Dot.BackgroundColor3 = Color3.fromRGB(239, 68, 68) -- Red
            HUD.Pill.Stroke.Color = Color3.fromRGB(120, 40, 50)
        end
        if title and HUD.StatusLabel then HUD.StatusLabel.Text = title end
        if subtitle and HUD.SubLabel then HUD.SubLabel.Text = subtitle end
    end)
end

-- ==========================================
-- 🔍 GENERATE CANDIDATE LIST (SMART-ORDERED)
-- ==========================================
local function buildCandidateHosts()
    local candidates = {}
    local seen = {}

    local function add(host)
        if type(host) == "string" and #host > 0 and not seen[host] then
            seen[host] = true
            table.insert(candidates, host)
        end
    end

    -- 1. ลำดับแรก: ถ้า Maker กำหนด BridgeURL ไว้โดยตรง ให้ใช้ก่อน
    local directTargets = {
        getgenv().BridgeURL,
        getgenv().bridgeurl,
        getgenv().TargetMCPHost,
        getgenv().CustomMCPHost,
    }
    for _, t in ipairs(directTargets) do
        if type(t) == "string" and #t > 0 then
            if t:find(":") then
                add(t)
            else
                for _, port in ipairs(CONFIG.PORTS) do
                    add(("%s:%s"):format(t, tostring(port)))
                end
            end
        end
    end

    -- 2. เลือกลำดับ IP ต้นทางตามแพลตฟอร์มที่กำลังรัน
    local hostPool = PlatformInfo.IsMobileOrEmulator and CONFIG.EMULATOR_HOSTS or CONFIG.PC_HOSTS
    local fallbackPool = PlatformInfo.IsMobileOrEmulator and CONFIG.PC_HOSTS or CONFIG.EMULATOR_HOSTS

    for _, ip in ipairs(hostPool) do
        if type(ip) == "string" and #ip > 0 then
            for _, port in ipairs(CONFIG.PORTS) do
                add(("%s:%s"):format(ip, tostring(port)))
            end
        end
    end

    -- 3. รวม fallback pool ต่อท้าย
    for _, ip in ipairs(fallbackPool) do
        if type(ip) == "string" and #ip > 0 then
            for _, port in ipairs(CONFIG.PORTS) do
                add(("%s:%s"):format(ip, tostring(port)))
            end
        end
    end

    return candidates
end

-- ==========================================
-- ⚡ FAST CONCURRENT PROBE & CONNECT
-- ==========================================
local function tryConnect()
    local candidates = buildCandidateHosts()
    local responsiveHost = nil
    local responsiveBody = nil

    -- ทำการ Probe พร้อมกันเป็นชุด (Batch Parallel) เพื่อความรวดเร็วสูงสุด
    local batchSize = 4
    for i = 1, #candidates, batchSize do
        local completed = false
        local threads = {}

        for j = i, math.min(i + batchSize - 1, #candidates) do
            local host = candidates[j]
            local th = task.spawn(function()
                local url = ("http://%s/script.luau"):format(host)
                local ok, body = safeHttpGet(url, CONFIG.FAST_PROBE_WAIT)
                if ok and body and #body > 20 and not completed then
                    completed = true
                    responsiveHost = host
                    responsiveBody = body
                end
            end)
            table.insert(threads, th)
        end

        local t0 = os.clock()
        while not completed and (os.clock() - t0 < CONFIG.FAST_PROBE_WAIT) do
            task.wait(0.04)
        end

        if responsiveHost and responsiveBody then
            break
        end
    end

    if not responsiveHost or not responsiveBody then
        return false, "No responsive MCP Bridge server found across candidate endpoints"
    end

    -- ตรวจสอบว่าโค้ดคอมไพล์ผ่าน
    local fn, parseErr = loadstring(responsiveBody)
    if not fn then
        return false, ("Parse error on %s: %s"):format(responsiveHost, tostring(parseErr))
    end

    -- ตั้งค่า Bridge Environment ตัวแปรสำคัญ
    getgenv().BridgeURL = responsiveHost
    getgenv().bridgeurl = responsiveHost

    -- รัน connector script
    local runOk, runErr = pcall(fn)
    if not runOk then
        return false, ("Runtime error on %s: %s"):format(responsiveHost, tostring(runErr))
    end

    return true, responsiveHost
end

-- ==========================================
-- 🚀 MAIN LOADER CONTROLLER
-- ==========================================
local function startLoader()
    setupHUD()

    if getgenv().MCP_Loaded then
        local currentHost = tostring(getgenv().BridgeURL)
        print("[MCP Pro] Bridge is already active! Host: " .. currentHost)
        notify("MCP Bridge Active", currentHost, 3)
        updateHUD("connected", "MCP: Connected ⚡", currentHost)
        return true
    end

    print(string.format("[MCP Pro] Scanning [%s Mode] across candidate endpoints...", PlatformInfo.PlatformTag))
    notify("MCP Bridge", string.format("Scanning for PC/Emulator (%s)...", PlatformInfo.PlatformTag), 2)
    updateHUD("connecting", "MCP: Scanning...", PlatformInfo.PlatformTag .. " • Searching")

    local attempts = 0
    local connectedHost = nil

    while not getgenv().MCP_Loaded and attempts < CONFIG.MAX_PROBE_ROUNDS do
        attempts += 1
        local ok, detail = tryConnect()

        if ok then
            connectedHost = detail
            break
        end

        task.wait(CONFIG.RETRY_DELAY)
    end

    if getgenv().MCP_Loaded then
        local finalHost = tostring(connectedHost or getgenv().BridgeURL)
        local msg = ("Connected to %s in %d attempt(s) ✓"):format(finalHost, attempts)
        print("[MCP Pro] " .. msg)
        notify("MCP Connected! ⚡", finalHost, 4, "rbxassetid://10888375286")
        updateHUD("connected", "MCP: Connected ⚡", finalHost)
        return true
    else
        local failMsg = ("Failed to connect after %d attempts."):format(CONFIG.MAX_PROBE_ROUNDS)
        warn("[MCP Pro] " .. failMsg)
        notify("MCP Error", "Cannot reach server (Check PC & Port)", 5)
        updateHUD("failed", "MCP: Failed ✕", "Tap to retry scan")
        return false
    end
end

-- ==========================================
-- 🐕 BACKGROUND WATCHDOG (AUTO RECONNECT)
-- ==========================================
local function startWatchdog()
    if not CONFIG.ENABLE_WATCHDOG or getgenv()._MCP_WatchdogRunning then return end
    getgenv()._MCP_WatchdogRunning = true

    task.spawn(function()
        while true do
            task.wait(12)
            if not getgenv().MCP_Loaded then
                print("[MCP Watchdog] Connection lost or inactive. Attempting reconnect...")
                updateHUD("connecting", "MCP: Reconnecting...", "Lost connection")
                startLoader()
            end
        end
    end)
end

-- ==========================================
-- 🛠️ EXPOSE MCP CONTROLLER API
-- ==========================================
getgenv().MCP = {
    Reload = function()
        getgenv().MCP_Loaded = false
        return startLoader()
    end,
    GetHost = function()
        return getgenv().BridgeURL or "None"
    end,
    GetPlatform = function()
        return PlatformInfo
    end,
    Ping = function()
        local host = getgenv().BridgeURL
        if not host then return false, "No host" end
        local t0 = os.clock()
        local ok, _ = safeHttpGet(("http://%s/script.luau"):format(host), 1.5)
        local dt = math.floor((os.clock() - t0) * 1000)
        return ok, dt
    end,
    Config = CONFIG,
}

-- เริ่มการทำงานทันที
startLoader()
startWatchdog()
