-- [[ 🔥 2SKI - LOOT TO FORGE (หลอมอาวุธ & ลงด่าน) MASTER MOBILE & iOS EDITION 🔥 ]] --
-- Game: +1 ของรางวัลที่จะหลอม (Loot to Forge) - PlaceId: 118805555015549
-- UI Engine: WindUI Glassy Tiffany + macOS 3-Dots + Responsive Mobile & iOS Layout
-- Fully Audited, Zero-Bug, Direct Remote Hook & Auto-Farm Engine by cook45 for clack

local myToken = tick()
_G.TwoSkiActiveToken = myToken

if _G.TwoSkiCleanup then
    pcall(_G.TwoSkiCleanup)
    task.wait(0.2)
end

_G.TwoSkiActiveToken = myToken
_G.TwoSkiRunning = true
_G.TwoSkiLoaded = false

-- Core Services
local cloneref = (cloneref or clonereference or function(inst) return inst end)
local function safeService(name)
    local ok, svc = pcall(function()
        local s = game:GetService(name)
        if cloneref then
            local ref = cloneref(s)
            if ref and typeof(ref) == "Instance" then return ref end
        end
        return s
    end)
    return ok and svc or nil
end

local Players = safeService("Players") or game:GetService("Players")
local ReplicatedStorage = safeService("ReplicatedStorage") or game:GetService("ReplicatedStorage")
local UserInputService = safeService("UserInputService") or game:GetService("UserInputService")
local RunService = safeService("RunService") or game:GetService("RunService")
local HttpService = safeService("HttpService") or game:GetService("HttpService")
local TweenService = safeService("TweenService") or game:GetService("TweenService")
local TeleportService = safeService("TeleportService") or game:GetService("TeleportService")
local CoreGui = safeService("CoreGui")
local VirtualUser = safeService("VirtualUser")
local VirtualInputManager = safeService("VirtualInputManager")

-- Mobile Diagnostics
local isTouchDevice = UserInputService.TouchEnabled
local isMobile = isTouchDevice and (not UserInputService.KeyboardEnabled or isTouchDevice)

local function safeCopy(text)
    pcall(function()
        if setclipboard then
            setclipboard(text)
        elseif toclipboard then
            toclipboard(text)
        end
    end)
end

local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.05)
    LocalPlayer = Players.LocalPlayer
end

-- Safe Universal GUI Resolver
local getgenv_fn = getgenv or function() return _G end
local env = getgenv_fn()

local canWriteCoreGui = false
pcall(function()
    if CoreGui then
        local test = Instance.new("Folder")
        test.Parent = CoreGui
        test:Destroy()
        canWriteCoreGui = true
    end
end)

if not env.gethui or type(env.gethui) ~= "function" then
    if not canWriteCoreGui then
        env.gethui = function()
            return LocalPlayer:WaitForChild("PlayerGui", 10)
        end
    end
end

local function getSafeGuiContainer()
    if env.gethui then
        local ok, h = pcall(env.gethui)
        if ok and h and typeof(h) == "Instance" then return h end
    end
    if canWriteCoreGui and CoreGui then
        local ok, r = pcall(function() return CoreGui:FindFirstChild("RobloxGui") end)
        if ok and r then return r end
        return CoreGui
    end
    return LocalPlayer:WaitForChild("PlayerGui", 10)
end

local function safeDestroyGui(name)
    pcall(function()
        local parents = {}
        if gethui then pcall(function() table.insert(parents, gethui()) end) end
        if CoreGui then
            pcall(function() table.insert(parents, CoreGui:FindFirstChild("RobloxGui")) end)
            table.insert(parents, CoreGui)
        end
        if LocalPlayer then table.insert(parents, LocalPlayer:FindFirstChild("PlayerGui")) end
        for _, p in ipairs(parents) do
            if p then
                for _, c in ipairs(p:GetChildren()) do
                    if c and (c.Name == name or c.Name:find(name, 1, true)) then
                        pcall(function() c:Destroy() end)
                    end
                end
            end
        end
    end)
end

safeDestroyGui("TwoSki_LootToForge_Floating")
safeDestroyGui("WindUI")

-- Game Remotes & Modules
local Remotes = ReplicatedStorage:WaitForChild("Remote", 10)
local Remote_TrainOnce        = Remotes and Remotes:FindFirstChild("Train") and Remotes.Train:FindFirstChild("TrainOnceRE")
local Remote_IntoAutoTrain    = Remotes and Remotes:FindFirstChild("Train") and Remotes.Train:FindFirstChild("IntoAutoTrainRE")
local Remote_ExitAutoTrain    = Remotes and Remotes:FindFirstChild("Train") and Remotes.Train:FindFirstChild("ExitAutoTrainRE")
local Remote_StageFinished    = Remotes and Remotes:FindFirstChild("Stage") and Remotes.Stage:FindFirstChild("StageFinishedRF")
local Remote_GetOre           = Remotes and Remotes:FindFirstChild("Stage") and Remotes.Stage:FindFirstChild("GetOreRF")
local Remote_ClaimedAllOre    = Remotes and Remotes:FindFirstChild("Stage") and Remotes.Stage:FindFirstChild("ClaimedAllOreRE")
local Remote_Forge            = Remotes and Remotes:FindFirstChild("Forge") and Remotes.Forge:FindFirstChild("ForgeRF")
local Remote_TryEquip         = Remotes and Remotes:FindFirstChild("Backpack") and Remotes.Backpack:FindFirstChild("TryEquipItemRE")
local Remote_TrySellAll       = Remotes and Remotes:FindFirstChild("Backpack") and Remotes.Backpack:FindFirstChild("TrySellAllRE")
local Remote_TrySellItem      = Remotes and Remotes:FindFirstChild("Backpack") and Remotes.Backpack:FindFirstChild("TrySellItemRE")
local Remote_UpgradeOnce      = Remotes and Remotes:FindFirstChild("Upgrade") and Remotes.Upgrade:FindFirstChild("UpgradeOnceRE")
local Remote_TryRebirth       = Remotes and Remotes:FindFirstChild("Rebirth") and Remotes.Rebirth:FindFirstChild("TryRebirthRE")
local Remote_OnlineClaim      = Remotes and Remotes:FindFirstChild("Online") and Remotes.Online:FindFirstChild("TryClaimRE")
local Remote_UpdateClaim      = Remotes and Remotes:FindFirstChild("UpdateLog") and Remotes.UpdateLog:FindFirstChild("TryClaimUPDRewardRE")
local Remote_OfflineClaim     = Remotes and Remotes:FindFirstChild("Offline") and Remotes.Offline:FindFirstChild("TryClaimOfflineRewardRE")
local Remote_DungeonTicket    = Remotes and Remotes:FindFirstChild("Dungeon") and Remotes.Dungeon:FindFirstChild("TryClaimDailyDunTicRE")
local Remote_TryIntoDungeon   = Remotes and Remotes:FindFirstChild("Dungeon") and Remotes.Dungeon:FindFirstChild("TryIntoDungeonRF")
local Remote_ExitDungeon      = Remotes and Remotes:FindFirstChild("Dungeon") and Remotes.Dungeon:FindFirstChild("ExitDungeonRE")
local Remote_StartRound       = Remotes and Remotes:FindFirstChild("Dungeon") and Remotes.Dungeon:FindFirstChild("StartRoundRE")
local Remote_CompleteRound    = Remotes and Remotes:FindFirstChild("Dungeon") and Remotes.Dungeon:FindFirstChild("CompleteRoundRF")
local Remote_IndexExp         = Remotes and Remotes:FindFirstChild("Index") and Remotes.Index:FindFirstChild("TryClaimIndexExpRF")
local Remote_IndexLvlReward   = Remotes and Remotes:FindFirstChild("Index") and Remotes.Index:FindFirstChild("TryClaimLevelRewardRF")
local Remote_KillSuperLoot    = Remotes and Remotes:FindFirstChild("SuperLoot") and Remotes.SuperLoot:FindFirstChild("KillSuperLootRE")
local Remote_Enchant          = Remotes and Remotes:FindFirstChild("Backpack") and Remotes.Backpack:FindFirstChild("EnchantRE")
local Remote_UnEnchant        = Remotes and Remotes:FindFirstChild("Backpack") and Remotes.Backpack:FindFirstChild("UnEnchantRE")
local Remote_TryUsePotion     = Remotes and Remotes:FindFirstChild("Potion") and Remotes.Potion:FindFirstChild("TryUsePotionRE")
local Remote_LuckOnce         = Remotes and Remotes:FindFirstChild("Class") and Remotes.Class:FindFirstChild("LuckOnceRE")

-- Internal Controllers & Config
local TrainCTRL = nil
pcall(function() TrainCTRL = require(ReplicatedStorage.CTRL.TrainCTRL) end)
local ProfileData = nil
pcall(function() ProfileData = require(ReplicatedStorage.ProfileData) end)
local BackpackData = nil
pcall(function() BackpackData = require(ReplicatedStorage.LocalData.BackpackData) end)
local UpgradeData = nil
pcall(function() UpgradeData = require(ReplicatedStorage.LocalData.UpgradeData) end)
local UpgradeHelper = nil
pcall(function() UpgradeHelper = require(ReplicatedStorage.Config.Upgrade.Helper) end)
local OnlineData = nil
pcall(function() OnlineData = require(ReplicatedStorage.LocalData.OnlineData) end)
local RebirthHelper = nil
pcall(function() RebirthHelper = require(ReplicatedStorage.Config.Rebirth.Helper) end)
local DungeonData = nil
pcall(function()
    DungeonData = require(ReplicatedStorage.LocalData.DungeonData)
    if DungeonData and DungeonData.CompleteRound then
        local origComplete = DungeonData.CompleteRound
        DungeonData.CompleteRound = function(round)
            local v1, v2 = origComplete(round)
            if type(v1) ~= "table" then v1 = {} end
            return v1, v2
        end
    end
end)
local EnemyCTRL = nil
pcall(function() EnemyCTRL = require(ReplicatedStorage.CTRL.EnemyCTRL) end)
local HPCTRL = nil
pcall(function() HPCTRL = require(ReplicatedStorage.CTRL.HPCTRL) end)
local CommunicationUtils = nil
pcall(function() CommunicationUtils = require(ReplicatedStorage.Utils.CommunicationUtils) end)
local Bindable_EnemyHit = nil
if CommunicationUtils and CommunicationUtils.TryGetBindableEvent then
    pcall(function() Bindable_EnemyHit = CommunicationUtils.TryGetBindableEvent("Attack", "EnemyHitBE") end)
end
local TrainAreaHelper = nil
pcall(function() TrainAreaHelper = require(ReplicatedStorage.Config.TrainArea.Helper) end)
local WeaponHelper = nil
pcall(function() WeaponHelper = require(ReplicatedStorage.Config.Weapon.Helper) end)
local ArmorHelper = nil
pcall(function() ArmorHelper = require(ReplicatedStorage.Config.Armor.Helper) end)
local RarityHelper = nil
pcall(function() RarityHelper = require(ReplicatedStorage.Config.Rarity.Helper) end)
local RarityConfig = nil
pcall(function() RarityConfig = require(ReplicatedStorage.Config.Rarity.Config) end)
local OreHelper = nil
pcall(function() OreHelper = require(ReplicatedStorage.Config.Ore.Helper) end)
local OreConfig = nil
pcall(function() OreConfig = require(ReplicatedStorage.Config.Ore.Config) end)
local EnchStoneHelper = nil
pcall(function() EnchStoneHelper = require(ReplicatedStorage.Config.EnchStone.Helper) end)
local EnchStoneConfig = nil
pcall(function() EnchStoneConfig = require(ReplicatedStorage.Config.EnchStone.Config) end)
local StoneHelper = nil
pcall(function() StoneHelper = require(ReplicatedStorage.Config.Stone.Helper) end)
local StoneConfig = nil
pcall(function() StoneConfig = require(ReplicatedStorage.Config.Stone.Config) end)
local EnchantHelper = nil
pcall(function() EnchantHelper = require(ReplicatedStorage.Config.Enchant.Helper) end)
local EnchantConfig = nil
pcall(function() EnchantConfig = require(ReplicatedStorage.Config.Enchant.Config) end)
local BuffData = nil
pcall(function() BuffData = require(ReplicatedStorage.LocalData.BuffData) end)
local PotionData = nil
pcall(function() PotionData = require(ReplicatedStorage.LocalData.PotionData) end)
local ClassData = nil
pcall(function() ClassData = require(ReplicatedStorage.LocalData.ClassData) end)
local ClassConfig = nil
pcall(function() ClassConfig = require(ReplicatedStorage.Config.Class.Config) end)
local PemData = nil
pcall(function() PemData = require(ReplicatedStorage.LocalData.PemData) end)
local MonetizationConfig = nil
pcall(function() MonetizationConfig = require(ReplicatedStorage.Config.Monetization) end)

-- ═══════════════════════════════════════════════════════════════════
-- GAME PASS BYPASS SYSTEM (Triple-Layer: PemData + NamecallHook + PurchaseIntercept)
-- ═══════════════════════════════════════════════════════════════════
local MarketplaceService = safeService("MarketplaceService")

-- All game pass IDs mapped to their internal Pem keys
local GamePassMap = {
    [1962630901] = "VIP",           -- VIP (x2 Coins, x2 EXP)
    [1963566878] = "SuperLuck",     -- Super Luck (x200% Luck)
    [1965960643] = "CommonLuck",    -- Common Luck (x150% Luck)
    [1963764856] = "MoreOre",       -- More Ore (x200% Ore Drop)
    [1982474360] = "UltraLuck",     -- Ultra Luck (x500% Luck)
    [1962564854] = "SkipForge",     -- Skip Forge (Instant Forge)
}

-- Extra premium features (TrainArea multiplier unlocks)
local ExtraPremiumKeys = {
    "AutoTrainArea_9", "AutoTrainArea_10", "AutoTrainArea_11"
}

local function applyGamePassBypass()
    -- Layer 1: Inject all gamepass flags directly into PemData store
    pcall(function()
        local pemStore = ProfileData and ProfileData.GetStoreData and ProfileData.GetStoreData("Pem")
        if pemStore and type(pemStore) == "table" then
            for _, pemKey in pairs(GamePassMap) do
                pemStore[pemKey] = true
            end
            for _, key in ipairs(ExtraPremiumKeys) do
                pemStore[key] = true
            end
        end
    end)

    -- Layer 2: Hook __namecall to intercept UserOwnsGamePassAsync calls
    if hookmetamethod and newcclosure and getnamecallmethod then
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if self == MarketplaceService and method == "UserOwnsGamePassAsync" then
                    local args = {...}
                    local gpId = args[2] or args[1]
                    if type(gpId) == "number" and GamePassMap[gpId] then
                        return true
                    end
                end
                return oldNamecall(self, ...)
            end))
        end)
    end

    -- Layer 3: Intercept PromptGamePassPurchase to auto-complete without Robux dialog
    if hookfunction and newcclosure and MarketplaceService then
        pcall(function()
            local oldPromptGP
            oldPromptGP = hookfunction(MarketplaceService.PromptGamePassPurchase, newcclosure(function(self, player, gpId)
                if GamePassMap[gpId] then
                    -- Inject into PemData silently
                    pcall(function()
                        local pemStore = ProfileData and ProfileData.GetStoreData and ProfileData.GetStoreData("Pem")
                        if pemStore then pemStore[GamePassMap[gpId]] = true end
                    end)
                    -- Fire the purchase finished signal
                    pcall(function()
                        MarketplaceService.PromptGamePassPurchaseFinished:Fire(player, gpId, true)
                    end)
                    -- Refresh shop UI
                    pcall(function()
                        local Shop = require(ReplicatedStorage.GuiUtils.Shop)
                        if Shop and Shop.updateGamePass then Shop.updateGamePass() end
                    end)
                    return
                end
                return oldPromptGP(self, player, gpId)
            end))
        end)
    end

    -- Refresh Shop GUI to show "Owned" badges
    pcall(function()
        local Shop = require(ReplicatedStorage.GuiUtils.Shop)
        if Shop then
            if Shop.updateGamePass then Shop.updateGamePass() end
            if Shop.updateTrainArea then Shop.updateTrainArea() end
        end
    end)
