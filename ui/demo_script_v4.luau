--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — UI v4.5 MASTER DEMONSTRATION SUITE        ║
    ║        Hybrid Obsidian Engine + Neo-Cyber Glassmorphism Architecture     ║
    ║        Features: Dual Groupboxes, SaveManager, ThemeManager, Mobile Orb   ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local UI = nil

-- Check local workspace file safely without throwing
if isfile and isfile("ui/ui_template_master_v4.luau") and loadfile then
    local ok, res = pcall(function()
        return loadfile("ui/ui_template_master_v4.luau")()
    end)
    if ok and res then
        UI = res
    end
end

-- Fallback to GitHub via HttpGet
if not UI then
    local ok, raw = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/Barun080/Project-Barun/main/ui/ui_template_master_v4.luau?v=" .. tick())
    end)
    if ok and raw then
        local chunk, err = loadstring(raw)
        if chunk then
            UI = chunk()
        else
            warn("[Project Barun UI] Failed to compile downloaded UI: " .. tostring(err))
        end
    else
        warn("[Project Barun UI] Failed to fetch UI from GitHub!")
    end
end

if not UI then
    error("[Project Barun UI] Could not load UI Library (Local and Web both failed)")
end

local Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    Subtitle = "OBSIDIAN HYBRID v4.5",
    Size = UDim2.new(0, 840, 0, 520),
    Name = "Barun_DemoSuite_v4",
    ToggleKey = Enum.KeyCode.RightShift,
    MobileButton = true, -- Displays the sleek neon floating draggable button for mobile players
    Accent = Color3.fromRGB(34, 211, 238), -- Electric Cyan
})

-- Watermark
Window:SetWatermark("PROJECT BARUN | Obsidian Glass v4.5 | 60 FPS")
Window:SetWatermarkVisibility(true)

-- Welcome Toast
Window:Notify({
    Title = "Welcome to Barun v4.5",
    Content = "Dual-Column Groupbox, SaveManager & ThemeManager active!",
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
