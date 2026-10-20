--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — OUROBOROS OBSIDIAN EDITION v5.5           ║
    ║        Anime Dice: Halloween Event & 2K Ultra Automation Suite           ║
    ║        Engineered with Mimi Precision for Clack's Arsenal                ║
    ║                   https://github.com/Barun080/Project-Barun              ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ═════════════════════════════════════════════════════════════════════
-- 1. INSTANCE HYGIENE & CLEANUP
-- ═════════════════════════════════════════════════════════════════════
local myToken = tick()
_G.AnimeDiceActiveToken = myToken

if _G.AnimeDice_Cleanup then
    pcall(_G.AnimeDice_Cleanup)
    task.wait(0.2)
end

local Running = true
_G.AnimeDiceRunning = true

_G.AnimeDice_Cleanup = function()
    Running = false
    _G.AnimeDiceRunning = false
    pcall(function()
        local h = gethui and gethui() or game:GetService("CoreGui")
        for _, g in ipairs(h:GetChildren()) do
            if g.Name == "Obsidian" or g.Name == "PB_MobileToggleOrb" or g.Name == "ProjectBarun_AnimeDice" or g.Name == "ProjectBarun_MasterUI" then
                g:Destroy()
            end
        end
        local lp = game:GetService("Players").LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetChildren()) do
                if g.Name == "Obsidian" or g.Name == "PB_MobileToggleOrb" or g.Name == "ProjectBarun_AnimeDice" or g.Name == "ProjectBarun_MasterUI" then
                    g:Destroy()
                end
            end
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- 2. OBSIDIAN UI MASTER LOADER (OUROBOROS ENGINE WITH CACHING)
-- ═════════════════════════════════════════════════════════════════════
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"

local function loadObsidianComponent(fileName)
    local cachePath = "Obsidian_" .. fileName:gsub("[^%w_%-]", "_") .. ".luau"
    if readfile and isfile and isfile(cachePath) then
        local okRead, content = pcall(readfile, cachePath)
        if okRead and content and #content > 2000 then
            local fn, err = loadstring(content)
            if fn then return fn() end
        end
    end
    local raw = game:HttpGet(repo .. fileName, true)
    if writefile and raw and #raw > 2000 then
        pcall(writefile, cachePath, raw)
    end
    local fn = loadstring(raw)
    return fn()
end

local Library = loadObsidianComponent("Library.lua")
local ThemeManager = loadObsidianComponent("addons/ThemeManager.lua")
local SaveManager = loadObsidianComponent("addons/SaveManager.lua")

-- ═════════════════════════════════════════════════════════════════════
-- 3. CORE SERVICES & DEPENDENCIES
-- ═════════════════════════════════════════════════════════════════════
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local TeleportService   = game:GetService("TeleportService")
local VirtualUser       = game:GetService("VirtualUser")
local TweenService      = game:GetService("TweenService")
local HttpService       = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local LP = LocalPlayer

-- ═════════════════════════════════════════════════════════════════════
-- 4. NETWORK REMOTES (CORE + HALLOWEEN & PROGRESSION UPD)
-- ═════════════════════════════════════════════════════════════════════
local Network = ReplicatedStorage:WaitForChild("Network", 10) or ReplicatedStorage:FindFirstChild("Network")

local RollService            = Network and Network:WaitForChild("RollService", 10)
local PlotService            = Network and Network:WaitForChild("PlotService", 10)
local RebirthService         = Network and Network:FindFirstChild("RebirthService")
local DiceShopService        = Network and Network:FindFirstChild("DiceShopService")
local DailyRewardService     = Network and Network:FindFirstChild("DailyRewardService")
local GroupRewardService     = Network and Network:FindFirstChild("GroupRewardService")
local OfflineEarningsService = Network and Network:FindFirstChild("OfflineEarningsService")
local SpinService            = Network and Network:FindFirstChild("SpinService")
local TowersNet              = Network and Network:FindFirstChild("Towers")
local GradeNetwork           = Network and Network:FindFirstChild("GradeService")
local SellNetwork            = Network and Network:FindFirstChild("SellService")
local BoostNetwork           = Network and Network:FindFirstChild("BoostService")

local UpgradeServiceRE = Network and Network:FindFirstChild("RE") and Network.RE:FindFirstChild("BuyUpgrade")
local BoostUseRE       = BoostNetwork and BoostNetwork:FindFirstChild("RE") and BoostNetwork.RE:FindFirstChild("Use")

-- Towers Remotes
local EquipBestTowerTeamRE = TowersNet and TowersNet:FindFirstChild("RE") and TowersNet.RE:FindFirstChild("EquipBestTowerTeam")
local PlayTowerRF          = TowersNet and TowersNet:FindFirstChild("RF") and TowersNet.RF:FindFirstChild("PlayTower")
local CompleteTowerFloorRF = TowersNet and TowersNet:FindFirstChild("RF") and TowersNet.RF:FindFirstChild("CompleteTowerFloor")
local CancelTowerRF        = TowersNet and TowersNet:FindFirstChild("RF") and TowersNet.RF:FindFirstChild("CancelTower")

-- Grade Remotes
local RollGradeRE          = GradeNetwork and GradeNetwork:FindFirstChild("RE") and GradeNetwork.RE:FindFirstChild("Roll")
local SetGradeProtectedRE  = GradeNetwork and GradeNetwork:FindFirstChild("RE") and GradeNetwork.RE:FindFirstChild("SetGradeProtected")

-- Trait Remotes
local TraitNetwork         = Network and (Network:FindFirstChild("TraitService") or Network:FindFirstChild("TraitsService") or Network:FindFirstChild("Traits") or Network:FindFirstChild("Trait"))
local RollTraitRE          = TraitNetwork and TraitNetwork:FindFirstChild("RE") and (TraitNetwork.RE:FindFirstChild("Roll") or TraitNetwork.RE:FindFirstChild("Reroll") or TraitNetwork.RE:FindFirstChild("RollTrait"))
local RollTraitRF          = TraitNetwork and TraitNetwork:FindFirstChild("RF") and (TraitNetwork.RF:FindFirstChild("Roll") or TraitNetwork.RF:FindFirstChild("Reroll") or TraitNetwork.RF:FindFirstChild("RollTrait"))

