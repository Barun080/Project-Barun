--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║       ⚡ MARU HUB (KEYLESS MASTER MOBILE & PC EDITION) ⚡                 ║
    ║       Engineered by cook45 with Mimi Precision for Clack                 ║
    ║       Zero-Key, Zero-Whitelist, 100% Offline/Direct Execution            ║
    ║       Enhanced with Project Barun High-Performance Architecture          ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════════
-- 0. LIFECYCLE & CLEANUP PREVIOUS INSTANCES
-- ═══════════════════════════════════════════════════════════════════
local SessionToken = tick()
_G.MaruHubToken = SessionToken

if _G.MaruHubCleanup then
    pcall(_G.MaruHubCleanup)
    task.wait(0.15)
end

local HubRunning = true
_G.MaruHubRunning = true

_G.MaruHubCleanup = function()
    HubRunning = false
    _G.MaruHubRunning = false
    pcall(function()
        local h = (gethui and gethui()) or game:GetService("CoreGui")
        for _, g in ipairs(h:GetChildren()) do
            if g.Name == "MaruHub_MobileGui" or g.Name == "MaruFloatingButton" then
                g:Destroy()
            end
        end
        local lp = game:GetService("Players").LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetChildren()) do
                if g.Name == "MaruHub_MobileGui" or g.Name == "MaruFloatingButton" then
                    g:Destroy()
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 1. SERVICES & LOCAL PLAYER
-- ═══════════════════════════════════════════════════════════════════
local Players            = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")
local CoreGui           = game:GetService("CoreGui")
local StatsService      = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")

local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()

local function getGuiParent(): Instance
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if CoreGui then
        local ok, r = pcall(function() return CoreGui:FindFirstChild("RobloxGui") or CoreGui end)
        if ok and r then return r end
    end
    return LP:WaitForChild("PlayerGui")
end

-- ═══════════════════════════════════════════════════════════════════
-- 2. MARU CORE STATE & CONFIGURATION (KEYLESS)
-- ═══════════════════════════════════════════════════════════════════
local State = {
    -- Auto Farm
    AutoFarmLevel      = false,
    FastAttack         = true,
    BringMob           = true,
    FarmDistance       = 12,
    AttackDelay        = 0.05,
    SelectedWeapon     = "Melee", -- Melee / Sword / Fruit / Gun
    
    -- Safety & Movement
    SafePlatform       = true,
    NoClip             = false,
    AutoBuso           = true,
    AutoKen            = false,
    FlySpeed           = 250,
    
    -- Economy & Collect
    AutoChest          = false,
    AutoFruitCollect   = false,
    
    -- Progression & Stats
    AutoStatsMelee     = false,
    AutoStatsDefense   = false,
    AutoStatsSword     = false,
    AutoStatsFruit     = false,
    
    -- Settings
    AntiAFK            = true,
    FPSBoost           = false,
    Fullbright         = false
}

-- ═══════════════════════════════════════════════════════════════════
-- 3. TRIPLE-LAYER ZERO-DISCONNECT ANTI-AFK
-- ═══════════════════════════════════════════════════════════════════
task.spawn(function()
    pcall(function()
        LP.Idled:Connect(function()
            if State.AntiAFK and HubRunning then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end
        end)
    end)
    
    while HubRunning do
        task.wait(60)
        if State.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new(10, 10))
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 4. SAFE PLATFORM & NOCLIP ENGINE
-- ═══════════════════════════════════════════════════════════════════
local PlatformPart = nil
local function updatePlatform(pos: Vector3?)
    if not State.SafePlatform or not pos then
        if PlatformPart then
            PlatformPart:Destroy()
            PlatformPart = nil
        end
        return
    end

    if not PlatformPart or not PlatformPart.Parent then
        PlatformPart = Instance.new("Part")
        PlatformPart.Name = "Maru_SafePlatform"
        PlatformPart.Size = Vector3.new(12, 1, 12)
        PlatformPart.Transparency = 0.8
        PlatformPart.Color = Color3.fromRGB(0, 200, 255)
        PlatformPart.Material = Enum.Material.Neon
        PlatformPart.Anchored = true
        PlatformPart.CanCollide = true
        PlatformPart.Parent = Workspace
    end
    PlatformPart.CFrame = CFrame.new(pos - Vector3.new(0, 3.5, 0))
end

