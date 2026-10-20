--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — OUROBOROS OBSIDIAN DEMO SUITE             ║
    ║        Standard Template for building scripts with Obsidian UI           ║
    ║        Compatible with PC & Mobile Emulators                             ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local UI = nil

-- Check local file first, then fallback to remote
if isfile and readfile and isfile("ui/ui_template_master_ouroboros_obsidian.luau") then
    local fn = loadstring(readfile("ui/ui_template_master_ouroboros_obsidian.luau"))
    if fn then UI = fn() end
end

if not UI then
    local url = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/ui/ui_template_master_ouroboros_obsidian.luau?v=" .. tick()
    local ok, raw = pcall(function() return game:HttpGet(url, true) end)
    if ok and raw and #raw > 500 then
        local fn = loadstring(raw)
        if fn then UI = fn() end
    end
end

if not UI then
    error("[Project Barun] Could not load Obsidian UI template!")
end

local Library = UI.Library
local ThemeManager = UI.ThemeManager
local SaveManager = UI.SaveManager

-- Create Master Window
local Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    SubTitle = "Ouroboros Obsidian Demo",
    TabPadding = 6,
    MenuFadeTime = 0.2,
    ShowMobileButtons = true,
    CornerRadius = 6,
    AutoShow = true,
    MobileToggle = true,
    MobileToggleText = "PB",
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab("Main"),
    Combat = Window:AddTab("Combat"),
    Misc = Window:AddTab("Misc"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: MAIN
-- ─────────────────────────────────────────────────────────────────────
local LeftMain = Tabs.Main:AddLeftGroupbox("Automation Hub")
LeftMain:AddToggle("AutoFarm", {
    Text = "Auto Farm (เปิดฟาร์มอัตโนมัติ)",
    Default = false,
    Tooltip = "เริ่มระบบฟาร์มอัตโนมัติ",
    Callback = function(v)
        UI:Notify("Auto Farm", v and "Started auto farm!" or "Stopped auto farm.", 2.5)
    end
})

LeftMain:AddSlider("FarmSpeed", {
    Text = "Farm Speed Delay",
    Min = 0.01,
    Max = 1.0,
    Default = 0.1,
    Rounding = 2,
    Suffix = "s",
    Callback = function(v)
        print("Speed set to:", v)
    end
})

LeftMain:AddDropdown("FarmTarget", {
    Text = "Select Target Monster",
    Values = { "Goblin", "Bandit", "Skeleton Boss", "Dragon King" },
    Default = "Goblin",
    Callback = function(v)
        print("Selected target:", v)
    end
})

LeftMain:AddButton({
    Text = "Collect Rewards Now",
    Func = function()
        UI:Notify("Rewards", "Collected all available rewards!", 3)
    end
})

local RightMain = Tabs.Main:AddRightGroupbox("Character Stats")
RightMain:AddToggle("GodMode", {
    Text = "God Mode (อมตะ)",
    Default = false,
    Callback = function(v)
        UI:Notify("God Mode", v and "Activated God Mode!" or "Deactivated.", 2.5)
    end
})

RightMain:AddSlider("WalkSpeed", {
    Text = "Walk Speed",
    Min = 16,
    Max = 250,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        local lp = game:GetService("Players").LocalPlayer
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB: UI SETTINGS (OBSIDIAN THEMES & SAVE CONFIGS)
-- ─────────────────────────────────────────────────────────────────────
UI:SetupManagers(Tabs["UI Settings"], "ProjectBarun", "DemoHub")

UI:Notify("Project Barun", "Ouroboros Obsidian Demo loaded successfully!", 4)