local function resolveTraitRemote()
    if RollTraitRE then return RollTraitRE, false end
    if RollTraitRF then return RollTraitRF, true end
    if Network then
        for _, desc in ipairs(Network:GetDescendants()) do
            local dName = desc.Name:lower()
            local pName = desc.Parent and desc.Parent.Name:lower() or ""
            local isTrait = dName:find("trait") or pName:find("trait")
            local isRoll = dName:find("roll") or dName:find("reroll")
            if isTrait and isRoll then
                if desc:IsA("RemoteEvent") then
                    RollTraitRE = desc
                    return desc, false
                elseif desc:IsA("RemoteFunction") then
                    RollTraitRF = desc
                    return desc, true
                end
            end
        end
    end
    return nil, false
end

-- Lucky Wheel & Sell Remotes
local SpinWheelRE     = SpinService and SpinService:FindFirstChild("RE") and (SpinService.RE:FindFirstChild("Use") or SpinService.RE:FindFirstChild("Spin"))
local SellInventoryRF = SellNetwork and SellNetwork:FindFirstChild("RF") and SellNetwork.RF:FindFirstChild("SellInventory")

-- Halloween & Progression Remotes
local HalloweenNet           = Network and Network:FindFirstChild("HalloweenService")
local PumpkinDiceNet         = Network and Network:FindFirstChild("PumpkinDiceService")
local HalloweenQuestNet      = Network and Network:FindFirstChild("HalloweenQuestService")
local TrickOrTreatNet        = Network and Network:FindFirstChild("TrickOrTreatService")
local QuirkNet               = Network and Network:FindFirstChild("QuirkService")
local FusingNet              = Network and Network:FindFirstChild("FusingService")

local HalloweenTeleportRF    = HalloweenNet and HalloweenNet:FindFirstChild("RF") and HalloweenNet.RF:FindFirstChild("Teleport")
local PumpkinPassClaimAllRE  = HalloweenNet and HalloweenNet:FindFirstChild("RE") and HalloweenNet.RE:FindFirstChild("ClaimAllPath")
local PumpkinPassClaimTierRE = HalloweenNet and HalloweenNet:FindFirstChild("RE") and HalloweenNet.RE:FindFirstChild("ClaimPath")

local PumpkinDiceRollRF      = PumpkinDiceNet and PumpkinDiceNet:FindFirstChild("RF") and PumpkinDiceNet.RF:FindFirstChild("Roll")
local PumpkinDiceAutoSellRE  = PumpkinDiceNet and PumpkinDiceNet:FindFirstChild("RE") and PumpkinDiceNet.RE:FindFirstChild("SetAutoSell")

local HalloweenQuestClaimRE  = HalloweenQuestNet and HalloweenQuestNet:FindFirstChild("RE") and HalloweenQuestNet.RE:FindFirstChild("Claim")
local TrickDoorKnockedRE     = TrickOrTreatNet and TrickOrTreatNet:FindFirstChild("RE") and TrickOrTreatNet.RE:FindFirstChild("Knocked")

local QuirkRollRE            = QuirkNet and QuirkNet:FindFirstChild("RE") and QuirkNet.RE:FindFirstChild("Roll")
local QuirkProtectRE         = QuirkNet and QuirkNet:FindFirstChild("RE") and QuirkNet.RE:FindFirstChild("SetQuirkProtected")

local FuseUnitsRE            = FusingNet and FusingNet:FindFirstChild("RE") and FusingNet.RE:FindFirstChild("Fuse")

-- ═════════════════════════════════════════════════════════════════════
-- 5. FRAMEWORK MODULES & BUFFS
-- ═════════════════════════════════════════════════════════════════════
local Framework = ReplicatedStorage:WaitForChild("Framework", 10) or ReplicatedStorage:FindFirstChild("Framework")
local Features  = Framework and Framework:WaitForChild("Features", 10)

local DataController    = nil
local UnitUtil          = nil
local EntryRegistry     = nil
local GradesModule      = nil
local TreeStructure     = nil
local RebirthsModule    = nil
local UpgradesModule    = nil
local DiceModule        = nil
local GroupRewardConfig = nil
local BoostController   = nil
local BoostConfig       = nil
local EntryController   = nil
local TowerController   = nil
local BuffController    = nil
local UIReferences      = nil

pcall(function() DataController    = require(Features.Data.DataController) end)
pcall(function() UnitUtil          = require(Features.Inventory.Kinds.Unit.UnitUtil) end)
pcall(function() EntryRegistry     = require(Features.Inventory.EntryRegistry) end)
pcall(function() EntryController   = require(Features.Inventory.EntryController) end)
pcall(function() GradesModule      = require(Features.Grades.Grades) end)
pcall(function() TreeStructure     = require(Features.Upgrades.TreeStructure) end)
pcall(function() RebirthsModule    = require(Features.Rebirth.Rebirths) end)
pcall(function() UpgradesModule    = require(Features.Upgrades.Upgrades) end)
pcall(function() DiceModule        = require(Features.Rolling.Dice) end)
pcall(function() GroupRewardConfig = require(Features.Rewards.GroupRewardConfig) end)
pcall(function() BoostController   = require(Features.Inventory.Kinds.Boost.BoostController) end)
pcall(function() BoostConfig       = require(Features.Inventory.Kinds.Boost.BoostConfig) end)
pcall(function() BuffController    = require(Features.Buffs.BuffController) end)
pcall(function() TowerController   = require(Features.Towers.TowerController) end)
pcall(function() UIReferences      = require(Features.UI.UIReferences) end)