end

applyGamePassBypass()

-- State Management (Default: All automation features set to FALSE on startup)
local State = {
    -- Tab 1: ฟาร์มพลัง & แร่ & แท่นคูณพิเศษ & ดันเจี้ยน & น้ำยา
    AutoTrain           = false,
    AutoTrainBestZone   = false,
    SelectedTrainZone   = "Auto Best (แท่นคูณสูงสุดที่ปลดล็อค)",
    AutoClearStage      = false,
    SelectedStage       = "Auto Max (ด่านสูงสุดที่ผ่านได้)",
    StageDelay          = 0.35,
    AutoCollectCrystals = false,
    AutoKillSuperLoot   = false,
    AutoDungeon         = false,
    DungeonInstaKill    = false,
    TargetDungeonRound  = 1,
    AutoBuffPotions     = false,
    AutoTrainPotion     = false,
    AutoCoinPotion      = false,
    AutoLuckPotion      = false,
    AutoDamagePotion    = false,
    AutoHPPotion        = false,

    -- Tab 2: เก็บเงิน & รางวัล & ระบบขายของแยกอิสระ (เกียร์ / แร่ / หินตีบวก)
    AutoCollectMoney    = false,
    AutoSellGear        = false,
    AutoSellAll         = false,
    AutoSellOres        = false,
    MinRarityToKeep     = "🟡 Legendary ขึ้นไป (Keep Legendary+)",
    OreRaritiesToKeep   = {
        "👑 Infinite",
        "💠 Ancient",
        "🔴 Mythic",
        "🟡 Legendary"
    },
    AutoSellEnchant     = false,
    EnchantFilterMode   = "🔥 เลือกระดับที่จะขายทิ้ง (Sell Selected)",
    EnchantRarities     = {
        "🟣 Epic",
        "🟢 Rare",
        "🟢 Uncommon",
        "⚪ Common"
    },
    AutoClaimOnline     = false,
    AutoClaimGifts      = false,

    -- Tab 3: หลอม & อุปกรณ์ & ตีบวก
    AutoForge           = false,
    ForgeType           = "🔄 หมุนเวียนครบเซ็ต (ดาบ + เกราะ + หมวก)",
    OreQualityMode      = "🌟 ใช้แร่เกรดสูงสุดก่อน (Best Ores First)",
    MinOreToForge       = 4,
    AutoEquipBest       = false,
    AutoEnchant         = false,

    -- Tab 4: อัปเกรด & เกิดใหม่ & คลาส
    AutoUpgradeAll      = false,
    AutoUpgradeTrain    = false,
    AutoUpgradeLuck     = false,
    AutoUpgradeOrePack  = false,
    AutoRebirth         = false,
    AutoRollClass       = false,
    TargetClassRarity   = "🟡 Legendary ขึ้นไป",

    -- Tab 5: ผู้เล่น & ตั้งค่า
    WalkSpeed           = 16,
    JumpPower           = 50,
    InfiniteJump        = false,
    Noclip              = false,
    ManualFly           = false,
    ManualFlySpeed      = 100,
    AntiAfk             = false,
    CurrentTheme        = "2SKI Cyber Cyan (ธีมหลักทางการ - ขาว ฟ้าเรืองแสง Electric Blue)",
    FloatingButtonVisible = true,
    AutoLoadConfig      = false,
}
_G.TwoSkiState = State

local function normalizeMultiSelection(val)
    if not val then return {} end
    if type(val) == "string" then
        local s = val:gsub("^%s+", ""):gsub("%s+$", "")
        return #s > 0 and {s} or {}
    end
    if type(val) ~= "table" then return {} end
    local list = {}
    for k, v in pairs(val) do
        if type(k) == "number" and type(v) == "string" then
            local s = v:gsub("^%s+", ""):gsub("%s+$", "")
            if #s > 0 then table.insert(list, s) end
        elseif type(k) == "string" and (v == true or v == 1 or type(v) == "string") then
            local s = k:gsub("^%s+", ""):gsub("%s+$", "")
            if #s > 0 then table.insert(list, s) end
        elseif type(v) == "string" then
            local s = v:gsub("^%s+", ""):gsub("%s+$", "")
            if #s > 0 then table.insert(list, s) end
        end
    end
    return list
end

local UIControls = {}
local Connections = {}
local noclipCon = nil
local manualFlyBv = nil
local manualFlyBg = nil
local manualFlyCon = nil

local function getCharHrp()
    local c = LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
    local hrp = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    return c, hrp, hum
end

local function getStageList()
    local list = { "Auto Max (ด่านสูงสุดที่ผ่านได้)" }
    for i = 1, 27 do
        table.insert(list, "Stage_" .. tostring(i))
    end
    return list
end

-- Teleport Coordinates
local MapWaypoints = {
    ["แท่นหลอม (Forge Table)"]        = Vector3.new(0.5, 8.5, 40.2),
    ["ร้านอัปเกรด (Upgrade Station)"]    = Vector3.new(35.9, 6.2, 13.9),
    ["จุดขายของ (Sell Station)"]        = Vector3.new(35.9, 6.2, -12.6),
    ["จุดฝึกฝนอัตโนมัติ (Auto Train)"]    = Vector3.new(-52.9, 7.8, -20.8),
    ["ทางเข้าดันเจี้ยน (Dungeon Gate)"]   = Vector3.new(140.8, 29.5, 47.5),
    ["แท่นตีบวก (Enchant Station)"]     = Vector3.new(47.9, 5.0, 73.1),
    ["จุดรับรางวัลกลุ่ม (Group Gift)"]   = Vector3.new(-24.5, 9.8, -48.2),
    ["หน้าด่านต่อสู้ (Stage Entrance)"]   = Vector3.new(3.2, 19.0, -59.9),
    ["จุดเกิดหลัก (Spawn Point)"]        = Vector3.new(0.0, 5.0, 0.0)
}

-- Train Area Multiplier Zones Config
local TrainAreaConfig = {
    { Id = 1, Name = "Train_1 (x1.5 Power | Rebirth 0)",  Rebirth = 0,  Mult = 1.5, PadPos = Vector3.new(-53.0, 3.0, -41.0), DummyPos = Vector3.new(-57.88, 6.94, -41.04) },
    { Id = 2, Name = "Train_2 (x2 Power | Rebirth 2)",    Rebirth = 2,  Mult = 2,   PadPos = Vector3.new(-53.0, 3.0, -20.9), DummyPos = Vector3.new(-57.88, 6.94, -20.91) },
    { Id = 3, Name = "Train_3 (x4 Power | Rebirth 5)",    Rebirth = 5,  Mult = 4,   PadPos = Vector3.new(-53.0, 3.0, 21.4),  DummyPos = Vector3.new(-57.88, 6.94, 21.37) },
    { Id = 4, Name = "Train_4 (x6 Power | Rebirth 9)",    Rebirth = 9,  Mult = 6,   PadPos = Vector3.new(-53.0, 3.0, 43.25), DummyPos = Vector3.new(-57.88, 6.94, 43.25) },
    { Id = 5, Name = "Train_5 (x8 Power | Rebirth 12)",   Rebirth = 12, Mult = 8,   PadPos = Vector3.new(-80.0, 8.6, 21.29), DummyPos = Vector3.new(-84.50, 8.61, 21.29) },
    { Id = 6, Name = "Train_6 (x10 Power | Rebirth 15)",  Rebirth = 15, Mult = 10,  PadPos = Vector3.new(-80.0, 9.1, -20.90), DummyPos = Vector3.new(-83.92, 9.11, -20.90) },
    { Id = 7, Name = "Train_7 (x15 Power | Rebirth 18)",  Rebirth = 18, Mult = 15,  PadPos = Vector3.new(-108.0, 12.7, 32.24), DummyPos = Vector3.new(-114.22, 12.73, 32.24) },
    { Id = 8, Name = "Train_8 (x25 Power | Rebirth 21)",  Rebirth = 21, Mult = 25,  PadPos = Vector3.new(-106.0, 10.6, -31.00), DummyPos = Vector3.new(-110.27, 10.63, -30.99) },
}

local function getBestTrainZone()
    local pd = ProfileData and ProfileData.GetTotalData()
    local curReb = pd and pd.Eco and tonumber(pd.Eco.rebirth) or 0
    local best = TrainAreaConfig[1]
    for _, z in ipairs(TrainAreaConfig) do
        if curReb >= z.Rebirth then
            best = z
        end
    end
    return best
end

local function getZoneByName(name)
    for _, z in ipairs(TrainAreaConfig) do
        if z.Name == name or tostring(z.Id) == name then return z end
    end
    return nil
end

local function getTrainZoneNames()
    local list = { "Auto Best (แท่นคูณสูงสุดที่ปลดล็อค)" }
    for _, z in ipairs(TrainAreaConfig) do
        table.insert(list, z.Name)
    end
    return list
end

local collectAllWorldOres = nil

-- Definitive Mob Execution Function (Instant Kill + VFX + Server & Client Cleanup)
local function killEnemyEntity(enemy)
    if not enemy then return end
    local uuid = enemy:GetAttribute("UUID") or enemy.Name
    if not uuid then return end
    pcall(function()
        -- 1. Trigger official game event EnemyHitBE (notifies StageManager / DungeonManager natively)
        if Bindable_EnemyHit then
            Bindable_EnemyHit:Fire(uuid, 1e30)
        end

        -- 2. Direct internal Hurt & Death trigger in case event was missed
        if EnemyCTRL then
            if EnemyCTRL.HurtEnemy then
                EnemyCTRL.HurtEnemy(uuid, 1e30)
            end
            if EnemyCTRL.DeadEnemyData then
                EnemyCTRL.DeadEnemyData(uuid)
            end
        end

        -- 3. Update Visual HP Bar
        if HPCTRL and HPCTRL.SetCurrentHP then
            HPCTRL.SetCurrentHP(enemy, 0)
        end

        -- 4. Mark Model state & zero humanoid health
        if enemy:IsA("Model") then
            enemy:SetAttribute("Dead", true)
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    end)
end

-- Dungeon Combat Handler (Guaranteed Round Progression, Anti-Freeze & Loot Sweep)
local function handleDungeonCombat()
    if not LocalPlayer:GetAttribute("Dungeoning") then return false end

    local enemyFolder = workspace:FindFirstChild("EnemyFolder")
    local _, hrp = getCharHrp()
    local playerCF = hrp and hrp.CFrame or CFrame.new(3482, 23, -4)

    -- 1. Get DungeonManager environment and internal state
    local dmEnv = nil
    pcall(function()
        local dmScript = LocalPlayer.PlayerScripts:FindFirstChild("Manager") and LocalPlayer.PlayerScripts.Manager:FindFirstChild("DungeonManager")
        if dmScript and getsenv then
            dmEnv = getsenv(dmScript)
        end
    end)

    local u140 = nil
    if dmEnv and debug and debug.getupvalues and dmEnv.CheckFinishedOnce then
        pcall(function()
            local upvals = debug.getupvalues(dmEnv.CheckFinishedOnce)
            if upvals and type(upvals[1]) == "table" then
                u140 = upvals[1]
            end
        end)
    end

    -- 2. Kill all active mobs in EnemyFolder
    local lastPivot = nil
    if enemyFolder and State.DungeonInstaKill then
        local children = enemyFolder:GetChildren()
        for _, enemy in ipairs(children) do
            if enemy:IsA("Model") then
                local uuid = enemy:GetAttribute("UUID") or enemy.Name
                lastPivot = enemy:GetPivot()

                pcall(function()
                    if u140 then
                        u140.DeadCF = lastPivot or playerCF
                    end

                    if Bindable_EnemyHit then
                        Bindable_EnemyHit:Fire(uuid, 1e30)
                    end

                    if EnemyCTRL and EnemyCTRL.HurtEnemy then
                        EnemyCTRL.HurtEnemy(uuid, 1e30)
                    end

                    if HPCTRL and HPCTRL.SetCurrentHP then
                        HPCTRL.SetCurrentHP(enemy, 0)
                    end

                    enemy:SetAttribute("Dead", true)
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end)
            end
        end
    end

    -- 3. Ensure DeadCF is always a valid CFrame so RewardUtils.CreateOres never errors
    if u140 then
        if not u140.DeadCF or typeof(u140.DeadCF) ~= "CFrame" then
            u140.DeadCF = lastPivot or playerCF
        end
    end

    -- 4. Advance round when mobs are eliminated
    if dmEnv and dmEnv.CheckFinishedOnce then
        pcall(function()
            dmEnv.CheckFinishedOnce()
        end)
    end

    -- 5. If at round 30 and finished, exit dungeon cleanly
    if u140 and u140.Round and u140.Round >= 30 and u140.Finished then
        if dmEnv and dmEnv.ExitDungeon then
            pcall(function() dmEnv.ExitDungeon() end)
        end
    end

    -- 6. Sweep world dropped ores / crystals in dungeon
    if State.AutoCollectCrystals and collectAllWorldOres then
        pcall(collectAllWorldOres)
    end
    return true
end

-- Rebirth Verification (Uses curRebirth + 1 for correct next-tier level requirement)
local function checkRebirthStatus()
    local pd = ProfileData and ProfileData.GetTotalData()
    local eco = pd and pd.Eco or {}
    local curLevel = tonumber(eco.level) or 0
    local curRebirth = tonumber(eco.rebirth) or 0
    local isMax = false
    if RebirthHelper and RebirthHelper.CheckIsMax then
        pcall(function() isMax = RebirthHelper.CheckIsMax(curRebirth) end)
    end
    local needLevel = 0
    if not isMax and RebirthHelper and RebirthHelper.GetNeedLevel then
        pcall(function() needLevel = RebirthHelper.GetNeedLevel(curRebirth + 1) or 0 end)
    end
    local ready = (not isMax) and (curLevel >= needLevel) and (needLevel > 0)
    return ready, curRebirth, curLevel, needLevel, isMax
end

-- Rarity Level Resolver (Supports Weapons, Armors, Hats, Ores, and Enchant Stones)
local function getRarityLevel(item)
    if not item or not item.ID then return 1, "Common" end
    local rarity = item.Rarity or "Common"
    if item.Type == "Weapon" and WeaponHelper and WeaponHelper.GetRarity then
        pcall(function() rarity = WeaponHelper.GetRarity(item.ID) or rarity end)
    elseif (item.Type == "Armor" or item.Type == "Hat") and ArmorHelper and ArmorHelper.GetRarity then
        pcall(function() rarity = ArmorHelper.GetRarity(item.ID) or rarity end)
    elseif item.Type == "Ore" then
        if OreHelper and OreHelper.GetRarity then
            pcall(function() rarity = OreHelper.GetRarity(item.ID) or rarity end)
        elseif OreConfig and item.ID and OreConfig[item.ID] and OreConfig[item.ID].Rarity then
            rarity = OreConfig[item.ID].Rarity
        end
    elseif item.Type == "EnchStone" or (item.ID and item.ID:find("Stone")) then
        if EnchStoneHelper and EnchStoneHelper.GetRarity then
            pcall(function() rarity = EnchStoneHelper.GetRarity(item.ID) or rarity end)
        elseif EnchStoneConfig and item.ID and EnchStoneConfig[item.ID] and EnchStoneConfig[item.ID].Rarity then
            rarity = EnchStoneConfig[item.ID].Rarity
        elseif StoneHelper and StoneHelper.GetRarity then
            pcall(function() rarity = StoneHelper.GetRarity(item.ID) or rarity end)
        elseif StoneConfig and item.ID and StoneConfig[item.ID] and StoneConfig[item.ID].Rarity then
            rarity = StoneConfig[item.ID].Rarity
        elseif EnchantHelper and EnchantHelper.GetRarity then
            pcall(function() rarity = EnchantHelper.GetRarity(item.ID) or rarity end)
        elseif EnchantConfig and item.ID and EnchantConfig[item.ID] and EnchantConfig[item.ID].Rarity then
            rarity = EnchantConfig[item.ID].Rarity
        end
    end

    if item.Rarity and (rarity == "Common" or not rarity) then
        rarity = item.Rarity
    end

    -- Universal string matching fallback for stone and gear IDs
    if (rarity == "Common" or not rarity) and item.ID then
        for _, rName in ipairs({"Infinite", "Ancient", "Secret", "Eternal", "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common"}) do
            if item.ID:lower():find(rName:lower(), 1, true) then
                rarity = rName
                break
            end
        end
    end

    local lvl = 1
    if RarityHelper and RarityHelper.GetRarityLevel then
        pcall(function() lvl = RarityHelper.GetRarityLevel(rarity) or 1 end)
    else
        local defaultLevels = {
            Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
            Legendary = 5, Mythic = 6, Ancient = 7, Infinite = 8
        }
        lvl = defaultLevels[rarity] or 1
    end
    return lvl, rarity