RunService.Stepped:Connect(function()
    if not HubRunning then return end
    if State.NoClip or State.AutoFarmLevel or State.AutoChest then
        pcall(function()
            local char = LP.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 5. SMOOTH TWEEN MOVEMENT ENGINE
-- ═══════════════════════════════════════════════════════════════════
local CurrentTween = nil
local function tweenTo(targetCFrame: CFrame, speed: number?)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local currentPos = hrp.Position
    local targetPos = targetCFrame.Position
    local dist = (targetPos - currentPos).Magnitude

    if dist < 8 then
        hrp.CFrame = targetCFrame
        updatePlatform(targetPos)
        return
    end

    local actualSpeed = speed or State.FlySpeed
    local timeToTravel = math.clamp(dist / actualSpeed, 0.05, 10)

    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end

    local ti = TweenInfo.new(timeToTravel, Enum.EasingStyle.Linear)
    CurrentTween = TweenService:Create(hrp, ti, { CFrame = targetCFrame })
    CurrentTween:Play()

    updatePlatform(targetPos)
end

local function stopTween()
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    updatePlatform(nil)
end

-- ═══════════════════════════════════════════════════════════════════
-- 6. MARU COMBAT & FAST ATTACK ENGINE
-- ═══════════════════════════════════════════════════════════════════
local function equipWeaponCategory(category: string)
    pcall(function()
        local bp = LP:FindFirstChild("Backpack")
        local char = LP.Character
        if not bp or not char then return end

        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local tType = tool:GetAttribute("WeaponType") or tool.ToolTip or ""
                if string.find(string.lower(tType), string.lower(category)) or string.find(string.lower(tool.Name), string.lower(category)) then
                    return -- Already equipped
                end
            end
        end

        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local tType = tool:GetAttribute("WeaponType") or tool.ToolTip or ""
                if category == "Melee" and (tool:FindFirstChild("CombatScript") or string.find(string.lower(tool.Name), "combat") or string.find(string.lower(tool.Name), "style") or string.find(string.lower(tool.Name), "black leg") or string.find(string.lower(tool.Name), "electro") or string.find(string.lower(tool.Name), "karate") or string.find(string.lower(tool.Name), "dragon")) then
                    char.Humanoid:EquipTool(tool)
                    return
                elseif string.find(string.lower(tType), string.lower(category)) or string.find(string.lower(tool.Name), string.lower(category)) then
                    char.Humanoid:EquipTool(tool)
                    return
                end
            end
        end

        -- Fallback: equip first available tool if category not matched
        local firstTool = bp:FindFirstChildOfClass("Tool")
        if firstTool and not char:FindFirstChildOfClass("Tool") then
            char.Humanoid:EquipTool(firstTool)
        end
    end)
end

local function triggerFastAttack(targetPart: BasePart)
    pcall(function()
        local char = LP.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")

        -- 1. Standard Tool Activation
        if tool then
            tool:Activate()
        end

        -- 2. Fast Attack Packet Emulation (Maru Net Hook Pattern)
        local net = ReplicatedStorage:FindFirstChild("Net") or ReplicatedStorage:FindFirstChild("Remotes")
        if net then
            local registerAttack = net:FindFirstChild("RegisterAttack") or net:FindFirstChild("Attack")
            if registerAttack and registerAttack:IsA("RemoteEvent") then
                registerAttack:FireServer(0)
            end
            local registerHit = net:FindFirstChild("RegisterHit") or net:FindFirstChild("Damage")
            if registerHit and registerHit:IsA("RemoteEvent") and targetPart then
                registerHit:FireServer(targetPart, { targetPart })
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 7. MOB TARGETING & BRING MOB ENGINE
-- ═══════════════════════════════════════════════════════════════════
local function getEnemiesFolder(): Instance?
    return Workspace:FindFirstChild("Enemies") or Workspace:FindFirstChild("Mobs") or Workspace:FindFirstChild("NPCs") or Workspace
end

local function getClosestEnemy(maxRadius: number?): (Model?, BasePart?)
    local char = LP.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil end

    local folder = getEnemiesFolder()
    if not folder then return nil, nil end

    local closestEnemy = nil
    local closestPart = nil
    local minDist = maxRadius or 3000

    for _, enemy in ipairs(folder:GetChildren()) do
        if enemy:IsA("Model") and enemy ~= char then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local eHrp = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
            if hum and hum.Health > 0 and eHrp then
                local dist = (eHrp.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestEnemy = enemy
                    closestPart = eHrp
                end
            end
        end
    end

    return closestEnemy, closestPart
end

local function bringMobsToPoint(centerPoint: Vector3, radius: number)
    if not State.BringMob then return end
    local folder = getEnemiesFolder()
    if not folder then return end

    for _, enemy in ipairs(folder:GetChildren()) do
        if enemy:IsA("Model") and enemy ~= LP.Character then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local eHrp = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso")
            if hum and hum.Health > 0 and eHrp then
                local dist = (eHrp.Position - centerPoint).Magnitude
                if dist <= radius and dist > 4 then
                    pcall(function()
                        eHrp.CFrame = CFrame.new(centerPoint)
                        eHrp.CanCollide = false
                        eHrp.Velocity = Vector3.zero
                    end)
                end
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- 8. AUTO FARM LOOP (CORE BACKGROUND WORKER)
-- ═══════════════════════════════════════════════════════════════════
task.spawn(function()
    while HubRunning do
        task.wait(State.AttackDelay)

        if State.AutoFarmLevel then
            pcall(function()
                local char = LP.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local enemy, eHrp = getClosestEnemy(5000)
                if enemy and eHrp then
                    -- Position player directly above the target (Maru Safe Overhead Angle)
                    local hoverPos = eHrp.Position + Vector3.new(0, State.FarmDistance, 0)
                    local targetLookAt = CFrame.new(hoverPos, eHrp.Position)

                    hrp.CFrame = targetLookAt
                    updatePlatform(hoverPos)

                    -- Bring surrounding mobs
                    bringMobsToPoint(eHrp.Position, 75)

                    -- Equip active weapon category
                    equipWeaponCategory(State.SelectedWeapon)

                    -- Auto Buso Haki if enabled
                    if State.AutoBuso and not char:FindFirstChild("HasBuso") then
                        local busoRem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Buso")
                        if busoRem then busoRem:FireServer() end
                    end

                    -- Trigger attack
                    triggerFastAttack(eHrp)
                else
                    updatePlatform(nil)
                end
            end)
        end

        -- Auto Chest Farming
        if State.AutoChest and not State.AutoFarmLevel then
            pcall(function()
                local chestFolder = Workspace:FindFirstChild("Chests") or Workspace
                for _, obj in ipairs(chestFolder:GetDescendants()) do
                    if string.find(string.lower(obj.Name), "chest") and (obj:IsA("BasePart") or obj:IsA("Model")) then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local char = LP.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                                task.wait(0.2)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 9. MARU MOBILE NEON UI ENGINE (OBSIDIAN & CYAN GLOW)
-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaruHub_MobileGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = getGuiParent()

-- Main Container Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 560, 0, 360)
MainWindow.Position = UDim2.new(0.5, -280, 0.5, -180)
MainWindow.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MainWindow.BorderSizePixel = 0
MainWindow.ClipsDescendants = true
MainWindow.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainWindow

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 210, 255)
MainStroke.Thickness = 1.6
MainStroke.Transparency = 0.2
MainStroke.Parent = MainWindow

-- Title Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainWindow

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 260, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ MARU HUB  <font color=\"#00d2ff\">[KEYLESS]</font>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Telemetry Pill (Ping & FPS)
local TelemetryPill = Instance.new("TextLabel")
TelemetryPill.Name = "TelemetryPill"
TelemetryPill.Size = UDim2.new(0, 160, 0, 24)
TelemetryPill.Position = UDim2.new(1, -210, 0.5, -12)
TelemetryPill.BackgroundColor3 = Color3.fromRGB(24, 30, 44)
TelemetryPill.TextColor3 = Color3.fromRGB(0, 220, 255)
TelemetryPill.Font = Enum.Font.GothamMedium
TelemetryPill.TextSize = 11
TelemetryPill.Text = "FPS: 60 | Ping: 45ms"
TelemetryPill.Parent = TopBar

local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(0, 6)
PillCorner.Parent = TelemetryPill

-- Close / Minimize Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainWindow.Visible = false
end)

-- Sidebar Tabs Container
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 8, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainWindow

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = Sidebar

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 6)
TabPadding.PaddingLeft = UDim.new(0, 6)
TabPadding.PaddingRight = UDim.new(0, 6)
TabPadding.Parent = Sidebar

-- Content Pages Container
local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Size = UDim2.new(1, -154, 1, -50)
PageContainer.Position = UDim2.new(0, 144, 0, 46)
PageContainer.BackgroundColor3 = Color3.fromRGB(15, 18, 26)
PageContainer.BorderSizePixel = 0
PageContainer.Parent = MainWindow

local PageCorner = Instance.new("UICorner")
PageCorner.CornerRadius = UDim.new(0, 8)
PageCorner.Parent = PageContainer

-- ═══════════════════════════════════════════════════════════════════
-- 10. TAB NAVIGATION & COMPONENT BUILDERS
-- ═══════════════════════════════════════════════════════════════════
local Pages = {}
local TabButtons = {}

local function createPage(name: string): ScrollingFrame
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = PageContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop = UDim.new(0, 10)
    pagePad.PaddingBottom = UDim.new(0, 10)
    pagePad.PaddingLeft = UDim.new(0, 10)
    pagePad.PaddingRight = UDim.new(0, 10)
    pagePad.Parent = page

    Pages[name] = page
    return page
end

local function switchTab(name: string)
    for pName, pFrame in pairs(Pages) do
        pFrame.Visible = (pName == name)
    end
    for tName, tBtn in pairs(TabButtons) do
        if tName == name then
            tBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            tBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
            tBtn.TextColor3 = Color3.fromRGB(160, 170, 190)
        end
    end
end

local function addTabButton(name: string, icon: string)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "TabBtn"
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
    btn.TextColor3 = Color3.fromRGB(160, 170, 190)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Text = icon .. "  " .. name
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.Parent = btn

    TabButtons[name] = btn

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

-- Component: Toggle Switch
local function addToggle(parent: Instance, title: string, defaultVal: boolean, callback: (boolean) -> ())
    local card = Instance.new("Frame")
    card.Name = title .. "_ToggleCard"
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
    card.Parent = parent

    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 6)
    cCorner.Parent = card

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230, 235, 245)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.Text = title
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = card

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 42, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = defaultVal and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(40, 46, 60)
    switch.Text = ""
    switch.Parent = card

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = defaultVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local current = defaultVal
    switch.MouseButton1Click:Connect(function()
        current = not current
        local targetPos = current and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = current and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(40, 46, 60)

        TweenService:Create(knob, TweenInfo.new(0.18), { Position = targetPos }):Play()
        TweenService:Create(switch, TweenInfo.new(0.18), { BackgroundColor3 = targetColor }):Play()

        callback(current)
    end)
