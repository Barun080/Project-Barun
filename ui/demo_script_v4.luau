--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — UI v4.0 MASTER DEMONSTRATION SUITE        ║
    ║        Features: Mobile Floating Orb, Real-Time Search, 5 Pillars        ║
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
    Subtitle = "AURORA ELITE v4.0",
    Size = UDim2.new(0, 840, 0, 520),
    Name = "Barun_DemoSuite_v4",
    ToggleKey = Enum.KeyCode.RightShift,
    MobileButton = true, -- Displays the sleek neon floating draggable button for mobile players
    Accent = Color3.fromRGB(34, 211, 238), -- Electric Cyan
})

-- Welcome Toast
Window:Notify({
    Title = "Welcome to Barun v4.0",
    Content = "Mobile Floating Orb & Real-Time Search active!",
    Duration = 4,
    Type = "success"
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: MAIN FARM (5-PILLAR STANDARD)
-- ─────────────────────────────────────────────────────────────────────
local TabMain = Window:CreateTab({
    Name = "Main Farm",
    Icon = "⚔️",
    Subtitle = "Core Farm Loop & Live Telemetry"
})

TabMain:AddSection("LIVE TELEMETRY")
local CardRolls = TabMain:AddStatCard({
    Title = "Session Actions",
    Value = "1,420",
    Subtext = "Total automated clicks",
    Progress = 0.65
})

TabMain:AddSection("AUTOMATED COMBAT ENGINE")
TabMain:AddToggle({
    Name = "Auto Farm Level (ฟาร์มเลเวลอัตโนมัติ)",
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

TabMain:AddToggle({
    Name = "Fast Attack (โจมตีความเร็วสูง)",
    Desc = "ข้ามดีเลย์แอนิเมชันสวิงอาวุธ 100%",
    Default = true,
    Callback = function(v) end
})

TabMain:AddSlider({
    Name = "Farm Distance (ระยะห่างจากมอนสเตอร์)",
    Min = 5,
    Max = 30,
    Default = 12,
    Increment = 1,
    ValueName = "studs",
    Callback = function(v) end
})

TabMain:AddButton({
    Name = "Fast Equip Melee (สวมใส่หมัดทันที)",
    Icon = "👊",
    Callback = function()
        Window:Notify({ Title = "Weapon", Content = "Melee equipped!", Type = "info" })
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2: ECONOMY
-- ─────────────────────────────────────────────────────────────────────
local TabEcon = Window:CreateTab({
    Name = "Economy",
    Icon = "💰",
    Subtitle = "Auto Sell & Chest Collection"
})

TabEcon:AddSection("CHEST FARMING")
TabEcon:AddToggle({
    Name = "Auto Collect Chests (เก็บหีบทั่วแมพ)",
    Default = false,
    Callback = function(v) end
})

TabEcon:AddDropdown({
    Name = "Select Items to Protect (ห้ามขาย)",
    Options = { "Mythical", "Legendary", "Equipped", "Plotted", "Locked" },
    Default = { "Mythical", "Legendary", "Equipped" },
    MultiSelect = true, -- Multi-select support!
    Callback = function(selected)
        print("Protected items:", table.concat(selected, ", "))
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 3: CONTENT
-- ─────────────────────────────────────────────────────────────────────
local TabContent = Window:CreateTab({
    Name = "Content",
    Icon = "🏰",
    Subtitle = "Dungeons & Mini-games"
})

TabContent:AddSection("DUNGEON SELECTOR")
TabContent:AddDropdown({
    Name = "Target Dungeon",
    Options = { "Dragon Tower", "Infinity Tower", "Raid Boss Arena", "Ghost Cavern" },
    Default = "Dragon Tower",
    Callback = function(v)
        Window:Notify({ Title = "Target Selected", Content = "Dungeon set to: " .. v, Type = "info" })
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 4: PROGRESSION
-- ─────────────────────────────────────────────────────────────────────
local TabProg = Window:CreateTab({
    Name = "Progression",
    Icon = "📈",
    Subtitle = "Stats & Upgrades"
})

TabProg:AddSection("AUTO STATS DISTRIBUTION")
TabProg:AddToggle({
    Name = "Auto Allocate Melee (+3 Points)",
    Default = false,
    Callback = function(v) end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 5: SETTINGS
-- ─────────────────────────────────────────────────────────────────────
local TabSettings = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙️",
    Subtitle = "Anti-AFK & Performance"
})

TabSettings:AddSection("SAFETY & PERFORMANCE")
TabSettings:AddToggle({
    Name = "Triple-Layer Anti-AFK (24/7 กันหลุด)",
    Desc = "ป้องกันเกมเตะออกหลังจากไม่ขยับตัว 20 นาที",
    Default = true,
    Callback = function(v) end
})

TabSettings:AddToggle({
    Name = "Mobile FPS Boost (120 FPS Cap & Shadow Stripper)",
    Default = false,
    Callback = function(v) end
})

TabSettings:AddKeybind({
    Name = "Toggle UI Hotkey",
    Default = Enum.KeyCode.RightShift,
    Callback = function(k)
        print("Hotkey changed to:", k.Name)
    end
})

TabSettings:AddButton({
    Name = "Rejoin Current Server",
    Icon = "🔄",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
    end
})

print("💎 [PROJECT BARUN] UI v4.0 MASTER SUITE LAUNCHED!")