end

local RarityThresholds = {
    ["👑 Infinite เท่านั้น (Keep Infinite Only)"]     = 10,
    ["💠 Ancient ขึ้นไป (Keep Ancient+)"]            = 9,
    ["🌌 Secret ขึ้นไป (Keep Secret+)"]              = 8,
    ["⚡ Eternal ขึ้นไป (Keep Eternal+)"]             = 7,
    ["🔴 Mythic ขึ้นไป (Keep Mythic+)"]             = 6,
    ["🟡 Legendary ขึ้นไป (Keep Legendary+)"]       = 5,
    ["🟣 Epic ขึ้นไป (Keep Epic+)"]                 = 4,
    ["🟢 Rare ขึ้นไป (Keep Rare+)"]                 = 3,
    ["⚪ Uncommon ขึ้นไป (Keep Uncommon+)"]         = 2,
    ["ขายทั้งหมดที่ไม่ใส่ (Sell All Non-Equipped)"] = 999,
    ["เก็บทั้งหมด (Keep All - ไม่ขายเกียร์)"]       = 0,
}

-- Best Gear Power Scoring Helper (Rarity Level + Design Power + Affix + Enhancement)
local function calculateGearScore(item)
    if not item or not item.ID then return 0 end
    local basePower = 0
    if item.Type == "Weapon" and WeaponHelper and WeaponHelper.GetDesignPower then
        pcall(function() basePower = WeaponHelper.GetDesignPower(item.ID) or 0 end)
    elseif (item.Type == "Armor" or item.Type == "Hat") and ArmorHelper and ArmorHelper.GetDesignPower then
        pcall(function() basePower = ArmorHelper.GetDesignPower(item.ID) or 0 end)
    end
    local rarityLevel, _ = getRarityLevel(item)
    local affixNum = (item.MainAffix and tonumber(item.MainAffix.Number)) or 0
    local enhance = tonumber(item.EnchanceNum) or 0
    return (rarityLevel * 1000000000000) + (basePower * 1000000000) + affixNum + (enhance * 10)
end

-- Best Gear Equip Scanner (Safe & Synchronous across Weapon, Armor, Hat)
local function equipBestGearNow(targetType)
    if not BackpackData or not Remote_TryEquip then return false, 0 end
    local bp = BackpackData.GetData()
    if not bp or not bp.have then return false, 0 end

    local targets = {}
    if targetType == "All" or targetType == "ฟูลเซ็ต" or not targetType then
        targets = { "Weapon", "Armor", "Hat" }
    elseif string.find(targetType, "Weapon") or string.find(targetType, "ดาบ") or string.find(targetType, "อาวุธ") then
        targets = { "Weapon" }
    elseif string.find(targetType, "Armor") or string.find(targetType, "เกราะ") then
        targets = { "Armor" }
    elseif string.find(targetType, "Hat") or string.find(targetType, "หมวก") then
        targets = { "Hat" }
    else
        targets = { targetType }
    end

    local equippedAny = false
    local lastPower = 0
    for _, slotType in ipairs(targets) do
        local bestUuid = nil
        local bestScore = -1
        for uuid, item in pairs(bp.have) do
            if item.Type == slotType then
                local score = calculateGearScore(item)
                if score > bestScore then
                    bestScore = score
                    bestUuid = uuid
                end
            end
        end

        if bestUuid then
            pcall(function()
                Remote_TryEquip:FireServer(bestUuid, slotType)
            end)
            equippedAny = true
            lastPower = bestScore
        end
    end

    return equippedAny, lastPower
end

-- Core Auto Forge Execution with Smart Ore Slicing & 3-Slot Support
local forgeCycleIndex = 1
local function executeForgeNow(forgeType, minOres)
    forgeType = forgeType or State.ForgeType or "All"
    minOres = minOres or State.MinOreToForge or 4
    if not BackpackData or not Remote_Forge then return false, "No remote" end

    local bp = BackpackData.GetData()
    if not bp or not bp.have then return false, "No backpack data" end

    -- Count total available ores
    local totalOres = 0
    for _, item in pairs(bp.have) do
        if item.Type == "Ore" then
            totalOres = totalOres + (item.Number or 1)
        end
    end

    if totalOres < 4 then
        return false, "Not enough ores (need at least 4)"
    end

    -- Determine slot and target ore count
    local isRotate = string.find(forgeType, "All") or string.find(forgeType, "หมุนเวียน")
    local actualSlot = "Weapon"

    if isRotate then
        local cycleSlots = { "Weapon", "Armor", "Hat" }
        actualSlot = cycleSlots[((forgeCycleIndex - 1) % #cycleSlots) + 1]
    elseif string.find(forgeType, "Hat") or string.find(forgeType, "หมวก") then
        actualSlot = "Hat"
    elseif string.find(forgeType, "Armor") or string.find(forgeType, "เกราะ") then
        actualSlot = "Armor"
    else
        actualSlot = "Weapon"
    end

    local serverConfigType = "Weapon"
    local targetOreCount = 4

    if actualSlot == "Weapon" then
        serverConfigType = "Weapon"
        -- Weapon config: min 4, max 13 (13 ores = 100% Greatsword)
        targetOreCount = math.clamp(totalOres, 4, 13)
        if minOres and minOres > 4 then
            targetOreCount = math.clamp(minOres, 4, math.min(totalOres, 13))
        end
    elseif actualSlot == "Hat" then
        serverConfigType = "Armor"
        -- Hat config: 4 ores = 100% Hat_Light, 16 ores = 80% Hat_Heave
        if totalOres >= 16 and (minOres or 0) >= 16 then
            targetOreCount = 16
        else
            targetOreCount = 4
        end
    elseif actualSlot == "Armor" then
        serverConfigType = "Armor"
        -- Armor config: 23 ores = 100% Armor_Heave, 11 ores = 80% Armor_Light, 8-10 ores = 50-70% Armor_Light
        if totalOres < 8 then
            if not isRotate then
                targetOreCount = math.clamp(totalOres, 4, 23)
            else
                -- In rotation, if less than 8 ores, fallback to guaranteed Hat (4 ores)
                actualSlot = "Hat"
                serverConfigType = "Armor"
                targetOreCount = 4
            end
        else
            if totalOres >= 23 and (minOres or 0) >= 20 then
                targetOreCount = 23
            elseif totalOres >= 11 then
                targetOreCount = 11
            else
                targetOreCount = math.clamp(totalOres, 8, 11)
            end
        end
    end

    if totalOres < targetOreCount then
        return false, "Ores insufficient for " .. actualSlot .. " (need " .. targetOreCount .. ")"
    end

    -- Build ore slice table with quality sorting
    local oreEntries = {}
    for uuid, item in pairs(bp.have) do
        if item.Type == "Ore" then
            local pwr = 0
            if OreHelper and OreHelper.GetPower then
                pcall(function() pwr = OreHelper.GetPower(item.ID) or 0 end)
            end
            table.insert(oreEntries, { uuid = uuid, count = item.Number or 1, power = pwr })
        end
    end

    if State.OreQualityMode == "🌟 ใช้แร่เกรดสูงสุดก่อน (Best Ores First)" then
        table.sort(oreEntries, function(a, b) return a.power > b.power end)
    elseif State.OreQualityMode == "⚪ ใช้แร่เกรดต่ำสุดก่อน (Low Ores First)" then
        table.sort(oreEntries, function(a, b) return a.power < b.power end)
    end

    local oreList = {}
    local collected = 0
    for _, entry in ipairs(oreEntries) do
        local needed = targetOreCount - collected
        local take = math.min(entry.count, needed)
        if take > 0 then
            oreList[entry.uuid] = take
            collected = collected + take
        end
        if collected >= targetOreCount then break end
    end

    if collected < targetOreCount then
        return false, "Failed to slice sufficient ores"
    end

    local ok, res = pcall(function()
        return Remote_Forge:InvokeServer({
            ConfigType = serverConfigType,
            UUIDList = oreList
        })
    end)

    if ok and res then
        if isRotate then
            forgeCycleIndex = forgeCycleIndex + 1
        end
        -- Auto equip the newly forged category and confirm best full set
        task.delay(0.2, function()
            equipBestGearNow(actualSlot)
            task.wait(0.1)
            equipBestGearNow("All")
        end)
        return true, actualSlot, collected
    end

    return false, "Forge remote invoke failed"
end

-- Intelligent Trash Gear Selling with Rarity Retain Filter (Strictly Gear Only - Ores Untouched)
local function sellTrashGearNow()
    if not BackpackData then return 0 end
    local bp = BackpackData.GetData()
    if not bp or not bp.have then return 0 end

    -- Always equip full best gear first if enabled!
    if State.AutoEquipBest then
        equipBestGearNow("All")
        task.wait(0.1)
    end

    local keepThreshold = RarityThresholds[State.MinRarityToKeep] or 5
    if keepThreshold == 0 then return 0 end -- Keep all!

    local soldCount = 0
    -- Iterate strictly over Weapon, Armor, Hat (Never touches Ores/Materials/Stones):
    for uuid, item in pairs(bp.have) do
        if item.Type == "Weapon" or item.Type == "Armor" or item.Type == "Hat" then
            local isEquipped = false
            if BackpackData.IsEquipedUUID then
                pcall(function() isEquipped = BackpackData.IsEquipedUUID(uuid) end)
            end
            if not isEquipped then
                local lvl, _ = getRarityLevel(item)
                if lvl < keepThreshold then
                    -- Server requires 2 arguments: (uuid, quantity)
                    if Remote_TrySellItem then
                        pcall(function() Remote_TrySellItem:FireServer(uuid, 1) end)
                    elseif BackpackData.TrySellItem then
                        pcall(function() BackpackData.TrySellItem(uuid, 1) end)
                    end
                    soldCount = soldCount + 1
                    task.wait(0.02)
                end
            end
        end
    end
    return soldCount
end

-- Independent Auto Sell Ores with Multi-Select Keep Filter (ขายแร่อิสระ พร้อมตัวกรองเลือกระดับแร่ที่จะเก็บไว้)
local function sellOresNow()
    if not BackpackData then return 0 end
    local bp = BackpackData.GetData()
    if not bp or not bp.have then return 0 end

    local keepList = normalizeMultiSelection(State.OreRaritiesToKeep)
    local keepMap = {}
    for _, k in ipairs(keepList) do
        local clean = tostring(k):lower():gsub("[^%a]", "")
        if #clean > 0 then
            keepMap[clean] = true
        end
    end

    local soldCount = 0
    for uuid, item in pairs(bp.have) do
        if item.Type == "Ore" then
            local lvl, rarityName = getRarityLevel(item)
            local cleanR = tostring(rarityName or "Common"):lower():gsub("[^%a]", "")

            -- If this ore rarity is in user's selected keep list, KEEP IT!
            local shouldKeep = (keepMap[cleanR] == true)

            if not shouldKeep then
                local num = tonumber(item.Number) or 1
                -- Server requires 2 arguments: (uuid, quantity)
                if Remote_TrySellItem then
                    pcall(function() Remote_TrySellItem:FireServer(uuid, num) end)
                elseif BackpackData.TrySellItem then
                    pcall(function() BackpackData.TrySellItem(uuid, num) end)
                end
                soldCount = soldCount + 1
                task.wait(0.02)
            end
        end
    end
    return soldCount
end

-- Independent Auto Sell Enchant Stones with Mode & Multi-Select Rarity Filter (ขายหินตีบวกอิสระ ไม่แตะอาวุธ/แร่)
local function sellEnchantStonesNow()
    if not BackpackData then return 0 end
    local bp = BackpackData.GetData()
    if not bp or not bp.have then return 0 end

    local selectedList = normalizeMultiSelection(State.EnchantRarities)
    local selectedMap = {}
    for _, k in ipairs(selectedList) do
        local clean = tostring(k):lower():gsub("[^%a]", "")
        if #clean > 0 then
            selectedMap[clean] = true
        end
    end

    local isSellSelected = true
    if State.EnchantFilterMode and State.EnchantFilterMode:find("เก็บ") then
        isSellSelected = false -- Keep Selected Mode
    end

    local soldCount = 0
    for uuid, item in pairs(bp.have) do
        local isEnchStone = (item.Type == "EnchStone") or (item.ID and item.ID:find("Stone"))
        if isEnchStone then
            local lvl, rarityName = getRarityLevel(item)
            local cleanR = tostring(rarityName or "Common"):lower():gsub("[^%a]", "")

            local isSelected = (selectedMap[cleanR] == true)
            local shouldSell = false

            if isSellSelected then
                -- Sell Selected Mode: If this rarity is in selected list, SELL IT
                shouldSell = isSelected
            else
                -- Keep Selected Mode: If this rarity is in selected list, KEEP IT (sell if not selected)
                shouldSell = not isSelected
            end

            if shouldSell then
                local num = tonumber(item.Number) or tonumber(item.Count) or 1
                -- Server requires 2 arguments: (uuid, quantity)
                if Remote_TrySellItem then
                    pcall(function() Remote_TrySellItem:FireServer(uuid, num) end)
                elseif BackpackData.TrySellItem then
                    pcall(function() BackpackData.TrySellItem(uuid, num) end)
                end
                soldCount = soldCount + 1
                task.wait(0.02)
            end
        end
    end
    return soldCount
end

-- Collect Dropped Crystals / Ores in Workspace (Universal Map-Wide Sweep)
collectAllWorldOres = function()
    local count = 0
    local oreCache = workspace:FindFirstChild("OreCache")
    if oreCache then
        for _, ore in ipairs(oreCache:GetChildren()) do
            local prompt = ore:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                pcall(function()
                    prompt.MaxActivationDistance = 99999
                    prompt.RequiresLineOfSight = false
                end)
                if fireproximityprompt then
                    pcall(function() fireproximityprompt(prompt, 0) end)
                else
                    pcall(function()
                        prompt:InputHoldBegin()
                        task.wait(0.05)
                        prompt:InputHoldEnd()
                    end)
                end
                count = count + 1
            end
        end
    end
    return count
end

-- Auto Enchant Equipped Gear (Weapons, Armor, Hats)
local function autoEnchantEquippedGear()
    if not BackpackData then return false end
    local bp = BackpackData.GetData()
    if not bp or not bp.have then return false end

    -- 1. Gather all available enchantment stones in inventory
    local stones = {}
    for uuid, item in pairs(bp.have) do
        if item.Type == "EnchStone" or (item.ID and item.ID:find("Stone")) then
            local count = item.Number or item.Count or 1
            for i = 1, count do
                table.insert(stones, uuid)
            end
        end
    end

    if #stones == 0 then return false end

    -- 2. Find equipped items that have open enchantment slots
    local stoneIdx = 1
    local enchantedCount = 0

    for uuid, item in pairs(bp.have) do
        if BackpackData.IsEquipedUUID and BackpackData.IsEquipedUUID(uuid) then
            local maxSlots = item.EnchanceNum or 0
            if maxSlots > 0 then
                local currentList = item.EnchanceList or {}
                local usedSlots = 0
                for _, s in ipairs(currentList) do
                    if s and (s.ID or s.id or s.Name) and (s.ID ~= "" and s.id ~= "") then
                        usedSlots = usedSlots + 1
                    end
                end

                local emptySlots = maxSlots - usedSlots
                while emptySlots > 0 and stoneIdx <= #stones do
                    local stoneUuid = stones[stoneIdx]
                    stoneIdx = stoneIdx + 1
                    pcall(function()
                        if BackpackData.EnchantEquipment then
                            BackpackData.EnchantEquipment(uuid, stoneUuid)
                        elseif Remote_Enchant then
                            Remote_Enchant:FireServer(uuid, stoneUuid)
                        end
                    end)
                    enchantedCount = enchantedCount + 1
                    emptySlots = emptySlots - 1
                    task.wait(0.2)
                end
            end
        end
        if stoneIdx > #stones then break end
    end

    return enchantedCount > 0
end

-- Auto Drink Multiplier Buff Potions (Zero-Waste, Check Active Buffs)
local function autoDrinkPotionsNow()
    local usedAny = false
    local potList = {
        { id = "TrainPotion", buff = "Train_1", enabled = State.AutoTrainPotion },
        { id = "CoinPotion", buff = "Coin_1", enabled = State.AutoCoinPotion },
        { id = "LuckPotion", buff = "Luck_1", enabled = State.AutoLuckPotion },
        { id = "DamagePotion", buff = "Damage_1", enabled = State.AutoDamagePotion },
        { id = "HPPotion", buff = "HP_1", enabled = State.AutoHPPotion },
    }

    local pData = PotionData and PotionData.GetData and PotionData.GetData()
    for _, pot in ipairs(potList) do
        if pot.enabled and (State.AutoBuffPotions or pot.enabled) then
            local hasBuff = false
            if BuffData and BuffData.IsHaveBuff then
                hasBuff = BuffData.IsHaveBuff(pot.buff) or (BuffData.GetBuffLastTime and BuffData.GetBuffLastTime(pot.buff) > 0)
            end

            if not hasBuff then
                local count = pData and pData[pot.id] or 0
                if count > 0 then
                    pcall(function()
                        if PotionData and PotionData.UsePotion then
                            PotionData.UsePotion(pot.id)
                        elseif Remote_TryUsePotion then
                            Remote_TryUsePotion:FireServer(pot.id)
                        end
                    end)
                    usedAny = true
                    task.wait(0.15)
                end
            end
        end
    end
    return usedAny
end

-- Auto Roll Class with Target Rarity Stop Lock
local function autoRollClassNow()
    if not ClassData or not Remote_LuckOnce then return false end
    local tickets = (ClassData.GetLuckTimes and ClassData.GetLuckTimes()) or 0
    if tickets <= 0 then return false end

    -- Check current class
    local curClassId = ClassData.GetEquipedClass and ClassData.GetEquipedClass()
    local curRarity = "Common"
    if ClassConfig and curClassId and ClassConfig[curClassId] then
        curRarity = ClassConfig[curClassId].Rarity or "Common"
    end

    local rarityWeight = {
        ["Common"] = 1,
        ["UnCommon"] = 2,
        ["Rare"] = 3,
        ["Epic"] = 4,
        ["Legendary"] = 5,
        ["Mythic"] = 6
    }

    local targetWeight = 5 -- Default: Legendary+
    if State.TargetClassRarity and State.TargetClassRarity:find("Mythic") then
        targetWeight = 6
    elseif State.TargetClassRarity and State.TargetClassRarity:find("Epic") then
        targetWeight = 4
    end

    local curWeight = rarityWeight[curRarity] or 1
    if curWeight >= targetWeight then
        -- Target reached! Stop rolling.
        State.AutoRollClass = false
        if UIControls.AutoRollClass then
            pcall(function()
                if UIControls.AutoRollClass.SetValue then UIControls.AutoRollClass:SetValue(false)
                elseif UIControls.AutoRollClass.Set then UIControls.AutoRollClass:Set(false) end
            end)
        end
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Class",
                Content = "สุ่มได้คลาสระดับ " .. tostring(curRarity) .. " แล้ว! หยุดสุ่มอัตโนมัติเพื่อเซฟตั๋ว"
            })
        end
        return false
    end

    -- Fire roll
    pcall(function()
        Remote_LuckOnce:FireServer()
    end)
    return true