end

-- Component: Action Button
local function addButton(parent: Instance, title: string, callback: () -> ())
    local btn = Instance.new("TextButton")
    btn.Name = title .. "_Btn"
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(28, 34, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Text = "▶  " .. title
    btn.Parent = parent

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    local bStroke = Instance.new("UIStroke")
    bStroke.Color = Color3.fromRGB(0, 170, 255)
    bStroke.Thickness = 1
    bStroke.Transparency = 0.6
    bStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(0, 170, 255) }):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(28, 34, 50) }):Play()
        pcall(callback)
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 11. BUILD 5 CORE STANDARD TABS
-- ═══════════════════════════════════════════════════════════════════

-- Tab 1: Main Farm
addTabButton("Main Farm", "⚔️")
local pageFarm = createPage("Main Farm")

addToggle(pageFarm, "Auto Farm Level / Nearest Mob", State.AutoFarmLevel, function(v)
    State.AutoFarmLevel = v
    if not v then stopTween() end
end)

addToggle(pageFarm, "Fast Attack (No Cooldown)", State.FastAttack, function(v)
    State.FastAttack = v
end)

addToggle(pageFarm, "Bring / Magnet Mobs to Front", State.BringMob, function(v)
    State.BringMob = v
end)

addToggle(pageFarm, "Safe Floating Platform (Anti-Fall/Water)", State.SafePlatform, function(v)
    State.SafePlatform = v
    if not v then updatePlatform(nil) end
end)

