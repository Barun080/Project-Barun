--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — OUROBOROS OBSIDIAN UI MASTER SUITE        ║
    ║        The Authentic Obsidian UI Engine Used by Ouroboros & PB Hubs      ║
    ║        Features: Search Bar • Dual Groupboxes • SaveManager • ThemeMgr   ║
    ║                  Universal Mobile/PC Draggable Neon Toggle Orb           ║
    ║                   https://github.com/Barun080/Project-Barun              ║
    ╚══════════════════════════════════════════════════════════════════════════╝
--]]

local MasterObsidian = {}

-- ═════════════════════════════════════════════════════════════════════
-- 1. MULTI-MIRROR COMPONENT LOADER (LOCAL FILE -> CACHE -> GITHUB -> CDN)
-- ═════════════════════════════════════════════════════════════════════
local GitHubBase = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/"
local CDNBase    = "https://cdn.jsdelivr.net/gh/deividcomsono/Obsidian@main/"

local function loadComponent(componentName, remoteSubpath)
    local cacheFileName = "Obsidian_" .. componentName:gsub("[^%w_%-]", "_") .. ".luau"
    local localFolderPaths = {
        "ui/obsidian/" .. remoteSubpath,
        "obsidian/" .. remoteSubpath,
        cacheFileName
    }

    -- 1. Check local file or cache first (Offline / Fast)
    if isfile and readfile then
        for _, path in ipairs(localFolderPaths) do
            if isfile(path) then
                local okRead, content = pcall(readfile, path)
                if okRead and type(content) == "string" and #content > 2000 then
                    local fn, err = loadstring(content)
                    if fn then
                        return fn()
                    end
                end
            end
        end
    end

    -- 2. Fetch from GitHub Raw
    local remoteUrls = {
        GitHubBase .. remoteSubpath,
        CDNBase .. remoteSubpath,
    }

    for _, url in ipairs(remoteUrls) do
        local okFetch, raw = pcall(function()
            return game:HttpGet(url .. "?v=" .. tick(), true)
        end)
        if okFetch and type(raw) == "string" and #raw > 2000 then
            -- Cache locally if possible
            if writefile then
                pcall(writefile, cacheFileName, raw)
            end
            local fn, err = loadstring(raw)
            if fn then
                return fn()
            end
        end
    end

    error("[Project Barun UI] Failed to load Obsidian component: " .. componentName)
end

-- Load Core Modules
local Library      = loadComponent("Library", "Library.lua")
local ThemeManager = loadComponent("ThemeManager", "addons/ThemeManager.lua")
local SaveManager  = loadComponent("SaveManager", "addons/SaveManager.lua")

MasterObsidian.Library      = Library
MasterObsidian.ThemeManager = ThemeManager
MasterObsidian.SaveManager  = SaveManager

-- ═════════════════════════════════════════════════════════════════════
-- 2. FACTORY: CREATE OBSIDIAN WINDOW
-- ═════════════════════════════════════════════════════════════════════
function MasterObsidian:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "PROJECT BARUN"
    local subTitle    = config.SubTitle or config.Subtitle or "Ouroboros Obsidian Edition"

    local Window = Library:CreateWindow({
        Title             = windowTitle,
        SubTitle          = subTitle,
        TabPadding        = config.TabPadding or 6,
        MenuFadeTime      = config.MenuFadeTime or 0.2,
        ShowMobileButtons = (config.ShowMobileButtons ~= nil and config.ShowMobileButtons) or true,
        CornerRadius      = config.CornerRadius or 6,
        AutoShow          = (config.AutoShow ~= nil and config.AutoShow) or true,
    })

    -- Attach helper for mobile draggable button if requested
    if config.MobileToggle ~= false then
        MasterObsidian:CreateMobileToggle(Window, config.MobileToggleText or "PB")
    end

    return Window
end

-- ═════════════════════════════════════════════════════════════════════
-- 3. NOTIFICATION HELPER
-- ═════════════════════════════════════════════════════════════════════
function MasterObsidian:Notify(title, text, duration)
    pcall(function()
        Library:Notify({
            Title    = title or "Project Barun",
            Content  = text or "",
            Duration = duration or 3,
        })
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- 4. THEME & SAVE MANAGER ATTACHMENT
-- ═════════════════════════════════════════════════════════════════════
function MasterObsidian:SetupManagers(settingsTab, folderName, subFolderName)
    folderName = folderName or "ProjectBarun"
    subFolderName = subFolderName or "Universal"

    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    ThemeManager:SetFolder(folderName)
    SaveManager:SetFolder(folderName .. "/" .. subFolderName)
    SaveManager:BuildConfigSection(settingsTab)
    ThemeManager:ApplyToTab(settingsTab)
end

-- ═════════════════════════════════════════════════════════════════════
-- 5. DRAGGABLE FLOATING NEON TOGGLE ORB (MOBILE & PC UNIVERSAL)
-- ═════════════════════════════════════════════════════════════════════
function MasterObsidian:CreateMobileToggle(windowInstance, orbText)
    local CoreGui          = game:GetService("CoreGui")
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players          = game:GetService("Players")

    local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local ParentTarget = (gethui and gethui()) or CoreGui or (LP and LP:FindFirstChild("PlayerGui"))

    pcall(function()
        local existing = ParentTarget:FindFirstChild("PB_MobileToggleOrb")
        if existing then existing:Destroy() end

        local orbGui = Instance.new("ScreenGui")
        orbGui.Name = "PB_MobileToggleOrb"
        orbGui.ResetOnSpawn = false
        orbGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(orbGui) end
        end)
        orbGui.Parent = ParentTarget

        local orb = Instance.new("TextButton")
        orb.Name = "ToggleOrb"
        orb.Size = UDim2.fromOffset(46, 46)
        orb.Position = UDim2.new(0, 18, 0.5, -23)
        orb.BackgroundColor3 = Color3.fromRGB(15, 14, 26)
        orb.Text = orbText or "PB"
        orb.TextColor3 = Color3.fromRGB(168, 85, 247)
        orb.Font = Enum.Font.GothamBold
        orb.TextSize = 15
        orb.AutoButtonColor = false
        orb.Active = true
        orb.Parent = orbGui

        local orbCorner = Instance.new("UICorner")
        orbCorner.CornerRadius = UDim.new(1, 0)
        orbCorner.Parent = orb

        local orbStroke = Instance.new("UIStroke")
        orbStroke.Color = Color3.fromRGB(168, 85, 247)
        orbStroke.Thickness = 1.6
        orbStroke.Transparency = 0.2
        orbStroke.Parent = orb

        -- Drag logic
        local dragging, dragStart, startPos = false, nil, nil
        orb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = orb.Position
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
                orb.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        -- Click toggle with smooth bounce animation
        orb.MouseButton1Click:Connect(function()
            TweenService:Create(orb, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(52, 52)
            }):Play()
            task.wait(0.12)
            TweenService:Create(orb, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(46, 46)
            }):Play()

            pcall(function()
                if Library.Toggle then
                    Library:Toggle()
                elseif windowInstance and windowInstance.Toggle then
                    windowInstance:Toggle()
                end
            end)
        end)
    end)
end

return MasterObsidian