end

-- Full Palette Theme Presets
local ThemePresets = {
    ["2SKI Cyber Cyan (ธีมหลักทางการ - ขาว ฟ้าเรืองแสง Electric Blue)"] = {
        WindTheme = "Sky",
        Hex = "#00BFFF",
        C1 = Color3.fromRGB(248, 251, 255),
        C2 = Color3.fromRGB(125, 235, 255),
        C3 = Color3.fromRGB(0, 191, 255),
        C4 = Color3.fromRGB(0, 140, 255),
        Glow = Color3.fromRGB(0, 140, 255),
        GlowTransparency = 0.55
    },
    ["Tiffany Pastel Mint (สีเขียวมิ้นท์พาสเทล)"] = { WindTheme = "Tiffany", Hex = "#00FFE0", C1 = Color3.fromRGB(0,255,224), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(80,230,210), Glow = Color3.fromRGB(0,255,224), GlowTransparency = 0.55 },
    ["Sky Blue Glow (ฟ้านีออนสว่าง)"]            = { WindTheme = "Sky",     Hex = "#00D0FF", C1 = Color3.fromRGB(0,208,255), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(100,225,255), Glow = Color3.fromRGB(0,208,255), GlowTransparency = 0.55 },
    ["Neon Emerald (เขียวมรกตนีออน)"]             = { WindTheme = "Emerald", Hex = "#00FF99", C1 = Color3.fromRGB(0,255,153), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(90,255,180), Glow = Color3.fromRGB(0,255,153), GlowTransparency = 0.55 },
    ["Cyber Violet (ม่วงไซเบอร์)"]                = { WindTheme = "Purple",  Hex = "#C866FF", C1 = Color3.fromRGB(200,102,255), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(220,160,255), Glow = Color3.fromRGB(200,102,255), GlowTransparency = 0.55 },
    ["Neon Rose (ชมพูกุหลาบไฟ)"]                = { WindTheme = "Rose",    Hex = "#FF3377", C1 = Color3.fromRGB(255,51,119), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(255,140,180), Glow = Color3.fromRGB(255,51,119), GlowTransparency = 0.55 },
    ["Golden Amber (ทองอำพันพรีเมียม)"]           = { WindTheme = "Amber",   Hex = "#FFB700", C1 = Color3.fromRGB(255,183,0), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(255,215,100), Glow = Color3.fromRGB(255,183,0), GlowTransparency = 0.55 },
    ["Electric Blue (น้ำเงินสดใส)"]               = { WindTheme = "Blue",    Hex = "#3D8EFF", C1 = Color3.fromRGB(61,142,255), C2 = Color3.fromRGB(255,255,255), C3 = Color3.fromRGB(140,190,255), Glow = Color3.fromRGB(61,142,255), GlowTransparency = 0.55 }
}

-- Cleanup Function
_G.TwoSkiCleanup = function()
    _G.TwoSkiRunning = false
    _G.TwoSkiLoaded = false
    if manualFlyCon then pcall(function() manualFlyCon:Disconnect() end) end
    if manualFlyBv then pcall(function() manualFlyBv:Destroy() end) end
    if manualFlyBg then pcall(function() manualFlyBg:Destroy() end) end
    if noclipCon then pcall(function() noclipCon:Disconnect() end) end
    local _, _, hum = getCharHrp()
    if hum then hum.PlatformStand = false end
    for _, c in ipairs(Connections) do
        if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
    end
    safeDestroyGui("TwoSki_LootToForge_Floating")
    safeDestroyGui("WindUI")
    if _G.TwoSkiWindUI then
        pcall(function()
            if _G.TwoSkiWindUI.Window and _G.TwoSkiWindUI.Window.Destroy then
                _G.TwoSkiWindUI.Window:Destroy()
            end
        end)
        _G.TwoSkiWindUI.Window = nil
        pcall(function()
            if _G.TwoSkiWindUI.ScreenGui then
                _G.TwoSkiWindUI.ScreenGui:Destroy()
            end
        end)
        _G.TwoSkiWindUI.ScreenGui = nil
    end
    if WindUI and WindUI.Window and WindUI.Window.Destroy then
        pcall(function() WindUI.Window:Destroy() end)
        WindUI.Window = nil
    end
end

-- ── TURBO-SPEED WINDUI ENGINE LOADER (LOCAL SSD CACHE + OFFLINE BUNDLED ICONS) ──
local WindUI = nil
local cacheFile = "2k_windui_fast_cache.lua"

-- 1. Instant Local Disk Cache (Loads in <0.01 seconds without downloading!)
if isfile and readfile and isfile(cacheFile) then
    pcall(function()
        local cached = readfile(cacheFile)
        if cached and #cached > 1000000 then
            local fn = loadstring(cached)
            if fn then
                WindUI = fn()
            end
        end
    end)
end

-- 2. Fast Standalone Bundle (Pre-patched icons, ZERO extra GitHub HTTP requests)
if not WindUI then
    local WindUILoadUrls = {
        "https://raw.githubusercontent.com/hxrendontcry/2kscripts/main/windui.lua",
        "https://cdn.jsdelivr.net/gh/hxrendontcry/2kscripts@main/windui.lua",
        "https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
        "https://fastly.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua"
    }

    for _, url in ipairs(WindUILoadUrls) do
        local ok, res = pcall(function()
            local raw = game:HttpGet(url .. "?v=" .. tostring(os.time()))
            if raw and #raw > 100000 then
                -- Auto-save to local disk cache for instant startup next time
                if writefile then
                    pcall(writefile, cacheFile, raw)
                end
                return loadstring(raw)()
            end
        end)
        if ok and res and type(res) == "table" then
            WindUI = res
            break
        end
    end
end

if WindUI then
    _G.TwoSkiWindUI = WindUI
    pcall(function()
        if WindUI.Window then
            if WindUI.Window.Destroy then WindUI.Window:Destroy() end
            WindUI.Window = nil
        end
    end)
end

if not WindUI then
    warn("[2SKI] Critical Error: Cannot load WindUI engine.")
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "TwoSki_LoadError"
        sg.ResetOnSpawn = false
        sg.DisplayOrder = 9999999
        local fr = Instance.new("Frame")
        fr.Size = UDim2.fromOffset(360, 110)
        fr.Position = UDim2.new(0.5, -180, 0.15, 0)
        fr.BackgroundColor3 = Color3.fromRGB(24, 12, 16)
        fr.BorderSizePixel = 0
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, 10)
        uic.Parent = fr
        local uis = Instance.new("UIStroke")
        uis.Color = Color3.fromRGB(255, 60, 80)
        uis.Thickness = 1.5
        uis.Parent = fr
        local lb = Instance.new("TextLabel")
        lb.Size = UDim2.new(1, -20, 1, -20)
        lb.Position = UDim2.new(0, 10, 0, 10)
        lb.BackgroundTransparency = 1
        lb.TextColor3 = Color3.fromRGB(255, 255, 255)
        lb.Font = Enum.Font.GothamMedium
        lb.TextSize = 13
        lb.TextWrapped = true
        lb.Text = "[2SKI Engine Error]\nไม่สามารถดาวน์โหลด WindUI ได้\nกรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ตหรือตัวรัน (Executor)"
        lb.Parent = fr
        local parent = (env.gethui and env.gethui()) or (CoreGui and CoreGui:FindFirstChild("RobloxGui")) or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 5))
        if parent then
            fr.Parent = sg
            sg.Parent = parent
            task.delay(8, function() pcall(function() sg:Destroy() end) end)
        end
    end)
    return
end

-- Register Custom Themes
local function regTheme(name, hexAcc, hexBg, hexDlg, hexBtn, hexPnl, hexElm)
    local cAcc = Color3.fromHex(hexAcc)
    WindUI:AddTheme({
        Name = name,
        Accent = cAcc,
        Dialog = Color3.fromHex(hexDlg),
        Outline = cAcc,
        Text = Color3.fromHex("#FFFFFF"),
        Placeholder = cAcc,
        Background = Color3.fromHex(hexBg),
        Button = Color3.fromHex(hexBtn),
        Icon = cAcc,
        Toggle = cAcc,
        Slider = cAcc,
        Checkbox = cAcc,
        PanelBackground = Color3.fromHex(hexPnl),
        ElementBackground = Color3.fromHex(hexElm)
    })
end

regTheme("Tiffany", "#00FFE0", "#10282C", "#163A40", "#24555E", "#17373D", "#1E464E")
regTheme("Sky",     "#00D0FF", "#102538", "#153652", "#255278", "#173550", "#1F4568")
regTheme("Emerald", "#00FF99", "#102B1E", "#153E2A", "#235B3E", "#173C2A", "#1F4E37")
regTheme("Purple",  "#C866FF", "#241538", "#331E50", "#4E2E78", "#321E4E", "#422766")
regTheme("Rose",    "#FF3377", "#2B121C", "#3E1827", "#5E243A", "#3D1A28", "#4F2235")
regTheme("Amber",   "#FFB700", "#2A200E", "#3E2D12", "#5C451D", "#3B2D14", "#4C3A1A")
regTheme("Blue",    "#3D8EFF", "#14223B", "#1C3054", "#2C497E", "#1C3054", "#253F6D")

local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
local winWidth = isMobile and math.clamp(math.floor(vp.X * 0.88), 360, 560) or 580
local winHeight = isMobile and math.clamp(math.floor(vp.Y * 0.82), 275, 430) or 460
local minW = isMobile and math.clamp(math.floor(vp.X * 0.68), 290, 440) or 480
local minH = isMobile and math.clamp(math.floor(vp.Y * 0.60), 220, 310) or 320

-- Config Manager with Debounce
local CONFIG_FILE = "2SKI_LootToForge_Config.json"
local saveDebounce = false

local function saveConfig(silent)
    if not writefile then return false end
    local clean = {}
    for k, v in pairs(State) do
        local t = type(v)
        if t == "boolean" or t == "number" or t == "string" or t == "table" then
            clean[k] = v
        end
    end
    local ok = pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(clean)) end)
    if ok and not silent and _G.TwoSkiLoaded and WindUI and WindUI.Notify then
        WindUI:Notify({ Title = "2SKI Config", Content = "บันทึกการตั้งค่าลงเครื่องเรียบร้อย!" })
    end
    return ok
end

local function autoSaveConfig()
    if saveDebounce then return end
    saveDebounce = true
    task.delay(0.6, function()
        saveDebounce = false
        saveConfig(true)
    end)
end

-- Auto-Save Tab Wrapper (Wraps all UI controls)
local function wrapTabWithAutoSave(tab)
    local oldToggle = tab.Toggle
    if oldToggle then
        tab.Toggle = function(self, opt)
            local origCb = opt.Callback
            opt.Callback = function(val)
                if origCb then origCb(val) end
                autoSaveConfig()
            end
            return oldToggle(self, opt)
        end
    end
    local oldSlider = tab.Slider
    if oldSlider then
        tab.Slider = function(self, opt)
            local origCb = opt.Callback
            opt.Callback = function(val)
                if origCb then origCb(val) end
                autoSaveConfig()
            end
            return oldSlider(self, opt)
        end
    end
    local oldDropdown = tab.Dropdown
    if oldDropdown then
        tab.Dropdown = function(self, opt)
            local origCb = opt.Callback
            opt.Callback = function(val)
                if origCb then origCb(val) end
                autoSaveConfig()
            end
            return oldDropdown(self, opt)
        end
    end
    return tab
end

if WindUI.Window then
    pcall(function()
        if WindUI.Window.Destroy then WindUI.Window:Destroy() end
    end)
    WindUI.Window = nil
end

local Window = WindUI:CreateWindow({
    Title = "2SKI",
    SubTitle = "+1 ของรางวัลที่จะหลอม (Loot to Forge) v2.5 Master",
    Folder = "2ski_loot_to_forge",
    Theme = "Sky",
    Transparent = false,
    SideBarWidth = isMobile and 140 or 195,
    HasOutline = true,
    Keybind = Enum.KeyCode.LeftControl,
    Size = UDim2.fromOffset(winWidth, winHeight),
    MinSize = Vector2.new(minW, minH),
    OpenButton = { Enabled = false, Draggable = false, OnlyMobile = false },
    User = { Enabled = true, Anonymous = false },
    Topbar = { Height = isMobile and 40 or 44, ButtonsType = "Mac" }
})