addToggle(pageFarm, "Continuous NoClip", State.NoClip, function(v)
    State.NoClip = v
end)

addButton(pageFarm, "Equip Melee (หมัด)", function()
    State.SelectedWeapon = "Melee"
    equipWeaponCategory("Melee")
end)

addButton(pageFarm, "Equip Sword (ดาบ)", function()
    State.SelectedWeapon = "Sword"
    equipWeaponCategory("Sword")
end)

-- Tab 2: Economy & Items
addTabButton("Economy", "💰")
local pageEcon = createPage("Economy")

addToggle(pageEcon, "Auto Collect All Chests", State.AutoChest, function(v)
    State.AutoChest = v
end)

addButton(pageEcon, "Teleport to Closest Chest", function()
    pcall(function()
        local chestFolder = Workspace:FindFirstChild("Chests") or Workspace
        for _, obj in ipairs(chestFolder:GetDescendants()) do
            if string.find(string.lower(obj.Name), "chest") and obj:IsA("BasePart") then
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                    break
                end
            end
        end
    end)
end)

-- Tab 3: Combat & Haki
addTabButton("Combat", "🔥")
local pageCombat = createPage("Combat")

addToggle(pageCombat, "Auto Buso Haki (ฮาคิเกราะ)", State.AutoBuso, function(v)
    State.AutoBuso = v
end)