local function getAllBoostNames()
    local names = {}
    local nameSet = {}
    pcall(function()
        if BoostConfig and BoostConfig.entries then
            for name, _ in pairs(BoostConfig.entries) do
                if not nameSet[name] then
                    nameSet[name] = true
                    table.insert(names, name)
                end
            end
        end
    end)
    pcall(function()
        if DataController and DataController.Inventory then
            for _, unitFn in pairs(DataController.Inventory) do
                local uData = type(unitFn) == "function" and unitFn() or unitFn
                if uData and uData.kind == "Boost" and uData.name and not nameSet[uData.name] then
                    nameSet[uData.name] = true
                    table.insert(names, uData.name)
                end
            end
        end
    end)
    table.sort(names)
    return names
end

local TowerList = {
    "Dragon Tower",
    "Hidden Leaf Tower",
    "Infinity Tower",
    "Shadow Tower",
    "Cursed Tower",
    "Pirate Tower",
    "Slayer Tower",
    "Front Yard",
    "Foyer",
    "Attic",
    "Crypt",
    "Bell Tower",
    "The Abyss"
}

-- ═════════════════════════════════════════════════════════════════════
-- 6. SCRIPT CONFIGURATION & RUNTIME STATE
-- ═════════════════════════════════════════════════════════════════════
local Config = {
    -- Anti-AFK
    AntiAFK = true,

    -- Rolling
    AutoRoll = false,
    SkipCutscene = false,
    RollSpeedDelay = 0.05,
    BurstRolls = false,
    BurstRollCount = 3,

    -- Plot & Slots
    AutoFarmPlot = false,
    AutoCollectChest = false,
    AutoEquipBestPlot = false,
    AutoUpgradeSlots = false,
    TargetSlotLevel = 25,

    -- Halloween Event
    AutoClaimPumpkinPass = false,
    AutoRollPumpkinDice = false,
    PumpkinDiceRollMode = "Multi (5 Rolls / 500 🎃)",
    PumpkinDiceDelay = 0.35,
    AutoClaimHalloweenQuests = false,
    AutoKnockHalloweenDoors = false,

    -- Units & Grades
    AutoRerollGrade = false,
    TargetGrade = "S+",
    GradeRollMode = "All Plotted Units",
    TargetGradeUnitKey = "",
    GradeRollDelay = 0.25,
    ServerProtectGrades = {
        ["S"]  = true,
        ["S+"] = true,
        ["Z"]  = true,
        ["Z+"] = true,
        ["神"] = true,
    },

    -- Traits
    AutoRerollTrait = false,
    TargetTrait = "Godly",
    TraitRollMode = "All Plotted Units",
    TargetTraitUnitKey = "",
    TraitRollDelay = 0.35,

    -- Quirks
    AutoRerollQuirks = false,
    QuirkRollMode = "All Plotted Units",
    TargetQuirkUnitKey = "",
    QuirkRollDelay = 0.3,
    SelectedTargetQuirks = {
        ["Fortune's Favor"] = true,
        ["Midas Touch"] = true,
        ["Prodigy"] = true,
        ["Tycoon"] = true,
        ["Fortune III"] = true,
        ["Wealth III"] = true,
        ["Gifted III"] = true,
        ["Swift III"] = true,
    },

    -- Towers
    AutoTowers                  = false,
    SelectedTower               = TowerList[1],
    TargetTowerFloor            = 200,
    AutoTowerFloorDelay         = 0.15,
    HideTowerScreen             = true,
    AutoCycleTowers             = false,
    AutoUseDamagePotionsInTower = true,
    AutoRetryFailedFloor        = true,
    EndlessInfinityMode         = false,

    -- Economy & Sell
    AutoSellUnits = false,
    SelectedSellRarities = {
        ["Common"] = false,
        ["Uncommon"] = false,
        ["Rare"] = false,
        ["Epic"] = false,
    },
    ProtectPlottedUnits = false,
    ProtectTowerTeam = false,
    ProtectLockedUnits = false,
    ProtectGradeSPlus = false,

    -- Rebirth & Upgrades
    AutoRebirth = false,
    TargetRebirth = 12,
    AutoUpgrades = false,
    AutoBuyDice = false,

    -- Potions
    AutoUseAllOwned = false,
    AutoUsePotions = false,
    ActivePotions = {},
    ItemUseCondition = "กดใช้ทันที / ซ้อนเวลา (Always Use)",
    PotionInterval = 2,

    -- Free Rewards & Misc
    AutoClaimRewards = false,
    AutoSpinWheel = false,

    -- Visuals & Physics
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
    JumpPowerEnabled = false,
    JumpPowerValue = 50,
    FlyEnabled = false,
    FlySpeed = 50,
    Noclip = false,
    InfiniteJump = false,
    FPSBooster = false,
    FullBright = false,
    GodAura = false,
}

local State = {
    TotalRollsSession = 0,
    TotalRebirthsSession = 0,
    TotalPotionsUsedSession = 0,
    GradeRerollsSession = 0,
    TraitRerollsSession = 0,
    CurrentTowerStatus = "Standby",
}

-- ═════════════════════════════════════════════════════════════════════
-- 7. NOTIFICATION SYSTEM HELPER
-- ═════════════════════════════════════════════════════════════════════
local function notify(title, content, dur)
    pcall(function()
        Library:Notify({
            Title = tostring(title or "PROJECT BARUN"),
            Description = tostring(content or ""),
            Time = tonumber(dur) or 3.5
        })
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- 8. CORE GAMEPLAY HOOKS & AUTOMATION ENGINES
-- ═════════════════════════════════════════════════════════════════════
-- Cutscene Bypass
local function SetupCutsceneBypass()
    pcall(function()
        if Features and Features:FindFirstChild("Rolling") then
            local rollController = require(Features.Rolling.RollController)
            if rollController then
                rollController.PlayCutscene = function(...)
                    if Config.SkipCutscene then return end
                end
            end
        end
    end)
    pcall(function()
        if Framework and Framework:FindFirstChild("Utils") then
            local camShaker = require(Framework.Utils.CameraShaker)
            if camShaker then
                camShaker.Shake = function(...) if Config.SkipCutscene then return end end
                camShaker.ShakeOnce = function(...) if Config.SkipCutscene then return end end
            end
        end
    end)
end
SetupCutsceneBypass()

-- Anti-AFK System
pcall(function()
    local afkScript = LP.PlayerScripts:FindFirstChild("AFK")
    if afkScript then
        afkScript.Disabled = true
        afkScript:Destroy()
    end
    if getconnections then
        for _, c in ipairs(getconnections(LP.Idled)) do
            pcall(function() c:Disable() end)
        end
    end
    LP.Idled:Connect(function()
        if Config.AntiAFK and VirtualUser then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.zero)
            end)
        end
    end)