if not Window and WindUI.Window then
    Window = WindUI.Window
end

if not Window then
    warn("[2SKI] Critical Error: Failed to create WindUI Window.")
    return
end

_G.TwoSkiWindow = Window

local origWindowTab = Window.Tab
Window.Tab = function(self, opt)
    local t = origWindowTab(self, opt)
    return wrapTabWithAutoSave(t)
end

-- Floating Squircle Laser Comet Toggle Button
local GuiParent = getSafeGuiContainer() or (LocalPlayer and LocalPlayer:WaitForChild("PlayerGui", 10))
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "TwoSki_LootToForge_Floating"
ToggleGui.ResetOnSpawn = false
ToggleGui.DisplayOrder = 9999999
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.IgnoreGuiInset = true
ToggleGui.Parent = GuiParent

local FloatingContainer = Instance.new("Frame")
FloatingContainer.Name = "FloatingContainer"
FloatingContainer.Size = UDim2.fromOffset(38, 38)
FloatingContainer.Position = UDim2.new(0, 15, 0.45, 0)
FloatingContainer.BackgroundTransparency = 1
FloatingContainer.BorderSizePixel = 0
FloatingContainer.Active = true
FloatingContainer.ZIndex = 1000
FloatingContainer.Parent = ToggleGui

local GlowFrame = Instance.new("Frame")
GlowFrame.Name = "GlowHalo"
GlowFrame.Size = UDim2.new(1, 6, 1, 6)
GlowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
GlowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
GlowFrame.BackgroundTransparency = 1
GlowFrame.BorderSizePixel = 0
GlowFrame.ZIndex = 999
GlowFrame.Parent = FloatingContainer

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 13)
GlowCorner.Parent = GlowFrame

local GlowStroke = Instance.new("UIStroke")
GlowStroke.Thickness = 3.2
GlowStroke.Color = Color3.fromRGB(0, 220, 255)
GlowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
GlowStroke.Parent = GlowFrame

local GlowGradient = Instance.new("UIGradient")
GlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.12, Color3.fromRGB(125, 235, 255)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(0, 191, 255)),
    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 70, 200)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
})
GlowGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.0, 0.05),
    NumberSequenceKeypoint.new(0.15, 0.2),
    NumberSequenceKeypoint.new(0.32, 0.85),
    NumberSequenceKeypoint.new(0.45, 1.0),
    NumberSequenceKeypoint.new(1.0, 1.0)
})
GlowGradient.Parent = GlowStroke

local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingSquircle"
FloatingButton.Size = UDim2.new(1, 0, 1, 0)
FloatingButton.Position = UDim2.new(0.5, 0, 0.5, 0)
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.BackgroundColor3 = Color3.fromRGB(4, 8, 16)
FloatingButton.AutoButtonColor = false
FloatingButton.Text = ""
FloatingButton.BorderSizePixel = 0
FloatingButton.Active = true
FloatingButton.ClipsDescendants = false
FloatingButton.ZIndex = 1001
FloatingButton.Parent = FloatingContainer

local SquircleCorner = Instance.new("UICorner")
SquircleCorner.CornerRadius = UDim.new(0, 11)
SquircleCorner.Parent = FloatingButton

local BorderStroke = Instance.new("UIStroke")
BorderStroke.Thickness = 2.4
BorderStroke.Color = Color3.fromRGB(255, 255, 255)
BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
BorderStroke.Parent = FloatingButton

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.10, Color3.fromRGB(135, 245, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 191, 255)),
    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(0, 80, 240)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
})
BorderGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0.0, 0.0),
    NumberSequenceKeypoint.new(0.12, 0.0),
    NumberSequenceKeypoint.new(0.28, 0.75),
    NumberSequenceKeypoint.new(0.38, 1.0),
    NumberSequenceKeypoint.new(0.92, 1.0),
    NumberSequenceKeypoint.new(1.0, 0.0)
})
BorderGradient.Parent = BorderStroke

local MintDot = Instance.new("Frame")
MintDot.Name = "MintIndicatorDot"
MintDot.Size = UDim2.fromOffset(7, 7)
MintDot.Position = UDim2.new(1, -9.5, 0, 3)
MintDot.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
MintDot.BorderSizePixel = 0
MintDot.ZIndex = 1003
MintDot.Parent = FloatingButton

local MintCorner = Instance.new("UICorner")
MintCorner.CornerRadius = UDim.new(1, 0)
MintCorner.Parent = MintDot

local LogoImage = Instance.new("ImageLabel")
LogoImage.Name = "LogoImage"
LogoImage.Size = UDim2.new(0.88, 0, 0.88, 0)
LogoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
LogoImage.AnchorPoint = Vector2.new(0.5, 0.5)
LogoImage.BackgroundTransparency = 1
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.ZIndex = 1002
LogoImage.Parent = FloatingButton

pcall(function()
    local getAsset = getcustomasset or getsynasset
    local fileName = "2ski_logo.png"
    if writefile and getAsset then
        if not (isfile and isfile(fileName)) then
            local ok, content = pcall(function()
                return game:HttpGet("https://files.catbox.moe/jrwfti.png")
            end)
            if ok and content and #content > 0 then
                writefile(fileName, content)
            end
        end
        LogoImage.Image = getAsset(fileName)
    elseif getAsset then
        LogoImage.Image = getAsset(fileName)
    end
end)

local LogoText = Instance.new("TextLabel")
LogoText.Name = "LogoText"
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.RichText = true
LogoText.Font = Enum.Font.FredokaOne
LogoText.Text = '<font color="#FFFFFF">2</font><font color="#00D0FF">SKI</font>'
LogoText.TextSize = 14
LogoText.ZIndex = 1003
LogoText.Parent = FloatingButton

if LogoImage.Image and LogoImage.Image ~= "" then
    LogoText.Visible = false
else
    LogoText.Visible = true
end

local rotSpeed = 42
local currentRot = 0
local rotConnection = RunService.RenderStepped:Connect(function(dt)
    if not _G.TwoSkiRunning or _G.TwoSkiActiveToken ~= myToken then return end
    if not State.FloatingButtonVisible or not ToggleGui or not ToggleGui.Enabled then return end
    currentRot = (currentRot + dt * rotSpeed) % 360
    if BorderGradient and BorderGradient.Parent then BorderGradient.Rotation = currentRot end
    if GlowGradient and GlowGradient.Parent then GlowGradient.Rotation = currentRot end
end)
table.insert(Connections, rotConnection)

local function applyThemePreset(presetName)
    local p = ThemePresets[presetName]
    if not p then return end
    pcall(function() if WindUI and WindUI.SetTheme then WindUI:SetTheme(p.WindTheme) end end)
    if BorderGradient then
        BorderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.18, p.C1 or Color3.fromRGB(125, 235, 255)),
            ColorSequenceKeypoint.new(0.42, p.C2 or Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(0.7, p.C3 or Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
        })
    end
    if GlowGradient then
        GlowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.25, p.C1 or Color3.fromRGB(125, 235, 255)),
            ColorSequenceKeypoint.new(0.6, p.C2 or Color3.fromRGB(0, 191, 255)),
            ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255))
        })
    end
    if MintDot then MintDot.BackgroundColor3 = p.C3 or p.C1 end
    if LogoText then LogoText.Text = '<font color="#FFFFFF">2</font><font color="' .. p.Hex .. '">SKI</font>' end
end

local isWindowOpen = true
pcall(function()
    if Window.OnOpen then
        Window:OnOpen(function()
            isWindowOpen = true
        end)
    end
    if Window.OnClose then
        Window:OnClose(function()
            isWindowOpen = false
        end)
    end
end)

local lastToggleTime = 0
local function toggleMainWindow()
    local now = tick()
    if now - lastToggleTime < 0.22 then return end
    lastToggleTime = now

    pcall(function()
        if not Window then return end

        local currentlyOpen = isWindowOpen
        if Window.UIElements and Window.UIElements.Main then
            currentlyOpen = Window.UIElements.Main.Visible
        elseif Window.Closed ~= nil then
            currentlyOpen = not Window.Closed
        end

        if currentlyOpen then
            isWindowOpen = false
            Window:Close()
        else
            isWindowOpen = true
            Window:Open()
            task.defer(function()
                pcall(function()
                    if TabFarm and TabFarm.Select then
                        TabFarm:Select()
                    elseif Window.SelectTab then
                        Window:SelectTab(1)
                    end
                end)
            end)
        end
    end)
end

local isDragging = false
local wasDragged = false
local dragStartPos = nil
local startBtnPos = nil
local activeDragInput = nil

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        wasDragged = false
        activeDragInput = input
        dragStartPos = input.Position
        startBtnPos = Vector2.new(FloatingContainer.AbsolutePosition.X, FloatingContainer.AbsolutePosition.Y)
    end
end)

table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input == activeDragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if dragStartPos and startBtnPos then
            local delta = input.Position - dragStartPos
            if delta.Magnitude > 14 then
                wasDragged = true
            end
            if wasDragged then
                local currentVp = cam and cam.ViewportSize or Vector2.new(1280, 720)
                local btnSize = FloatingContainer.AbsoluteSize
                local newX = math.clamp(startBtnPos.X + delta.X, 0, currentVp.X - btnSize.X)
                local newY = math.clamp(startBtnPos.Y + delta.Y, 0, currentVp.Y - btnSize.Y)
                FloatingContainer.Position = UDim2.fromOffset(newX, newY)
            end
        end
    end
end))

table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isDragging then
            isDragging = false
            activeDragInput = nil
            if not wasDragged then
                toggleMainWindow()
            else
                task.delay(0.2, function() wasDragged = false end)
            end
        end
    end
end))

-- Direct Roblox Activated & MouseButton1Click bindings (guaranteed mobile & desktop toggle!)
FloatingButton.Activated:Connect(function()
    if not wasDragged then
        toggleMainWindow()
    end
end)

FloatingButton.MouseButton1Click:Connect(function()
    if not wasDragged then
        toggleMainWindow()
    end
end)

table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
        toggleMainWindow()
    end
end))

-- TAB 1: ฟาร์มพลัง & แร่ (Power & Ore Auto-Farm)
local TabFarm = Window:Tab({ Title = "ฟาร์มพลัง & แร่", Icon = "sword" })

local function updateLiveStatsDisplay()
    -- Live stats dashboard disabled per user request
end

TabFarm:Section({ Title = "ระบบปั๊มพลังตีหุ่น & แท่นคูณพิเศษ (Power Train & Multiplier Zones)" })

UIControls.AutoTrain = TabFarm:Toggle({
    Title = "ปั๊มพลังอัตโนมัติ (Auto Train Power)",
    Value = State.AutoTrain,
    Callback = function(val)
        State.AutoTrain = val
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Farm", Content = val and "เริ่มระบบปั๊มพลังอัตโนมัติ (Auto Train)!" or "หยุดปั๊มพลัง" })
        end
    end
})

UIControls.AutoTrainBestZone = TabFarm:Toggle({
    Title = "ปั๊มพลังแท่นคูณพิเศษออโต้ (Auto Train Multiplier Zone)",
    Value = State.AutoTrainBestZone,
    Callback = function(val)
        State.AutoTrainBestZone = val
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Zone", Content = val and "เริ่มระบบยืนแท่นคูณและปั๊มพลังอัตโนมัติ!" or "หยุดปั๊มพลังแท่นคูณ" })
        end
    end
})

UIControls.SelectedTrainZone = TabFarm:Dropdown({
    Title = "เลือกแท่นฝึกพลัง (Select Training Zone)",
    Values = getTrainZoneNames(),
    Value = State.SelectedTrainZone,
    Callback = function(val)
        State.SelectedTrainZone = val
    end
})

TabFarm:Section({ Title = "⚔️ เคลียร์ด่าน & ดูดแร่อัตโนมัติ (Stage & Crystal Farm)" })

UIControls.AutoClearStage = TabFarm:Toggle({
    Title = "เคลียร์ด่านอัตโนมัติ (Auto Clear Stage)",
    Value = State.AutoClearStage,
    Callback = function(val)
        State.AutoClearStage = val
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Stage", Content = val and ("เริ่มฟาร์มด่าน " .. tostring(State.SelectedStage) .. " อัตโนมัติ!") or "หยุดฟาร์มด่าน" })
        end
    end
})

UIControls.SelectedStage = TabFarm:Dropdown({
    Title = "เลือกด่านที่ต้องการฟาร์ม (Select Stage)",
    Values = getStageList(),
    Value = State.SelectedStage,
    Callback = function(val)
        State.SelectedStage = val
    end
})

UIControls.AutoCollectCrystals = TabFarm:Toggle({
    Title = "ดูดคริสตัล & แร่ในแมพอัตโนมัติ (Auto Collect Crystals)",
    Value = State.AutoCollectCrystals,
    Callback = function(val) State.AutoCollectCrystals = val end
})

UIControls.StageDelay = TabFarm:Slider({
    Title = "ดีเลย์รอบฟาร์มด่าน (วินาที)",
    Step = 0.05,
    Value = { Min = 0.15, Max = 2.0, Default = State.StageDelay },
    Callback = function(val) State.StageDelay = val end
})

TabFarm:Section({ Title = "🏰 ดันเจี้ยน & กิจกรรมพิเศษ (Dungeon & Boss)" })

UIControls.AutoDungeon = TabFarm:Toggle({
    Title = "ลงดันเจี้ยนอัตโนมัติ (Auto Dungeon)",
    Value = State.AutoDungeon,
    Callback = function(val)
        State.AutoDungeon = val
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Dungeon", Content = val and "เริ่มระบบลงดันเจี้ยนอัตโนมัติ!" or "หยุดลงดันเจี้ยน" })
        end
    end
})

UIControls.TargetDungeonRound = TabFarm:Slider({
    Title = "เลือกรอบดันเจี้ยน (Target Round)",
    Step = 1,
    Value = { Min = 1, Max = 30, Default = State.TargetDungeonRound or 1 },
    Callback = function(val)
        State.TargetDungeonRound = val
    end
})

UIControls.DungeonInstaKill = TabFarm:Toggle({
    Title = "กำจัดมอนสเตอร์ในดันทันที (Insta-Kill Dungeon Mobs)",
    Value = State.DungeonInstaKill,
    Callback = function(val)
        State.DungeonInstaKill = val
    end
})

UIControls.AutoKillSuperLoot = TabFarm:Toggle({
    Title = "ล่า SuperLoot อัตโนมัติเมื่อเกิด (Auto Kill SuperLoot)",
    Value = State.AutoKillSuperLoot,
    Callback = function(val) State.AutoKillSuperLoot = val end
})

TabFarm:Section({ Title = "🧪 บัพคูณพลังอัตโนมัติ (Auto 2x Buff Potions)" })

UIControls.AutoBuffPotions = TabFarm:Toggle({
    Title = "ดื่มน้ำยาบัพคูณพลังอัตโนมัติเมื่อหมดเวลา (Auto Drink Potions)",
    Value = State.AutoBuffPotions,
    Callback = function(val)
        State.AutoBuffPotions = val
        if val then
            autoDrinkPotionsNow()
            if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                WindUI:Notify({ Title = "2SKI Potions", Content = "เปิดระบบดื่มน้ำยาบัพอัตโนมัติ (x2 ทุกค่า) เรียบร้อย!" })
            end
        end
    end
})

UIControls.AutoTrainPotion = TabFarm:Toggle({
    Title = "ดื่ม Train Potion (คูณพลังฝึก x2)",
    Value = State.AutoTrainPotion,
    Callback = function(val) State.AutoTrainPotion = val end
})

UIControls.AutoCoinPotion = TabFarm:Toggle({
    Title = "ดื่ม Coin Potion (คูณเงินดรอป x2)",
    Value = State.AutoCoinPotion,
    Callback = function(val) State.AutoCoinPotion = val end
})

UIControls.AutoLuckPotion = TabFarm:Toggle({
    Title = "ดื่ม Luck Potion (คูณดวงดรอปของเทพ x2)",
    Value = State.AutoLuckPotion,
    Callback = function(val) State.AutoLuckPotion = val end
})