addButton(pageCombat, "Toggle Buso Haki Now", function()
    local busoRem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Buso")
    if busoRem then busoRem:FireServer() end
end)

-- Tab 4: Progression
addTabButton("Progression", "📈")
local pageProg = createPage("Progression")

addButton(pageProg, "Redistribute Stats: Melee (+3)", function()
    pcall(function()
        local mainRem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Points")
        if mainRem then mainRem:FireServer("Melee", 3) end
    end)
end)

addButton(pageProg, "Redistribute Stats: Defense (+3)", function()
    pcall(function()
        local mainRem = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Points")
        if mainRem then mainRem:FireServer("Defense", 3) end
    end)
end)

-- Tab 5: Settings
addTabButton("Settings", "⚙️")
local pageSettings = createPage("Settings")

addToggle(pageSettings, "Triple-Layer Anti-AFK (24/7)", State.AntiAFK, function(v)
    State.AntiAFK = v
end)

addToggle(pageSettings, "Mobile FPS Boost & Shadow Stripper", State.FPSBoost, function(v)
    State.FPSBoost = v
    pcall(function()
        Lighting.GlobalShadows = not v
        Lighting.FogEnd = v and 9e9 or 1000
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and v then
                part.Material = Enum.Material.SmoothPlastic
                part.CastShadow = false
            end
        end
    end)
end)

addButton(pageSettings, "Rejoin Current Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
end)

addButton(pageSettings, "Unload Hub Cleanly", function()
    if _G.MaruHubCleanup then _G.MaruHubCleanup() end
end)

-- Set default active tab
switchTab("Main Farm")

-- ═══════════════════════════════════════════════════════════════════
-- 12. MARU ICONIC FLOATING MOBILE BUTTON (DRAGGABLE & TOUCH FRIENDLY)
-- ═══════════════════════════════════════════════════════════════════
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "MaruFloatingButton"
FloatingButton.Size = UDim2.new(0, 48, 0, 48)
FloatingButton.Position = UDim2.new(0, 16, 0.4, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
FloatingButton.Image = "rbxassetid://10723415760" -- Neon Cyber Shield / Emblem Icon
FloatingButton.ImageColor3 = Color3.fromRGB(0, 220, 255)
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(0, 200, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatingButton

-- Smooth Dragging Logic for Mobile & PC
local isDragging = false
local dragStartPos = nil
local btnStartPos = nil

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = input.Position
        btnStartPos = FloatingButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        FloatingButton.Position = UDim2.new(
            btnStartPos.X.Scale,
            btnStartPos.X.Offset + delta.X,
            btnStartPos.Y.Scale,
            btnStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Click to Toggle Visibility
local lastClick = 0
FloatingButton.MouseButton1Click:Connect(function()
    -- Only toggle if it wasn't a heavy drag
    if tick() - lastClick > 0.15 then
        lastClick = tick()
        MainWindow.Visible = not MainWindow.Visible
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 13. LIVE TELEMETRY LOOP
-- ═══════════════════════════════════════════════════════════════════
task.spawn(function()
    local frameCount = 0
    local lastTime = tick()
    local fps = 60

    RunService.RenderStepped:Connect(function()
        frameCount += 1
        local now = tick()
        if now - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = now

            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            if TelemetryPill and TelemetryPill.Parent then
                TelemetryPill.Text = string.format("FPS: %d | Ping: %dms", fps, ping)
            end
        end
    end)
end)

print("⚡ [MARU HUB] KEYLESS MASTER EDITION LOADED SUCCESSFULLY!")
