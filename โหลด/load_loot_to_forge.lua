--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) | SUPREME LOADER — AURORA EDITION           ║
    ║        High-Speed Multi-CDN • Anti-Detection Shield • Glass Splash UI     ║
    ║                   https://github.com/Barun080/Project-Barun              ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [ONE-LINER EXECUTION]:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Barun080/Project-Barun/main/loot_to_forge_hub.lua?v=" .. tick()))()
--]]

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local Players          = game:GetService("Players")
local HttpService      = game:GetService("HttpService")

local LocalPlayer      = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ParentTarget     = (gethui and gethui()) or CoreGui

-- ═══════════════════════════════════════════════════════════════════
-- 1. PRE-LOAD PURGE & INSTANCE HYGIENE
-- ═══════════════════════════════════════════════════════════════════
pcall(function()
    if _G.LootToForgeCleanup then pcall(_G.LootToForgeCleanup) end
    for _, name in ipairs({"ProjectBarunForge", "ProjectBarun_LootToForge", "Orion", "PB_Supreme_Splash"}) do
        for _, root in ipairs({ParentTarget, LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")}) do
            if root then
                local found = root:FindFirstChild(name)
                if found then found:Destroy() end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 2. LUXURY AURORA GLASS BOOT SPLASH SCREEN
-- ═══════════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PB_Supreme_Splash"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
end)
ScreenGui.Parent = ParentTarget

local Card = Instance.new("CanvasGroup")
Card.Name = "SplashCard"
Card.Size = UDim2.fromOffset(360, 150)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.BackgroundColor3 = Color3.fromRGB(13, 15, 23)
Card.GroupTransparency = 1
Card.Parent = ScreenGui

local CardCorner = Instance.new("UICorner")
CardCorner.CornerRadius = UDim.new(0, 16)
CardCorner.Parent = Card

local CardStroke = Instance.new("UIStroke")
CardStroke.Color = Color3.fromRGB(56, 64, 102)
CardStroke.Thickness = 1.4
CardStroke.Transparency = 0.2
CardStroke.Parent = Card

-- Ambient Glow Orbs
local GlowOrb1 = Instance.new("ImageLabel")
GlowOrb1.Size = UDim2.fromOffset(180, 180)
GlowOrb1.Position = UDim2.new(0, -50, 0, -50)
GlowOrb1.BackgroundTransparency = 1
GlowOrb1.Image = "rbxassetid://5028857084"
GlowOrb1.ImageColor3 = Color3.fromRGB(124, 92, 255)
GlowOrb1.ImageTransparency = 0.75
GlowOrb1.Parent = Card

local GlowOrb2 = Instance.new("ImageLabel")
GlowOrb2.Size = UDim2.fromOffset(180, 180)
GlowOrb2.Position = UDim2.new(1, -120, 1, -120)
GlowOrb2.BackgroundTransparency = 1
GlowOrb2.Image = "rbxassetid://5028857084"
GlowOrb2.ImageColor3 = Color3.fromRGB(0, 229, 255)
GlowOrb2.ImageTransparency = 0.78
GlowOrb2.Parent = Card

-- Brand Pill
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -32, 0, 24)
Logo.Position = UDim2.new(0, 16, 0, 18)
Logo.BackgroundTransparency = 1
Logo.Text = "💎 PROJECT BARUN"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = Card

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -32, 0, 16)
Subtitle.Position = UDim2.new(0, 16, 0, 42)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Loot To Forge Master Suite • Supreme Loader"
Subtitle.TextColor3 = Color3.fromRGB(0, 229, 255)
Subtitle.Font = Enum.Font.GothamMedium
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Card

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -32, 0, 16)
StatusText.Position = UDim2.new(0, 16, 0, 78)
StatusText.BackgroundTransparency = 1
StatusText.Text = "กำลังเริ่มต้นระบบ..."
StatusText.TextColor3 = Color3.fromRGB(160, 168, 204)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = Card

-- Progress Track
local Track = Instance.new("Frame")
Track.Size = UDim2.new(1, -32, 0, 8)
Track.Position = UDim2.new(0, 16, 0, 108)
Track.BackgroundColor3 = Color3.fromRGB(24, 28, 44)
Track.BorderSizePixel = 0
Track.Parent = Card

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(1, 0)
TrackCorner.Parent = Track

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0.05, 0, 1, 0)
Bar.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
Bar.BorderSizePixel = 0
Bar.Parent = Track

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = Bar

local BarGrad = Instance.new("UIGradient")
BarGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 92, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 229, 255)),
})
BarGrad.Parent = Bar

-- Smooth Fade In
TweenService:Create(Card, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    GroupTransparency = 0
}):Play()

local function setProgress(pct, status)
    if StatusText then StatusText.Text = status or StatusText.Text end
    if Bar then
        TweenService:Create(Bar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
        }):Play()
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- 3. MULTI-CDN HIGH-SPEED LOADER WITH FAILOVER MIRRORS
-- ═══════════════════════════════════════════════════════════════════
local MirrorEndpoints = {
    "https://raw.githubusercontent.com/Barun080/Project-Barun/main/loot_to_forge_hub.lua?v=" .. tick(),
    "https://cdn.jsdelivr.net/gh/Barun080/Project-Barun@main/loot_to_forge_hub.lua?v=" .. tick(),
}

task.spawn(function()
    task.wait(0.15)
    setProgress(0.20, "ตรวจสอบสภาพแวดล้อม Executor และสิทธิ์...")
    task.wait(0.2)

    setProgress(0.45, "เชื่อมต่อไปยัง Multi-CDN Server...")
    
    local scriptCode = nil
    local lastError = nil

    for idx, url in ipairs(MirrorEndpoints) do
        local ok, res = pcall(function()
            return game:HttpGet(url, true)
        end)
        if ok and type(res) == "string" and #res > 5000 then
            scriptCode = res
            break
        else
            lastError = res
        end
        task.wait(0.1)
    end

    if not scriptCode and isfile and isfile("loot_to_forge_hub.lua") then
        pcall(function()
            scriptCode = readfile("loot_to_forge_hub.lua")
        end)
    end

    if not scriptCode then
        setProgress(0.5, "เกิดข้อผิดพลาดในการดาวน์โหลดสคริปต์!")
        StatusText.TextColor3 = Color3.fromRGB(255, 77, 106)
        task.wait(2.5)
        TweenService:Create(Card, TweenInfo.new(0.4), { GroupTransparency = 1 }):Play()
        task.wait(0.4)
        ScreenGui:Destroy()
        return
    end

    setProgress(0.75, "ประมวลผล Aurora Engine v3.0 Supreme...")
    task.wait(0.15)

    local fn, compileErr = loadstring(scriptCode)
    if not fn then
        setProgress(0.8, "คอมไพล์สคริปต์ล้มเหลว: " .. tostring(compileErr):sub(1, 30))
        StatusText.TextColor3 = Color3.fromRGB(255, 77, 106)
        task.wait(3.0)
        ScreenGui:Destroy()
        return
    end

    setProgress(1.0, "ระบบพร้อมทำงาน! เริ่มต้น Master Hub...")
    task.wait(0.35)

    -- Smooth dismiss splash screen
    local fadeTw = TweenService:Create(Card, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        GroupTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.48, 0)
    })
    fadeTw:Play()
    fadeTw.Completed:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Execute script payload
    task.spawn(fn)
end)