TabFarm:Button({
    Title = "⚡ ตรวจสอบและดื่มน้ำยาบัพทันที (Drink Buff Potions Now)",
    Callback = function()
        local ok = autoDrinkPotionsNow()
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Potions",
                Content = ok and "ดื่มน้ำยาบัพคูณพลัง x2 สำเร็จ!" or "บัพยังคงทำงานอยู่ หรือไม่มีน้ำยาในกระเป๋า"
            })
        end
    end
})

-- TAB 2: เก็บเงิน & รางวัล (Money & Rewards Auto-Collect)
local TabMoney = Window:Tab({ Title = "เก็บเงิน & รางวัล", Icon = "coins" })

TabMoney:Section({ Title = "⚔️ ระบบขายอุปกรณ์ขยะอัตโนมัติ (Auto Sell Gear Only)" })

UIControls.AutoSellGear = TabMoney:Toggle({
    Title = "ขายอุปกรณ์ขยะอัตโนมัติ (เฉพาะดาบ/เกราะ/หมวก ไม่แตะแร่)",
    Value = State.AutoSellGear or State.AutoSellAll,
    Callback = function(val)
        State.AutoSellGear = val
        State.AutoSellAll = val
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Gear Sell",
                Content = val and "เปิดระบบขายอุปกรณ์ขยะอัตโนมัติ (แร่และหินตีบวกปลอดภัย 100%)" or "ปิดระบบขายอุปกรณ์"
            })
        end
    end
})

UIControls.MinRarityToKeep = TabMoney:Dropdown({
    Title = "ระดับอุปกรณ์ที่จะเก็บไว้ ไม่ขายทิ้ง (Keep Gear Rarity)",
    Values = {
        "👑 Infinite เท่านั้น (Keep Infinite Only)",
        "💠 Ancient ขึ้นไป (Keep Ancient+)",
        "🌌 Secret ขึ้นไป (Keep Secret+)",
        "⚡ Eternal ขึ้นไป (Keep Eternal+)",
        "🔴 Mythic ขึ้นไป (Keep Mythic+)",
        "🟡 Legendary ขึ้นไป (Keep Legendary+)",
        "🟣 Epic ขึ้นไป (Keep Epic+)",
        "🟢 Rare ขึ้นไป (Keep Rare+)",
        "⚪ Uncommon ขึ้นไป (Keep Uncommon+)",
        "ขายทั้งหมดที่ไม่ใส่ (Sell All Non-Equipped)",
        "เก็บทั้งหมด (Keep All - ไม่ขายเกียร์)"
    },
    Value = State.MinRarityToKeep,
    Callback = function(val) State.MinRarityToKeep = val end
})

TabMoney:Button({
    Title = "สวมใส่ของโหดสุดแล้วขายอุปกรณ์ขยะทันที (Sell Trash Gear Now)",
    Callback = function()
        local count = sellTrashGearNow()
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Gear Sell",
                Content = "ขายอุปกรณ์ขยะไป " .. tostring(count) .. " ชิ้น (แร่และหินตีบวกปลอดภัย ไม่โดนขาย)!"
            })
        end
    end
})

TabMoney:Section({ Title = "💎 ระบบขายแร่อัตโนมัติ (Auto Sell Ores Only - แยกอิสระ)" })

UIControls.AutoSellOres = TabMoney:Toggle({
    Title = "ขายแร่ที่หิ้วมาอัตโนมัติ (Auto Sell Ores)",
    Value = State.AutoSellOres,
    Callback = function(val)
        State.AutoSellOres = val
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Ore Sell",
                Content = val and "เปิดระบบขายแร่อัตโนมัติ (ขายเฉพาะแร่ที่ไม่ได้เลือกเก็บ)!" or "ปิดระบบขายแร่"
            })
        end
    end
})

UIControls.OreRaritiesToKeep = TabMoney:Dropdown({
    Title = "เลือกระดับแร่ที่จะเก็บไว้ (ห้ามขาย) - เลือกได้หลายระดับ",
    Values = {
        "👑 Infinite",
        "💠 Ancient",
        "🔴 Mythic",
        "🟡 Legendary",
        "🟣 Epic",
        "🟢 Rare",
        "🟢 Uncommon",
        "⚪ Common"
    },
    Value = State.OreRaritiesToKeep,
    Multi = true,
    AllowNone = true,
    Callback = function(val)
        State.OreRaritiesToKeep = type(val) == "table" and val or {val}
    end
})

TabMoney:Button({
    Title = "⚡ ขายแร่ทันที (ตามตัวกรองที่ไม่ได้เลือกเก็บ)",
    Callback = function()
        local count = sellOresNow()
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Ore Sell",
                Content = "ขายแร่ไป " .. tostring(count) .. " ชิ้น (แร่ระดับที่เลือกเก็บยังอยู่ครบ)!"
            })
        end
    end
})

TabMoney:Section({ Title = "🔮 ระบบขายหินตีบวกอัตโนมัติ (Auto Sell Enchant Stones - แยกอิสระ)" })

UIControls.AutoSellEnchant = TabMoney:Toggle({
    Title = "ขายหินตีบวกอัตโนมัติ (Auto Sell Enchant Stones)",
    Value = State.AutoSellEnchant,
    Callback = function(val)
        State.AutoSellEnchant = val
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Enchant Sell",
                Content = val and "เปิดระบบขายหินตีบวกอัตโนมัติ (ตามเงื่อนไขที่เลือก)!" or "ปิดระบบขายหินตีบวก"
            })
        end
    end
})

UIControls.EnchantFilterMode = TabMoney:Dropdown({
    Title = "โหมดตัวกรองหินตีบวก (Enchant Filter Mode)",
    Values = {
        "🔥 เลือกระดับที่จะขายทิ้ง (Sell Selected)",
        "🛡️ เลือกระดับที่จะเก็บไว้ (Keep Selected)"
    },
    Value = State.EnchantFilterMode,
    Callback = function(val)
        State.EnchantFilterMode = val
    end
})

UIControls.EnchantRarities = TabMoney:Dropdown({
    Title = "เลือกระดับหินตีบวก - ติ๊กได้หลายระดับ (Enchant Rarities)",
    Values = {
        "👑 Infinite",
        "💠 Ancient",
        "🔴 Mythic",
        "🟡 Legendary",
        "🟣 Epic",
        "🟢 Rare",
        "🟢 Uncommon",
        "⚪ Common"
    },
    Value = State.EnchantRarities,
    Multi = true,
    AllowNone = true,
    Callback = function(val)
        State.EnchantRarities = type(val) == "table" and val or {val}
    end
})

TabMoney:Button({
    Title = "⚡ ขายหินตีบวกทันที (ตามเงื่อนไขที่เลือก)",
    Callback = function()
        local count = sellEnchantStonesNow()
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Enchant Sell",
                Content = "ขายหินตีบวกไป " .. tostring(count) .. " ชิ้นเรียบร้อย!"
            })
        end
    end
})

TabMoney:Section({ Title = "💰 ระบบเก็บเงินและของขวัญ (Auto Collect Money & Gifts)" })

UIControls.AutoCollectMoney = TabMoney:Toggle({
    Title = "เก็บเงิน & รับของขวัญอัตโนมัติ (ไม่ขายอุปกรณ์ / ไม่ขายแร่)",
    Value = State.AutoCollectMoney,
    Callback = function(val)
        State.AutoCollectMoney = val
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({ Title = "2SKI Money", Content = val and "เปิดระบบเก็บเงินและรับรางวัลอัตโนมัติ!" or "ปิดระบบเก็บเงิน" })
        end
    end
})

TabMoney:Section({ Title = "รับของขวัญและเงินออนไลน์ (Auto Gifts)" })

UIControls.AutoClaimOnline = TabMoney:Toggle({
    Title = "รับของขวัญออนไลน์ออโต้ (Auto Claim Online Gifts)",
    Value = State.AutoClaimOnline,
    Callback = function(val) State.AutoClaimOnline = val end
})

UIControls.AutoClaimGifts = TabMoney:Toggle({
    Title = "รับรางวัลอัปเดต & เงินออฟไลน์ (Loop Rewards)",
    Value = State.AutoClaimGifts,
    Callback = function(val) State.AutoClaimGifts = val end
})

TabMoney:Button({
    Title = "กดรับเงินและของขวัญทั้งหมดทันที (Claim All Coins Now)",
    Callback = function()
        pcall(function()
            if OnlineData and OnlineData.TryClaim then
                for i = 1, 12 do
                    OnlineData.TryClaim(tostring(i))
                    task.wait(0.02)
                end
            end
            if Remote_UpdateClaim then Remote_UpdateClaim:FireServer() end
            if Remote_OfflineClaim then Remote_OfflineClaim:FireServer() end
            if Remote_DungeonTicket then Remote_DungeonTicket:FireServer() end
            if Remote_IndexExp then Remote_IndexExp:InvokeServer() end
            if Remote_IndexLvlReward then
                for lvl = 1, 10 do
                    pcall(function() Remote_IndexLvlReward:InvokeServer(lvl) end)
                end
            end
            if _G.TwoSkiLoaded then
                WindUI:Notify({ Title = "2SKI Money", Content = "รับเงินและของขวัญทุกหมวดหมู่สำเร็จ!" })
            end
        end)
    end
})

-- TAB 3: หลอม & อุปกรณ์ (Auto Forge & Equip)
local TabForge = Window:Tab({ Title = "หลอม & อุปกรณ์", Icon = "hammer" })

TabForge:Section({ Title = "ระบบหลอมอุปกรณ์อัตโนมัติ (Auto Forge)" })

UIControls.AutoForge = TabForge:Toggle({
    Title = "หลอมอุปกรณ์อัตโนมัติเมื่อแร่ครบ (Auto Forge)",
    Value = State.AutoForge,
    Callback = function(val)
        State.AutoForge = val
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Forge", Content = val and "เริ่มระบบหลอมอุปกรณ์อัตโนมัติ!" or "หยุดระบบหลอม" })
        end
    end
})

UIControls.ForgeType = TabForge:Dropdown({
    Title = "เลือกประเภทที่จะหลอม (Forge Target Type)",
    Values = {
        "🔄 หมุนเวียนครบเซ็ต (ดาบ + เกราะ + หมวก)",
        "🗡️ ดาบ / อาวุธ (Sword / Weapon)",
        "🛡️ ชุดเกราะ (Body Armor)",
        "👑 หมวก / เฮลม์ (Helmet / Hat)"
    },
    Value = State.ForgeType,
    Callback = function(val) State.ForgeType = val end
})

UIControls.MinOreToForge = TabForge:Slider({
    Title = "จำนวนคริสตัลขั้นต่ำในการหลอม (Min Ores)",
    Step = 1,
    Value = { Min = 4, Max = 23, Default = State.MinOreToForge },
    Callback = function(val) State.MinOreToForge = val end
})

UIControls.OreQualityMode = TabForge:Dropdown({
    Title = "เลือกลำดับเกรดแร่ในการหลอม (Forge Ore Quality)",
    Values = {
        "🌟 ใช้แร่เกรดสูงสุดก่อน (Best Ores First)",
        "⚪ ใช้แร่เกรดต่ำสุดก่อน (Low Ores First)"
    },
    Value = State.OreQualityMode,
    Callback = function(val) State.OreQualityMode = val end
})

TabForge:Button({
    Title = "⚡ หลอมอุปกรณ์ตามประเภทที่เลือกทันที (Forge Selected Now)",
    Callback = function()
        local ok, slot, count = executeForgeNow(State.ForgeType, State.MinOreToForge)
        if _G.TwoSkiLoaded then
            WindUI:Notify({
                Title = "2SKI Forge",
                Content = ok and ("หลอม " .. tostring(slot) .. " สำเร็จ (" .. tostring(count) .. " แร่) และใส่ออโต้แล้ว!") or ("หลอมไม่สำเร็จ: " .. tostring(count or "แร่ไม่พอ"))
            })
        end
    end
})

TabForge:Section({ Title = "🛡️ ระบบสวมใส่อุปกรณ์ที่ดีที่สุด (Gear Management)" })

UIControls.AutoEquipBest = TabForge:Toggle({
    Title = "ใส่อุปกรณ์ที่ดีที่สุดอัตโนมัติ (ดาบ + เกราะ + หมวก)",
    Value = State.AutoEquipBest,
    Callback = function(val)
        State.AutoEquipBest = val
        if val then
            equipBestGearNow("All")
            if _G.TwoSkiLoaded then
                WindUI:Notify({ Title = "2SKI Gear", Content = "เปิดระบบสวมใส่ฟูลเซ็ตที่ดีที่สุดอัตโนมัติ!" })
            end
        end
    end
})

TabForge:Button({
    Title = "⚡ สวมใส่ฟูลเซ็ตที่ดีที่สุดทันที (Equip All Best Gear)",
    Callback = function()
        local ok = equipBestGearNow("All")
        if _G.TwoSkiLoaded then
            WindUI:Notify({
                Title = "2SKI Gear",
                Content = ok and "สวมใส่ฟูลเซ็ต (ดาบ + เกราะ + หมวก) โหดสุดเรียบร้อย!" or "ตรวจสอบอุปกรณ์ในกระเป๋าแล้ว"
            })
        end
    end
})

TabForge:Section({ Title = "🔮 ระบบตีบวกอุปกรณ์อัตโนมัติ (Auto Enchant Gear)" })

UIControls.AutoEnchant = TabForge:Toggle({
    Title = "ตีบวกอุปกรณ์ที่สวมใส่อัตโนมัติเมื่อมีหิน (Auto Enchant Equipped)",
    Value = State.AutoEnchant,
    Callback = function(val)
        State.AutoEnchant = val
        if val then
            autoEnchantEquippedGear()
            if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                WindUI:Notify({ Title = "2SKI Enchant", Content = "เปิดระบบตีบวกอุปกรณ์ฟูลเซ็ตอัตโนมัติ!" })
            end
        end
    end
})

TabForge:Button({
    Title = "⚡ ตีบวกอุปกรณ์ที่สวมใส่ทั้งหมดทันที (Enchant All Equipped Now)",
    Callback = function()
        local ok = autoEnchantEquippedGear()
        if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
            WindUI:Notify({
                Title = "2SKI Enchant",
                Content = ok and "ตีบวกใส่อุปกรณ์เรียบร้อย!" or "อุปกรณ์เต็มช่องตีบวกแล้ว หรือไม่มีหินตีบวกในกระเป๋า"
            })
        end
    end
})

-- TAB 4: อัปเกรด & เกิดใหม่ (Upgrades & Rebirth)
local TabUpgrade = Window:Tab({ Title = "อัปเกรด & เกิดใหม่", Icon = "zap" })

TabUpgrade:Section({ Title = "สถานะการเกิดใหม่ (Rebirth Status)" })

UIControls.RebirthParagraph = TabUpgrade:Paragraph({
    Title = "สถานะ Rebirth ปัจจุบัน",
    Content = "กำลังโหลดข้อมูลสถานะ..."
})

local function refreshRebirthUI()
    pcall(function()
        local ready, curRebirth, curLevel, needLevel, isMax = checkRebirthStatus()
        local statusTxt = "เลเวลยังไม่ถึงเกณฑ์"
        if isMax then
            statusTxt = "ระดับ Rebirth สูงสุดแล้ว (Max)"
        elseif ready then
            statusTxt = "พร้อมเกิดใหม่แล้ว!"
        elseif needLevel == 0 then
            statusTxt = "กำลังโหลดข้อมูล..."
        end

        local txt = string.format("ระดับ Rebirth ปัจจุบัน: %d\nเลเวลปัจจุบัน: %d / เลเวลที่ต้องการ: %d\nสถานะ: %s",
            curRebirth, curLevel, needLevel, statusTxt)
        if UIControls.RebirthParagraph and UIControls.RebirthParagraph.SetContent then
            UIControls.RebirthParagraph:SetContent(txt)
        end
    end)
end

UIControls.AutoRebirth = TabUpgrade:Toggle({
    Title = "เกิดใหม่อัตโนมัติเมื่อเลเวลถึง (Auto Rebirth)",
    Value = State.AutoRebirth,
    Callback = function(val)
        State.AutoRebirth = val
        refreshRebirthUI()
    end
})