end)

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        task.wait(35)
        if Config.AntiAFK and VirtualUser then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.zero)
            end)
        end
    end
end)

-- Auto Roll Dice Engine
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRoll and RollService and RollService.RF:FindFirstChild("RollDice") then
            local burst = Config.BurstRolls and math.clamp(Config.BurstRollCount or 3, 1, 10) or 1
            for b = 1, burst do
                task.spawn(function()
                    pcall(function()
                        RollService.RF.RollDice:InvokeServer()
                        State.TotalRollsSession = State.TotalRollsSession + 1
                    end)
                end)
            end
            task.wait(math.clamp(tonumber(Config.RollSpeedDelay) or 0.05, 0.01, 1))
        else
            task.wait(0.2)
        end
    end
end)

-- Plot & Money Sucking Engine
local function CollectAllMoney()
    pcall(function()
        for slotId = 1, 24 do
            if PlotService and PlotService.RE:FindFirstChild("CollectBalance") then
                PlotService.RE.CollectBalance:FireServer(slotId)
            end
        end
    end)
end

local function levelUpAllSlots()
    pcall(function()
        local curMoney = (DataController and DataController.Money and DataController.Money())
            or (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Money") and LP.leaderstats.Money.Value)
            or 0
        if curMoney <= 0 then return end
        local targetLvl = tonumber(Config.TargetSlotLevel) or 25
        for slot = 1, 24 do
            if PlotService and PlotService.RE:FindFirstChild("LevelUpSlot") then
                PlotService.RE.LevelUpSlot:FireServer(slot)
                task.wait(0.02)
            end
        end
    end)
end

local function TeleportToPlot()
    pcall(function()
        local plotCtrl = Features and Features:FindFirstChild("Plot") and require(Features.Plot.PlotController)
        local p = plotCtrl and plotCtrl.plot
        if p and p:FindFirstChild("Spawn") then
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = p.Spawn.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoFarmPlot then
            if Config.AutoCollectChest then CollectAllMoney() end
            if Config.AutoEquipBestPlot and PlotService and PlotService.RE:FindFirstChild("EquipBest") then
                pcall(function() PlotService.RE.EquipBest:FireServer() end)
            end
            if Config.AutoUpgradeSlots then levelUpAllSlots() end
            task.wait(3.0)
        else
            task.wait(0.5)
        end
    end
end)

-- Halloween Automation Engines
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoClaimPumpkinPass and PumpkinPassClaimAllRE then
            pcall(function() PumpkinPassClaimAllRE:FireServer() end)
            task.wait(10)
        else
            task.wait(2)
        end
    end
end)

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoClaimHalloweenQuests and HalloweenQuestClaimRE then
            pcall(function()
                for id = 1, 6 do HalloweenQuestClaimRE:FireServer("Daily", id) end
                for id = 1, 5 do HalloweenQuestClaimRE:FireServer("Hourly", id) end
            end)
            task.wait(15)
        else
            task.wait(3)
        end
    end
end)

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRollPumpkinDice and PumpkinDiceRollRF then
            pcall(function()
                local amount = (Config.PumpkinDiceRollMode and (Config.PumpkinDiceRollMode:find("Single") or Config.PumpkinDiceRollMode == "1")) and 1 or 5
                PumpkinDiceRollRF:InvokeServer(amount)
            end)
            task.wait(tonumber(Config.PumpkinDiceDelay) or 0.35)
        else
            task.wait(0.5)
        end
    end
end)

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoKnockHalloweenDoors and TrickDoorKnockedRE then
            pcall(function()
                local halloweenFolder = workspace:FindFirstChild("Halloween")
                if halloweenFolder then
                    for _, obj in ipairs(halloweenFolder:GetDescendants()) do
                        if obj.Name == "TrickOrTreatDoor" or obj:GetAttribute("DoorId") or obj.Name:find("Door") then
                            TrickDoorKnockedRE:FireServer(obj)
                            task.wait(0.2)
                        end
                    end
                end
            end)
            task.wait(15)
        else
            task.wait(3)
        end
    end
end)

-- Quirks Auto-Reroll Engine
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRerollQuirks and QuirkRollRE then
            pcall(function()
                if Config.QuirkRollMode == "Selected Unit" then
                    if Config.TargetQuirkUnitKey and Config.TargetQuirkUnitKey ~= "" then
                        QuirkRollRE:FireServer(Config.TargetQuirkUnitKey)
                    end
                else
                    if DataController and DataController.Slots then
                        for slot = 1, 24 do
                            if not Config.AutoRerollQuirks then break end
                            local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                            if sData and sData.unitId then
                                QuirkRollRE:FireServer(sData.unitId)
                                task.wait(tonumber(Config.QuirkRollDelay) or 0.3)
                            end
                        end
                    end
                end
            end)
            task.wait(tonumber(Config.QuirkRollDelay) or 0.3)
        else
            task.wait(0.5)
        end
    end
end)

-- Free Rewards Engine
local function ClaimAllRewards()
    pcall(function()
        if DailyRewardService and DailyRewardService:FindFirstChild("RE") and DailyRewardService.RE:FindFirstChild("Claim") then
            DailyRewardService.RE.Claim:FireServer()
        end
        if OfflineEarningsService and OfflineEarningsService:FindFirstChild("RE") and OfflineEarningsService.RE:FindFirstChild("Claim") then
            OfflineEarningsService.RE.Claim:FireServer()
        end
        if SpinService and SpinService:FindFirstChild("RE") and SpinService.RE:FindFirstChild("Use") then
            SpinService.RE.Use:FireServer()
        end
    end)
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoClaimRewards then
            ClaimAllRewards()
            task.wait(15)
        else
            task.wait(5)
        end
    end
