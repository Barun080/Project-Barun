--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — TITANIUM LUXE v5.1 DEMONSTRATION SUITE    ║
    ║        Hybrid Obsidian Engine + Refined Neo-Cyber Glassmorphism          ║
    ║        Features: Titanium Palette, Dual Groupboxes, Save/Theme Manager   ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local UI = nil

-- Check local workspace files safely (Priority: v5.1 Titanium Luxe, then v4)
local localCandidates = {
    "ui/ui_template_master_v5_1_titanium_luxe.luau",
    "ui/ui_template_master_v4.luau",
}

if isfile and loadfile then
    for _, path in ipairs(localCandidates) do
        if isfile(path) then
            local ok, res = pcall(function()
                return loadfile(path)()
            end)
            if ok and res then
                UI = res
                break
            end
        end
    end
end

-- Fallback to GitHub via HttpGet
if not UI then
    local webCandidates = {
        "https://raw.githubusercontent.com/Barun080/Project-Barun/main/ui/ui_template_master_v5_1_titanium_luxe.luau?v=" .. tick(),
        "https://raw.githubusercontent.com/Barun080/Project-Barun/main/ui/ui_template_master_v4.luau?v=" .. tick(),
    }
    for _, url in ipairs(webCandidates) do
        local ok, raw = pcall(function() return game:HttpGet(url) end)
        if ok and raw and #raw > 100 then
            local chunk, err = loadstring(raw)
            if chunk then
                local execOk, res = pcall(chunk)
                if execOk and res then
                    UI = res
                    break
                end
            end
        end
    end
end

if not UI then
    error("[Project Barun UI] Could not load UI Library (Local and Web both failed)")
end

local Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    Subtitle = "TITANIUM LUXE v5.1",
    Size = UDim2.new(0, 900, 0, 570),
    Name = "Barun_DemoSuite_v4",
    ToggleKey = Enum.KeyCode.RightShift,
    ToggleButton = true, -- Displays the sleek neon floating draggable toggle button on screen (PC & Mobile)
    Accent = Color3.fromRGB(113, 220, 225), -- Titanium Ice Cyan
})

-- Watermark
Window:SetWatermark("PROJECT BARUN | Titanium Luxe v5.1 | 60 FPS")
Window:SetWatermarkVisibility(true)

-- Welcome Toast
Window:Notify({
    Title = "Project Barun v5.1 Active",
    Content = "Titanium Luxe Glassmorphism & High-Performance Suite initialized!",
    Duration = 4,
    Type = "success"
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: MAIN COMBAT (OBSIDIAN DUAL-COLUMN GROUPBOX DEMO)
-- ─────────────────────────────────────────────────────────────────────
local TabMain = Window:CreateTab({
    Name = "Main Farm",
    Icon = "⚔️",
})

-- Left Groupbox: Combat Automation
local LeftBox = TabMain:AddLeftGroupbox("Automation Engine")

local FarmToggle = LeftBox:AddToggle("AutoFarm", {
    Text = "Auto Farm Level (ฟาร์มเลเวลอัตโนมัติ)",
    Desc = "วาร์ปขึ้นเหนือหัวมอนสเตอร์ในระยะปลอดภัย พร้อมตีต่อเนื่อง",
    Default = false,
    Callback = function(v)
        Window:Notify({
            Title = "Auto Farm",
            Content = v and "Started auto level farming!" or "Stopped.",
            Type = v and "success" or "warning"
        })
    end
})
-- Inline Keybind attachment (Obsidian / Linoria style)
FarmToggle:AddKeybind("AutoFarmKey", { Default = Enum.KeyCode.F, Mode = "Toggle" })

LeftBox:AddToggle("FastAttack", {
    Text = "Fast Attack (โจมตีความเร็วสูง)",
    Desc = "ข้ามดีเลย์แอนิเมชันสวิงอาวุธ 100%",
    Default = true,
})

LeftBox:AddSlider("FarmDistance", {
    Text = "Farm Distance (ระยะห่างจากมอน)",
    Min = 5,
    Max = 30,
    Default = 12,
    Rounding = 1,
    Suffix = " studs",
})

LeftBox:AddButton({
    Text = "Fast Equip Weapon",
    Func = function()
        Window:Notify({ Title = "Weapon", Content = "Equipped weapon!", Type = "info" })
    end,
})

-- Right Groupbox: Telemetry & Targets
local RightBox = TabMain:AddRightGroupbox("Target & Telemetry")

RightBox:AddLabel("Status: Active and monitoring entities", true)
RightBox:AddDivider()

RightBox:AddDropdown("MobSelect", {
    Text = "Select Target Mob",
    Values = { "Bandit [Lv. 1]", "Pirate [Lv. 15]", "Marine [Lv. 30]", "Boss Dragon [Lv. 100]" },
    Default = "Bandit [Lv. 1]",
})

RightBox:AddDropdown("AttackModes", {
    Text = "Attack Method",
    Values = { "Melee Priority", "Sword Slash", "Fruit Skill Chain", "Gun Snipe" },
    Default = { "Melee Priority", "Fruit Skill Chain" },
    Multi = true,
})

RightBox:AddInput("CustomTarget", {
    Text = "Custom Target Name",
    Placeholder = "Enter mob name...",
    Default = "",
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2: ECONOMY & DUNGEONS
-- ─────────────────────────────────────────────────────────────────────
local TabEcon = Window:CreateTab({
    Name = "Economy",
    Icon = "💰",
})

local EconLeft = TabEcon:AddLeftGroupbox("Chests & Grinding")
EconLeft:AddToggle("AutoChest", {
    Text = "Auto Collect Chests (เก็บหีบทั่วแมพ)",
    Default = false,
})

EconLeft:AddDropdown("ProtectedItems", {
    Text = "Protected Items (ห้ามขาย)",
    Values = { "Mythical", "Legendary", "Equipped", "Plotted", "Locked" },
    Default = { "Mythical", "Legendary", "Equipped" },
    Multi = true,
})

local EconRight = TabEcon:AddRightGroupbox("Dungeon & Raids")
EconRight:AddDropdown("DungeonSelect", {
    Text = "Target Dungeon",
    Values = { "Dragon Tower", "Infinity Tower", "Raid Boss Arena", "Ghost Cavern" },
    Default = "Dragon Tower",
})

EconRight:AddToggle("AutoReplay", {
    Text = "Auto Replay on Finish",
    Default = true,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 3: SETTINGS (INTEGRATED SAVEMANAGER & THEMEMANAGER)
-- ─────────────────────────────────────────────────────────────────────
local TabSettings = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙️",
})

-- Built-in Obsidian SaveManager (Saves all configs to JSON automatically)
UI.SaveManager:SetFolder("ProjectBarun/Configs/BarunMaster")
UI.SaveManager:BuildConfigSection(TabSettings)

-- Built-in Obsidian ThemeManager (Theme switcher and hotkey manager)
UI.ThemeManager:ApplyToTab(TabSettings)

print("💎 [PROJECT BARUN] UI v4.5 HYBRID OBSIDIAN SUITE INITIALIZED!")