TabUpgrade:Button({
    Title = "กดเกิดใหม่ทันที (Force Rebirth Now)",
    Callback = function()
        if Remote_TryRebirth then
            Remote_TryRebirth:FireServer()
            refreshRebirthUI()
            if _G.TwoSkiLoaded then
                WindUI:Notify({ Title = "2SKI Rebirth", Content = "ส่งคำสั่งเกิดใหม่เรียบร้อย!" })
            end
        end
    end
})

TabUpgrade:Section({ Title = "ระบบอัปเกรดอัตโนมัติ (Smart Upgrades)" })

UIControls.AutoUpgradeAll = TabUpgrade:Toggle({
    Title = "อัปเกรดทุกอย่างอัตโนมัติเมื่อเงินพอ (Upgrade All)",
    Value = State.AutoUpgradeAll,
    Callback = function(val) State.AutoUpgradeAll = val end
})

UIControls.AutoUpgradeTrain = TabUpgrade:Toggle({
    Title = "อัปเกรด Train Multiplier (เพิ่มคูณพลังฝึก)",
    Value = State.AutoUpgradeTrain,
    Callback = function(val) State.AutoUpgradeTrain = val end
})

UIControls.AutoUpgradeLuck = TabUpgrade:Toggle({
    Title = "อัปเกรด Luck (เพิ่มดวงดรอปของเทพ)",
    Value = State.AutoUpgradeLuck,
    Callback = function(val) State.AutoUpgradeLuck = val end
})

UIControls.AutoUpgradeOrePack = TabUpgrade:Toggle({
    Title = "อัปเกรด OrePack (เพิ่มความจุกระเป๋าคริสตัล)",
    Value = State.AutoUpgradeOrePack,
    Callback = function(val) State.AutoUpgradeOrePack = val end
})

TabUpgrade:Button({
    Title = "อัปเกรดทั้งหมดทันทีเมื่อเงินพอ (Force Upgrade Now)",
    Callback = function()
        pcall(function()
            local pd = ProfileData and ProfileData.GetTotalData()
            local curCoins = pd and pd.Eco and pd.Eco.coin or 0
            for _, name in ipairs({"Train", "Luck", "OrePack"}) do
                local curLvl = UpgradeData.GetLevel(name) or 0
                local price = (UpgradeHelper and UpgradeHelper.GetPrice and UpgradeHelper.GetPrice(name, curLvl + 1)) or 0
                local isMax = (UpgradeHelper and UpgradeHelper.CheckIsMax and UpgradeHelper.CheckIsMax(name, curLvl)) or false
                if not isMax and curCoins >= price and Remote_UpgradeOnce then
                    Remote_UpgradeOnce:FireServer(name)
                end
            end
        end)
    end
})

TabUpgrade:Section({ Title = "🎲 ระบบสุ่มคลาสอัตโนมัติ (Auto Class Gacha)" })

UIControls.AutoRollClass = TabUpgrade:Toggle({
    Title = "สุ่มคลาสอัตโนมัติเมื่อมีตั๋ว (Auto Roll Class)",
    Value = State.AutoRollClass,
    Callback = function(val)
        State.AutoRollClass = val
        if val then
            autoRollClassNow()
            if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                WindUI:Notify({ Title = "2SKI Class", Content = "เปิดระบบสุ่มคลาสอัตโนมัติ (จะหยุดทันทีเมื่อได้เกรดเป้าหมาย)!" })
            end
        end
    end
})

UIControls.TargetClassRarity = TabUpgrade:Dropdown({
    Title = "หยุดสุ่มเมื่อได้รับระดับ (Stop at Target Rarity)",
    Values = {
        "🟡 Legendary ขึ้นไป",
        "🔴 Mythic ขึ้นไป",
        "🟣 Epic ขึ้นไป"
    },
    Value = State.TargetClassRarity,
    Callback = function(val) State.TargetClassRarity = val end
})

TabUpgrade:Button({
    Title = "⚡ กดสุ่มคลาส 1 ครั้งทันที (Roll Class Once Now)",
    Callback = function()
        if not ClassData or not Remote_LuckOnce then return end
        local tickets = (ClassData.GetLuckTimes and ClassData.GetLuckTimes()) or 0
        if tickets > 0 then
            Remote_LuckOnce:FireServer()
            if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                WindUI:Notify({ Title = "2SKI Class", Content = "กดสุ่มคลาสเรียบร้อย! (เหลือตั๋ว: " .. tostring(tickets - 1) .. ")" })
            end
        else
            if _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                WindUI:Notify({ Title = "2SKI Class", Content = "ตั๋วสุ่มคลาสไม่เพียงพอ!" })
            end
        end
    end
})

-- TAB 5: วาร์ป & เซิร์ฟเวอร์ (Teleports & Servers)
local TabTP = Window:Tab({ Title = "วาร์ป & เซิร์ฟเวอร์", Icon = "compass" })

TabTP:Section({ Title = "วาร์ปสถานที่สำคัญในแมพ (Map Teleports)" })

for name, pos in pairs(MapWaypoints) do
    TabTP:Button({
        Title = "วาร์ปไป: " .. name,
        Callback = function()
            local _, hrp = getCharHrp()
            if hrp then
                hrp.CFrame = CFrame.new(pos)
                if _G.TwoSkiLoaded then
                    WindUI:Notify({ Title = "2SKI Teleport", Content = "วาร์ปมายัง " .. name .. " แล้ว!" })
                end
            end
        end
    })
end

TabTP:Section({ Title = "ระบบเซิร์ฟเวอร์ (Server Actions)" })

TabTP:Button({
    Title = "ย้ายไปเซิร์ฟเวอร์คนน้อยที่สุด (Hop Lowest Server)",
    Callback = function()
        pcall(function()
            local url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(game.PlaceId))
            local res = game:HttpGet(url)
            local data = HttpService:JSONDecode(res)
            if data and data.data then
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and (s.playing or 0) < (s.maxPlayers or 20) and (s.playing or 0) > 0 then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                        return
                    end
                end
            end
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
})

TabTP:Button({
    Title = "รีจอยน์เซิร์ฟเวอร์เดิม (Rejoin Server)",
    Callback = function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end
})

-- TAB 6: ผู้เล่น & ธีมสี (Player & Theme Settings)
local TabSettings = Window:Tab({ Title = "ผู้เล่น & ธีมสี", Icon = "palette" })

TabSettings:Section({ Title = "ระบบธีมสี 2SKI (Theme Color Presets)" })

TabSettings:Button({
    Title = "🔽 ย่อ / ปิดหน้าต่าง UI (Minimize / Close UI)",
    Callback = function()
        toggleMainWindow()
    end
})

UIControls.CurrentTheme = TabSettings:Dropdown({
    Title = "เลือกพาเลทสี (Color Palette Selector)",
    Values = {
        "2SKI Cyber Cyan (ธีมหลักทางการ - ขาว ฟ้าเรืองแสง Electric Blue)",
        "Tiffany Pastel Mint (สีเขียวมิ้นท์พาสเทล)",
        "Sky Blue Glow (ฟ้านีออนสว่าง)",
        "Neon Emerald (เขียวมรกตนีออน)",
        "Cyber Violet (ม่วงไซเบอร์)",
        "Neon Rose (ชมพูกุหลาบไฟ)",
        "Golden Amber (ทองอำพันพรีเมียม)",
        "Electric Blue (น้ำเงินสดใส)"
    },
    Value = State.CurrentTheme,
    Callback = function(val)
        State.CurrentTheme = val
        applyThemePreset(val)
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Themes", Content = "เปลี่ยนธีมสีเรียบร้อย: " .. tostring(val) })
        end
    end
})

UIControls.FloatingButtonVisible = TabSettings:Toggle({
    Title = "แสดงปุ่มลอย 2SKI (Floating Button)",
    Value = State.FloatingButtonVisible,
    Callback = function(val)
        State.FloatingButtonVisible = val
        if ToggleGui then ToggleGui.Enabled = val end
    end
})

TabSettings:Section({ Title = "ความสามารถตัวละคร (Character Physics)" })

local function syncSpeedToHumanoid(hum)
    if not hum then return end
    pcall(function()
        hum.MaxSlopeAngle = 89
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        if State.WalkSpeed and State.WalkSpeed ~= 16 then
            hum.WalkSpeed = State.WalkSpeed
        end
    end)
end

local hookedHumanoids = {}
local function hookHumanoidJump(hum)
    if not hum or hookedHumanoids[hum] then return end
    hookedHumanoids[hum] = true
    pcall(function()
        hum.UseJumpPower = true
        local jp = (State.JumpPower and State.JumpPower > 30) and State.JumpPower or 50
        hum.JumpPower = jp
        local grav = (workspace.Gravity and workspace.Gravity > 0) and workspace.Gravity or 250
        hum.JumpHeight = (jp * jp) / (2 * grav)
        hum.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping then
                local _, hrp = getCharHrp()
                if hrp then
                    local targetJp = (State.JumpPower and State.JumpPower > 30) and State.JumpPower or 50
                    if hrp.AssemblyLinearVelocity.Y < (targetJp * 0.85) then
                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, targetJp, hrp.AssemblyLinearVelocity.Z)
                    end
                end
            end
        end)
    end)
end

-- Hook Character Respawn (CharacterAdded)
table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5) or char:FindFirstChildOfClass("Humanoid")
    if hum then
        syncSpeedToHumanoid(hum)
        hookHumanoidJump(hum)
    end
    if State.Noclip then
        updateNoclipConnection()
    end
end))

do
    local _, _, initHum = getCharHrp()
    if initHum then
        syncSpeedToHumanoid(initHum)
        hookHumanoidJump(initHum)
    end
end

UIControls.WalkSpeed = TabSettings:Slider({
    Title = "ความเร็วเดิน (WalkSpeed)",
    Step = 1,
    Value = { Min = 16, Max = 250, Default = State.WalkSpeed },
    Callback = function(val)
        State.WalkSpeed = val
        local _, _, hum = getCharHrp()
        if hum then hum.WalkSpeed = val end
    end
})

UIControls.JumpPower = TabSettings:Slider({
    Title = "พลังการกระโดด (JumpPower)",
    Step = 1,
    Value = { Min = 50, Max = 300, Default = State.JumpPower },
    Callback = function(val)
        State.JumpPower = val
        local _, _, hum = getCharHrp()
        if hum then hum.UseJumpPower = true; hum.JumpPower = val end
    end
})

UIControls.InfiniteJump = TabSettings:Toggle({
    Title = "กระโดดไร้ขีดจำกัด (Infinite Jump)",
    Value = State.InfiniteJump,
    Callback = function(val) State.InfiniteJump = val end
})

table.insert(Connections, UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump then
        local _, hrp, hum = getCharHrp()
        if hrp and hum and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            local jp = (State.JumpPower and State.JumpPower > 30) and State.JumpPower or 50
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, jp, hrp.AssemblyLinearVelocity.Z)
        end
    end
end))

local function updateNoclipConnection()
    if State.Noclip or State.ManualFly then
        if not noclipCon then
            noclipCon = RunService.Stepped:Connect(function()
                if not (State.Noclip or State.ManualFly) then
                    if noclipCon then noclipCon:Disconnect(); noclipCon = nil end
                    return
                end
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetChildren()) do
                        if p:IsA("BasePart") and p.CanCollide then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipCon then noclipCon:Disconnect(); noclipCon = nil end
    end
end

UIControls.Noclip = TabSettings:Toggle({
    Title = "เดินทะลุกำแพง & สิ่งกีดขวาง (Noclip All)",
    Value = State.Noclip,
    Callback = function(val)
        State.Noclip = val
        updateNoclipConnection()
    end
})

local function updateManualFly()
    if State.ManualFly then
        local char, hrp, hum = getCharHrp()
        if not hrp or not hum then return end

        if not manualFlyBv or not manualFlyBv.Parent or manualFlyBv.Parent ~= hrp then
            local old = hrp:FindFirstChild("TwoSkiManualFlyBV")
            if old then old:Destroy() end
            manualFlyBv = Instance.new("BodyVelocity")
            manualFlyBv.Name = "TwoSkiManualFlyBV"
            manualFlyBv.MaxForce = Vector3.new(2e6, 2e6, 2e6)
            manualFlyBv.Velocity = Vector3.zero
            manualFlyBv.Parent = hrp
        end

        if not manualFlyBg or not manualFlyBg.Parent or manualFlyBg.Parent ~= hrp then
            local oldBg = hrp:FindFirstChild("TwoSkiManualFlyBG")
            if oldBg then oldBg:Destroy() end
            manualFlyBg = Instance.new("BodyGyro")
            manualFlyBg.Name = "TwoSkiManualFlyBG"
            manualFlyBg.MaxTorque = Vector3.new(0, 4e6, 0)
            manualFlyBg.P = 4000
            manualFlyBg.D = 400
            manualFlyBg.CFrame = hrp.CFrame
            manualFlyBg.Parent = hrp
        end

        hum.PlatformStand = true
        updateNoclipConnection()

        if not manualFlyCon then
            local flyCurrentVel = Vector3.zero
            manualFlyCon = RunService.RenderStepped:Connect(function(dt)
                if not State.ManualFly then
                    if manualFlyCon then manualFlyCon:Disconnect(); manualFlyCon = nil end
                    return
                end
                local _, h, hm = getCharHrp()
                if not h or not hm or hm.Health <= 0 then return end
                hm.PlatformStand = true

                local cam = workspace.CurrentCamera
                local camCF = cam and cam.CFrame or h.CFrame
                local speed = State.ManualFlySpeed or 100
                local dir = Vector3.zero

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end

                if dir.Magnitude == 0 and hm.MoveDirection.Magnitude > 0 then
                    local rel = camCF:VectorToObjectSpace(hm.MoveDirection)
                    dir = (camCF.LookVector * (-rel.Z) + camCF.RightVector * rel.X)
                end

                local targetVel = dir.Magnitude > 0.05 and (dir.Unit * speed) or Vector3.zero
                flyCurrentVel = flyCurrentVel:Lerp(targetVel, math.clamp(dt * 18, 0.15, 1.0))
                if manualFlyBv and manualFlyBv.Parent == h then manualFlyBv.Velocity = flyCurrentVel end
                if manualFlyBg and manualFlyBg.Parent == h then
                    local look = camCF.LookVector
                    local flatLook = Vector3.new(look.X, 0, look.Z)
                    if flatLook.Magnitude > 0.001 then manualFlyBg.CFrame = CFrame.lookAt(h.Position, h.Position + flatLook.Unit) end
                end
            end)
            table.insert(Connections, manualFlyCon)
        end
    else
        if manualFlyCon then manualFlyCon:Disconnect(); manualFlyCon = nil end
        if manualFlyBv then pcall(function() manualFlyBv:Destroy() end); manualFlyBv = nil end
        if manualFlyBg then pcall(function() manualFlyBg:Destroy() end); manualFlyBg = nil end
        local _, _, hum = getCharHrp()
        if hum then hum.PlatformStand = false end
        updateNoclipConnection()
    end
end

UIControls.ManualFly = TabSettings:Toggle({
    Title = "บินอิสระ / บินเอง (Manual Fly [F])",
    Value = State.ManualFly,
    Callback = function(val)
        State.ManualFly = val
        updateManualFly()
        if _G.TwoSkiLoaded then
            WindUI:Notify({ Title = "2SKI Fly", Content = val and "เปิดโหมดบินอิสระ [F] เรียบร้อย!" or "ปิดโหมดบินอิสระ" })
        end
    end
})

UIControls.ManualFlySpeed = TabSettings:Slider({
    Title = "ความเร็วบินอิสระ (Fly Speed)",
    Step = 5,
    Value = { Min = 20, Max = 350, Default = State.ManualFlySpeed },
    Callback = function(val) State.ManualFlySpeed = val end
})

table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        State.ManualFly = not State.ManualFly
        if UIControls.ManualFly then
            pcall(function()
                if UIControls.ManualFly.SetValue then UIControls.ManualFly:SetValue(State.ManualFly)
                elseif UIControls.ManualFly.Set then UIControls.ManualFly:Set(State.ManualFly) end
            end)
        end
        updateManualFly()
    end