end)

-- ═════════════════════════════════════════════════════════════════════
-- 9. CREATE OUROBOROS OBSIDIAN WINDOW & TABS
-- ═════════════════════════════════════════════════════════════════════
local Window = Library:CreateWindow({
    Title = "PROJECT BARUN",
    SubTitle = "Anime Dice [Halloween UPD]",
    TabPadding = 6,
    MenuFadeTime = 0.2,
    ShowMobileButtons = true,
    CornerRadius = 6,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Halloween = Window:AddTab("Halloween"),
    Units = Window:AddTab("Units & Gacha"),
    Dungeons = Window:AddTab("Dungeons"),
    Economy = Window:AddTab("Economy"),
    Misc = Window:AddTab("Misc"),
    ["UI Settings"] = Window:AddTab("UI Settings"),
}

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: MAIN (ฟาร์มหลัก & สล็อตเกาะ)
-- ─────────────────────────────────────────────────────────────────────
local LeftMain = Tabs.Main:AddLeftGroupbox("Dice Rolling")
LeftMain:AddToggle("AutoRoll", {
    Text = "Auto Roll Dice (ทอยเต๋าออโต้)",
    Default = Config.AutoRoll,
    Tooltip = "ทอยต่อเนื่องความเร็วสูงด้วยแพ็กเก็ตปลอดภัย",
    Callback = function(v) Config.AutoRoll = v end
})
LeftMain:AddToggle("SkipCutscene", {
    Text = "Skip Cutscene & Shakes (ตัดแอนิเมชัน)",
    Default = Config.SkipCutscene,
    Tooltip = "ตัดแอนิเมชันลูกเต๋า 100% หน้าจอไม่สั่น",
    Callback = function(v)
        Config.SkipCutscene = v
        SetupCutsceneBypass()
    end
})
LeftMain:AddSlider("RollSpeedDelay", {
    Text = "Roll Speed Delay (ความเร็วการทอย)",
    Min = 0.01,
    Max = 0.5,
    Default = Config.RollSpeedDelay,
    Rounding = 2,
    Suffix = "s",
    Callback = function(v) Config.RollSpeedDelay = v end
})
LeftMain:AddToggle("BurstRolls", {
    Text = "Hyper Burst Rolls (ทอยรัวแพ็กเก็ต)",
    Default = Config.BurstRolls,
    Callback = function(v) Config.BurstRolls = v end
})
LeftMain:AddSlider("BurstCount", {
    Text = "Burst Multiplier",
    Min = 1,
    Max = 10,
    Default = Config.BurstRollCount,
    Rounding = 0,
    Suffix = "x",
    Callback = function(v) Config.BurstRollCount = v end
})
LeftMain:AddButton({
    Text = "Roll Dice 1x Now (ทดลองทอย 1 ครั้ง)",
    Func = function()
        if RollService and RollService.RF:FindFirstChild("RollDice") then
            RollService.RF.RollDice:InvokeServer()
            notify("Roll Dice", "Fired 1x roll successfully!", 2.5)
        end
    end
})

local RightMain = Tabs.Main:AddRightGroupbox("Island & Plot Balance")
RightMain:AddToggle("AutoFarmPlot", {
    Text = "Auto Farm Plot (เปิดระบบดูดเงินเกาะ)",
    Default = Config.AutoFarmPlot,
    Callback = function(v) Config.AutoFarmPlot = v end
})
RightMain:AddToggle("AutoCollectChest", {
    Text = "Auto Collect Money (ดูดเงิน 24 สล็อต)",
    Default = Config.AutoCollectChest,
    Callback = function(v) Config.AutoCollectChest = v end
})
RightMain:AddToggle("AutoEquipBestPlot", {
    Text = "Auto Equip Best Plot Units (ใส่อนิเมะผลิตเงินสูงสุด)",
    Default = Config.AutoEquipBestPlot,
    Callback = function(v) Config.AutoEquipBestPlot = v end
})
RightMain:AddToggle("AutoUpgradeSlots", {
    Text = "Auto Upgrade Slots (อัพเกรดสล็อต)",
    Default = Config.AutoUpgradeSlots,
    Callback = function(v) Config.AutoUpgradeSlots = v end
})
RightMain:AddSlider("TargetSlotLevel", {
    Text = "Target Slot Level (เลเวลสล็อตเป้าหมาย)",
    Min = 1,
    Max = 25,
    Default = Config.TargetSlotLevel,
    Rounding = 0,
    Callback = function(v) Config.TargetSlotLevel = v end
})
RightMain:AddButton({
    Text = "Force Collect All Money Now (ดูดเงินทันที)",
    Func = function()
        CollectAllMoney()
        notify("Collect Money", "Collected balance from all 24 slots!", 2.5)
    end
})
RightMain:AddButton({
    Text = "Teleport to Island Spawn (วาร์ปไปเกาะตนเอง)",
    Func = function()
        TeleportToPlot()
        notify("Teleport", "Teleported to island!", 2.5)
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2: HALLOWEEN (อีเวนต์ฮาโลวีน & PUMPKIN DICE)
-- ─────────────────────────────────────────────────────────────────────
local LeftHallow = Tabs.Halloween:AddLeftGroupbox("Halloween Island & Pass")
LeftHallow:AddButton({
    Text = "🎃 Teleport to Halloween Island (วาร์ปไปเกาะฮาโลวีน)",
    Func = function()
        pcall(function()
            if HalloweenTeleportRF then
                HalloweenTeleportRF:InvokeServer("Island")
                notify("Halloween", "Teleported to Halloween Island!", 2.5)
            end
        end)
    end
})
LeftHallow:AddButton({
    Text = "🏛️ Return to Main Hub (วาร์ปกลับเกาะหลัก)",
    Func = function()
        pcall(function()
            if HalloweenTeleportRF then
                HalloweenTeleportRF:InvokeServer("Hub")
                notify("Halloween", "Returned to Main Hub!", 2.5)
            end
        end)
    end
})
LeftHallow:AddDivider()
LeftHallow:AddToggle("AutoClaimPumpkinPass", {
    Text = "Auto Claim Pumpkin Pass (รับรางวัลพาสออโต้)",
    Default = Config.AutoClaimPumpkinPass,
    Callback = function(v) Config.AutoClaimPumpkinPass = v end
})
LeftHallow:AddButton({
    Text = "🎁 Claim All Pass Rewards Now (กดรับรางวัลพาสทั้งหมดทันที)",
    Func = function()
        pcall(function()
            if PumpkinPassClaimAllRE then
                PumpkinPassClaimAllRE:FireServer()
                notify("Pumpkin Pass", "Claimed all unlocked pass rewards!", 2.5)
            end
        end)
    end
})

local RightHallow = Tabs.Halloween:AddRightGroupbox("Pumpkin Dice & Quests")
RightHallow:AddToggle("AutoRollPumpkinDice", {
    Text = "Auto Roll Pumpkin Dice (ทอยเต๋าฟักทองออโต้)",
    Default = Config.AutoRollPumpkinDice,
    Callback = function(v) Config.AutoRollPumpkinDice = v end
})
RightHallow:AddDropdown("PumpkinDiceMode", {
    Text = "Pumpkin Roll Mode (โหมดการทอย)",
    Values = { "Multi (5 Rolls / 500 🎃)", "Single (1 Roll / 100 🎃)" },
    Default = Config.PumpkinDiceRollMode,
    Callback = function(v) Config.PumpkinDiceRollMode = v end
})
RightHallow:AddSlider("PumpkinDiceDelay", {
    Text = "Pumpkin Roll Delay",
    Min = 0.1,
    Max = 1.0,
    Default = Config.PumpkinDiceDelay,
    Rounding = 2,
    Suffix = "s",
    Callback = function(v) Config.PumpkinDiceDelay = v end
})
RightHallow:AddButton({
    Text = "🎲 Roll Pumpkin Dice 5x Now (ทอย 5 ครั้งทันที)",
    Func = function()
        pcall(function()
            if PumpkinDiceRollRF then
                PumpkinDiceRollRF:InvokeServer(5)
                notify("Pumpkin Dice", "Rolled 5x Pumpkin Dice!", 2.5)
            end
        end)
    end
})
RightHallow:AddDivider()
RightHallow:AddToggle("AutoClaimHalloweenQuests", {
    Text = "Auto Claim Quests (รับเควสต์ Daily & Hourly ออโต้)",
    Default = Config.AutoClaimHalloweenQuests,
    Callback = function(v) Config.AutoClaimHalloweenQuests = v end
})
RightHallow:AddToggle("AutoKnockHalloweenDoors", {
    Text = "Auto Knock Trick-or-Treat Doors (เคาะประตู 7 บาน)",
    Default = Config.AutoKnockHalloweenDoors,
    Callback = function(v) Config.AutoKnockHalloweenDoors = v end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 3: UNITS & GACHA (เกรด, TRAITS, QUIRKS, FUSION)
-- ─────────────────────────────────────────────────────────────────────
local LeftUnits = Tabs.Units:AddLeftGroupbox("Grade Reroll Supreme")
LeftUnits:AddToggle("AutoRerollGrade", {
    Text = "Auto Reroll Grade (สุ่มเกรดออโต้)",
    Default = Config.AutoRerollGrade,
    Callback = function(v) Config.AutoRerollGrade = v end
})
LeftUnits:AddDropdown("TargetGrade", {
    Text = "Target Grade (เกรดเป้าหมาย)",
    Values = { "S+", "Z", "Z+", "神", "S", "A+", "A" },
    Default = Config.TargetGrade,
    Callback = function(v) Config.TargetGrade = v end
})
LeftUnits:AddDropdown("GradeRollMode", {
    Text = "Target Mode (กลุ่มเป้าหมาย)",
    Values = { "All Plotted Units", "Tower Team Units", "Selected Unit" },
    Default = Config.GradeRollMode,
    Callback = function(v) Config.GradeRollMode = v end
})
LeftUnits:AddSlider("GradeRollDelay", {
    Text = "Grade Roll Delay",
    Min = 0.1,
    Max = 1.0,
    Default = Config.GradeRollDelay,
    Rounding = 2,
    Suffix = "s",
    Callback = function(v) Config.GradeRollDelay = v end
})
LeftUnits:AddDivider()
LeftUnits:AddLabel("Server Grade Protection:")
local protectGrades = { "神", "Z+", "Z", "S+", "S" }
for _, g in ipairs(protectGrades) do
    LeftUnits:AddToggle("LockGrade_" .. g, {
        Text = "Lock Grade " .. g .. " (ล็อกบนเซิร์ฟเวอร์)",
        Default = Config.ServerProtectGrades[g] == true,
        Callback = function(v)
            Config.ServerProtectGrades[g] = v
            if SetGradeProtectedRE then pcall(function() SetGradeProtectedRE:FireServer(g, v) end) end
        end
    })
end

local RightUnits = Tabs.Units:AddRightGroupbox("Traits, Quirks & Fusion")
RightUnits:AddToggle("AutoRerollTrait", {
    Text = "Auto Reroll Trait (สุ่ม Trait ออโต้)",
    Default = Config.AutoRerollTrait,
    Callback = function(v) Config.AutoRerollTrait = v end
})
RightUnits:AddDropdown("TargetTrait", {
    Text = "Target Trait (Trait เป้าหมาย)",
    Values = { "Godly", "Overpowered", "Celestial", "Cosmic", "Shiny", "Fortune", "Speedy", "Rich" },
    Default = Config.TargetTrait,
    Callback = function(v) Config.TargetTrait = v end
})
RightUnits:AddDivider()
RightUnits:AddToggle("AutoRerollQuirks", {
    Text = "Auto Reroll Quirks (สุ่ม Quirk ออโต้ - UPD 8)",
    Default = Config.AutoRerollQuirks,
    Callback = function(v) Config.AutoRerollQuirks = v end
})
local allQuirks = {
    "Fortune's Favor", "Midas Touch", "Prodigy", "Tycoon",
    "Fortune III", "Fortune II", "Fortune I",
    "Wealth III", "Wealth II", "Wealth I",
    "Gifted III", "Gifted II", "Gifted I",
    "Swift III", "Swift II", "Swift I",
    "Refined III", "Refined II", "Refined I"
}
RightUnits:AddDropdown("TargetQuirks", {
    Text = "Target Quirks (เลือก Quirk ที่ต้องการ)",
    Values = allQuirks,
    Multi = true,
    Default = Config.SelectedTargetQuirks,
    Callback = function(v) Config.SelectedTargetQuirks = v end
})
RightUnits:AddButton({
    Text = "⚗️ Fuse 3 Identical Units (หลอม 3 ตัวซ้ำต่ำสุด)",
    Func = function()
        pcall(function()
            if FuseUnitsRE and DataController and DataController.Inventory then
                local inv = DataController.Inventory
                local grouped = {}
                for id, unitFn in pairs(inv) do
                    local unit = type(unitFn) == "function" and unitFn() or unitFn
                    if unit and unit.name then
                        grouped[unit.name] = grouped[unit.name] or {}
                        table.insert(grouped[unit.name], id)
                    end
                end
                for name, ids in pairs(grouped) do
                    if #ids >= 3 then
                        FuseUnitsRE:FireServer(ids[1], ids[2], ids[3])
                        notify("Unit Fusion", "Fused 3x " .. name .. "!", 2.5)
                        return
                    end
                end
                notify("Unit Fusion", "ไม่พบยูนิตที่ซ้ำกัน 3 ตัวสำหรับหลอม", 2.5)
            end
        end)
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 4: DUNGEONS (หอคอย & HAUNTED HOUSE WINGS)
-- ─────────────────────────────────────────────────────────────────────
local LeftDungeons = Tabs.Dungeons:AddLeftGroupbox("Towers & Floors")
LeftDungeons:AddToggle("AutoTowers", {
    Text = "Auto Towers (ลงหอคอยอัตโนมัติ)",
    Default = Config.AutoTowers,
    Callback = function(v) Config.AutoTowers = v end
})
LeftDungeons:AddDropdown("SelectedTower", {
    Text = "Select Tower / Wing",
    Values = TowerList,
    Default = Config.SelectedTower,
    Callback = function(v) Config.SelectedTower = v end
})
LeftDungeons:AddSlider("TargetTowerFloor", {
    Text = "Target Floor (ชั้นเป้าหมาย)",
    Min = 1,
    Max = 200,
    Default = Config.TargetTowerFloor,
    Rounding = 0,
    Callback = function(v) Config.TargetTowerFloor = v end
})
LeftDungeons:AddSlider("AutoTowerFloorDelay", {
    Text = "Floor Clear Delay",
    Min = 0.05,
    Max = 1.0,
    Default = Config.AutoTowerFloorDelay,
    Rounding = 2,
    Suffix = "s",
    Callback = function(v) Config.AutoTowerFloorDelay = v end
})

local RightDungeons = Tabs.Dungeons:AddRightGroupbox("Tower Strategy")
RightDungeons:AddToggle("AutoCycleTowers", {
    Text = "Auto Cycle All Towers",
    Default = Config.AutoCycleTowers,
    Callback = function(v) Config.AutoCycleTowers = v end
})
RightDungeons:AddToggle("AutoUseDamagePotionsInTower", {
    Text = "Auto Use Damage Potions In Tower",
    Default = Config.AutoUseDamagePotionsInTower,
    Callback = function(v) Config.AutoUseDamagePotionsInTower = v end
})
RightDungeons:AddToggle("HideTowerScreen", {
    Text = "Hide Tower Screen (ย่อจอหอคอย)",
    Default = Config.HideTowerScreen,
    Callback = function(v) Config.HideTowerScreen = v end
})
RightDungeons:AddButton({
    Text = "Equip Best Tower Team Now",
    Func = function()
        if EquipBestTowerTeamRE then
            pcall(function() EquipBestTowerTeamRE:FireServer() end)
            notify("Tower Team", "Equipped best tower team!", 2.5)
        end
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 5: ECONOMY (ขายตัวละคร & น้ำยาบัฟ)
-- ─────────────────────────────────────────────────────────────────────
local LeftEconomy = Tabs.Economy:AddLeftGroupbox("Auto Sell Units")
LeftEconomy:AddToggle("AutoSellUnits", {
    Text = "Auto Sell Units (ขายตัวละครออโต้)",
    Default = Config.AutoSellUnits,
    Callback = function(v) Config.AutoSellUnits = v end
})
LeftEconomy:AddToggle("SellCommon", {
    Text = "Sell Common",
    Default = Config.SelectedSellRarities["Common"],
    Callback = function(v) Config.SelectedSellRarities["Common"] = v end
})
LeftEconomy:AddToggle("SellUncommon", {
    Text = "Sell Uncommon",
    Default = Config.SelectedSellRarities["Uncommon"],
    Callback = function(v) Config.SelectedSellRarities["Uncommon"] = v end
})
LeftEconomy:AddToggle("SellRare", {
    Text = "Sell Rare",
    Default = Config.SelectedSellRarities["Rare"],
    Callback = function(v) Config.SelectedSellRarities["Rare"] = v end
})
LeftEconomy:AddToggle("ProtectPlottedUnits", {
    Text = "Safety: Protect Plotted Units (ห้ามขายตัวบนเกาะ)",
    Default = Config.ProtectPlottedUnits,
    Callback = function(v) Config.ProtectPlottedUnits = v end
})

local RightEconomy = Tabs.Economy:AddRightGroupbox("Potions & Rebirth")
RightEconomy:AddToggle("AutoUseAllOwned", {
    Text = "Auto Use All Owned Potions (ใช้น้ำยาทุกชนิดในกระเป๋า)",
    Default = Config.AutoUseAllOwned,
    Callback = function(v) Config.AutoUseAllOwned = v end
})
RightEconomy:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth (เกิดใหม่อัตโนมัติ)",
    Default = Config.AutoRebirth,
    Callback = function(v) Config.AutoRebirth = v end
})
RightEconomy:AddSlider("TargetRebirth", {
    Text = "Target Rebirth (รีเบิร์ธเป้าหมาย)",
    Min = 1,
    Max = 25,
    Default = Config.TargetRebirth,
    Rounding = 0,
    Callback = function(v) Config.TargetRebirth = v end
})
RightEconomy:AddToggle("AutoUpgrades", {
    Text = "Auto Buy Island Upgrades (ซื้ออัพเกรด)",
    Default = Config.AutoUpgrades,
    Callback = function(v) Config.AutoUpgrades = v end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 6: MISC (ตัวละคร, ภาพกราฟิก, ของขวัญฟรี, วาร์ป)
-- ─────────────────────────────────────────────────────────────────────
local LeftMisc = Tabs.Misc:AddLeftGroupbox("Player & Visuals")
LeftMisc:AddToggle("FPSBooster", {
    Text = "FPS Booster (ลดกราฟิกลื่นไหล 60+ FPS)",
    Default = Config.FPSBooster,
    Callback = function(v)
        Config.FPSBooster = v
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then terrain.Decoration = not v end
            game:GetService("Lighting").GlobalShadows = not v
        end)
    end
})
LeftMisc:AddToggle("FullBright", {
    Text = "FullBright (สว่างทั่วทั้งแมพ)",
    Default = Config.FullBright,
    Callback = function(v)
        Config.FullBright = v
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.Brightness = v and 2 or 1
            lighting.ClockTime = v and 14 or 12
            lighting.FogEnd = v and 1e5 or 1000
        end)
    end
})
LeftMisc:AddToggle("GodAura", {
    Text = "God Aura & Neon Highlight (ออร่าเทพ)",
    Default = Config.GodAura,
    Callback = function(v) Config.GodAura = v end
})
LeftMisc:AddToggle("WalkSpeedEnabled", {
    Text = "Speed Hack",
    Default = Config.WalkSpeedEnabled,
    Callback = function(v)
        Config.WalkSpeedEnabled = v
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and (Config.WalkSpeedValue or 50) or 16 end
    end
})
LeftMisc:AddSlider("WalkSpeedValue", {
    Text = "Speed Value",
    Min = 16,
    Max = 200,
    Default = 50,
    Rounding = 0,
    Callback = function(v)
        Config.WalkSpeedValue = v
        if Config.WalkSpeedEnabled then
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end
})

local RightMisc = Tabs.Misc:AddRightGroupbox("Free Gifts & World")
RightMisc:AddToggle("AntiAFK", {
    Text = "Triple-Layer Anti-AFK (กันหลุด 24 ชม.)",
    Default = Config.AntiAFK,
    Callback = function(v) Config.AntiAFK = v end
})
RightMisc:AddToggle("AutoClaimRewards", {
    Text = "Auto Claim Free Gifts (Daily, Offline, Spins)",
    Default = Config.AutoClaimRewards,
    Callback = function(v) Config.AutoClaimRewards = v end
})
RightMisc:AddButton({
    Text = "Claim All Free Gifts Now",
    Func = function()
        ClaimAllRewards()
        notify("Gifts", "Claimed Daily, Offline, and Spins!", 2.5)
    end
})
RightMisc:AddToggle("AutoSpinWheel", {
    Text = "Auto Spin Lucky Wheel",
    Default = Config.AutoSpinWheel,
    Callback = function(v) Config.AutoSpinWheel = v end
})
RightMisc:AddButton({
    Text = "Unload Hub (ถอนการติดตั้ง)",
    Func = function()
        _G.AnimeDice_Cleanup()
        Library:Unload()
    end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 7: UI SETTINGS (OBSIDIAN THEMES & CONFIG MANAGER)
-- ─────────────────────────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("ProjectBarun")
SaveManager:SetFolder("ProjectBarun/AnimeDice")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- ═════════════════════════════════════════════════════════════════════
-- 10. DRAGGABLE FLOATING NEON ORB (MOBILE & PC UNIVERSAL TOGGLE)
-- ═════════════════════════════════════════════════════════════════════
pcall(function()
    local h = gethui and gethui() or game:GetService("CoreGui")
    for _, existing in ipairs(h:GetChildren()) do
        if existing.Name == "PB_MobileToggleOrb" then existing:Destroy() end
    end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PB_MobileToggleOrb"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = h

    local Orb = Instance.new("ImageButton")
    Orb.Name = "ToggleOrb"
    Orb.Size = UDim2.fromOffset(46, 46)
    Orb.Position = UDim2.new(0, 16, 0.45, 0)
    Orb.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    Orb.BackgroundTransparency = 0.15
    Orb.AutoButtonColor = false
    Orb.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Orb

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(125, 85, 255)
    Stroke.Thickness = 1.8
    Stroke.Parent = Orb

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = "PB"
    Icon.Font = Enum.Font.GothamBlack
    Icon.TextSize = 14
    Icon.TextColor3 = Color3.fromRGB(125, 85, 255)
    Icon.TextXAlignment = Enum.TextXAlignment.Center
    Icon.Parent = Orb

    local dragging = false
    local dragStart, startPos

    Orb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Orb.Position
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
            Orb.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    Orb.MouseButton1Click:Connect(function()
        Library:Toggle()
    end)
end)

notify("PROJECT BARUN", "Ouroboros Obsidian Edition loaded successfully!", 4.0)
print("[PROJECT BARUN] Anime Dice Ouroboros Obsidian Suite initialized!")