end))

UIControls.AntiAfk = TabSettings:Toggle({
    Title = "ป้องกันการหลุดอัตโนมัติ (Anti-AFK 24/7)",
    Value = State.AntiAfk,
    Callback = function(val) State.AntiAfk = val end
})

-- Anti-AFK System 24/7 (Triple-Protected: Connection Disable + Idled Hook + Active Heartbeat)
local function setupAntiAfk()
    -- 1. Disable Roblox's default Idled connections so the 20-min AFK dialog never triggers
    if getconnections then
        pcall(function()
            for _, conn in ipairs(getconnections(LocalPlayer.Idled)) do
                if conn.Disable then
                    conn:Disable()
                elseif conn.Disconnect then
                    conn:Disconnect()
                end
            end
        end)
    end

    -- 2. Hook Idled event with VirtualUser simulation
    table.insert(Connections, LocalPlayer.Idled:Connect(function()
        if State.AntiAfk then
            pcall(function()
                if VirtualUser then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end
            end)
        end
    end))

    -- 3. Active Background Heartbeat (Simulates active user input every 120s)
    task.spawn(function()
        while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
            task.wait(120)
            if State.AntiAfk then
                pcall(function()
                    if VirtualUser then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(10, 10))
                    end
                    if VirtualInputManager then
                        VirtualInputManager:SendMouseButtonEvent(10, 10, 0, true, game, 0)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(10, 10, 0, false, game, 0)
                    end
                end)
            end
        end
    end)
end

setupAntiAfk()

-- Configuration System Load & Buttons
local function loadConfig(silent)
    if readfile and isfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(function() return readfile(CONFIG_FILE) end)
        if ok and data then
            local okDecode, parsed = pcall(function() return HttpService:JSONDecode(data) end)
            if okDecode and type(parsed) == "table" then
                for k, v in pairs(parsed) do
                    if State[k] ~= nil then
                        State[k] = v
                        if UIControls[k] then
                            pcall(function()
                                if UIControls[k].SetValue then
                                    UIControls[k]:SetValue(v)
                                elseif UIControls[k].Set then
                                    UIControls[k]:Set(v)
                                elseif UIControls[k].Select then
                                    UIControls[k]:Select(v)
                                end
                            end)
                        end
                    end
                end
                if State.CurrentTheme then applyThemePreset(State.CurrentTheme) end
                if not silent and _G.TwoSkiLoaded and WindUI and WindUI.Notify then
                    WindUI:Notify({ Title = "2SKI Config", Content = "โหลดการตั้งค่าสำเร็จ!" })
                end
                return true
            end
        end
    end
    return false
end

TabSettings:Button({ Title = "บันทึกการตั้งค่า (Save Config)", Callback = function() saveConfig(false) end })
TabSettings:Button({ Title = "โหลดการตั้งค่า (Load Config)", Callback = function() loadConfig(false) end })

---------------------------------------------------------------------
-- BACKGROUND AUTOMATION LOOPS (HIGH EFFICIENCY)
---------------------------------------------------------------------

-- Loop 1: Auto Train Power Loop (Power Multiplier Zone & Normal Train)
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        if State.AutoTrain or State.AutoTrainBestZone then
            if State.AutoTrainBestZone then
                local targetZone = (State.SelectedTrainZone == "Auto Best (แท่นคูณสูงสุดที่ปลดล็อค)") and getBestTrainZone() or (getZoneByName(State.SelectedTrainZone) or getBestTrainZone())
                if targetZone then
                    local _, hrp, hum = getCharHrp()
                    if hrp and hum and hum.Health > 0 then
                        local curPos = hrp.Position
                        local dist = (Vector3.new(curPos.X, targetZone.PadPos.Y, curPos.Z) - targetZone.PadPos).Magnitude
                        if dist > 6 then
                            hrp.CFrame = CFrame.lookAt(targetZone.PadPos + Vector3.new(0, 1.5, 0), targetZone.DummyPos)
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.1)
                        end
                    end
                    
                    if LocalPlayer:GetAttribute("AutoTrainAreaID") ~= targetZone.Id then
                        if Remote_IntoAutoTrain then
                            pcall(function() Remote_IntoAutoTrain:FireServer(targetZone.Id) end)
                        end
                    end
                end
            end

            -- Fire both client animation and server remote for maximum reliable power gain
            pcall(function()
                if TrainCTRL and TrainCTRL.TrainOnce then
                    TrainCTRL.TrainOnce()
                end
                if Remote_TrainOnce then
                    Remote_TrainOnce:FireServer()
                end
            end)
            task.wait(0.15)
        else
            if LocalPlayer:GetAttribute("AutoTrainAreaID") then
                if Remote_ExitAutoTrain then
                    pcall(function() Remote_ExitAutoTrain:FireServer() end)
                end
            end
            task.wait(0.6)
        end
    end
end)

-- Loop 2: Auto Stage & Crystal Farm Loop (Remote Server Clear - No Character Teleportation)
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        if State.AutoClearStage and Remote_StageFinished and Remote_GetOre and Remote_ClaimedAllOre then
            -- 1. Determine Stage ID (Supports Selected Stage or Auto Max)
            local stageId = State.SelectedStage
            if not stageId or stageId:find("Auto Max") then
                local pd = ProfileData and ProfileData.GetTotalData()
                local maxPass = pd and pd.Stats and pd.Stats.StagePass or 0
                local targetNum = math.clamp(maxPass + 1, 1, 27)
                stageId = "Stage_" .. tostring(targetNum)
            else
                local clean = stageId:match("Stage_%d+")
                if clean then
                    stageId = clean
                else
                    stageId = tostring(stageId)
                end
            end

            -- 2. Check Backpack Ore Capacity & Forge if full or threshold met
            local bp = BackpackData and BackpackData.GetData()
            local oreCount = 0
            if bp and bp.have then
                for _, item in pairs(bp.have) do
                    if item.Type == "Ore" then oreCount = oreCount + (item.Number or 1) end
                end
            end
            local maxOre = (UpgradeData and UpgradeData.GetMaxNum and UpgradeData.GetMaxNum("OrePack")) or 6

            if oreCount >= maxOre or (State.AutoForge and oreCount >= (State.MinOreToForge or 4)) then
                if State.AutoForge then
                    executeForgeNow(State.ForgeType, math.min(State.MinOreToForge or 4, maxOre))
                    task.wait(0.2)
                end
            end

            -- 3. Clear Stage on Server & Claim Loot (No Physical Teleport Needed)
            local ok, ores = pcall(function()
                return Remote_StageFinished:InvokeServer(stageId)
            end)

            if ok and type(ores) == "table" then
                for oreUuid in pairs(ores) do
                    pcall(function() Remote_GetOre:InvokeServer(oreUuid) end)
                end
                pcall(function() Remote_ClaimedAllOre:FireServer() end)
            end

            -- 4. Insta-Kill Stage Mobs in EnemyFolder (Silent Clean Without Moving)
            local ef = workspace:FindFirstChild("EnemyFolder")
            if ef then
                for _, enemy in ipairs(ef:GetChildren()) do
                    if enemy:IsA("Model") and not enemy:GetAttribute("Dead") then
                        killEnemyEntity(enemy)
                    end
                end
            end

            -- 5. Sweep world dropped ores / crystals across map
            if State.AutoCollectCrystals and collectAllWorldOres then
                pcall(collectAllWorldOres)
            end

            -- 6. Auto Forge & Equip Best
            if State.AutoForge then
                pcall(function()
                    executeForgeNow(State.ForgeType, State.MinOreToForge)
                    equipBestGearNow("All")
                end)
            end

            task.wait(math.clamp(State.StageDelay or 0.35, 0.15, 3.0))
        else
            if State.AutoCollectCrystals and collectAllWorldOres then
                pcall(collectAllWorldOres)
            end
            task.wait(0.6)
        end
    end
end)

-- Loop 3: Auto Money, Gear Sell, Ore Sell & Enchant Sell Loop (Completely Decoupled & Independent)
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        -- 1. Auto Sell Trash Gear (Strictly Weapons, Armors, Hats - Ores & Enchant Stones are NEVER touched)
        if State.AutoSellGear or State.AutoSellAll then
            pcall(sellTrashGearNow)
            task.wait(0.15)
        end

        -- 2. Auto Sell Ores (Independent toggle - sells carried ores for coins based on ore filter)
        if State.AutoSellOres then
            pcall(sellOresNow)
            task.wait(0.15)
        end

        -- 3. Auto Sell Enchant Stones (Independent toggle - sells carried stones based on enchant filter)
        if State.AutoSellEnchant then
            pcall(sellEnchantStonesNow)
            task.wait(0.15)
        end

        -- 4. Auto Collect Money & Online Gifts (Only collects gifts/money, NEVER sells items)
        if State.AutoCollectMoney or State.AutoClaimOnline then
            if OnlineData and OnlineData.TryClaim then
                pcall(function()
                    for i = 1, 12 do
                        OnlineData.TryClaim(tostring(i))
                        task.wait(0.02)
                    end
                end)
            end
        end

        if State.AutoCollectMoney or State.AutoClaimGifts then
            pcall(function()
                if Remote_UpdateClaim then Remote_UpdateClaim:FireServer() end
                if Remote_OfflineClaim then Remote_OfflineClaim:FireServer() end
                if Remote_DungeonTicket then Remote_DungeonTicket:FireServer() end
                if Remote_IndexExp then
                    task.spawn(function()
                        pcall(function() Remote_IndexExp:InvokeServer() end)
                    end)
                end
                if Remote_IndexLvlReward then
                    for lvl = 1, 10 do
                        task.spawn(function()
                            pcall(function() Remote_IndexLvlReward:InvokeServer(lvl) end)
                        end)
                    end
                end
            end)
        end

        task.wait(2.2)
    end
end)

-- Loop 4: Auto Upgrades & Rebirth Loop (With Coin Balance Check)
task.spawn(function()
    local lastUpgradeTick = 0
    local lastRebirthTick = 0
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        local now = tick()
        if (State.AutoUpgradeAll or State.AutoUpgradeTrain or State.AutoUpgradeLuck or State.AutoUpgradeOrePack) and (now - lastUpgradeTick >= 1.5) then
            lastUpgradeTick = now
            pcall(function()
                local pd = ProfileData and ProfileData.GetTotalData()
                local curCoins = pd and pd.Eco and pd.Eco.coin or 0
                local upgradesToTry = {}
                if State.AutoUpgradeAll or State.AutoUpgradeTrain then table.insert(upgradesToTry, "Train") end
                if State.AutoUpgradeAll or State.AutoUpgradeLuck then table.insert(upgradesToTry, "Luck") end
                if State.AutoUpgradeAll or State.AutoUpgradeOrePack then table.insert(upgradesToTry, "OrePack") end

                for _, name in ipairs(upgradesToTry) do
                    local curLvl = (UpgradeData and UpgradeData.GetLevel and UpgradeData.GetLevel(name)) or 0
                    local price = (UpgradeHelper and UpgradeHelper.GetPrice and UpgradeHelper.GetPrice(name, curLvl + 1)) or 0
                    local isMax = (UpgradeHelper and UpgradeHelper.CheckIsMax and UpgradeHelper.CheckIsMax(name, curLvl)) or false
                    if not isMax and curCoins >= price and Remote_UpgradeOnce then
                        Remote_UpgradeOnce:FireServer(name)
                        curCoins = curCoins - price
                        task.wait(0.05)
                    end
                end
            end)
        end

        if State.AutoRebirth and (now - lastRebirthTick >= 2.0) and Remote_TryRebirth then
            lastRebirthTick = now
            pcall(function()
                local ready = checkRebirthStatus()
                if ready then
                    -- Prevent "Pack is full." rejection by selling junk equipment/ores before Rebirth
                    if Remote_TrySellAll then
                        pcall(function() Remote_TrySellAll:FireServer() end)
                        task.wait(0.15)
                    end
                    Remote_TryRebirth:FireServer()
                    refreshRebirthUI()
                end
            end)
        end

        task.wait(1.0)
    end
end)

-- Loop 5: SuperLoot Auto Hunter (Multi-Folder Scan)
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        if State.AutoKillSuperLoot and Remote_KillSuperLoot then
            pcall(function()
                local slf = workspace:FindFirstChild("SuperLootFolder")
                if slf then
                    for _, category in ipairs(slf:GetChildren()) do
                        for _, loot in ipairs(category:GetChildren()) do
                            local id = loot:GetAttribute("SuperLootID") or loot.Name
                            Remote_KillSuperLoot:FireServer(id)
                        end
                    end
                end
            end)
        end
        task.wait(4.0)
    end
end)

-- Loop 6: Live Stats Refresher & Humanoid Speed Keeper
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        updateLiveStatsDisplay()
        refreshRebirthUI()

        local _, _, hum = getCharHrp()
        if hum and hum.Health > 0 then
            if State.WalkSpeed and State.WalkSpeed ~= 16 and math.abs(hum.WalkSpeed - State.WalkSpeed) > 0.5 then
                pcall(function() hum.WalkSpeed = State.WalkSpeed end)
            end
        end
        task.wait(1.0)
    end
end)

-- Loop 7: Auto Dungeon Farm Loop (Auto Enter, Insta-Kill, Sweep Loot & Repeat)
task.spawn(function()
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        if State.AutoDungeon then
            local inDungeon = LocalPlayer:GetAttribute("Dungeoning")
            if inDungeon then
                handleDungeonCombat()
                task.wait(0.25)
            else
                -- Claim free daily ticket
                if Remote_DungeonTicket then
                    pcall(function() Remote_DungeonTicket:FireServer() end)
                end
                task.wait(0.3)

                local targetRound = math.clamp(tonumber(State.TargetDungeonRound) or 1, 1, 30)
                if Remote_TryIntoDungeon then
                    pcall(function()
                        Remote_TryIntoDungeon:InvokeServer(targetRound)
                    end)
                elseif DungeonData and DungeonData.TryIntoDungeon then
                    pcall(function()
                        DungeonData.TryIntoDungeon(targetRound)
                    end)
                end
                task.wait(2.5)
            end
        else
            task.wait(1.0)
        end
    end
end)

-- Loop 8: Auto Enchant, Auto Potions & Auto Class Gacha Loop (Zero-Lag Throttled)
task.spawn(function()
    local lastPotionCheck = 0
    local lastEnchantCheck = 0
    local lastClassCheck = 0
    while _G.TwoSkiRunning and _G.TwoSkiActiveToken == myToken do
        local now = tick()

        -- Auto Buff Potions (Check every 2.0s)
        if (State.AutoBuffPotions or State.AutoTrainPotion or State.AutoCoinPotion or State.AutoLuckPotion) and (now - lastPotionCheck >= 2.0) then
            lastPotionCheck = now
            pcall(autoDrinkPotionsNow)
        end

        -- Auto Enchant Equipped Gear (Check every 3.0s)
        if State.AutoEnchant and (now - lastEnchantCheck >= 3.0) then
            lastEnchantCheck = now
            pcall(autoEnchantEquippedGear)
        end

        -- Auto Class Gacha Roll (Check every 1.5s)
        if State.AutoRollClass and (now - lastClassCheck >= 1.5) then
            lastClassCheck = now
            pcall(autoRollClassNow)
        end

        task.wait(0.75)
    end
end)

_G.TwoSkiLoaded = true
refreshRebirthUI()
updateLiveStatsDisplay()

-- Automatically Open Main Window on Load and Focus "ฟาร์มพลัง & แร่"
pcall(function()
    if Window then
        Window:Open()
        task.defer(function()
            pcall(function()
                if TabFarm and TabFarm.Select then
                    TabFarm:Select()
                elseif Window.SelectTab then
                    Window:SelectTab(1)
                end
            end)
        end)
    end
end)

if WindUI and WindUI.Notify then
    WindUI:Notify({
        Title = "2SKI Engine",
        Content = "โหลดสคริปต์ Loot to Forge Master สมบูรณ์ 100%!"
    })
end
