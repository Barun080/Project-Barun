--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) — NEO-CYBER TITANIUM LUXE v5.1               ║
    ║        Anime Dice: Halloween Event & 2K Ultra Automation Suite           ║
    ║        Engineered with Mimi Precision for Clack's Arsenal                ║
    ║                   https://github.com/Barun080/Project-Barun              ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ═════════════════════════════════════════════════════════════════════
-- 1. NEO-CYBER TITANIUM LUXE v5.1 UI MASTER ENGINE
-- ═════════════════════════════════════════════════════════════════════
local UI = (function()
--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║      💎 PROJECT BARUN (PB) — NEO-CYBER TITANIUM LUXE v5.1               ║
    ║      Dual-Engine: Obsidian / Linoria Hybrid + Refined Glassmorphism     ║
    ║      Engineered with Mimi Precision for Clack's Arsenal                  ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S ELEVATED IN v5.1 TITANIUM LUXE]
    • New Titanium Luxe default theme: restrained ice-cyan accents, deep graphite surfaces, calmer contrast
    • Refined spacing, card geometry, border weight and default canvas for a more premium visual hierarchy
    • All existing themes, widget methods, config APIs and hotkeys remain available

    [v5.0 NEO-CYBER GLASS FEATURES]
    • Ultra-Sleek Glassmorphic Aesthetics: Multi-layered acrylic chassis, depth shadows & rim glow
    • Kinetic Fluid Background: Breathing ambient aurora mesh orbs with procedural organic drift
    • Dynamic Iridescent Orbit Stroke: 360-degree rotating gradient neon border with specular sheen
    • Live Dynamic Theming Engine: 8 curated Cyber themes that update the active GUI in real-time
    • Advanced Telemetry HUD: Real-time Ping (ms), FPS, and live RAM monitor (MB) with latency dots
    • Modern Navigation Sidebar: Spring-animated active pill indicator, icon glow & hover feedback
    • Next-Gen Component Polish:
      - Toggles: Neon active track, bouncy spring knob, ripple pulse & inline Keybind/Colorpicker badges
      - Sliders: Dual-color gradient fill, draggable glowing knob, interactive live numeric badges
      - Dropdowns: Smooth 180° chevron rotation, chip badges for multi-select, accordion expand
      - Buttons: Cyber glass with micro-spring press physics (UIScale 0.96) and accent hover glow
      - Inputs: Frosted glass inset with neon focus glow and quick-clear controls
      - Toasts: Floating slide-in cards with status badges and live countdown progress bars
    • Universal Dual-Mode: Keyboard hotkey (RightShift) + Draggable Floating Neon Orb with boundary dampening
    • 100% Backward Compatible with all v4.x / v4.5 scripts & demo suites
--]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local StatsService     = game:GetService("Stats")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ─── Curated Next-Gen Cyber Palettes ─────────────────────────────────
local Themes = {
    ["Aurora Cyan"] = {
        VoidBg          = Color3.fromRGB(10, 12, 18),
        SurfaceBg       = Color3.fromRGB(14, 17, 26),
        SidebarBg       = Color3.fromRGB(12, 14, 22),
        CardBg          = Color3.fromRGB(19, 23, 36),
        CardHover       = Color3.fromRGB(26, 31, 48),
        CardBorder      = Color3.fromRGB(38, 44, 68),
        CardBorderGlow  = Color3.fromRGB(56, 189, 248),
        InputBg         = Color3.fromRGB(13, 16, 25),
        AccentPrimary   = Color3.fromRGB(139, 92, 246), -- Neon Purple
        AccentSecondary = Color3.fromRGB(59, 130, 246),  -- Cyber Blue
        Accent          = Color3.fromRGB(34, 211, 238),  -- Electric Cyan
        AccentGlow      = Color3.fromRGB(56, 189, 248),
        TextTitle       = Color3.fromRGB(248, 250, 252),
        TextBody        = Color3.fromRGB(203, 213, 225),
        TextDim         = Color3.fromRGB(110, 124, 148),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Obsidian Dark"] = {
        VoidBg          = Color3.fromRGB(8, 8, 10),
        SurfaceBg       = Color3.fromRGB(12, 12, 15),
        SidebarBg       = Color3.fromRGB(10, 10, 13),
        CardBg          = Color3.fromRGB(18, 18, 23),
        CardHover       = Color3.fromRGB(25, 25, 33),
        CardBorder      = Color3.fromRGB(35, 35, 45),
        CardBorderGlow  = Color3.fromRGB(160, 160, 180),
        InputBg         = Color3.fromRGB(11, 11, 14),
        AccentPrimary   = Color3.fromRGB(150, 150, 175),
        AccentSecondary = Color3.fromRGB(95, 95, 115),
        Accent          = Color3.fromRGB(220, 220, 240),
        AccentGlow      = Color3.fromRGB(180, 180, 205),
        TextTitle       = Color3.fromRGB(252, 252, 254),
        TextBody        = Color3.fromRGB(215, 215, 225),
        TextDim         = Color3.fromRGB(120, 120, 135),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Cyber Amethyst"] = {
        VoidBg          = Color3.fromRGB(11, 9, 18),
        SurfaceBg       = Color3.fromRGB(16, 12, 28),
        SidebarBg       = Color3.fromRGB(13, 10, 23),
        CardBg          = Color3.fromRGB(23, 18, 40),
        CardHover       = Color3.fromRGB(32, 24, 54),
        CardBorder      = Color3.fromRGB(50, 36, 82),
        CardBorderGlow  = Color3.fromRGB(168, 85, 247),
        InputBg         = Color3.fromRGB(14, 10, 24),
        AccentPrimary   = Color3.fromRGB(168, 85, 247),
        AccentSecondary = Color3.fromRGB(124, 58, 237),
        Accent          = Color3.fromRGB(192, 132, 252),
        AccentGlow      = Color3.fromRGB(216, 180, 254),
        TextTitle       = Color3.fromRGB(250, 245, 255),
        TextBody        = Color3.fromRGB(222, 212, 238),
        TextDim         = Color3.fromRGB(132, 118, 158),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Blood Crimson"] = {
        VoidBg          = Color3.fromRGB(14, 8, 11),
        SurfaceBg       = Color3.fromRGB(20, 10, 15),
        SidebarBg       = Color3.fromRGB(17, 9, 13),
        CardBg          = Color3.fromRGB(28, 14, 21),
        CardHover       = Color3.fromRGB(40, 18, 29),
        CardBorder      = Color3.fromRGB(68, 26, 42),
        CardBorderGlow  = Color3.fromRGB(244, 63, 94),
        InputBg         = Color3.fromRGB(16, 9, 13),
        AccentPrimary   = Color3.fromRGB(244, 63, 94),
        AccentSecondary = Color3.fromRGB(225, 29, 72),
        Accent          = Color3.fromRGB(251, 113, 133),
        AccentGlow      = Color3.fromRGB(253, 164, 175),
        TextTitle       = Color3.fromRGB(255, 245, 247),
        TextBody        = Color3.fromRGB(235, 212, 220),
        TextDim         = Color3.fromRGB(152, 112, 128),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Emerald Matrix"] = {
        VoidBg          = Color3.fromRGB(7, 14, 10),
        SurfaceBg       = Color3.fromRGB(10, 20, 15),
        SidebarBg       = Color3.fromRGB(8, 17, 13),
        CardBg          = Color3.fromRGB(14, 30, 22),
        CardHover       = Color3.fromRGB(20, 42, 30),
        CardBorder      = Color3.fromRGB(30, 68, 48),
        CardBorderGlow  = Color3.fromRGB(52, 211, 153),
        InputBg         = Color3.fromRGB(9, 18, 14),
        AccentPrimary   = Color3.fromRGB(16, 185, 129),
        AccentSecondary = Color3.fromRGB(5, 150, 105),
        Accent          = Color3.fromRGB(52, 211, 153),
        AccentGlow      = Color3.fromRGB(110, 231, 183),
        TextTitle       = Color3.fromRGB(245, 255, 250),
        TextBody        = Color3.fromRGB(210, 236, 226),
        TextDim         = Color3.fromRGB(112, 152, 132),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Golden Amber"] = {
        VoidBg          = Color3.fromRGB(14, 12, 7),
        SurfaceBg       = Color3.fromRGB(20, 17, 10),
        SidebarBg       = Color3.fromRGB(17, 14, 9),
        CardBg          = Color3.fromRGB(30, 25, 15),
        CardHover       = Color3.fromRGB(42, 35, 20),
        CardBorder      = Color3.fromRGB(68, 56, 30),
        CardBorderGlow  = Color3.fromRGB(251, 191, 36),
        InputBg         = Color3.fromRGB(18, 15, 10),
        AccentPrimary   = Color3.fromRGB(245, 158, 11),
        AccentSecondary = Color3.fromRGB(217, 119, 6),
        Accent          = Color3.fromRGB(251, 191, 36),
        AccentGlow      = Color3.fromRGB(253, 224, 71),
        TextTitle       = Color3.fromRGB(255, 252, 245),
        TextBody        = Color3.fromRGB(235, 230, 216),
        TextDim         = Color3.fromRGB(152, 142, 118),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Nord Frost"] = {
        VoidBg          = Color3.fromRGB(10, 13, 18),
        SurfaceBg       = Color3.fromRGB(15, 19, 26),
        SidebarBg       = Color3.fromRGB(13, 16, 22),
        CardBg          = Color3.fromRGB(22, 27, 38),
        CardHover       = Color3.fromRGB(30, 37, 52),
        CardBorder      = Color3.fromRGB(46, 56, 78),
        CardBorderGlow  = Color3.fromRGB(136, 192, 208),
        InputBg         = Color3.fromRGB(14, 17, 24),
        AccentPrimary   = Color3.fromRGB(129, 161, 193),
        AccentSecondary = Color3.fromRGB(94, 129, 172),
        Accent          = Color3.fromRGB(136, 192, 208),
        AccentGlow      = Color3.fromRGB(143, 188, 187),
        TextTitle       = Color3.fromRGB(248, 250, 252),
        TextBody        = Color3.fromRGB(216, 224, 236),
        TextDim         = Color3.fromRGB(122, 136, 160),
        Success         = Color3.fromRGB(163, 190, 140),
        Warning         = Color3.fromRGB(235, 203, 139),
        Danger          = Color3.fromRGB(191, 97, 106),
    },
    ["Titanium Luxe"] = {
        VoidBg          = Color3.fromRGB(7, 10, 16),
        SurfaceBg       = Color3.fromRGB(12, 16, 24),
        SidebarBg       = Color3.fromRGB(9, 13, 20),
        CardBg          = Color3.fromRGB(17, 23, 33),
        CardHover       = Color3.fromRGB(24, 33, 46),
        CardBorder      = Color3.fromRGB(43, 56, 72),
        CardBorderGlow  = Color3.fromRGB(103, 210, 220),
        InputBg         = Color3.fromRGB(10, 15, 23),
        AccentPrimary   = Color3.fromRGB(85, 155, 177),
        AccentSecondary = Color3.fromRGB(93, 116, 160),
        Accent          = Color3.fromRGB(113, 220, 225),
        AccentGlow      = Color3.fromRGB(173, 244, 240),
        TextTitle       = Color3.fromRGB(245, 249, 252),
        TextBody        = Color3.fromRGB(202, 214, 225),
        TextDim         = Color3.fromRGB(125, 144, 162),
        Success         = Color3.fromRGB(77, 207, 158),
        Warning         = Color3.fromRGB(239, 190, 103),
        Danger          = Color3.fromRGB(242, 105, 125),
    },
    ["Synthwave Pink"] = {
        VoidBg          = Color3.fromRGB(15, 8, 20),
        SurfaceBg       = Color3.fromRGB(22, 11, 30),
        SidebarBg       = Color3.fromRGB(18, 9, 25),
        CardBg          = Color3.fromRGB(32, 16, 44),
        CardHover       = Color3.fromRGB(46, 22, 62),
        CardBorder      = Color3.fromRGB(75, 32, 98),
        CardBorderGlow  = Color3.fromRGB(244, 114, 182),
        InputBg         = Color3.fromRGB(19, 10, 27),
        AccentPrimary   = Color3.fromRGB(236, 72, 153),
        AccentSecondary = Color3.fromRGB(168, 85, 247),
        Accent          = Color3.fromRGB(244, 114, 182),
        AccentGlow      = Color3.fromRGB(251, 207, 232),
        TextTitle       = Color3.fromRGB(255, 245, 252),
        TextBody        = Color3.fromRGB(238, 216, 232),
        TextDim         = Color3.fromRGB(160, 118, 152),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
}

local CurrentThemeName = "Titanium Luxe"
local Theme = {}
for k, v in pairs(Themes[CurrentThemeName]) do Theme[k] = v end

Theme.FontTitle   = Enum.Font.GothamBold
Theme.FontBold    = Enum.Font.GothamBold
Theme.FontBlack   = Enum.Font.GothamBlack
Theme.FontSemi    = Enum.Font.GothamMedium
Theme.FontRegular = Enum.Font.Gotham

local WHITE = Color3.fromRGB(255, 255, 255)
local SHADOW_ASSET = "rbxassetid://1316045217"

-- ─── UI Library Master Object ───────────────────────────────────────
local UI = {
    Themes         = Themes,
    CurrentTheme   = CurrentThemeName,
    Toggles        = {},
    Options        = {},
    ThemeTrackers  = {}, -- Elements registered for live theme updates
    ThemeListeners = {}, -- Callback listeners when theme changes
}
UI.__index = UI

function UI:RegisterThemeCallback(fn)
    table.insert(self.ThemeListeners, fn)
end

function UI:RegisterThemeElement(inst, propName, themeKey)
    table.insert(self.ThemeTrackers, {
        Instance = inst,
        Property = propName,
        Key = themeKey
    })
end

-- ─── Core Helpers ───────────────────────────────────────────────────
local function tw(inst, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.28, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local function make(className, properties, children)
    local inst = Instance.new(className)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
    end
    if inst:IsA("TextLabel") then
        inst.BackgroundTransparency = 1
    end
    for k, v in pairs(properties or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(r)
    return make("UICorner", { CornerRadius = UDim.new(0, r) })
end

local function pill()
    return make("UICorner", { CornerRadius = UDim.new(1, 0) })
end

local function stroke(color, thickness, transparency, name)
    return make("UIStroke", {
        Name = name or "UIStroke",
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function grad(c0, c1, rotation, name)
    return make("UIGradient", {
        Name = name or "UIGradient",
        Color = ColorSequence.new(c0, c1),
        Rotation = rotation or 0,
    })
end

local function txt(props, children)
    local p = {
        Font = Theme.FontRegular,
        TextSize = 12,
        TextColor3 = Theme.TextBody,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }
    for k, v in pairs(props or {}) do
        p[k] = v
    end
    return make("TextLabel", p, children)
end

local function orb(parent, color, diameter, pos)
    local holder = make("Frame", {
        Name = "AuroraOrb",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = pos,
        Size = UDim2.new(0, diameter, 0, diameter),
        Parent = parent,
    })
    for i = 1, 8 do
        local s = 1 - (i - 1) * 0.11
        make("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(s, 0, s, 0),
            BackgroundColor3 = color,
            BackgroundTransparency = 0.955,
            Parent = holder,
        }, { pill() })
    end
    return holder
end

local function makeCard(parent, height, interactive)
    local props = {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.CardBg,
        BackgroundTransparency = 0.08,
        Parent = parent,
    }
    if interactive then
        props.AutoButtonColor = false
        props.Text = ""
    end

    local card = make(interactive and "TextButton" or "Frame", props, {
        corner(12),
        stroke(Theme.CardBorder, 1.1, 0.32, "CardStroke"),
        make("UIGradient", {
            Name = "Sheen",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, WHITE),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(220, 225, 240)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(180, 185, 205)),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.0, 0.0),
                NumberSequenceKeypoint.new(0.4, 0.02),
                NumberSequenceKeypoint.new(1.0, 0.05),
            }),
            Rotation = 90,
        }),
        make("Frame", {
            Name = "Highlight",
            Size = UDim2.new(1, -20, 0, 1),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundColor3 = WHITE,
            BackgroundTransparency = 0.84,
        }, {
            make("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1.0, 1),
                }),
            }),
        }),
    })

    UI:RegisterThemeElement(card, "BackgroundColor3", "CardBg")
    local s = card:FindFirstChild("CardStroke")
    if s then UI:RegisterThemeElement(s, "Color", "CardBorder") end
    return card
end

local function hoverable(card, accent)
    local s = card:FindFirstChild("CardStroke")
    card.MouseEnter:Connect(function()
        tw(card, { BackgroundColor3 = Theme.CardHover }, 0.18)
        if s then
            tw(s, { Color = accent or Theme.CardBorderGlow, Transparency = 0.08 }, 0.18)
        end
    end)
    card.MouseLeave:Connect(function()
        tw(card, { BackgroundColor3 = Theme.CardBg }, 0.18)
        if s then
            tw(s, { Color = Theme.CardBorder, Transparency = 0.32 }, 0.18)
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- WINDOW CREATION (NEO-CYBER TITANIUM LUXE v5.1)
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText      = config.Title or "PROJECT BARUN"
    local SubtitleText   = config.Subtitle or "OBSIDIAN GLASS v5.0"
    local WindowSize     = config.Size or UDim2.new(0, 900, 0, 570)
    local WindowName     = config.Name or "ProjectBarun_MasterUI"
    local ToggleKey      = config.ToggleKey or config.MenuKeybind or Enum.KeyCode.RightShift
    local ShowToggleBtn  = (config.ToggleButton ~= false and config.MobileButton ~= false)
    local AccentColor    = config.Accent or Theme.Accent

    local okHui, huiTarget = pcall(function() return gethui and gethui() end)
    local ParentTarget = (okHui and huiTarget) or CoreGui

    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == WindowName or existing.Name == WindowName .. "_ToggleButton" or existing.Name == WindowName .. "_MobileOrb" then
            existing:Destroy()
        end
    end

    local Conns = {}
    local function bind(signal, fn)
        local c = signal:Connect(fn)
        table.insert(Conns, c)
        return c
    end

    local ScreenGui = make("ScreenGui", {
        Name = WindowName,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ParentTarget,
    })

    -- Optional safe depth blur in Lighting
    local DepthBlur = nil
    pcall(function()
        DepthBlur = Instance.new("BlurEffect")
        DepthBlur.Name = WindowName .. "_Blur"
        DepthBlur.Size = 0
        DepthBlur.Parent = Lighting
    end)

    ScreenGui.Destroying:Connect(function()
        for _, c in ipairs(Conns) do
            pcall(function() c:Disconnect() end)
        end
        if DepthBlur and DepthBlur.Parent then
            pcall(function() DepthBlur:Destroy() end)
        end
    end)

    -- ─── Root Container ─────────────────────────────────────────────
    local Root = make("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = WindowSize,
        BackgroundTransparency = 1,
        Visible = false,
        Parent = ScreenGui,
    }, {
        make("UIScale", { Name = "Scale", Scale = 0.92 }),
    })
    local RootScale = Root.Scale

    -- Multi-stage Ambient Depth Shadows
    local Shadow = make("ImageLabel", {
        Name = "AmbientShadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 14),
        Size = UDim2.new(1, 88, 1, 88),
        BackgroundTransparency = 1,
        Image = SHADOW_ASSET,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = Root,
    })

    -- Main Chassis with Frosted Glass Layering
    local Main = make("Frame", {
        Name = "MainChassis",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = Root,
    }, {
        corner(18),
    })

    local Backdrop = make("Frame", {
        Name = "Backdrop",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = WHITE,
        Parent = Main,
    }, {
        make("UIGradient", {
            Name = "BackdropGrad",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(18, 21, 33)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(13, 15, 23)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(8, 9, 14)),
            }),
            Rotation = 48,
        }),
    })

    -- Glassmorphic Frost Panel
    local Glass = make("Frame", {
        Name = "GlassBackground",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.SurfaceBg,
        BackgroundTransparency = 0.35,
        Parent = Main,
    }, {
        corner(18),
        make("UIGradient", {
            Name = "GlassGrad",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(30, 36, 56)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 18, 28)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(10, 11, 18)),
            }),
            Rotation = 120,
        }),
    })
    UI:RegisterThemeElement(Glass, "BackgroundColor3", "SurfaceBg")

    -- Kinetic Ambient Aurora Mesh Orbs (Organic Breathing Drift)
    local Orb1 = orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
    local Orb2 = orb(Main, AccentColor, 400, UDim2.new(0.12, 0, 1.0, 0))
    local Orb3 = orb(Main, Theme.AccentSecondary, 280, UDim2.new(0.62, 0, 0.55, 0))

    bind(RunService.RenderStepped, function()
        local t = tick()
        Orb1.Position = UDim2.new(0.92 + math.sin(t * 0.7) * 0.035, 0, 0.02 + math.cos(t * 0.6) * 0.035, 0)
        Orb2.Position = UDim2.new(0.12 + math.cos(t * 0.5) * 0.04, 0, 1.0 - math.sin(t * 0.6) * 0.04, 0)
        Orb3.Position = UDim2.new(0.62 + math.sin(t * 0.9) * 0.03, 0, 0.55 + math.cos(t * 0.8) * 0.03, 0)
    end)

    -- Dynamic Orbiting Neon Border
    local BorderFrame = make("Frame", {
        Name = "Border",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = Root,
    }, {
        corner(16),
        make("UIStroke", {
            Name = "Stroke",
            Color = WHITE,
            Thickness = 1.6,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, {
            make("UIGradient", {
                Name = "Orbit",
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.0, Theme.AccentPrimary),
                    ColorSequenceKeypoint.new(0.33, AccentColor),
                    ColorSequenceKeypoint.new(0.66, Theme.AccentSecondary),
                    ColorSequenceKeypoint.new(1.0, Theme.AccentPrimary),
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 0.05),
                    NumberSequenceKeypoint.new(0.5, 0.75),
                    NumberSequenceKeypoint.new(1.0, 0.05),
                }),
            }),
        }),
    })
    local BorderStroke = BorderFrame.Stroke
    local OrbitGrad = BorderStroke.Orbit

    bind(RunService.RenderStepped, function()
        OrbitGrad.Rotation = (OrbitGrad.Rotation + 0.4) % 360
    end)

    -- Shimmering Neon Top Accent Bar
    local NeonTopLine = make("Frame", {
        Name = "NeonAccentBar",
        Size = UDim2.new(1, -56, 0, 2),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundColor3 = WHITE,
        ClipsDescendants = true,
        Parent = Main,
    }, {
        make("UIGradient", {
            Name = "TopLineGrad",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Theme.AccentPrimary),
                ColorSequenceKeypoint.new(0.5, AccentColor),
                ColorSequenceKeypoint.new(1.0, Theme.AccentSecondary),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.0, 1),
                NumberSequenceKeypoint.new(0.12, 0),
                NumberSequenceKeypoint.new(0.88, 0),
                NumberSequenceKeypoint.new(1.0, 1),
            }),
        }),
    })
    local Shimmer = make("Frame", {
        Name = "Shimmer",
        Size = UDim2.new(0, 110, 1, 0),
        Position = UDim2.new(0, -110, 0, 0),
        BackgroundColor3 = WHITE,
        Parent = NeonTopLine,
    }, {
        make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.0, 1),
                NumberSequenceKeypoint.new(0.5, 0.25),
                NumberSequenceKeypoint.new(1.0, 1),
            }),
        }),
    })
    task.spawn(function()
        while ScreenGui.Parent do
            Shimmer.Position = UDim2.new(0, -110, 0, 0)
            local t = TweenService:Create(Shimmer, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(1, 50, 0, 0)
            })
            t:Play()
            t.Completed:Wait()
            task.wait(1.8)
        end
    end)

    -- Toast HUD Stack
    local ToastHolder = make("Frame", {
        Name = "ToastHolder",
        Size = UDim2.new(0, 320, 1, -40),
        Position = UDim2.new(1, -340, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 35,
        Parent = ScreenGui,
    }, {
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
        }),
    })

    -- ─── Watermark Telemetry Bar ────────────────────────────────────
    local WatermarkFrame = make("Frame", {
        Name = "Watermark",
        Size = UDim2.new(0, 280, 0, 28),
        Position = UDim2.new(0, 20, 0, 14),
        BackgroundColor3 = Color3.fromRGB(13, 16, 25),
        BackgroundTransparency = 0.18,
        Visible = false,
        ZIndex = 30,
        Parent = ScreenGui,
    }, {
        corner(9),
        stroke(AccentColor, 1.25, 0.35, "WmStroke"),
        txt({
            Name = "WmText",
            Text = "PROJECT BARUN | Obsidian Glass v5.0",
            Font = Theme.FontBold,
            TextSize = 10.5,
            TextColor3 = WHITE,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
        }),
    })
    UI:RegisterThemeElement(WatermarkFrame.WmStroke, "Color", "Accent")

    -- ─── TopBar ──────────────────────────────────────────────────────
    local TopBar = make("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = Main,
    }, {
        make("Frame", {
            Size = UDim2.new(1, -28, 0, 1),
            Position = UDim2.new(0, 14, 1, -1),
            BackgroundColor3 = Theme.CardBorderGlow,
        }, {
            make("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 1),
                    NumberSequenceKeypoint.new(0.2, 0.5),
                    NumberSequenceKeypoint.new(0.8, 0.5),
                    NumberSequenceKeypoint.new(1.0, 1),
                }),
            }),
        }),
    })

    -- Cyber Logo Badge
    local LogoBadgeHolder = make("Frame", {
        Name = "LogoBadgeHolder",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundColor3 = WHITE,
        Parent = TopBar,
    }, {
        corner(10),
        stroke(AccentColor, 1.4, 0.15, "LogoGlowStroke"),
        grad(Color3.fromRGB(32, 38, 64), Color3.fromRGB(14, 16, 28), 45),
        txt({
            Name = "FallbackText",
            Size = UDim2.new(1, 0, 1, 0),
            Text = "PB",
            Font = Theme.FontBlack,
            TextSize = 16,
            TextColor3 = AccentColor,
            TextXAlignment = Enum.TextXAlignment.Center,
        }),
    })
    UI:RegisterThemeElement(LogoBadgeHolder.LogoGlowStroke, "Color", "Accent")
    UI:RegisterThemeElement(LogoBadgeHolder.FallbackText, "TextColor3", "Accent")

    -- Title & Subtitle Hierarchy
    local TitleLabel = txt({
        Name = "Title",
        Text = TitleText,
        Font = Theme.FontBlack,
        TextSize = 13.5,
        TextColor3 = Theme.TextTitle,
        Position = UDim2.new(0, 62, 0, 12),
        Size = UDim2.new(0, 180, 0, 18),
        Parent = TopBar,
    })
    local SubtitleLabel = txt({
        Name = "Subtitle",
        Text = SubtitleText,
        Font = Theme.FontSemi,
        TextSize = 9.5,
        TextColor3 = AccentColor,
        Position = UDim2.new(0, 62, 0, 31),
        Size = UDim2.new(0, 180, 0, 14),
        Parent = TopBar,
    })
    UI:RegisterThemeElement(SubtitleLabel, "TextColor3", "Accent")

    -- ─── Real-Time Global Search Bar ─────────────────────────────────
    local SearchBoxHolder = make("Frame", {
        Name = "SearchBoxHolder",
        Size = UDim2.new(0, 175, 0, 30),
        Position = UDim2.new(0, 246, 0.5, -15),
        BackgroundColor3 = Theme.InputBg,
        Parent = TopBar,
    }, {
        corner(8),
        stroke(Theme.CardBorder, 1, 0.35, "SearchStroke"),
        txt({
            Name = "SearchIcon",
            Text = "🔍",
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(0, 6, 0, 0),
            TextSize = 10,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Center,
        }),
    })
    UI:RegisterThemeElement(SearchBoxHolder, "BackgroundColor3", "InputBg")
    UI:RegisterThemeElement(SearchBoxHolder.SearchStroke, "Color", "CardBorder")

    local SearchInput = make("TextBox", {
        Name = "SearchInput",
        Size = UDim2.new(1, -34, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "ค้นหาฟังก์ชัน...",
        PlaceholderColor3 = Theme.TextDim,
        TextColor3 = WHITE,
        Font = Theme.FontRegular,
        TextSize = 10.5,
        ClearTextOnFocus = false,
        Parent = SearchBoxHolder,
    })

    SearchInput.Focused:Connect(function()
        tw(SearchBoxHolder, { Size = UDim2.new(0, 195, 0, 30) }, 0.2)
        tw(SearchBoxHolder.SearchStroke, { Color = AccentColor, Transparency = 0.05 }, 0.18)
    end)
    SearchInput.FocusLost:Connect(function()
        tw(SearchBoxHolder, { Size = UDim2.new(0, 175, 0, 30) }, 0.2)
        tw(SearchBoxHolder.SearchStroke, { Color = Theme.CardBorder, Transparency = 0.35 }, 0.18)
    end)

    -- ─── Telemetry HUD (FPS, Ping, RAM) ──────────────────────────────
    local TelemetryCard = make("Frame", {
        Name = "TelemetryCard",
        Size = UDim2.new(0, 190, 0, 28),
        Position = UDim2.new(1, -285, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(18, 22, 34),
        Parent = TopBar,
    }, {
        corner(8),
        stroke(Theme.CardBorder, 1, 0.4, "TelStroke"),
        txt({
            Name = "PingLabel",
            Text = "Ping: --",
            Font = Theme.FontSemi,
            TextSize = 9.5,
            TextColor3 = AccentColor,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.33, -4, 1, 0),
        }),
        txt({
            Name = "FpsLabel",
            Text = "FPS: --",
            Font = Theme.FontSemi,
            TextSize = 9.5,
            TextColor3 = Theme.Success,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2.new(0.33, 0, 0, 0),
            Size = UDim2.new(0.33, 0, 1, 0),
        }),
        txt({
            Name = "MemLabel",
            Text = "RAM: --",
            Font = Theme.FontSemi,
            TextSize = 9.5,
            TextColor3 = Theme.Warning,
            TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2.new(0.66, 0, 0, 0),
            Size = UDim2.new(0.34, -10, 1, 0),
        }),
    })
    UI:RegisterThemeElement(TelemetryCard.TelStroke, "Color", "CardBorder")
    UI:RegisterThemeElement(TelemetryCard.PingLabel, "TextColor3", "Accent")

    local frameCount = 0
    local lastSec = tick()
    bind(RunService.RenderStepped, function()
        frameCount += 1
        local now = tick()
        if now - lastSec >= 1 then
            local fps = frameCount
            frameCount = 0
            lastSec = now
            local ping = 0
            pcall(function()
                ping = math.floor(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            local memMb = math.floor(gcinfo() / 1024)

            TelemetryCard.FpsLabel.Text = string.format("FPS: %d", fps)
            TelemetryCard.FpsLabel.TextColor3 = fps >= 55 and Theme.Success or (fps >= 30 and Theme.Warning or Theme.Danger)
            TelemetryCard.PingLabel.Text = string.format("Ping: %dms", ping)
            TelemetryCard.PingLabel.TextColor3 = ping <= 90 and Theme.Success or (ping <= 160 and Theme.Warning or Theme.Danger)
            TelemetryCard.MemLabel.Text = string.format("RAM: %dM", memMb)
        end
    end)

    -- Window Controls
    local WindowControls = make("Frame", {
        Name = "WindowControls",
        Size = UDim2.new(0, 68, 0, 28),
        Position = UDim2.new(1, -84, 0.5, -14),
        BackgroundTransparency = 1,
        Parent = TopBar,
    }, {
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
        }),
    })

    local MinBtn = make("TextButton", {
        Name = "MinBtn",
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Color3.fromRGB(28, 32, 48),
        Text = "—",
        TextColor3 = Theme.TextBody,
        Font = Theme.FontBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = WindowControls,
    }, { corner(7), stroke(Theme.CardBorder, 1, 0.45) })

    local CloseBtn = make("TextButton", {
        Name = "CloseBtn",
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = Color3.fromRGB(244, 63, 94),
        Text = "✕",
        TextColor3 = WHITE,
        Font = Theme.FontBold,
        TextSize = 11,
        AutoButtonColor = false,
        Parent = WindowControls,
    }, { corner(7) })

    MinBtn.MouseEnter:Connect(function()
        tw(MinBtn, { BackgroundColor3 = Theme.CardHover, TextColor3 = WHITE }, 0.15)
    end)
    MinBtn.MouseLeave:Connect(function()
        tw(MinBtn, { BackgroundColor3 = Color3.fromRGB(28, 32, 48), TextColor3 = Theme.TextBody }, 0.15)
    end)

    CloseBtn.MouseEnter:Connect(function()
        tw(CloseBtn, { BackgroundColor3 = Color3.fromRGB(255, 30, 75) }, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        tw(CloseBtn, { BackgroundColor3 = Color3.fromRGB(244, 63, 94) }, 0.15)
    end)

    -- ─── Layout: Sidebar & Content Area ──────────────────────────────
    local ContentHolder = make("Frame", {
        Name = "ContentHolder",
        Size = UDim2.new(1, 0, 1, -58),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Sidebar = make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 178, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundColor3 = Theme.SidebarBg,
        BackgroundTransparency = 0.28,
        Parent = ContentHolder,
    }, {
        corner(12),
        stroke(Theme.CardBorder, 1, 0.45, "SbStroke"),
        make("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
        }),
    })
    UI:RegisterThemeElement(Sidebar, "BackgroundColor3", "SidebarBg")
    UI:RegisterThemeElement(Sidebar.SbStroke, "Color", "CardBorder")

    local TabScroll = make("ScrollingFrame", {
        Name = "TabScroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar,
    }, {
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
        }),
    })
    UI:RegisterThemeElement(TabScroll, "ScrollBarImageColor3", "Accent")

    local PagesContainer = make("Frame", {
        Name = "PagesContainer",
        Size = UDim2.new(1, -214, 1, -16),
        Position = UDim2.new(0, 200, 0, 8),
        BackgroundTransparency = 1,
        Parent = ContentHolder,
    })

    -- ─── Minimize & Visibility Logic ─────────────────────────────────
    local isVisible = false
    local ToggleButton = nil

    local function setWindowVisible(show)
        isVisible = show
        if show then
            Root.Size = WindowSize
            ContentHolder.Visible = true
            Root.Visible = true
            tw(RootScale, { Scale = 1 }, 0.34, Enum.EasingStyle.Back)
            tw(BorderStroke, { Transparency = 0 }, 0.28)
            tw(Shadow, { ImageTransparency = 0.45 }, 0.35)
            if DepthBlur then pcall(function() tw(DepthBlur, { Size = 14 }, 0.3) end) end
            if ToggleButton and ToggleButton:FindFirstChild("StatusDot") then
                tw(ToggleButton.StatusDot, { BackgroundColor3 = Theme.Success }, 0.2)
            end
        else
            tw(RootScale, { Scale = 0.9 }, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tw(BorderStroke, { Transparency = 1 }, 0.22)
            tw(Shadow, { ImageTransparency = 1 }, 0.22)
            if DepthBlur then pcall(function() tw(DepthBlur, { Size = 0 }, 0.24) end) end
            if ToggleButton and ToggleButton:FindFirstChild("StatusDot") then
                tw(ToggleButton.StatusDot, { BackgroundColor3 = Theme.TextDim }, 0.2)
            end
            task.delay(0.24, function()
                if not isVisible then Root.Visible = false end
            end)
        end
    end

    MinBtn.MouseButton1Click:Connect(function()
        setWindowVisible(false)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        setWindowVisible(false)
    end)

    bind(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            setWindowVisible(not isVisible)
        end
    end)

    -- Smooth Window Dragging Physics
    local isDragging = false
    local dragStart = Vector2.zero
    local startPos = UDim2.new()

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = Root.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Root.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ─── Floating Draggable Neon Orb (PC & Mobile Universal) ─────────
    if ShowToggleBtn then
        ToggleButton = make("ImageButton", {
            Name = WindowName .. "_ToggleButton",
            Size = UDim2.fromOffset(48, 48),
            Position = UDim2.new(0, 20, 0.45, 0),
            BackgroundColor3 = Color3.fromRGB(15, 18, 28),
            BackgroundTransparency = 0.08,
            AutoButtonColor = false,
            ZIndex = 40,
            Parent = ScreenGui,
        }, {
            pill(),
            stroke(AccentColor, 1.8, 0.15, "ToggleStroke"),
            make("UIGradient", {
                Name = "Sheen",
                Color = ColorSequence.new(WHITE, Color3.fromRGB(180, 190, 220)),
                Rotation = 45,
            }),
            make("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(0.5, -12, 0.5, -12),
                BackgroundTransparency = 1,
                Image = "rbxassetid://10723415760",
                ImageColor3 = AccentColor,
                ZIndex = 41,
            }),
            make("Frame", {
                Name = "StatusDot",
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(1, -10, 0, 2),
                BackgroundColor3 = Theme.Success,
                ZIndex = 42,
            }, { pill() }),
        })
        UI:RegisterThemeElement(ToggleButton.ToggleStroke, "Color", "Accent")
        UI:RegisterThemeElement(ToggleButton.Icon, "ImageColor3", "Accent")

        local btnScale = make("UIScale", { Scale = 1, Parent = ToggleButton })

        ToggleButton.MouseEnter:Connect(function()
            tw(btnScale, { Scale = 1.08 }, 0.16, Enum.EasingStyle.Back)
            if ToggleButton:FindFirstChild("ToggleStroke") then
                tw(ToggleButton.ToggleStroke, { Transparency = 0.0, Thickness = 2.2 }, 0.16)
            end
        end)
        ToggleButton.MouseLeave:Connect(function()
            tw(btnScale, { Scale = 1.0 }, 0.16)
            if ToggleButton:FindFirstChild("ToggleStroke") then
                tw(ToggleButton.ToggleStroke, { Transparency = 0.15, Thickness = 1.8 }, 0.16)
            end
        end)

        local btnDrag = false
        local btnStart = Vector2.zero
        local btnPos = UDim2.new()
        local btnMoved = false

        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                btnDrag = true
                btnStart = input.Position
                btnPos = ToggleButton.Position
                btnMoved = false
                tw(btnScale, { Scale = 0.94 }, 0.08)

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        btnDrag = false
                        tw(btnScale, { Scale = 1.0 }, 0.16, Enum.EasingStyle.Back)
                        task.delay(0.08, function() btnMoved = false end)
                    end
                end)
            end
        end)

        bind(UserInputService.InputChanged, function(input)
            if btnDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - btnStart
                if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                    btnMoved = true
                    -- Boundary screen clamping so user doesn't drag button off screen
                    local viewSize = ScreenGui.AbsoluteSize
                    local newX = math.clamp(btnPos.X.Offset + delta.X, 10, math.max(viewSize.X - 58, 10))
                    local newY = math.clamp(btnPos.Y.Offset + delta.Y, 10, math.max(viewSize.Y - 58, 10))
                    ToggleButton.Position = UDim2.new(btnPos.X.Scale, newX, btnPos.Y.Scale, newY)
                end
            end
        end)

        ToggleButton.MouseButton1Click:Connect(function()
            if not btnMoved then
                setWindowVisible(not isVisible)
            end
        end)
    end

    -- ─── Window Object ───────────────────────────────────────────────
    local Window = {
        Gui            = ScreenGui,
        Root           = Root,
        ToggleButton   = ToggleButton,
        FloatingOrb    = ToggleButton,
        Toggles        = UI.Toggles,
        Options        = UI.Options,
        Tabs           = {},
        ActiveTab      = nil,
        Conns          = Conns,
    }

    function Window:Toggle()
        setWindowVisible(not isVisible)
    end

    function Window:SetToggleButtonVisibility(vis)
        if ToggleButton then ToggleButton.Visible = (vis == true) end
    end

    function Window:SetWatermark(text)
        WatermarkFrame.WmText.Text = tostring(text)
        local bounds = WatermarkFrame.WmText.TextBounds
        WatermarkFrame.Size = UDim2.new(0, math.max(bounds.X + 28, 160), 0, 28)
    end

    function Window:SetWatermarkVisibility(vis)
        WatermarkFrame.Visible = (vis == true)
    end

    function Window:SetKeybind(key)
        ToggleKey = key
    end

    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "System Notification"
        local content = notifConfig.Content or notifConfig.Text or ""
        local duration = notifConfig.Duration or notifConfig.Time or 3.5
        local nType = notifConfig.Type or "info"

        local typeColors = {
            info    = AccentColor,
            success = Theme.Success,
            warning = Theme.Warning,
            danger  = Theme.Danger,
        }
        local typeIcons = {
            info    = "ℹ",
            success = "✓",
            warning = "⚠",
            danger  = "✕",
        }
        local accent = typeColors[nType] or AccentColor
        local iconSymbol = typeIcons[nType] or "ℹ"

        local Toast = make("Frame", {
            Name = "ToastCard",
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(1, 40, 0, 0), -- Off-screen for slide-in
            BackgroundColor3 = Color3.fromRGB(17, 20, 31),
            BackgroundTransparency = 0.08,
            ClipsDescendants = true,
            Parent = ToastHolder,
        }, {
            corner(10),
            stroke(accent, 1.25, 0.25, "ToastStroke"),
            txt({
                Name = "BadgeIcon",
                Text = iconSymbol,
                Font = Theme.FontBlack,
                TextSize = 13,
                TextColor3 = accent,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(0, 20, 0, 20),
            }),
            txt({
                Text = title,
                Font = Theme.FontBold,
                TextSize = 11.5,
                TextColor3 = WHITE,
                Position = UDim2.new(0, 36, 0, 8),
                Size = UDim2.new(1, -44, 0, 18),
            }),
            txt({
                Text = content,
                Font = Theme.FontRegular,
                TextSize = 10,
                TextColor3 = Theme.TextBody,
                Position = UDim2.new(0, 36, 0, 28),
                Size = UDim2.new(1, -44, 0, 22),
            }),
            make("Frame", {
                Name = "ProgressBar",
                Size = UDim2.new(1, 0, 0, 2.5),
                Position = UDim2.new(0, 0, 1, -2.5),
                BackgroundColor3 = accent,
            }, { pill() }),
        })

        -- Slide-in animation
        tw(Toast, { Position = UDim2.new(0, 0, 0, 0) }, 0.28, Enum.EasingStyle.Back)
        tw(Toast.ProgressBar, { Size = UDim2.new(0, 0, 0, 2.5) }, duration, Enum.EasingStyle.Linear)

        task.delay(duration, function()
            if Toast and Toast.Parent then
                tw(Toast, { Position = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1 }, 0.24)
                task.wait(0.25)
                Toast:Destroy()
            end
        end)
    end

    -- ─── Tab & Page Registry ─────────────────────────────────────────
    local AllCards = {}

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchInput.Text)
        for card, data in pairs(AllCards) do
            if Window.ActiveTab and data.Page == Window.ActiveTab.Page then
                if query == "" or string.find(string.lower(data.Title), query) then
                    card.Visible = true
                else
                    card.Visible = false
                end
            end
        end
    end)

    function Window:CreateTab(tabConfig, iconArg)
        if type(tabConfig) == "string" then
            tabConfig = { Name = tabConfig, Icon = iconArg or "✦" }
        end
        tabConfig = tabConfig or {}
        local tabName     = tabConfig.Name or "Tab"
        local tabIcon     = tabConfig.Icon or "✦"

        local TabBtn = make("TextButton", {
            Name = tabName .. "_TabBtn",
            Size = UDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Color3.fromRGB(19, 22, 34),
            BackgroundTransparency = 0.55,
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll,
        }, {
            corner(9),
            stroke(Theme.CardBorder, 1, 0.75, "TabStroke"),
            make("Frame", {
                Name = "ActiveIndicator",
                Size = UDim2.new(0, 3, 0, 18),
                Position = UDim2.new(0, 4, 0.5, -9),
                BackgroundColor3 = AccentColor,
                BackgroundTransparency = 1,
            }, { pill() }),
            txt({
                Name = "Icon",
                Text = tabIcon,
                Font = Theme.FontBold,
                TextSize = 12.5,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Center,
            }),
            txt({
                Name = "Label",
                Text = tabName,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextBody,
                Position = UDim2.new(0, 38, 0, 0),
                Size = UDim2.new(1, -44, 1, 0),
            }),
        })

        local Page = make("ScrollingFrame", {
            Name = tabName .. "_Page",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = PagesContainer,
        }, {
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
            }),
            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 8),
            }),
        })

        local TabObj = {
            Button        = TabBtn,
            Page          = Page,
            Name          = tabName,
            LeftColumn    = nil,
            RightColumn   = nil,
            ColumnsHolder = nil,
        }

        local function activateTab()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                tw(t.Button, { BackgroundTransparency = 0.55, BackgroundColor3 = Color3.fromRGB(19, 22, 34) }, 0.18)
                tw(t.Button.Label, { TextColor3 = Theme.TextBody }, 0.18)
                tw(t.Button.Icon, { TextColor3 = Theme.TextDim }, 0.18)
                tw(t.Button.TabStroke, { Transparency = 0.75, Color = Theme.CardBorder }, 0.18)
                if t.Button:FindFirstChild("ActiveIndicator") then
                    tw(t.Button.ActiveIndicator, { BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 10) }, 0.18)
                end
            end
            Page.Visible = true
            Window.ActiveTab = TabObj

            -- Refined Modern Active Tab (Translucent Card + Spring Neon Indicator)
            tw(TabBtn, { BackgroundTransparency = 0.15, BackgroundColor3 = Color3.fromRGB(26, 30, 48) }, 0.22)
            tw(TabBtn.Label, { TextColor3 = WHITE }, 0.22)
            tw(TabBtn.Icon, { TextColor3 = AccentColor }, 0.22)
            tw(TabBtn.TabStroke, { Transparency = 0.25, Color = AccentColor }, 0.22)
            if TabBtn:FindFirstChild("ActiveIndicator") then
                tw(TabBtn.ActiveIndicator, { BackgroundTransparency = 0, Size = UDim2.new(0, 3, 0, 20) }, 0.25, Enum.EasingStyle.Back)
            end

            if SearchInput.Text ~= "" then
                local query = string.lower(SearchInput.Text)
                for card, data in pairs(AllCards) do
                    if data.Page == Page then
                        card.Visible = (string.find(string.lower(data.Title), query) ~= nil)
                    end
                end
            else
                for card, data in pairs(AllCards) do
                    if data.Page == Page then card.Visible = true end
                end
            end
        end

        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= TabObj then
                tw(TabBtn, { BackgroundTransparency = 0.35 }, 0.15)
                tw(TabBtn.Label, { TextColor3 = WHITE }, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= TabObj then
                tw(TabBtn, { BackgroundTransparency = 0.55 }, 0.15)
                tw(TabBtn.Label, { TextColor3 = Theme.TextBody }, 0.15)
            end
        end)

        TabBtn.MouseButton1Click:Connect(activateTab)
        Window.Tabs[tabName] = TabObj

        if not Window.ActiveTab then
            activateTab()
        end

        -- Helper to ensure dual column container exists for groupboxes
        local function ensureDualColumns()
            if TabObj.ColumnsHolder then
                return TabObj.LeftColumn, TabObj.RightColumn
            end

            local ColumnsHolder = make("Frame", {
                Name = "DualColumns",
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = Page,
            })

            local LeftCol = make("Frame", {
                Name = "LeftColumn",
                Size = UDim2.new(0.5, -5, 0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = ColumnsHolder,
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8),
                }),
            })

            local RightCol = make("Frame", {
                Name = "RightColumn",
                Size = UDim2.new(0.5, -5, 0, 0),
                Position = UDim2.new(0.5, 5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = ColumnsHolder,
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8),
                }),
            })

            TabObj.ColumnsHolder = ColumnsHolder
            TabObj.LeftColumn    = LeftCol
            TabObj.RightColumn   = RightCol
            return LeftCol, RightCol
        end

        -- ═════════════════════════════════════════════════════════════
        -- COMPONENT FACTORY (SHARED BETWEEN TAB & GROUPBOX)
        -- ═════════════════════════════════════════════════════════════
        local function attachWidgets(targetContainer, isInsideGroupbox)
            local W = {}

            -- 1. ADD TOGGLE (Supports Barun `{Name=...}` AND Linoria `(idx, {Text=...})`)
            function W:AddToggle(arg1, arg2)
                local idx, cfg
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    cfg = arg2
                elseif type(arg1) == "table" then
                    cfg = arg1
                    idx = cfg.Idx or cfg.Id or cfg.Name or cfg.Text
                else
                    error("Invalid AddToggle arguments")
                end

                local name     = cfg.Text or cfg.Name or "Toggle Switch"
                local desc     = cfg.Desc or cfg.Tooltip or ""
                local default  = (cfg.Default == true)
                local callback = cfg.Callback or function() end

                local isToggled = default
                local cardHeight = desc ~= "" and 50 or 38
                local ToggleCard = makeCard(targetContainer, cardHeight, true)
                hoverable(ToggleCard)

                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 11,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 12, 0, desc ~= "" and 6 or 0),
                    Size = UDim2.new(1, -95, 0, desc ~= "" and 18 or cardHeight),
                    Parent = ToggleCard,
                })
                if desc ~= "" then
                    txt({
                        Text = desc,
                        Font = Theme.FontRegular,
                        TextSize = 9,
                        TextColor3 = Theme.TextDim,
                        Position = UDim2.new(0, 12, 0, 24),
                        Size = UDim2.new(1, -95, 0, 16),
                        Parent = ToggleCard,
                    })
                end

                -- Accessory Stack on right side (Holds inline Keybind / Colorpicker)
                local AccessoryStack = make("Frame", {
                    Name = "AccessoryStack",
                    Size = UDim2.new(0, 80, 1, 0),
                    Position = UDim2.new(1, -86, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ToggleCard,
                }, {
                    make("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 6),
                    }),
                })

                local Track = make("Frame", {
                    Size = UDim2.new(0, 38, 0, 20),
                    BackgroundColor3 = isToggled and AccentColor or Color3.fromRGB(34, 38, 54),
                    Parent = AccessoryStack,
                }, {
                    pill(),
                    stroke(isToggled and AccentColor or Theme.CardBorder, 1.25, 0.3, "TrackStroke"),
                })

                local Knob = make("Frame", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = isToggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                    BackgroundColor3 = WHITE,
                    Parent = Track,
                }, { pill() })

                local changeCallbacks = {}
                local function sync(fire)
                    local targetPos = isToggled and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    local targetColor = isToggled and AccentColor or Color3.fromRGB(34, 38, 54)
                    tw(Knob, { Position = targetPos }, 0.22, Enum.EasingStyle.Back)
                    tw(Track, { BackgroundColor3 = targetColor }, 0.2)
                    tw(Track.TrackStroke, { Color = isToggled and AccentColor or Theme.CardBorder }, 0.2)

                    if fire then
                        task.spawn(callback, isToggled)
                        for _, fn in ipairs(changeCallbacks) do
                            task.spawn(fn, isToggled)
                        end
                    end
                end

                ToggleCard.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    sync(true)
                end)

                AllCards[ToggleCard] = { Title = name .. " " .. desc, Page = Page }

                local Handle = {
                    Value = isToggled,
                    Type  = "Toggle",
                }

                function Handle:SetValue(v)
                    isToggled = (v == true)
                    Handle.Value = isToggled
                    sync(true)
                end
                function Handle:Set(v) Handle:SetValue(v) end
                function Handle:Get() return isToggled end
                function Handle:OnChanged(fn)
                    table.insert(changeCallbacks, fn)
                    return fn
                end

                -- Inline Keybind attachment (Obsidian / Linoria style)
                function Handle:AddKeybind(kbIdx, kbCfg)
                    kbCfg = kbCfg or {}
                    local defaultKey = kbCfg.Default or Enum.KeyCode.Unknown
                    local mode = kbCfg.Mode or "Toggle"

                    local keyName = (typeof(defaultKey) == "EnumItem" and defaultKey.Name) or tostring(defaultKey)
                    local KeyBadge = make("TextButton", {
                        Name = "InlineKeybind",
                        Size = UDim2.new(0, 34, 0, 19),
                        BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                        Text = keyName == "Unknown" and "[NONE]" or "[" .. keyName .. "]",
                        Font = Theme.FontBold,
                        TextSize = 9,
                        TextColor3 = AccentColor,
                        AutoButtonColor = false,
                        LayoutOrder = -1,
                        Parent = AccessoryStack,
                    }, { corner(5), stroke(Theme.CardBorder, 1, 0.4) })

                    local isListening = false
                    KeyBadge.MouseButton1Click:Connect(function()
                        isListening = true
                        KeyBadge.Text = "[...]"
                    end)

                    bind(UserInputService.InputBegan, function(input, gpe)
                        if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
                            isListening = false
                            defaultKey = input.KeyCode
                            KeyBadge.Text = "[" .. defaultKey.Name .. "]"
                        elseif not gpe and input.KeyCode == defaultKey then
                            if mode == "Toggle" then
                                Handle:SetValue(not isToggled)
                            end
                        end
                    end)

                    local KbHandle = { Value = defaultKey }
                    if kbIdx then UI.Options[kbIdx] = KbHandle end
                    return Handle
                end

                -- Inline Colorpicker attachment
                function Handle:AddColorPicker(cpIdx, cpCfg)
                    cpCfg = cpCfg or {}
                    local defColor = cpCfg.Default or AccentColor

                    local ColorBadge = make("TextButton", {
                        Name = "InlineColorBadge",
                        Size = UDim2.new(0, 18, 0, 18),
                        BackgroundColor3 = defColor,
                        Text = "",
                        AutoButtonColor = false,
                        LayoutOrder = -2,
                        Parent = AccessoryStack,
                    }, { corner(5), stroke(Theme.CardBorder, 1, 0.4) })

                    local CpHandle = { Value = defColor }
                    if cpIdx then UI.Options[cpIdx] = CpHandle end
                    return Handle
                end

                if idx then
                    UI.Toggles[idx] = Handle
                end
                return Handle
            end

            -- 2. ADD SLIDER (Supports Barun and Linoria style)
            function W:AddSlider(arg1, arg2)
                local idx, cfg
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    cfg = arg2
                elseif type(arg1) == "table" then
                    cfg = arg1
                    idx = cfg.Idx or cfg.Id or cfg.Name or cfg.Text
                else
                    error("Invalid AddSlider arguments")
                end

                local name     = cfg.Text or cfg.Name or "Slider Parameter"
                local min      = cfg.Min or 0
                local max      = cfg.Max or 100
                local default  = math.clamp(cfg.Default or min, min, max)
                local inc      = cfg.Increment or cfg.Rounding or 1
                local suffix   = cfg.Suffix or cfg.ValueName or ""
                local callback = cfg.Callback or function() end

                local currentVal = default
                local SliderCard = makeCard(targetContainer, 50, false)

                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 10.5,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 12, 0, 6),
                    Size = UDim2.new(0.65, 0, 0, 16),
                    Parent = SliderCard,
                })

                local ValBadge = make("Frame", {
                    Name = "ValBadge",
                    Size = UDim2.new(0, 60, 0, 18),
                    Position = UDim2.new(1, -72, 0, 5),
                    BackgroundColor3 = Color3.fromRGB(15, 18, 28),
                    Parent = SliderCard,
                }, {
                    corner(5),
                    stroke(Theme.CardBorder, 1, 0.45),
                    txt({
                        Name = "ValText",
                        Text = tostring(currentVal) .. suffix,
                        Font = Theme.FontBold,
                        TextSize = 9.5,
                        TextColor3 = AccentColor,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Size = UDim2.new(1, 0, 1, 0),
                    }),
                })
                local ValText = ValBadge.ValText

                local Rail = make("Frame", {
                    Size = UDim2.new(1, -24, 0, 5),
                    Position = UDim2.new(0, 12, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                    Parent = SliderCard,
                }, { pill() })

                local pct = (max == min) and 0 or (currentVal - min) / (max - min)
                local Fill = make("Frame", {
                    Size = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = AccentColor,
                    Parent = Rail,
                }, {
                    pill(),
                    make("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.0, Theme.AccentPrimary),
                            ColorSequenceKeypoint.new(1.0, AccentColor),
                        }),
                    }),
                })

                local Knob = make("Frame", {
                    Size = UDim2.new(0, 13, 0, 13),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(pct, 0, 0.5, 0),
                    BackgroundColor3 = WHITE,
                    Parent = Rail,
                }, { pill(), stroke(AccentColor, 1.8, 0.2) })

                local changeCallbacks = {}
                local isSliding = false
                local function updateValue(inputX, fire)
                    local railX = Rail.AbsolutePosition.X
                    local railW = math.max(Rail.AbsoluteSize.X, 1)
                    local p = math.clamp((inputX - railX) / railW, 0, 1)
                    local raw = min + (max - min) * p
                    local stepped = min + math.floor((raw - min) / inc + 0.5) * inc
                    stepped = math.clamp(stepped, min, max)
                    currentVal = stepped

                    tw(Fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.05)
                    tw(Knob, { Position = UDim2.new(p, 0, 0.5, 0) }, 0.05)
                    ValText.Text = tostring(stepped) .. suffix

                    if fire then
                        task.spawn(callback, stepped)
                        for _, fn in ipairs(changeCallbacks) do
                            task.spawn(fn, stepped)
                        end
                    end
                end

                SliderCard.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = true
                        tw(Knob, { Size = UDim2.new(0, 15, 0, 15) }, 0.1)
                        updateValue(input.Position.X, true)
                    end
                end)
                bind(UserInputService.InputChanged, function(input)
                    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateValue(input.Position.X, true)
                    end
                end)
                bind(UserInputService.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false
                        tw(Knob, { Size = UDim2.new(0, 13, 0, 13) }, 0.1)
                    end
                end)

                AllCards[SliderCard] = { Title = name, Page = Page }

                local Handle = {
                    Value = currentVal,
                    Type  = "Slider",
                }

                function Handle:SetValue(v)
                    v = math.clamp(v, min, max)
                    currentVal = v
                    Handle.Value = currentVal
                    local p = (max == min) and 0 or (v - min) / (max - min)
                    tw(Fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.1)
                    tw(Knob, { Position = UDim2.new(p, 0, 0.5, 0) }, 0.1)
                    ValText.Text = tostring(v) .. suffix
                    task.spawn(callback, v)
                    for _, fn in ipairs(changeCallbacks) do task.spawn(fn, v) end
                end
                function Handle:Set(v) Handle:SetValue(v) end
                function Handle:Get() return currentVal end
                function Handle:OnChanged(fn)
                    table.insert(changeCallbacks, fn)
                    return fn
                end

                if idx then UI.Options[idx] = Handle end
                return Handle
            end

            -- 3. ADD DROPDOWN (Supports single / multi, SetValues, and real-time search)
            function W:AddDropdown(arg1, arg2)
                local idx, cfg
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    cfg = arg2
                elseif type(arg1) == "table" then
                    cfg = arg1
                    idx = cfg.Idx or cfg.Id or cfg.Name or cfg.Text
                else
                    error("Invalid AddDropdown arguments")
                end

                local name        = cfg.Text or cfg.Name or "Dropdown Selection"
                local options     = cfg.Values or cfg.Options or {}
                local default     = cfg.Default or options[1]
                local multiSelect = (cfg.Multi == true or cfg.MultiSelect == true)
                local callback    = cfg.Callback or function() end

                local isExpanded = false
                local selected = multiSelect and (type(default) == "table" and default or { default }) or default

                local DropCard = makeCard(targetContainer, 42, false)
                DropCard.ClipsDescendants = true

                local Header = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropCard,
                }, {
                    txt({
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 11,
                        TextColor3 = Theme.TextTitle,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(0.45, 0, 1, 0),
                    }),
                    txt({
                        Name = "SelectedLabel",
                        Text = multiSelect and table.concat(selected, ", ") or tostring(selected),
                        Font = Theme.FontBold,
                        TextSize = 10,
                        TextColor3 = AccentColor,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        Position = UDim2.new(0.45, 0, 0, 0),
                        Size = UDim2.new(0.55, -28, 1, 0),
                    }),
                    txt({
                        Name = "Arrow",
                        Text = "▾",
                        Font = Theme.FontBold,
                        TextSize = 11,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Position = UDim2.new(1, -22, 0.5, -8),
                        Size = UDim2.new(0, 16, 0, 16),
                    }),
                })

                local OptionScroll = make("ScrollingFrame", {
                    Size = UDim2.new(1, -24, 0, math.min(#options * 28, 140)),
                    Position = UDim2.new(0, 12, 0, 46),
                    BackgroundTransparency = 1,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = AccentColor,
                    CanvasSize = UDim2.new(0, 0, 0, #options * 28),
                    Parent = DropCard,
                }, {
                    make("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 3),
                    }),
                })

                local optBtns = {}
                local changeCallbacks = {}

                local function refreshSelected()
                    if multiSelect then
                        Header.SelectedLabel.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                        for opt, b in pairs(optBtns) do
                            local active = table.find(selected, opt) ~= nil
                            b.BackgroundColor3 = active and AccentColor or Color3.fromRGB(28, 32, 48)
                            b.TextColor3 = active and WHITE or Theme.TextBody
                        end
                    else
                        Header.SelectedLabel.Text = tostring(selected)
                        for opt, b in pairs(optBtns) do
                            local active = (opt == selected)
                            b.BackgroundColor3 = active and AccentColor or Color3.fromRGB(28, 32, 48)
                            b.TextColor3 = active and WHITE or Theme.TextBody
                        end
                    end
                end

                local function setOpen(open)
                    isExpanded = open
                    local targetH = open and (52 + math.min(#options * 28, 140)) or 42
                    tw(DropCard, { Size = UDim2.new(1, 0, 0, targetH) }, 0.22, Enum.EasingStyle.Quart)
                    tw(Header.Arrow, { Rotation = open and 180 or 0 }, 0.18)
                end

                Header.MouseButton1Click:Connect(function()
                    setOpen(not isExpanded)
                end)

                local function rebuildOptions(newList)
                    for _, child in ipairs(OptionScroll:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    optBtns = {}
                    options = newList or options
                    OptionScroll.CanvasSize = UDim2.new(0, 0, 0, #options * 28)
                    OptionScroll.Size = UDim2.new(1, -24, 0, math.min(#options * 28, 140))

                    for _, opt in ipairs(options) do
                        local oBtn = make("TextButton", {
                            Size = UDim2.new(1, 0, 0, 25),
                            BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                            Text = tostring(opt),
                            Font = Theme.FontRegular,
                            TextSize = 10,
                            TextColor3 = Theme.TextBody,
                            AutoButtonColor = false,
                            Parent = OptionScroll,
                        }, { corner(5) })
                        optBtns[opt] = oBtn

                        oBtn.MouseButton1Click:Connect(function()
                            if multiSelect then
                                local i = table.find(selected, opt)
                                if i then table.remove(selected, i) else table.insert(selected, opt) end
                                refreshSelected()
                                task.spawn(callback, selected)
                                for _, fn in ipairs(changeCallbacks) do task.spawn(fn, selected) end
                            else
                                selected = opt
                                refreshSelected()
                                setOpen(false)
                                task.spawn(callback, selected)
                                for _, fn in ipairs(changeCallbacks) do task.spawn(fn, selected) end
                            end
                        end)
                    end
                    refreshSelected()
                end

                rebuildOptions(options)
                AllCards[DropCard] = { Title = name, Page = Page }

                local Handle = {
                    Value = selected,
                    Type  = "Dropdown",
                }

                function Handle:SetValue(newVal)
                    selected = newVal
                    Handle.Value = selected
                    refreshSelected()
                    task.spawn(callback, selected)
                    for _, fn in ipairs(changeCallbacks) do task.spawn(fn, selected) end
                end
                function Handle:Set(v) Handle:SetValue(v) end
                function Handle:SetValues(newList)
                    rebuildOptions(newList)
                end
                function Handle:Get() return selected end
                function Handle:OnChanged(fn)
                    table.insert(changeCallbacks, fn)
                    return fn
                end

                if idx then UI.Options[idx] = Handle end
                return Handle
            end

            -- 4. ADD BUTTON (Supports Barun `{Name=..., Callback=...}` and Linoria `{Text=..., Func=...}`)
            function W:AddButton(arg1, arg2)
                local cfg
                if type(arg1) == "string" and type(arg2) == "function" then
                    cfg = { Text = arg1, Callback = arg2 }
                elseif type(arg1) == "table" then
                    cfg = arg1
                else
                    error("Invalid AddButton arguments")
                end

                local name     = cfg.Text or cfg.Name or "Action Button"
                local icon     = cfg.Icon or "▶"
                local callback = cfg.Func or cfg.Callback or function() end

                local BtnCard = makeCard(targetContainer, 38, true)
                BtnCard.ClipsDescendants = true
                hoverable(BtnCard, AccentColor)

                local Scale = make("UIScale", { Scale = 1, Parent = BtnCard })

                txt({
                    Text = icon .. "   " .. name,
                    Font = Theme.FontSemi,
                    TextSize = 11,
                    TextColor3 = WHITE,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -36, 1, 0),
                    Parent = BtnCard,
                })
                txt({
                    Text = "›",
                    Font = Theme.FontBold,
                    TextSize = 13,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(1, -22, 0, 0),
                    Size = UDim2.new(0, 14, 1, 0),
                    Parent = BtnCard,
                })

                BtnCard.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        tw(Scale, { Scale = 0.96 }, 0.08)
                    end
                end)
                BtnCard.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        tw(Scale, { Scale = 1 }, 0.16, Enum.EasingStyle.Back)
                    end
                end)
                BtnCard.MouseButton1Click:Connect(function()
                    task.spawn(callback)
                end)

                AllCards[BtnCard] = { Title = name, Page = Page }
                return BtnCard
            end

            -- 5. ADD INPUT / TEXTBOX
            function W:AddInput(arg1, arg2)
                return W:AddTextbox(arg1, arg2)
            end

            function W:AddTextbox(arg1, arg2)
                local idx, cfg
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    cfg = arg2
                elseif type(arg1) == "table" then
                    cfg = arg1
                    idx = cfg.Idx or cfg.Id or cfg.Name or cfg.Text
                else
                    error("Invalid AddTextbox arguments")
                end

                local name     = cfg.Text or cfg.Name or "Text Input"
                local default  = cfg.Default or ""
                local placeholder = cfg.Placeholder or cfg.PlaceholderText or "Type here..."
                local callback = cfg.Callback or function() end

                local BoxCard = makeCard(targetContainer, 40, false)
                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 10.5,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.42, 0, 1, 0),
                    Parent = BoxCard,
                })

                local Input = make("TextBox", {
                    Size = UDim2.new(0.54, 0, 0, 24),
                    Position = UDim2.new(0.44, 0, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(14, 17, 26),
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Theme.TextDim,
                    TextColor3 = WHITE,
                    Font = Theme.FontRegular,
                    TextSize = 10,
                    ClearTextOnFocus = false,
                    Parent = BoxCard,
                }, {
                    corner(6),
                    stroke(Theme.CardBorder, 1, 0.45, "Stroke"),
                })

                local changeCallbacks = {}
                local currentText = default

                Input.FocusLost:Connect(function(enterPressed)
                    tw(Input.Stroke, { Color = Theme.CardBorder }, 0.15)
                    currentText = Input.Text
                    task.spawn(callback, currentText, enterPressed)
                    for _, fn in ipairs(changeCallbacks) do task.spawn(fn, currentText) end
                end)
                Input.Focused:Connect(function()
                    tw(Input.Stroke, { Color = AccentColor }, 0.15)
                end)

                AllCards[BoxCard] = { Title = name, Page = Page }

                local Handle = {
                    Value = currentText,
                    Type  = "Input",
                }
                function Handle:SetValue(v)
                    currentText = tostring(v)
                    Input.Text = currentText
                    Handle.Value = currentText
                    task.spawn(callback, currentText, false)
                    for _, fn in ipairs(changeCallbacks) do task.spawn(fn, currentText) end
                end
                function Handle:Set(v) Handle:SetValue(v) end
                function Handle:Get() return currentText end
                function Handle:OnChanged(fn)
                    table.insert(changeCallbacks, fn)
                    return fn
                end

                if idx then UI.Options[idx] = Handle end
                return Handle
            end

            -- 6. ADD KEYBIND
            function W:AddKeybind(arg1, arg2)
                local idx, cfg
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    cfg = arg2
                elseif type(arg1) == "table" then
                    cfg = arg1
                    idx = cfg.Idx or cfg.Id or cfg.Name or cfg.Text
                else
                    error("Invalid AddKeybind arguments")
                end

                local name     = cfg.Text or cfg.Name or "Keybind"
                local default  = cfg.Default or Enum.KeyCode.E
                local callback = cfg.Callback or function() end

                local currentKey = default
                local isListening = false
                local KeyCard = makeCard(targetContainer, 38, false)

                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 10.5,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(0.6, 0, 1, 0),
                    Parent = KeyCard,
                })

                local KeyBtn = make("TextButton", {
                    Size = UDim2.new(0, 72, 0, 22),
                    Position = UDim2.new(1, -84, 0.5, -11),
                    BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                    Text = typeof(currentKey) == "EnumItem" and currentKey.Name or tostring(currentKey),
                    Font = Theme.FontBold,
                    TextSize = 10,
                    TextColor3 = AccentColor,
                    AutoButtonColor = false,
                    Parent = KeyCard,
                }, { corner(6), stroke(Theme.CardBorder, 1, 0.45, "KStroke") })

                KeyBtn.MouseButton1Click:Connect(function()
                    isListening = true
                    KeyBtn.Text = "..."
                    tw(KeyBtn.KStroke, { Color = AccentColor }, 0.15)
                end)

                bind(UserInputService.InputBegan, function(input, gpe)
                    if isListening and input.UserInputType == Enum.UserInputType.Keyboard then
                        isListening = false
                        currentKey = input.KeyCode
                        KeyBtn.Text = currentKey.Name
                        tw(KeyBtn.KStroke, { Color = Theme.CardBorder }, 0.15)
                        task.spawn(callback, currentKey)
                    elseif not gpe and input.KeyCode == currentKey then
                        task.spawn(callback, currentKey)
                    end
                end)

                AllCards[KeyCard] = { Title = name, Page = Page }

                local Handle = {
                    Value = currentKey,
                    Type  = "Keybind",
                }
                function Handle:SetValue(k)
                    currentKey = k
                    KeyBtn.Text = typeof(k) == "EnumItem" and k.Name or tostring(k)
                    Handle.Value = currentKey
                end
                if idx then UI.Options[idx] = Handle end
                return Handle
            end

            -- 7. ADD LABEL
            function W:AddLabel(textStr, doesWrap)
                local labelHeight = doesWrap and 34 or 24
                local LabelCard = make("Frame", {
                    Size = UDim2.new(1, 0, 0, labelHeight),
                    BackgroundTransparency = 1,
                    Parent = targetContainer,
                }, {
                    txt({
                        Name = "LabelText",
                        Text = tostring(textStr),
                        Font = Theme.FontSemi,
                        TextSize = 10,
                        TextColor3 = Theme.TextDim,
                        TextWrapped = doesWrap or false,
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -16, 1, 0),
                    }),
                })

                local Handle = {}
                function Handle:SetText(newText)
                    LabelCard.LabelText.Text = tostring(newText)
                end
                return Handle
            end

            -- 8. ADD DIVIDER
            function W:AddDivider()
                return make("Frame", {
                    Size = UDim2.new(1, -16, 0, 1),
                    BackgroundColor3 = Theme.CardBorder,
                    BackgroundTransparency = 0.55,
                    Parent = targetContainer,
                })
            end

            return W
        end

        -- Attach widget builders directly to Tab (for standard single-column mode)
        local TabWidgets = attachWidgets(Page, false)
        for k, v in pairs(TabWidgets) do
            TabObj[k] = v
        end

        -- ═════════════════════════════════════════════════════════════
        -- OBSIDIAN / LINORIA GROUPBOX BUILDER
        -- ═════════════════════════════════════════════════════════════
        local function createGroupbox(title, targetColumn)
            local GroupboxFrame = make("Frame", {
                Name = "Groupbox_" .. title,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.CardBg,
                BackgroundTransparency = 0.12,
                Parent = targetColumn,
            }, {
                corner(10),
                stroke(Theme.CardBorder, 1.15, 0.45, "GbStroke"),
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                }),
            })
            UI:RegisterThemeElement(GroupboxFrame, "BackgroundColor3", "CardBg")
            UI:RegisterThemeElement(GroupboxFrame.GbStroke, "Color", "CardBorder")

            -- Header with Title and sleek accent line
            local Header = make("Frame", {
                Name = "GbHeader",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Parent = GroupboxFrame,
            }, {
                txt({
                    Name = "Title",
                    Text = string.upper(title),
                    Font = Theme.FontBlack,
                    TextSize = 10,
                    TextColor3 = AccentColor,
                    Position = UDim2.new(0, 4, 0, 0),
                    Size = UDim2.new(1, -8, 0, 16),
                }),
                make("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.CardBorder,
                }, {
                    make("UIGradient", {
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0.0, 0.1),
                            NumberSequenceKeypoint.new(0.8, 0.8),
                            NumberSequenceKeypoint.new(1.0, 1.0),
                        }),
                    }),
                }),
            })
            UI:RegisterThemeElement(Header.Title, "TextColor3", "Accent")

            -- Inner container for Groupbox elements
            local InnerContainer = make("Frame", {
                Name = "InnerContainer",
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent = GroupboxFrame,
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6),
                }),
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 8),
                }),
            })

            local GbWidgets = attachWidgets(InnerContainer, true)
            GbWidgets.Frame = GroupboxFrame
            GbWidgets.Container = InnerContainer
            return GbWidgets
        end

        function TabObj:AddLeftGroupbox(title)
            local leftCol, _ = ensureDualColumns()
            return createGroupbox(title, leftCol)
        end

        function TabObj:AddRightGroupbox(title)
            local _, rightCol = ensureDualColumns()
            return createGroupbox(title, rightCol)
        end

        function TabObj:AddGroupbox(title, side)
            if string.lower(side or "left") == "right" then
                return TabObj:AddRightGroupbox(title)
            else
                return TabObj:AddLeftGroupbox(title)
            end
        end

        -- Legacy AddSection
        function TabObj:AddSection(titleText)
            local Sec = make("Frame", {
                Name = "Section_" .. titleText,
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = Page,
            }, {
                txt({
                    Text = string.upper(titleText),
                    Font = Theme.FontBlack,
                    TextSize = 10,
                    TextColor3 = AccentColor,
                    Position = UDim2.new(0, 4, 0, 0),
                    Size = UDim2.new(1, -8, 1, 0),
                }),
            })
            AllCards[Sec] = { Title = titleText, Page = Page }
            return Sec
        end

        -- Legacy AddStatCard
        function TabObj:AddStatCard(statConfig)
            statConfig = statConfig or {}
            local title    = statConfig.Title or "Metric"
            local val      = statConfig.Value or "0"
            local subtext  = statConfig.Subtext or ""
            local progress = statConfig.Progress or nil

            local card = makeCard(Page, progress and 56 or 46, false)
            txt({
                Text = title,
                Font = Theme.FontSemi,
                TextSize = 10.5,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(0.6, 0, 0, 14),
                Parent = card,
            })
            local valLabel = txt({
                Name = "ValLabel",
                Text = tostring(val),
                Font = Theme.FontBold,
                TextSize = 12.5,
                TextColor3 = AccentColor,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.5, 0, 0, 8),
                Size = UDim2.new(0.5, -14, 0, 16),
                Parent = card,
            })

            local Meter = nil
            if progress ~= nil then
                local track = make("Frame", {
                    Size = UDim2.new(1, -28, 0, 4),
                    Position = UDim2.new(0, 14, 0, 36),
                    BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                    Parent = card,
                }, { pill() })
                Meter = make("Frame", {
                    Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0),
                    BackgroundColor3 = AccentColor,
                    Parent = track,
                }, { pill() })
            end

            AllCards[card] = { Title = title .. " " .. subtext, Page = Page }

            local Handle = {}
            function Handle:Set(newVal, color, newProgress)
                valLabel.Text = tostring(newVal)
                if color then tw(valLabel, { TextColor3 = color }, 0.2) end
                if Meter and newProgress ~= nil then
                    tw(Meter, { Size = UDim2.new(math.clamp(newProgress, 0, 1), 0, 1, 0) }, 0.25)
                end
            end
            return Handle
        end

        return TabObj
    end

    -- Linoria alias for CreateTab
    function Window:AddTab(tabName, icon)
        return Window:CreateTab(tabName, icon)
    end

    -- Initial Window Open Animation
    setWindowVisible(true)

    -- Attach ThemeManager & SaveManager to Window
    Window.ThemeManager = UI.ThemeManager
    Window.SaveManager  = UI.SaveManager

    return Window
end

-- ═════════════════════════════════════════════════════════════════════
-- INTEGRATED THEME MANAGER (DYNAMIC LIVE THEME ENGINE)
-- ═════════════════════════════════════════════════════════════════════
UI.ThemeManager = {
    Themes = Themes,
}

function UI.ThemeManager:SetTheme(themeName)
    local t = Themes[themeName]
    if not t then return end
    UI.CurrentTheme = themeName
    for k, v in pairs(t) do Theme[k] = v end

    -- Live Dynamic Update of all registered UI elements across the GUI
    for _, item in ipairs(UI.ThemeTrackers) do
        pcall(function()
            if item.Instance and item.Instance.Parent then
                local targetColor = Theme[item.Key]
                if targetColor then
                    tw(item.Instance, { [item.Property] = targetColor }, 0.25)
                end
            end
        end)
    end

    -- Call custom registered listeners
    for _, fn in ipairs(UI.ThemeListeners) do
        pcall(fn, themeName, t)
    end
end

function UI.ThemeManager:ApplyToTab(tabObj)
    local gb = tabObj:AddRightGroupbox("Theme & Interface")
    local themeNames = {}
    for name, _ in pairs(Themes) do table.insert(themeNames, name) end
    table.sort(themeNames)

    gb:AddDropdown("ThemeSelector", {
        Text = "Color Theme",
        Values = themeNames,
        Default = UI.CurrentTheme,
        Callback = function(chosen)
            UI.ThemeManager:SetTheme(chosen)
        end,
    })

    gb:AddKeybind("ToggleHotkey", {
        Text = "Menu Keybind",
        Default = Enum.KeyCode.RightShift,
        Callback = function(key) end,
    })

    gb:AddButton({
        Text = "Unload UI",
        Func = function()
            local h = gethui and gethui() or CoreGui
            for _, c in ipairs(h:GetChildren()) do
                if string.find(c.Name, "ProjectBarun") then c:Destroy() end
            end
        end,
    })
end

-- ═════════════════════════════════════════════════════════════
-- INTEGRATED SAVE MANAGER (JSON CONFIG ENGINE)
-- ═════════════════════════════════════════════════════════════
UI.SaveManager = {
    Folder = "ProjectBarun/Configs",
    IgnoreIndexes = {},
}

function UI.SaveManager:SetFolder(folderPath)
    self.Folder = folderPath
    if makefolder and not isfolder(self.Folder) then
        pcall(makefolder, self.Folder)
    end
end

function UI.SaveManager:SetIgnoreIndexes(list)
    for _, idx in ipairs(list or {}) do
        self.IgnoreIndexes[idx] = true
    end
end

function UI.SaveManager:Save(configName)
    if not writefile then return false end
    configName = configName or "default"
    local filePath = self.Folder .. "/" .. configName .. ".json"

    local data = {
        Toggles = {},
        Options = {},
    }

    for idx, tog in pairs(UI.Toggles) do
        if not self.IgnoreIndexes[idx] then
            data.Toggles[idx] = tog.Value
        end
    end

    for idx, opt in pairs(UI.Options) do
        if not self.IgnoreIndexes[idx] then
            data.Options[idx] = opt.Value
        end
    end

    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and json then
        writefile(filePath, json)
        return true
    end
    return false
end

function UI.SaveManager:Load(configName)
    if not readfile or not isfile then return false end
    configName = configName or "default"
    local filePath = self.Folder .. "/" .. configName .. ".json"
    if not isfile(filePath) then return false end

    local content = readfile(filePath)
    local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok or type(data) ~= "table" then return false end

    for idx, val in pairs(data.Toggles or {}) do
        if UI.Toggles[idx] and UI.Toggles[idx].SetValue then
            pcall(function() UI.Toggles[idx]:SetValue(val) end)
        end
    end

    for idx, val in pairs(data.Options or {}) do
        if UI.Options[idx] and UI.Options[idx].SetValue then
            pcall(function() UI.Options[idx]:SetValue(val) end)
        end
    end

    return true
end

function UI.SaveManager:GetConfigs()
    local configs = {}
    if listfiles and isfolder and isfolder(self.Folder) then
        for _, file in ipairs(listfiles(self.Folder)) do
            if string.sub(file, -5) == ".json" then
                local name = string.match(file, "([^/\\]+)%.json$")
                if name then table.insert(configs, name) end
            end
        end
    end
    if #configs == 0 then table.insert(configs, "default") end
    return configs
end

function UI.SaveManager:BuildConfigSection(tabObj)
    local gb = tabObj:AddLeftGroupbox("Configuration Manager")
    local configInput = gb:AddInput("ConfigName", {
        Text = "Config Name",
        Placeholder = "e.g. farm_main",
        Default = "default",
    })

    local configList = gb:AddDropdown("ConfigList", {
        Text = "Saved Configs",
        Values = self:GetConfigs(),
        Default = "default",
    })

    gb:AddButton({
        Text = "Create / Save Config",
        Func = function()
            local name = configInput.Value ~= "" and configInput.Value or "default"
            self:Save(name)
            configList:SetValues(self:GetConfigs())
        end,
    })

    gb:AddButton({
        Text = "Load Selected Config",
        Func = function()
            local chosen = configList.Value
            if chosen then self:Load(chosen) end
        end,
    })

    gb:AddButton({
        Text = "Refresh Config List",
        Func = function()
            configList:SetValues(self:GetConfigs())
        end,
    })
end
    return UI
end)()

-- 💎 PROJECT BARUN — ANIME DICE [UPD 7] PRO PROGRESSION & AUTOMATION HUB
-- ═════════════════════════════════════════════════════════════════════

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")
local UserInputService  = game:GetService("UserInputService")
local TeleportService   = game:GetService("TeleportService")
local VirtualUser       = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local LP = LocalPlayer

-- ── 1. NETWORK REMOTES ────────────────────────────────────────────────
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

-- Halloween & Event Remotes
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

-- Grade Remotes
local RollGradeRE          = GradeNetwork and GradeNetwork:FindFirstChild("RE") and GradeNetwork.RE:FindFirstChild("Roll")
local SetGradeProtectedRE  = GradeNetwork and GradeNetwork:FindFirstChild("RE") and GradeNetwork.RE:FindFirstChild("SetGradeProtected")

-- Trait Remotes (Dynamic Detection for UPD 7 Traits Stall & Remotes)
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

-- Lucky Wheel Remotes
local SpinWheelRE          = SpinService and SpinService:FindFirstChild("RE") and (SpinService.RE:FindFirstChild("Use") or SpinService.RE:FindFirstChild("Spin"))

-- Sell Remotes
local SellInventoryRF      = SellNetwork and SellNetwork:FindFirstChild("RF") and SellNetwork.RF:FindFirstChild("SellInventory")

-- ── 2. FRAMEWORK & MODULE REFERENCES ──────────────────────────────────
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
local BuffController   = nil
pcall(function() BuffController   = require(Features.Buffs.BuffController) end)
pcall(function() TowerController   = require(Features.Towers.TowerController) end)
pcall(function() UIReferences      = require(Features.UI.UIReferences) end)

-- Upgrade Categories
-- ── 2.1 2K SMART BOOSTS & BUFF HELPERS ─────────────────────────────────
local function getAllBoostNames()
    local names = {}
    local nameSet = {}

    -- 1. In-game BoostConfig entries
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

    -- 2. Comprehensive canonical game potions (all worlds & tiers)
    local masterPotions = {
        "Cursed Damage I", "Cursed Damage II", "Cursed Damage III", "Cursed Damage IV",
        "Cursed Income I", "Cursed Income II", "Cursed Income III", "Cursed Income IV",
        "Cursed Luck I", "Cursed Luck II", "Cursed Luck III", "Cursed Luck IV",
        "Damage I", "Damage II", "Damage III", "Damage IV",
        "Dragon Damage I", "Dragon Damage II", "Dragon Damage III", "Dragon Damage IV",
        "Dragon Income I", "Dragon Income II", "Dragon Income III", "Dragon Income IV",
        "Dragon Luck I", "Dragon Luck II", "Dragon Luck III", "Dragon Luck IV",
        "Income I", "Income II", "Income III", "Income IV",
        "Leaf Damage I", "Leaf Damage II", "Leaf Damage III", "Leaf Damage IV",
        "Leaf Income I", "Leaf Income II", "Leaf Income III", "Leaf Income IV",
        "Leaf Luck I", "Leaf Luck II", "Leaf Luck III", "Leaf Luck IV",
        "Luck I", "Luck II", "Luck III", "Luck IV",
        "Pirate Damage I", "Pirate Damage II", "Pirate Damage III", "Pirate Damage IV",
        "Pirate Income I", "Pirate Income II", "Pirate Income III", "Pirate Income IV",
        "Pirate Luck I", "Pirate Luck II", "Pirate Luck III", "Pirate Luck IV",
        "Shadow Damage I", "Shadow Damage II", "Shadow Damage III", "Shadow Damage IV",
        "Shadow Income I", "Shadow Income II", "Shadow Income III", "Shadow Income IV",
        "Shadow Luck I", "Shadow Luck II", "Shadow Luck III", "Shadow Luck IV",
        "Shadow Speed I", "Shadow Speed II", "Shadow Speed III", "Shadow Speed IV",
        "Slayer Damage I", "Slayer Damage II", "Slayer Damage III", "Slayer Damage IV",
        "Slayer Income I", "Slayer Income II", "Slayer Income III", "Slayer Income IV",
        "Slayer Luck I", "Slayer Luck II", "Slayer Luck III", "Slayer Luck IV",
        "Speed I", "Speed II", "Speed III", "Speed IV"
    }
    for _, p in ipairs(masterPotions) do
        if not nameSet[p] then
            nameSet[p] = true
            table.insert(names, p)
        end
    end

    -- 3. Dynamic scan from player's inventory for any newly added/special event items
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if type(inv) == "table" then
            for id, it in pairs(inv) do
                if type(it) == "table" then
                    local iName = it.name or it.Name or it.displayName or it.DisplayName
                    if iName and not nameSet[iName] then
                        local cfg = EntryRegistry and EntryRegistry.getEntryConfig and EntryRegistry.getEntryConfig(iName)
                        if cfg and (cfg.kind == "Boost" or cfg.type == "Boost") then
                            nameSet[iName] = true
                            table.insert(names, iName)
                        end
                    end
                end
            end
        end
    end)

    table.sort(names)
    return names
end

local function getActiveBuffsSummary()
    local activeList = {}
    pcall(function()
        local bb = LP.PlayerGui:FindFirstChild("BuffBar", true)
        if bb then
            for _, child in ipairs(bb:GetChildren()) do
                if child:IsA("GuiObject") and child.Name:sub(1, 6) == "Boost_" then
                    local bName = child.Name:sub(7)
                    local lbl = child:FindFirstChildOfClass("TextLabel")
                    local timer = (lbl and lbl.Text ~= "" and lbl.Text) or "Active"
                    table.insert(activeList, string.format("%s (%s)", bName, timer))
                end
            end
        end
    end)
    if #activeList == 0 then
        pcall(function()
            if BuffController and (BuffController.buffs or BuffController.activeBuffs) then
                local bTable = BuffController.buffs or BuffController.activeBuffs
                if type(bTable) == "table" then
                    for k, v in pairs(bTable) do
                        table.insert(activeList, tostring(k))
                    end
                end
            end
        end)
    end
    if #activeList == 0 then
        return "No active boosts"
    end
    return table.concat(activeList, " • ")
end

-- Sliding window rate calculator
local moneyHistory = {}
local currentMoneyPerSec = 0

local function updateMoneyRate()
    pcall(function()
        local now = os.clock()
        local curMoney = (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Money") and LP.leaderstats.Money.Value) or (DataController and DataController.Money and DataController.Money()) or 0
        table.insert(moneyHistory, { time = now, total = tonumber(curMoney) or 0 })

        while #moneyHistory > 0 and (now - moneyHistory[1].time) > 3.5 do
            table.remove(moneyHistory, 1)
        end

        if #moneyHistory >= 2 then
            local oldest = moneyHistory[1]
            local dt = now - oldest.time
            local dWealth = (tonumber(curMoney) or 0) - oldest.total
            if dt > 0.3 and dWealth >= 0 then
                currentMoneyPerSec = dWealth / dt
            end
        end
    end)
end

local UpgradeCategories = {
    ["Luck & Fortune"]  = {"Luck", "Fortune"},
    ["Roll Speed"]       = {"Roll Speed"},
    ["Money"]           = {"Money"},
    ["Unit Storage"]    = {"Unit Storage"},
    ["Damage"]          = {"Damage"},
    ["Health"]          = {"Health"},
    ["Walkspeed"]       = {"Walkspeed"},
    ["Sell"]            = {"Sell"},
}

local function getCategoryOfKey(key)
    for catName, prefixes in pairs(UpgradeCategories) do
        for _, p in ipairs(prefixes) do
            if key:sub(1, #p) == p then
                return catName
            end
        end
    end
    return "Other"
end

local GradeOrder = {
    ["D"] = 1, ["C"] = 2, ["B"] = 3, ["A"] = 4, ["A+"] = 5,
    ["S"] = 6, ["S+"] = 7, ["Z"] = 8, ["Z+"] = 9, ["神"] = 10
}

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

pcall(function()
    local RS = game:GetService("ReplicatedStorage")
    local TowersMod = (RS:FindFirstChild("Framework") and RS.Framework:FindFirstChild("Features") and RS.Framework.Features:FindFirstChild("Towers") and RS.Framework.Features.Towers:FindFirstChild("Towers"))
        or RS:FindFirstChild("Towers", true)
    if TowersMod and TowersMod:IsA("ModuleScript") then
        local tData = require(TowersMod)
        if type(tData) == "table" then
            local liveList = {}
            for k, v in pairs(tData) do
                if type(k) == "string" and not table.find(liveList, k) then
                    table.insert(liveList, k)
                end
            end
            if #liveList >= 5 then
                table.sort(liveList)
                TowerList = liveList
            end
        end
    end
end)

local AllPotionsList = {
    "Luck IV", "Luck III", "Luck II", "Luck I",
    "Income IV", "Income III", "Income II", "Income I",
    "Damage IV", "Damage III", "Damage II", "Damage I",
    "Shadow Speed IV", "Shadow Speed III", "Shadow Speed II", "Shadow Speed I",
    "Shadow Luck IV", "Shadow Luck III", "Shadow Luck II", "Shadow Luck I",
    "Shadow Income IV", "Shadow Income III", "Shadow Income II", "Shadow Income I",
    "Dragon Luck III", "Dragon Damage III", "Dragon Income III",
    "Slayer Luck III", "Slayer Damage III", "Slayer Income III",
    "Leaf Luck III", "Leaf Damage III", "Leaf Income III",
    "Pirate Luck III", "Pirate Damage III", "Pirate Income III",
    "Cursed Luck III", "Cursed Damage III", "Cursed Income III"
}

-- ── 3. CONFIGURATION & STATE ──────────────────────────────────────────
local Config = {
    -- Anti-AFK
    AntiAFK = false,

    -- Rolling
    AutoRoll = false,
    SkipCutscene = false,
    RollSpeedDelay = 0.05,

    -- Plot & Slots
    AutoFarmPlot = false,
    AutoCollectChest = false,
    AutoEquipBestPlot = false,
    AutoUpgradeSlots = false,
    TargetSlotLevel = 25,

    -- Rebirth & Upgrades
    AutoRebirth = false,
    TargetRebirth = 12,
    AutoUpgrades = false,
    OnlySelectedUpgrades = false,
    SelectedUpgradeCategories = {
        ["Luck & Fortune"] = false,
        ["Roll Speed"] = false,
        ["Money"] = false,
    },
    AutoBuyDice = false,

    -- Auto Sell Units
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

    -- Hyper Burst Roll & Dice Gacha
    BurstRolls = false,
    BurstRollCount = 3,

    -- Grade Reroll Supreme
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

    -- Trait Reroll Supreme (Traits Stall)
    AutoRerollTrait = false,
    TargetTrait = "Godly",
    TraitRollMode = "All Plotted Units",
    TargetTraitUnitKey = "",
    TraitRollDelay = 0.35,

    -- Lucky Wheel Spins
    AutoSpinWheel = false,

    -- Halloween Event Automation
    AutoClaimPumpkinPass = false,
    AutoRollPumpkinDice = false,
    PumpkinDiceRollMode = "Multi (5 Rolls / 500 🎃)",
    PumpkinDiceDelay = 0.35,
    AutoClaimHalloweenQuests = false,
    AutoKnockHalloweenDoors = false,

    -- Quirks Automation
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

    -- Potions & Boosts
    AutoUsePotions = false,
    AutoUseAllOwned = false,
    PotionInterval = 2,
    ItemUseCondition = "กดใช้ทันที / ซ้อนเวลา (Always Use)",
    SelectedCustomPotion = "Luck IV",
    ActivePotions = {
        ["Luck IV"] = false,
        ["Luck III"] = false,
        ["Luck II"] = false,
        ["Luck I"] = false,
        ["Income IV"] = false,
        ["Income III"] = false,
        ["Income II"] = false,
        ["Income I"] = false,
        ["Damage IV"] = false,
        ["Damage III"] = false,
        ["Damage II"] = false,
        ["Damage I"] = false,
        ["Shadow Speed IV"] = false,
        ["Shadow Luck IV"] = false,
        ["Shadow Income IV"] = false,
        ["Dragon Luck III"] = false,
        ["Slayer Luck III"] = false,
    },

    -- Towers & Dungeon Supreme
    AutoTowers                  = false,
    SelectedTower               = TowerList[1],
    TargetTowerFloor            = 200,
    AutoTowerFloorDelay         = 0.15,
    HideTowerScreen             = true,
    AutoCycleTowers             = false,
    AutoUseDamagePotionsInTower = true,
    AutoRetryFailedFloor        = true,
    EndlessInfinityMode         = false,

    -- Free Gifts
    AutoClaimRewards = false,

    -- Movement & Physics Hacks
    WalkSpeedEnabled     = false,
    WalkSpeedValue       = 16,
    JumpPowerEnabled     = false,
    JumpPowerValue       = 50,
    InfiniteJump         = false,
    Noclip               = false,
    FlyEnabled           = false,
    FlySpeed             = 50,
    AutoReconnect        = true,

    -- Visuals & Performance
    FPSBooster           = false,
    FullBright           = false,
    GodAura              = false,
}

local State = {
    TotalRollsSession = 0,
    TotalChestCollected = 0,
    TotalPotionsUsedSession = 0,
    TotalRebirthsSession = 0,
    TotalSoldUnitsSession = 0,
    GradeRerollsSession = 0,
    TraitRerollsSession = 0,
    WheelSpinsSession = 0,
    FloorsClearedSession = 0,
    CurrentTowerStatus = "Standby",
    SlotLevels = {}
}

for i = 1, 24 do State.SlotLevels[i] = 1 end

-- Cleanup previous instance
local myToken = tick()
_G.AnimeDiceActiveToken = myToken

if _G.AnimeDice_Cleanup then
    pcall(_G.AnimeDice_Cleanup)
    task.wait(0.2)
end

local Running = true
_G.AnimeDice_Running = true

_G.AnimeDice_Cleanup = function()
    Running = false
    _G.AnimeDice_Running = false
    pcall(function()
        local h = gethui and gethui() or CoreGui
        for _, g in ipairs(h:GetChildren()) do
            if g.Name == "ProjectBarun_AnimeDice" or g.Name == "BarunHub_Main" or g.Name == "ApexScriptHub" then
                g:Destroy()
            end
        end
        local pg = LP and LP:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetChildren()) do
                if g.Name == "ProjectBarun_AnimeDice" or g.Name == "BarunHub_Main" or g.Name == "ApexScriptHub" then
                    g:Destroy()
                end
            end
        end
    end)
end

-- ── 4. TRIPLE-LAYER ANTI-AFK & ANTI-KICK DEFENSE ENGINE ──────────────
pcall(function()
    -- Layer 1: Destroy Game's custom 19-minute AFK script
    local afkScript = LP.PlayerScripts:FindFirstChild("AFK")
    if afkScript then
        afkScript.Disabled = true
        afkScript:Destroy()
    end
    LP.PlayerScripts.ChildAdded:Connect(function(child)
        if child.Name == "AFK" and child:IsA("LocalScript") then
            child.Disabled = true
            child:Destroy()
        end
    end)
end)

pcall(function()
    -- Layer 2: Disable Idled kick connections & simulate user click on Idle
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

-- Layer 3: Heartbeat Anti-AFK Virtual User Pulse every 35 seconds
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

-- ── 5. CUTSCENE BYPASS & INSTANT ROLL HOOK ───────────────────────────
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

-- Auto-close unwanted Group Rewards popup modal
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if pg then
                for _, gui in ipairs(pg:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Enabled then
                        local n = string.lower(gui.Name)
                        if string.find(n, "group") or string.find(n, "groupreward") then
                            gui.Enabled = false
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- ── 6. MONEY & PLOT AUTOMATION ───────────────────────────────────────
local function CollectAllMoney()
    pcall(function()
        for slotId = 1, 24 do
            if PlotService and PlotService.RE:FindFirstChild("CollectBalance") then
                PlotService.RE.CollectBalance:FireServer(slotId)
            end
        end
    end)

    State.TotalChestCollected = State.TotalChestCollected + 1
end

local function levelUpAllSlots()
    pcall(function()
        local curMoney = (DataController and DataController.Money and DataController.Money())
            or (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Money") and LP.leaderstats.Money.Value)
            or 0
        if curMoney <= 0 then return end

        local targetLvl = tonumber(Config.TargetSlotLevel) or 25
        for slot = 1, 24 do
            local canUpgrade = true
            if DataController and DataController.Slots and UnitUtil then
                local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                if sData and sData.unitId and DataController.Inventory then
                    local unitData = DataController.Inventory[sData.unitId] and DataController.Inventory[sData.unitId]()
                    if unitData then
                        local currentLvl = (unitData.attributes and unitData.attributes.level) or 1
                        if currentLvl >= targetLvl then
                            canUpgrade = false
                        else
                            local price = UnitUtil.GetLevelPrice(unitData.name, unitData.attributes)
                            if not price or curMoney < price then
                                canUpgrade = false
                            end
                        end
                    end
                end
            end

            if canUpgrade and PlotService and PlotService.RE:FindFirstChild("LevelUpSlot") then
                PlotService.RE.LevelUpSlot:FireServer(slot)
                task.wait(0.03)
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

-- Plot Farming Loop
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoFarmPlot then
            if Config.AutoCollectChest then
                CollectAllMoney()
            end
            if Config.AutoEquipBestPlot and PlotService and PlotService.RE:FindFirstChild("EquipBest") then
                pcall(function() PlotService.RE.EquipBest:FireServer() end)
            end
            if Config.AutoUpgradeSlots then
                levelUpAllSlots()
            end
            task.wait(3.0)
        else
            task.wait(0.5)
        end
    end
end)

-- ── 7. REBIRTH & UPGRADES ENGINE (FROM 2K SCRIPT) ─────────────────────
local function checkAndRebirth()
    pcall(function()
        if not RebirthService or not RebirthService:FindFirstChild("RE") or not RebirthService.RE:FindFirstChild("Rebirth") then return end
        local curRebirth = (DataController and DataController.Rebirth and DataController.Rebirth())
            or (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Rebirth") and LP.leaderstats.Rebirth.Value)
            or 0
        local targetRebirth = tonumber(Config.TargetRebirth) or 12
        if curRebirth >= targetRebirth then return end

        local curMoney = (DataController and DataController.Money and DataController.Money())
            or (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Money") and LP.leaderstats.Money.Value)
            or 0

        local canRebirth = false
        if RebirthsModule and RebirthsModule.GetNext then
            local nextData = RebirthsModule.GetNext(curRebirth)
            if nextData and nextData.cost and curMoney >= nextData.cost then
                canRebirth = true
            end
        else
            canRebirth = true
        end

        if canRebirth then
            RebirthService.RE.Rebirth:FireServer()
            State.TotalRebirthsSession = State.TotalRebirthsSession + 1
        end
    end)
end

local function buyPrioritizedUpgrades()
    pcall(function()
        if not UpgradeServiceRE or not UpgradesModule or not TreeStructure or not DataController then return end
        local curMoney = DataController.Money and DataController.Money() or 0
        if curMoney <= 0 then return end

        local unownedAvailable = {}
        for key, data in pairs(UpgradesModule) do
            local isOwned = DataController.Upgrades and DataController.Upgrades[key] and DataController.Upgrades[key]()
            if not isOwned then
                local parent = TreeStructure.GetParent(key)
                local parentUnlocked = (not parent or parent == "Start") or (DataController.Upgrades and DataController.Upgrades[parent] and DataController.Upgrades[parent]())
                if parentUnlocked and data.price and curMoney >= data.price then
                    table.insert(unownedAvailable, {
                        key = key,
                        price = data.price,
                        category = getCategoryOfKey(key)
                    })
                end
            end
        end

        if #unownedAvailable == 0 then return end

        local focusedList = {}
        local otherList = {}

        for _, item in ipairs(unownedAvailable) do
            if Config.SelectedUpgradeCategories[item.category] then
                table.insert(focusedList, item)
            else
                table.insert(otherList, item)
            end
        end

        table.sort(focusedList, function(a, b) return a.price < b.price end)
        table.sort(otherList, function(a, b) return a.price < b.price end)

        for _, item in ipairs(focusedList) do
            if curMoney >= item.price then
                curMoney = curMoney - item.price
                UpgradeServiceRE:FireServer(item.key)
                task.wait(0.12)
            end
        end

        if not Config.OnlySelectedUpgrades then
            for _, item in ipairs(otherList) do
                if curMoney >= item.price then
                    curMoney = curMoney - item.price
                    UpgradeServiceRE:FireServer(item.key)
                    task.wait(0.12)
                end
            end
        end
    end)
end

local function buyAffordableDice()
    pcall(function()
        if not DiceShopService or not DiceShopService:FindFirstChild("RE") or not DiceShopService.RE:FindFirstChild("BuyDice") then return end
        if not DiceModule or not DataController then return end
        local allDice = DiceModule.GetAll and DiceModule.GetAll()
        if not allDice then return end

        local curMoney = DataController.Money and DataController.Money() or 0
        for name, data in pairs(allDice) do
            local isOwned = DataController.OwnedDice and DataController.OwnedDice[name] and DataController.OwnedDice[name]()
            if not isOwned and data.price and data.price <= curMoney then
                DiceShopService.RE.BuyDice:FireServer(name)
                task.wait(0.4)
            end
        end
    end)
end

-- Rebirth & Upgrade Loop
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRebirth then
            checkAndRebirth()
        end
        if Config.AutoUpgrades then
            buyPrioritizedUpgrades()
        end
        if Config.AutoBuyDice then
            buyAffordableDice()
        end
        task.wait(2.5)
    end
end)

-- ── 8. SMART POTIONS ENGINE (2K BULLETPROOF INVENTORY & BUFFBAR RADAR) ─
local function normalizeBoostKey(str)
    local s = string.lower(tostring(str or ""))
    s = string.gsub(s, "[%s_%-]+", "")
    s = string.gsub(s, "iv$", "4")
    s = string.gsub(s, "iii$", "3")
    s = string.gsub(s, "ii$", "2")
    s = string.gsub(s, "i$", "1")
    return s
end

local function isBoostActive(boostName)
    if not boostName or boostName == "" then return false end
    local active = false

    -- 1. Query BuffController (Flamework Buff controller)
    pcall(function()
        if BuffController then
            if BuffController.GetBuff then
                local b = BuffController:GetBuff(boostName) or BuffController.GetBuff(boostName)
                if b then active = true return end
            end
            local bTable = BuffController.buffs or BuffController.activeBuffs
            if type(bTable) == "table" then
                if bTable[boostName] or bTable["Boost_" .. boostName] then
                    active = true
                    return
                end
                local targetNorm = normalizeBoostKey(boostName)
                for k, _ in pairs(bTable) do
                    if normalizeBoostKey(k) == targetNorm then
                        active = true
                        return
                    end
                end
            end
        end
    end)
    if active then return true end

    -- 2. Query BuffBar GUI in PlayerGui
    pcall(function()
        local bb = LP.PlayerGui:FindFirstChild("BuffBar", true)
        if bb then
            -- Exact direct match
            if bb:FindFirstChild("Boost_" .. boostName) or bb:FindFirstChild(boostName) then
                active = true
                return
            end

            local targetNorm = normalizeBoostKey(boostName)
            for _, child in ipairs(bb:GetChildren()) do
                if child:IsA("GuiObject") then
                    local cNorm = normalizeBoostKey(child.Name)
                    if cNorm == "boost" .. targetNorm or cNorm == targetNorm then
                        active = true
                        return
                    end

                    local attr = child:GetAttribute("BoostName") or child:GetAttribute("Name") or child:GetAttribute("Buff")
                    if attr and normalizeBoostKey(attr) == targetNorm then
                        active = true
                        return
                    end

                    for _, desc in ipairs(child:GetDescendants()) do
                        if desc:IsA("TextLabel") and desc.Text ~= "" then
                            local tNorm = normalizeBoostKey(desc.Text)
                            if string.find(tNorm, targetNorm, 1, true) then
                                active = true
                                return
                            end
                        end
                    end
                end
            end
        end
    end)

    return active
end

local function resolveInventoryItem(inv, targetName)
    if not targetName or targetName == "" then return nil, nil, 0 end

    -- 1. EntryController:GetAmount check
    local ecAmount = 0
    pcall(function()
        if EntryController and EntryController.GetAmount then
            local a = EntryController:GetAmount(targetName) or EntryController.GetAmount(targetName)
            if a and tonumber(a) then
                ecAmount = tonumber(a)
            end
        end
    end)

    if not inv or type(inv) ~= "table" then
        pcall(function()
            inv = DataController and DataController.Inventory and DataController.Inventory()
        end)
    end

    if type(inv) == "table" then
        -- 2. Direct key lookup
        if inv[targetName] and type(inv[targetName]) == "table" then
            local it = inv[targetName]
            local amt = tonumber(it.amount) or (tonumber(it.Count) or (tonumber(it.quantity) or ecAmount))
            return targetName, it, (amt > 0 and amt or (ecAmount > 0 and ecAmount or 1))
        end

        -- 3. Exact matching on item.name / item.id / slot id
        for id, item in pairs(inv) do
            if type(item) == "table" then
                local iName = item.name or item.Name or item.displayName or item.DisplayName
                local iId = item.id or item.Id or id
                if iName == targetName or tostring(iId) == targetName or tostring(id) == targetName then
                    local amt = tonumber(item.amount) or (tonumber(item.Count) or (tonumber(item.quantity) or ecAmount))
                    return id, item, (amt > 0 and amt or (ecAmount > 0 and ecAmount or 1))
                end
            end
        end

        -- 4. Normalized fuzzy match (roman numerals, casing, underscores)
        local targetNorm = normalizeBoostKey(targetName)
        for id, item in pairs(inv) do
            if type(item) == "table" then
                local iName = item.name or item.Name or item.displayName or item.DisplayName or ""
                local iId = item.id or item.Id or id or ""
                if normalizeBoostKey(iName) == targetNorm or normalizeBoostKey(iId) == targetNorm or normalizeBoostKey(id) == targetNorm then
                    local amt = tonumber(item.amount) or (tonumber(item.Count) or (tonumber(item.quantity) or ecAmount))
                    return id, item, (amt > 0 and amt or (ecAmount > 0 and ecAmount or 1))
                end
            end
        end
    end

    if ecAmount > 0 then
        return targetName, { name = targetName, amount = ecAmount }, ecAmount
    end

    return nil, nil, 0
end

local function UsePotion(potionName, itemId)
    if not potionName and not itemId then return false end
    local success = false
    local targetName = potionName or itemId

    -- Try BoostController.UseBoost with potion name
    pcall(function()
        if BoostController and BoostController.UseBoost then
            BoostController.UseBoost(targetName)
            success = true
        end
    end)

    -- If failed or not present, try direct remote event
    if not success then
        pcall(function()
            if BoostUseRE then
                BoostUseRE:FireServer(targetName)
                success = true
            end
        end)
    end

    -- If item ID is different, also try invoking with itemId
    if not success and itemId and itemId ~= targetName then
        pcall(function()
            if BoostController and BoostController.UseBoost then
                BoostController.UseBoost(itemId)
                success = true
            elseif BoostUseRE then
                BoostUseRE:FireServer(itemId)
                success = true
            end
        end)
    end

    -- Dynamic fallback remote search
    if not success then
        pcall(function()
            local bNet = Network and (Network:FindFirstChild("BoostService") or Network:FindFirstChild("Boosts"))
            local re = bNet and bNet:FindFirstChild("RE") and bNet.RE:FindFirstChild("Use")
            if re then
                re:FireServer(targetName)
                success = true
            end
        end)
    end

    if success then
        State.TotalPotionsUsedSession = State.TotalPotionsUsedSession + 1
    end
    return success
end

local function selectOwnedPotions()
    local count = 0
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if type(inv) ~= "table" then return end

        local allNames = getAllBoostNames()
        local allSet = {}
        for _, n in ipairs(allNames) do
            allSet[n] = n
            allSet[normalizeBoostKey(n)] = n
        end

        for id, item in pairs(inv) do
            if type(item) == "table" then
                local amt = tonumber(item.amount) or (tonumber(item.Count) or (tonumber(item.quantity) or 0))
                if amt > 0 then
                    local iName = item.name or item.Name or item.displayName or item.DisplayName
                    local matched = nil

                    if iName and allSet[iName] then
                        matched = allSet[iName]
                    elseif iName then
                        matched = allSet[normalizeBoostKey(iName)]
                    end

                    if not matched and iName and EntryRegistry and EntryRegistry.getEntryConfig then
                        local cfg = EntryRegistry.getEntryConfig(iName)
                        if cfg and (cfg.kind == "Boost" or cfg.type == "Boost") then
                            matched = iName
                        end
                    end

                    if matched then
                        Config.ActivePotions[matched] = true
                        count = count + 1
                    end
                end
            end
        end
    end)
    return count
end

local function isBoostItem(item, name)
    if not item and not name then return false end
    if item and type(item) == "table" then
        if item.kind == "Boost" or item.type == "Boost" or item.category == "Boost" then
            return true
        end
    end
    local targetName = name or (item and (item.name or item.Name or item.displayName or item.DisplayName))
    if not targetName then return false end
    if EntryRegistry and EntryRegistry.getEntryConfig then
        local cfg = EntryRegistry.getEntryConfig(targetName)
        if cfg and (cfg.kind == "Boost" or cfg.type == "Boost") then
            return true
        end
    end
    if BoostConfig and BoostConfig.entries and BoostConfig.entries[targetName] then
        return true
    end
    local norm = normalizeBoostKey(targetName)
    local all = getAllBoostNames()
    for _, b in ipairs(all) do
        if normalizeBoostKey(b) == norm then
            return true
        end
    end
    return false
end

local function useAllOwnedPotionsNow()
    local count = 0
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if type(inv) ~= "table" then return end
        for id, item in pairs(inv) do
            if type(item) == "table" then
                local amt = tonumber(item.amount) or (tonumber(item.Count) or (tonumber(item.quantity) or 0))
                if amt > 0 then
                    local iName = item.name or item.Name or item.displayName or item.DisplayName
                    if iName and isBoostItem(item, iName) then
                        local ok = UsePotion(iName, id)
                        if ok then
                            count = count + 1
                            task.wait(0.12)
                        end
                    end
                end
            end
        end
    end)
    return count
end

local function useSelectedItemsNow()
    local count = 0
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        for itemName, isSelected in pairs(Config.ActivePotions) do
            if isSelected then
                local id, itemData, amount = resolveInventoryItem(inv, itemName)
                if amount > 0 then
                    local ok = UsePotion(itemName, id)
                    if ok then
                        count = count + 1
                        task.wait(0.12)
                    end
                end
            end
        end
    end)
    return count
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoUsePotions or Config.AutoUseAllOwned then
            pcall(function()
                local inv = DataController and DataController.Inventory and DataController.Inventory()
                if type(inv) ~= "table" then return end

                local condition = tostring(Config.ItemUseCondition or "")
                local isAlways = (condition == "Always")
                    or string.find(condition, "Always", 1, true) ~= nil
                    or string.find(condition, "ซ้อนเวลา", 1, true) ~= nil
                    or Config.AutoUseAllOwned

                if Config.AutoUseAllOwned then
                    -- Mode 1: Instant Auto Use for ANY potion present in inventory
                    for id, item in pairs(inv) do
                        if type(item) == "table" and Running and _G.AnimeDiceActiveToken == myToken then
                            local amt = tonumber(item.amount) or (tonumber(item.Count) or (tonumber(item.quantity) or 0))
                            if amt > 0 then
                                local iName = item.name or item.Name or item.displayName or item.DisplayName
                                if iName and isBoostItem(item, iName) then
                                    local shouldConsume = false
                                    if isAlways then
                                        shouldConsume = true
                                    else
                                        if not isBoostActive(iName) then
                                            shouldConsume = true
                                        end
                                    end

                                    if shouldConsume then
                                        UsePotion(iName, id)
                                        task.wait(0.12)
                                    end
                                end
                            end
                        end
                    end
                else
                    -- Mode 2: Auto Use only specifically selected potions
                    for potionName, enabled in pairs(Config.ActivePotions) do
                        if enabled and Running and _G.AnimeDiceActiveToken == myToken then
                            local id, itemData, amount = resolveInventoryItem(inv, potionName)
                            if amount > 0 then
                                local shouldConsume = false
                                if isAlways then
                                    shouldConsume = true
                                else
                                    if not isBoostActive(potionName) then
                                        shouldConsume = true
                                    end
                                end

                                if shouldConsume then
                                    UsePotion(potionName, id)
                                    task.wait(0.15)
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(math.max(1, Config.PotionInterval))
        else
            task.wait(1)
        end
    end
end)

-- ── 9. AUTO SELL UNITS ENGINE ─────────────────────────────────────────
local function sellSelectedUnits()
    local soldCount = 0
    pcall(function()
        if not SellInventoryRF or not DataController or not DataController.Inventory then return end
        local inv = DataController.Inventory()
        if type(inv) ~= "table" then return end

        local plotted = {}
        if DataController.Slots then
            for slot = 1, 24 do
                local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                if sData and sData.unitId then
                    plotted[sData.unitId] = true
                end
            end
        end

        local towerTeam = {}
        if DataController.TowerTeam then
            local tt = DataController.TowerTeam()
            if type(tt) == "table" then
                for _, uid in pairs(tt) do
                    if type(uid) == "string" then towerTeam[uid] = true end
                end
            end
        end

        local toSell = {}
        for id, unit in pairs(inv) do
            if type(unit) == "table" and unit.name and unit.attributes then
                local isPlotted = plotted[id] == true
                local isTower   = towerTeam[id] == true
                local isLocked  = unit.attributes and unit.attributes.locked == true

                local canSell = true
                if Config.ProtectPlottedUnits and (isPlotted or isTower) then canSell = false end
                if Config.ProtectLockedUnits and isLocked then canSell = false end
                if Config.ProtectGradeSPlus and unit.attributes and unit.attributes.grade then
                    local gOrder = GradeOrder[unit.attributes.grade] or 0
                    if gOrder >= 6 then canSell = false end
                end

                if canSell and EntryRegistry and EntryRegistry.getEntryConfig then
                    local cfg = EntryRegistry.getEntryConfig(unit.name)
                    local rarity = (cfg and cfg.rarity) or "Common"
                    if Config.SelectedSellRarities[rarity] then
                        table.insert(toSell, id)
                        if #toSell >= 50 then break end
                    end
                end
            end
        end

        if #toSell > 0 then
            local res1, res2 = SellInventoryRF:InvokeServer(toSell)
            soldCount = res2 or #toSell
            State.TotalSoldUnitsSession = State.TotalSoldUnitsSession + soldCount
        end
    end)
    return soldCount
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoSellUnits then
            sellSelectedUnits()
            task.wait(4)
        else
            task.wait(1)
        end
    end
end)

-- ── 10. GACHA & REROLL SUPREME LOGIC ENGINE ───────────────────────────
local function getInventoryUnitOptions()
    local opts = {}
    local map = {}
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if not inv then return end
        for id, item in pairs(inv) do
            local itemData = type(item) == "function" and item() or item
            if type(itemData) == "table" and itemData.name then
                local isUnit = false
                if EntryRegistry and EntryRegistry.getEntryConfig then
                    local cfg = EntryRegistry.getEntryConfig(itemData.name)
                    if cfg and (cfg.kind == "Unit" or cfg.type == "Unit") then
                        isUnit = true
                    end
                elseif itemData.attributes and (itemData.attributes.grade or itemData.attributes.level) then
                    isUnit = true
                end

                if isUnit then
                    local grade = (itemData.attributes and itemData.attributes.grade) or "D"
                    local lvl = (itemData.attributes and itemData.attributes.level) or 1
                    local rawTrait = (itemData.attributes and (itemData.attributes.trait or itemData.attributes.traits)) or "None"
                    local traitStr = type(rawTrait) == "table" and (rawTrait[1] or "None") or tostring(rawTrait)
                    local label = string.format("%s [Lv.%s | %s | %s] (ID: %s)", itemData.name, tostring(lvl), grade, traitStr, string.sub(tostring(id), 1, 8))
                    table.insert(opts, label)
                    map[label] = tostring(id)
                end
            end
        end
    end)
    if #opts == 0 then
        table.insert(opts, "ไม่พบตัวละครในคลัง")
    end
    table.sort(opts)
    return opts, map
end

local function getUnitsForGradeReroll()
    local unitList = {}
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if not inv then return end

        if Config.GradeRollMode == "All Plotted Units" then
            if DataController.Slots then
                for slot = 1, 24 do
                    local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                    if sData and sData.unitId and inv[sData.unitId] then
                        local u = inv[sData.unitId]
                        local uData = type(u) == "function" and u() or u
                        if uData and uData.attributes then
                            local g = uData.attributes.grade or "D"
                            table.insert(unitList, {
                                id = sData.unitId,
                                name = uData.name or ("Slot " .. tostring(slot)),
                                grade = g,
                                slot = slot
                            })
                        end
                    end
                end
            end
        elseif Config.GradeRollMode == "Tower Team Units" then
            if DataController.TowerTeam then
                local tt = DataController.TowerTeam()
                if type(tt) == "table" then
                    for _, uId in pairs(tt) do
                        if uId and inv[uId] then
                            local u = inv[uId]
                            local uData = type(u) == "function" and u() or u
                            if uData and uData.attributes then
                                local g = uData.attributes.grade or "D"
                                table.insert(unitList, {
                                    id = uId,
                                    name = uData.name or "Tower Unit",
                                    grade = g
                                })
                            end
                        end
                    end
                end
            end
        else -- "Selected Unit"
            local uId = Config.TargetGradeUnitKey
            if uId and uId ~= "" and inv[uId] then
                local u = inv[uId]
                local uData = type(u) == "function" and u() or u
                if uData and uData.attributes then
                    local g = uData.attributes.grade or "D"
                    table.insert(unitList, {
                        id = uId,
                        name = uData.name or "Selected Unit",
                        grade = g
                    })
                end
            end
        end
    end)
    return unitList
end

local function executeGradeRerollStep()
    if not RollGradeRE then return false end
    local units = getUnitsForGradeReroll()
    if #units == 0 then return false end

    local targetOrder = GradeOrder[Config.TargetGrade] or 7
    for _, entry in ipairs(units) do
        local curOrder = GradeOrder[entry.grade] or 1
        if curOrder < targetOrder then
            local ok = pcall(function()
                RollGradeRE:FireServer(entry.id, true)
            end)
            if ok then
                State.GradeRerollsSession = (State.GradeRerollsSession or 0) + 1
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRerollGrade then
            local didRoll = executeGradeRerollStep()
            task.wait(didRoll and (Config.GradeRollDelay or 0.25) or 0.75)
        else
            task.wait(1)
        end
    end
end)

local function getUnitsForTraitReroll()
    local unitList = {}
    pcall(function()
        local inv = DataController and DataController.Inventory and DataController.Inventory()
        if not inv then return end

        if Config.TraitRollMode == "All Plotted Units" then
            if DataController.Slots then
                for slot = 1, 24 do
                    local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                    if sData and sData.unitId and inv[sData.unitId] then
                        local u = inv[sData.unitId]
                        local uData = type(u) == "function" and u() or u
                        if uData and uData.attributes then
                            local tr = uData.attributes.trait or uData.attributes.traits or "None"
                            if type(tr) == "table" then tr = tr[1] or "None" end
                            table.insert(unitList, {
                                id = sData.unitId,
                                name = uData.name or ("Slot " .. tostring(slot)),
                                trait = tostring(tr),
                                slot = slot
                            })
                        end
                    end
                end
            end
        elseif Config.TraitRollMode == "Tower Team Units" then
            if DataController.TowerTeam then
                local tt = DataController.TowerTeam()
                if type(tt) == "table" then
                    for _, uId in pairs(tt) do
                        if uId and inv[uId] then
                            local u = inv[uId]
                            local uData = type(u) == "function" and u() or u
                            if uData and uData.attributes then
                                local tr = uData.attributes.trait or uData.attributes.traits or "None"
                                if type(tr) == "table" then tr = tr[1] or "None" end
                                table.insert(unitList, {
                                    id = uId,
                                    name = uData.name or "Tower Unit",
                                    trait = tostring(tr)
                                })
                            end
                        end
                    end
                end
            end
        else -- "Selected Unit"
            local uId = Config.TargetTraitUnitKey
            if uId and uId ~= "" and inv[uId] then
                local u = inv[uId]
                local uData = type(u) == "function" and u() or u
                if uData and uData.attributes then
                    local tr = uData.attributes.trait or uData.attributes.traits or "None"
                    if type(tr) == "table" then tr = tr[1] or "None" end
                    table.insert(unitList, {
                        id = uId,
                        name = uData.name or "Selected Unit",
                        trait = tostring(tr)
                    })
                end
            end
        end
    end)
    return unitList
end

local function executeTraitRerollStep()
    local remote, isRF = resolveTraitRemote()
    if not remote then return false end

    local units = getUnitsForTraitReroll()
    if #units == 0 then return false end

    local target = Config.TargetTrait or "Godly"
    for _, entry in ipairs(units) do
        local cur = entry.trait:lower()
        local isMatch = false
        if target == "Any Top Tier" then
            local topTraits = {"godly", "overpowered", "celestial", "cosmic", "shiny"}
            for _, t in ipairs(topTraits) do
                if cur:find(t) then isMatch = true break end
            end
        else
            if cur:find(target:lower()) then
                isMatch = true
            end
        end

        if not isMatch then
            local ok = pcall(function()
                if isRF then
                    remote:InvokeServer(entry.id)
                else
                    remote:FireServer(entry.id)
                end
            end)
            if ok then
                State.TraitRerollsSession = (State.TraitRerollsSession or 0) + 1
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRerollTrait then
            local didRoll = executeTraitRerollStep()
            task.wait(didRoll and (Config.TraitRollDelay or 0.35) or 1.0)
        else
            task.wait(1)
        end
    end
end)

-- ── 10.1 AUTO LUCKY WHEEL SPIN ENGINE ─────────────────────────────────
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoSpinWheel and SpinWheelRE then
            pcall(function()
                SpinWheelRE:FireServer()
                State.WheelSpinsSession = (State.WheelSpinsSession or 0) + 1
            end)
            task.wait(8)
        else
            task.wait(2)
        end
    end
end)

-- ── 11. AUTO ROLL ENGINE (2K DYNAMIC BUFF DURATION SYNC & HYPER BURST) ─
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRoll and RollService and RollService:FindFirstChild("RF") and RollService.RF:FindFirstChild("RollDice") then
            local duration = Config.RollSpeedDelay or 0.05
            pcall(function()
                if BuffController and BuffController.GetBuff then
                    local d = BuffController.GetBuff("Roll Duration")
                    if type(d) == "number" and d > 0 then
                        duration = math.min(duration, d)
                    end
                end
            end)

            local burstCount = Config.BurstRolls and math.clamp(tonumber(Config.BurstRollCount) or 3, 1, 5) or 1
            if burstCount > 1 then
                for b = 1, burstCount do
                    task.spawn(function()
                        pcall(function() RollService.RF.RollDice:InvokeServer() end)
                    end)
                end
            else
                pcall(function() RollService.RF.RollDice:InvokeServer() end)
            end
            State.TotalRollsSession = State.TotalRollsSession + burstCount
            task.wait(math.max(duration, 0.1))
        else
            task.wait(0.3)
        end
    end
end)

-- ── 12. AUTO TOWERS & DUNGEON SUPREME ENGINE ────────────────────────────
local towerCycleIndex = 1
local TowerMaxFloors = {
    ["Dragon Tower"]      = 100,
    ["Cursed Tower"]      = 100,
    ["Pirate Tower"]      = 100,
    ["Hidden Leaf Tower"] = 100,
    ["Leaf Tower"]        = 100,
    ["Slayer Tower"]      = 100,
    ["Shadow Tower"]      = 150,
    ["Infinity Tower"]    = 200, -- สูงสุด 200 ชั้นตามสั่ง (อินลง 200)
}

-- ── 12.1 LEGITIMATE 10X COMBAT ACCELERATOR & TOWER ENGINE ─────────────
-- Patches internal action wait times to 0.05s so legitimate battle runs 10x faster
-- while ensuring 100% real server rewards, XP, drops, and floor completion.
local function speedUpTowerCombat()
    pcall(function()
        if TowerController and TowerController.startTower then
            local uvs = debug.getupvalues(TowerController.startTower)
            local uv4 = uvs and uvs[4]
            if uv4 and uv4.ActionWaitTime then
                uv4.ActionWaitTime.damageEnemy = 0.15
                uv4.ActionWaitTime.damagePlayer = 0.15
                uv4.ActionWaitTime.floorStarted = 0.12
                uv4.ActionWaitTime.floorCompleted = 0.12
            end
        end
    end)
end

speedUpTowerCombat()

local function getTowerElements()
    local screen = nil
    local hidden = nil
    if UIReferences and UIReferences.Root and UIReferences.Root:FindFirstChild("Tower") then
        local t = UIReferences.Root.Tower
        screen = t:FindFirstChild("Screen")
        hidden = t:FindFirstChild("Hidden")
    end
    if not screen and LP and LP:FindFirstChild("PlayerGui") then
        local root = LP.PlayerGui:FindFirstChild("Root")
        local t = root and root:FindFirstChild("Tower")
        if t then
            screen = t:FindFirstChild("Screen")
            hidden = t:FindFirstChild("Hidden")
        end
    end
    return screen, hidden
end

local function isPlayerInTower()
    local screen, hidden = getTowerElements()
    return (screen and screen.Visible == true) or (hidden and hidden.Visible == true) or false
end

local function getRealTowerFloor()
    local screen, hidden = getTowerElements()
    local fText = (screen and screen:FindFirstChild("Floor") and screen.Floor.Text)
        or (hidden and hidden:FindFirstChild("Floor", true) and hidden:FindFirstChild("Floor", true).Text)
    if fText then
        local num = fText:match("%d+")
        if num then return tonumber(num) or 1, fText end
    end
    return 1, "Floor 1"
end

local function activateInGameAutoButton()
    local screen, _ = getTowerElements()
    local autoBtn = screen and screen:FindFirstChild("Buttons") and screen.Buttons:FindFirstChild("Auto")
    if autoBtn and getconnections then
        local conns = getconnections(autoBtn.Activated)
        if conns and #conns > 0 then
            local autoFunc = conns[1].Function
            local isAutoOn = autoFunc and debug.getupvalues and debug.getupvalues(autoFunc)[1]
            if isAutoOn == false then
                pcall(function() conns[1]:Fire() end)
            end
        end
    end
    if autoBtn and firesignal then
        local grad = autoBtn:FindFirstChildOfClass("UIGradient")
        local isGreen = grad and tostring(grad.Color):find("0.298")
        if not isGreen then
            pcall(function() firesignal(autoBtn.Activated) end)
        end
    end
    if TowersNet and TowersNet:FindFirstChild("RE") and TowersNet.RE:FindFirstChild("SetAutoTower") then
        pcall(function() TowersNet.RE.SetAutoTower:FireServer(true) end)
    end
end

local function startTowerLegit(towerName)
    if isPlayerInTower() then return true end

    -- 1. Equip best team first
    if EquipBestTowerTeamRE then
        pcall(function() EquipBestTowerTeamRE:FireServer() end)
        task.wait(0.25)
    end

    -- 2. Ensure combat accelerator is patched
    speedUpTowerCombat()

    -- 3. Enter selected tower
    local started = false
    if TowerController and TowerController.startTower then
        pcall(function() started = TowerController.startTower(towerName) end)
    end
    if not started and PlayTowerRF then
        pcall(function() PlayTowerRF:InvokeServer(towerName) end)
    end

    -- 4. Poll for entry (ping-resilient up to 2.5s)
    for i = 1, 12 do
        if isPlayerInTower() then
            return true
        end
        task.wait(0.2)
    end

    -- 5. Fallback variations if first attempt didn't connect
    local variations = {}
    if towerName == "Hidden Leaf Tower" then table.insert(variations, "Leaf Tower") end
    if towerName == "Leaf Tower" then table.insert(variations, "Hidden Leaf Tower") end
    if towerName == "Slayer Tower" then table.insert(variations, "Demon Slayer Tower") end
    if towerName == "Shadow Tower" then table.insert(variations, "Solo Tower") end

    for _, altName in ipairs(variations) do
        if TowerController and TowerController.startTower then
            pcall(function() TowerController.startTower(altName) end)
        end
        if PlayTowerRF then
            pcall(function() PlayTowerRF:InvokeServer(altName) end)
        end
        for i = 1, 8 do
            if isPlayerInTower() then
                return true
            end
            task.wait(0.2)
        end
    end

    return isPlayerInTower()
end

local function instantClearCurrentFloor()
    if not TowersNet then return false end
    local currentFloor = getRealTowerFloor()
    if CompleteTowerFloorRF then
        local ok = pcall(function() return CompleteTowerFloorRF:InvokeServer(currentFloor) end)
        return ok
    end
    return false
end

-- ── 12.2 REAL COMBAT AUTO TOWER ENGINE (100% SERVER REWARDS & LOOT) ──
local lastSeenFloor = 0
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoTowers and TowersNet then
            pcall(function()
                local inTower = isPlayerInTower()

                if inTower then
                    -- ── STATE A: INSIDE TOWER (ACTIVE REAL COMBAT) ──
                    -- 1. Ensure in-game Auto button is active (Green)
                    activateInGameAutoButton()

                    -- 2. Read REAL in-game floor
                    local curFloor, floorString = getRealTowerFloor()
                    if curFloor > lastSeenFloor then
                        State.FloorsClearedSession = State.FloorsClearedSession + (curFloor - lastSeenFloor)
                        lastSeenFloor = curFloor
                    end

                    local towerName = Config.SelectedTower or "Dragon Tower"
                    local targetMax = TowerMaxFloors[towerName] or (towerName == "Infinity Tower" and 200 or 100)

                    State.CurrentTowerStatus = string.format("[%s] %s / Max %d (ได้รับของดรอปจริง!)", towerName, floorString, targetMax)

                    -- 3. Check target floor limit (Auto Preset: Infinity 200, Others 100/150)
                    if curFloor >= targetMax then
                        State.CurrentTowerStatus = string.format("[%s] ครบ %d ชั้นตามพรีเซ็ต! จบและรับของรางวัล...", towerName, curFloor)
                        if CancelTowerRF then
                            pcall(function() CancelTowerRF:InvokeServer() end)
                        end
                        if Config.AutoCycleTowers == true then
                            towerCycleIndex = towerCycleIndex + 1
                        end
                        task.wait(2.0)
                    end

                    -- 4. Screen visibility control (minimize if HideTowerScreen enabled)
                    local screen, hidden = getTowerElements()
                    if (Config.HideTowerScreen or true) and screen and screen.Visible and hidden and firesignal then
                        pcall(function() firesignal(hidden.Activated) end)
                    end

                    task.wait(0.4)
                else
                    -- ── STATE B: OUTSIDE TOWER (EQUIP & ENTER REAL TOWER) ──
                    lastSeenFloor = 0
                    local towerName = Config.SelectedTower or "Dragon Tower"
                    if Config.AutoCycleTowers == true then
                        towerName = TowerList[((towerCycleIndex - 1) % #TowerList) + 1]
                    end

                    State.CurrentTowerStatus = string.format("[%s] กำลังเข้าหอคอย...", tostring(towerName))

                    if Config.AutoUseDamagePotionsInTower then
                        UsePotion("Damage IV")
                        UsePotion("Damage III")
                        UsePotion("Luck IV")
                    end

                    local started = startTowerLegit(towerName)
                    if started or isPlayerInTower() then
                        State.CurrentTowerStatus = string.format("[%s] เข้าสู่หอคอยสำเร็จ!", tostring(towerName))
                        task.wait(1.0)
                        activateInGameAutoButton()
                    else
                        State.CurrentTowerStatus = string.format("[%s] กำลังรอคิว / เตรียมเข้าใหม่...", tostring(towerName))
                        task.wait(2.0)
                    end
                end
            end)
        else
            State.CurrentTowerStatus = "Standby"
            task.wait(1.0)
        end
    end
end)

-- ── 13. AUTO CLAIM REWARDS (SAFE ISINGROUP CHECK) ─────────────────────
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

        -- Safe Group check (Only fire if in group and haven't claimed)
        if GroupRewardConfig and GroupRewardConfig.GroupId and GroupRewardService then
            local inGroup = false
            pcall(function() inGroup = LP:IsInGroup(GroupRewardConfig.GroupId) end)
            if inGroup and DataController and DataController.ClaimedGroupReward and not DataController.ClaimedGroupReward() then
                GroupRewardService.RE.Claim:FireServer()
            end
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

-- ── 13.5. HALLOWEEN & QUIRKS AUTOMATION ENGINES ───────────────────────
-- Pumpkin Pass Auto-Claim Loop
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoClaimPumpkinPass then
            pcall(function()
                if PumpkinPassClaimAllRE then
                    PumpkinPassClaimAllRE:FireServer()
                end
            end)
            task.wait(10)
        else
            task.wait(2)
        end
    end
end)

-- Halloween Quests Auto-Claim Loop (Daily & Hourly)
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoClaimHalloweenQuests then
            pcall(function()
                if HalloweenQuestClaimRE then
                    for id = 1, 6 do
                        HalloweenQuestClaimRE:FireServer("Daily", id)
                        task.wait(0.05)
                    end
                    for id = 1, 5 do
                        HalloweenQuestClaimRE:FireServer("Hourly", id)
                        task.wait(0.05)
                    end
                end
            end)
            task.wait(15)
        else
            task.wait(3)
        end
    end
end)

-- Pumpkin Dice Auto-Roll Loop
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoRollPumpkinDice then
            pcall(function()
                if PumpkinDiceRollRF then
                    local amount = (Config.PumpkinDiceRollMode and (Config.PumpkinDiceRollMode:find("Single") or Config.PumpkinDiceRollMode == "1")) and 1 or 5
                    PumpkinDiceRollRF:InvokeServer(amount)
                end
            end)
            task.wait(tonumber(Config.PumpkinDiceDelay) or 0.35)
        else
            task.wait(0.5)
        end
    end
end)

-- Trick-or-Treat Door Knocker Loop
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        if Config.AutoKnockHalloweenDoors then
            pcall(function()
                local halloweenFolder = workspace:FindFirstChild("Halloween")
                if halloweenFolder and TrickDoorKnockedRE then
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

-- Quirks Auto-Reroll Loop
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

-- ═════════════════════════════════════════════════════════════════════
-- 14. BUILD UI INTERFACE (STANDARD 5-PILLAR ARCHITECTURE)
-- ═════════════════════════════════════════════════════════════════════

-- ═════════════════════════════════════════════════════════════════════
-- 15. 2K BULLETPROOF CONFIGURATION ENGINE (ROOT FILE NO-FOLDER SAFE)
-- ═════════════════════════════════════════════════════════════════════
local Window = nil
local UIHandles = {}

local DefaultCleanConfig = {
    AntiAFK = false,
    AutoRoll = false,
    SkipCutscene = false,
    RollSpeedDelay = 0.05,
    AutoFarmPlot = false,
    AutoCollectChest = false,
    AutoEquipBestPlot = false,
    AutoUpgradeSlots = false,
    TargetSlotLevel = 25,
    AutoRebirth = false,
    TargetRebirth = 12,
    AutoUpgrades = false,
    OnlySelectedUpgrades = false,
    SelectedUpgradeCategories = {
        ["Luck & Fortune"] = false,
        ["Roll Speed"] = false,
        ["Money"] = false,
    },
    AutoBuyDice = false,
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
    BurstRolls = false,
    BurstRollCount = 3,
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
    AutoRerollTrait = false,
    TargetTrait = "Godly",
    TraitRollMode = "All Plotted Units",
    TargetTraitUnitKey = "",
    TraitRollDelay = 0.35,
    AutoSpinWheel = false,
    AutoUsePotions = false,
    AutoUseAllOwned = false,
    PotionInterval = 2,
    ItemUseCondition = "กดใช้ทันที / ซ้อนเวลา (Always Use)",
    SelectedCustomPotion = "Luck IV",
    ActivePotions = {
        ["Luck IV"] = false,
        ["Luck III"] = false,
        ["Luck II"] = false,
        ["Luck I"] = false,
        ["Income IV"] = false,
        ["Income III"] = false,
        ["Income II"] = false,
        ["Income I"] = false,
        ["Damage IV"] = false,
        ["Damage III"] = false,
        ["Damage II"] = false,
        ["Damage I"] = false,
    },
    AutoTowers = false,
    SelectedTower = TowerList[1],
    TargetTowerFloor = 200,
    AutoTowerFloorDelay = 0.35,
    HideTowerScreen = false,
    AutoClaimRewards = false
}

local CONFIG_FILE = "PB_AnimeDice_Config.json"
local saveDebounce = false

local function getCleanConfigFilename(profileName)
    if profileName and profileName ~= "" and profileName ~= "default" then
        local sanitized = profileName:gsub("[^%w_%-]", "")
        if sanitized ~= "" then
            return "PB_AnimeDice_" .. sanitized .. ".json"
        end
    end
    return CONFIG_FILE
end

local function saveConfig(profileName, silent)
    if not writefile then
        if not silent and Window and Window.Notify then
            Window:Notify({ Title = "PB Config", Content = "Executor ไม่รองรับ writefile", Type = "error" })
        end
        return false
    end

    local fileName = getCleanConfigFilename(profileName)
    local clean = {}
    for k, v in pairs(Config) do
        local t = type(v)
        if t == "boolean" or t == "number" or t == "string" then
            clean[k] = v
        elseif t == "table" then
            local subClean = {}
            for subK, subV in pairs(v) do
                local st = type(subV)
                if st == "boolean" or st == "number" or st == "string" then
                    subClean[subK] = subV
                end
            end
            clean[k] = subClean
        end
    end

    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(clean)
    end)
    if not ok or not encoded then
        if not silent then
            pcall(function()
                if Window and Window.Notify then
                    Window:Notify({ Title = "PB Config", Content = "JSON Encode: " .. tostring(encoded), Type = "error" })
                end
            end)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "PB Config Error",
                    Text = "JSON Encode: " .. tostring(encoded),
                    Duration = 4
                })
            end)
            warn("[PB Config] JSON Encode error: " .. tostring(encoded))
        end
        return false
    end

    local writeOk, writeErr = pcall(function()
        writefile(fileName, encoded)
    end)
    if writeOk then
        if not silent then
            pcall(function()
                if Window and Window.Notify then
                    Window:Notify({ Title = "PB Config", Content = "บันทึกการตั้งค่าลงเครื่องเรียบร้อย! (" .. fileName .. ")", Type = "success" })
                end
            end)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "PB Config",
                    Text = "บันทึกการตั้งค่าลงเครื่องเรียบร้อย! (" .. fileName .. ")",
                    Duration = 3.5
                })
            end)
            print("[PB Config] Saved config to " .. fileName)
        end
        return true
    else
        if not silent then
            pcall(function()
                if Window and Window.Notify then
                    Window:Notify({ Title = "PB Config", Content = "บันทึกไฟล์ล้มเหลว: " .. tostring(writeErr), Type = "error" })
                end
            end)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "PB Config Error",
                    Text = "บันทึกไฟล์ล้มเหลว: " .. tostring(writeErr),
                    Duration = 4
                })
            end)
            warn("[PB Config] Save error: " .. tostring(writeErr))
        end
        return false
    end
end

local function loadConfig(profileName, silent)
    local fileName = getCleanConfigFilename(profileName)
    if not (readfile and isfile and isfile(fileName)) then
        if not silent then
            pcall(function()
                if Window and Window.Notify then
                    Window:Notify({ Title = "PB Config", Content = "ไม่พบไฟล์คอนฟิกบนเครื่อง (" .. fileName .. ")", Type = "warning" })
                end
            end)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "PB Config",
                    Text = "ไม่พบไฟล์คอนฟิกบนเครื่อง (" .. fileName .. ")",
                    Duration = 3.5
                })
            end)
            warn("[PB Config] Config file not found: " .. fileName)
        end
        return false
    end

    local ok, data = pcall(function() return readfile(fileName) end)
    if not ok or not data or data == "" then
        if not silent and Window and Window.Notify then
            Window:Notify({ Title = "PB Config", Content = "ไม่สามารถอ่านไฟล์คอนฟิกได้", Type = "error" })
        end
        return false
    end

    local okDecode, parsed = pcall(function() return HttpService:JSONDecode(data) end)
    if not okDecode or type(parsed) ~= "table" then
        if not silent and Window and Window.Notify then
            Window:Notify({ Title = "PB Config", Content = "ไฟล์คอนฟิกเสียหายหรือไม่ถูกต้อง", Type = "error" })
        end
        return false
    end

    for k, v in pairs(parsed) do
        if Config[k] ~= nil then
            if type(v) == "table" and type(Config[k]) == "table" then
                for subK, subV in pairs(v) do
                    Config[k][subK] = subV
                end
            else
                Config[k] = v
            end
        end

        if UIHandles[k] then
            pcall(function()
                if UIHandles[k].SetValue then
                    UIHandles[k]:SetValue(v)
                elseif UIHandles[k].Set then
                    UIHandles[k]:Set(v)
                elseif UIHandles[k].Select then
                    UIHandles[k]:Select(v)
                end
            end)
        end
    end

    -- Sync sub-toggles
    if Config.SelectedSellRarities then
        if UIHandles.SellCommon then pcall(function() UIHandles.SellCommon:Set(Config.SelectedSellRarities["Common"] == true) end) end
        if UIHandles.SellUncommon then pcall(function() UIHandles.SellUncommon:Set(Config.SelectedSellRarities["Uncommon"] == true) end) end
        if UIHandles.SellRare then pcall(function() UIHandles.SellRare:Set(Config.SelectedSellRarities["Rare"] == true) end) end
    end
    if Config.SelectedUpgradeCategories then
        if UIHandles.UpgrLuck then pcall(function() UIHandles.UpgrLuck:Set(Config.SelectedUpgradeCategories["Luck & Fortune"] == true) end) end
        if UIHandles.UpgrSpeed then pcall(function() UIHandles.UpgrSpeed:Set(Config.SelectedUpgradeCategories["Roll Speed"] == true) end) end
        if UIHandles.UpgrMoney then pcall(function() UIHandles.UpgrMoney:Set(Config.SelectedUpgradeCategories["Money"] == true) end) end
    end

    if not silent then
        pcall(function()
            if Window and Window.Notify then
                Window:Notify({ Title = "PB Config", Content = "โหลดการตั้งค่าสำเร็จ! (" .. fileName .. ")", Type = "success" })
            end
        end)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "PB Config",
                Text = "โหลดการตั้งค่าสำเร็จ! (" .. fileName .. ")",
                Duration = 3.5
            })
        end)
        print("[PB Config] Loaded config from " .. fileName)
    end
    return true
end

local function resetConfig()
    for k, v in pairs(DefaultCleanConfig) do
        if type(v) == "table" then
            Config[k] = table.clone(v)
        else
            Config[k] = v
        end
    end
    for k, handle in pairs(UIHandles) do
        if handle and handle.Set and Config[k] ~= nil then
            pcall(function() handle:Set(Config[k]) end)
        end
    end
    if Window and Window.Notify then
        Window:Notify({ Title = "PB Config", Content = "รีเซ็ตค่าเริ่มต้นเรียบร้อย!", Type = "info" })
    end
end

Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    Subtitle = "ANIME DICE [HALLOWEEN UPD]",
    DefaultTab = "Main Farm",
    Size = UDim2.fromOffset(880, 540),
    Accent = Color3.fromRGB(113, 220, 225),
    ToggleButton = true,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: MAIN FARM (ฟาร์มหลัก)
-- ─────────────────────────────────────────────────────────────────────
local TabMain = Window:CreateTab({
    Name = "Main Farm",
    Icon = "🎲",
    Subtitle = "Core Gameplay Loop & Telemetry",
})

TabMain:AddSection("LIVE TELEMETRY")
local StatRolls = TabMain:AddStatCard({ Title = "Total Rolls", Value = "0", Subtext = "Dice rolled this session", Progress = 0 })
local StatCash = TabMain:AddStatCard({ Title = "Player Wallet", Value = "0", Subtext = "Cash in wallet", Progress = 0.5 })
local StatRate = TabMain:AddStatCard({ Title = "Money Rate", Value = "+$0/s", Subtext = "Calculated earnings rate", Progress = 0.8 })
local StatRebirth = TabMain:AddStatCard({ Title = "Rebirths", Value = "0", Subtext = "Rebirth session count", Progress = 0 })
local StatPotions = TabMain:AddStatCard({ Title = "Potions Used", Value = "0", Subtext = "Auto consumed this session", Progress = 0 })
local StatTowerStatus = TabMain:AddStatCard({ Title = "Tower Status", Value = "Standby", Subtext = "Selected: Dragon Tower" })

TabMain:AddSection("DICE ROLLING (ทอยเต๋าอัตโนมัติ)")
UIHandles.AutoRoll = TabMain:AddToggle({
    Name = "Auto Roll (เปิดทอยลูกเต๋าอัตโนมัติ)",
    Desc = "ทอยต่อเนื่องความเร็วสูงด้วยแพ็กเก็ตปลอดภัย",
    Default = Config.AutoRoll,
    Callback = function(v)
        Config.AutoRoll = v
        Window:Notify({ Title = "Auto Roll", Content = v and "Started auto rolling!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
UIHandles.SkipCutscene = TabMain:AddToggle({
    Name = "Skip Cutscene & Screen Shakes",
    Desc = "ตัดแอนิเมชันลูกเต๋า 100% หน้าจอไม่สั่นเวียนหัว",
    Default = Config.SkipCutscene,
    Callback = function(v)
        Config.SkipCutscene = v
        SetupCutsceneBypass()
        Window:Notify({ Title = "Cutscene Bypass", Content = v and "Cutscenes disabled!" or "Restored.", Type = "info" })
    end,
})
UIHandles.RollSpeedDelay = TabMain:AddSlider({
    Name = "Roll Speed Delay (ความเร็วในการทอย)",
    Min = 0.01,
    Max = 0.5,
    Default = Config.RollSpeedDelay,
    Increment = 0.01,
    Format = "%.2fs",
    Callback = function(v) Config.RollSpeedDelay = v end,
})
UIHandles.BurstRolls = TabMain:AddToggle({
    Name = "Hyper Burst Rolls (ทอยรัวแพ็กเก็ต)",
    Desc = "ทอยหลายครั้งต่อ 1 รอบการทำงาน เพื่อเร่งความเร็วขั้นสุด",
    Default = Config.BurstRolls,
    Callback = function(v) Config.BurstRolls = v end,
})
TabMain:AddSlider({
    Name = "Burst Multiplier (จำนวนทอยต่อรอบ)",
    Min = 1,
    Max = 10,
    Default = Config.BurstRollCount,
    Increment = 1,
    Format = "%dx",
    Callback = function(v) Config.BurstRollCount = v end,
})
TabMain:AddButton({
    Name = "Roll Dice 1x Now (ทดลองทอย 1 ครั้ง)",
    Icon = "🎲",
    Callback = function()
        if RollService and RollService.RF:FindFirstChild("RollDice") then
            RollService.RF.RollDice:InvokeServer()
        end
        Window:Notify({ Title = "Roll Dice", Content = "Roll completed!", Type = "info" })
    end,
})

TabMain:AddSection("ISLAND & PLOT BALANCE (เกาะ & สล็อตดูดเงิน)")
UIHandles.AutoFarmPlot = TabMain:AddToggle({
    Name = "Auto Farm Plot (เปิดระบบทำงานบนเกาะ)",
    Desc = "เปิดระบบดูดเงินทุกสล็อตบนเกาะ + สวมใส่ตัวผลิตเงินสูงสุด",
    Default = Config.AutoFarmPlot,
    Callback = function(v)
        Config.AutoFarmPlot = v
        Window:Notify({ Title = "Auto Farm Plot", Content = v and "Plot farming active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
UIHandles.AutoCollectChest = TabMain:AddToggle({
    Name = "Auto Collect Money (ดูดเงิน 24 สล็อต)",
    Desc = "ส่งคำสั่ง CollectBalance ดูดเงินเข้าตัวทุกสล็อต ปลอดภัย ไม่เด้งป๊อปอัป",
    Default = Config.AutoCollectChest,
    Callback = function(v) Config.AutoCollectChest = v end,
})
UIHandles.AutoEquipBestPlot = TabMain:AddToggle({
    Name = "Auto Equip Best Plot Units",
    Desc = "คัดสรรและสวมใส่อนิเมะตัวที่ผลิตเงินสูงสุดลงแท่นอัตโนมัติ",
    Default = Config.AutoEquipBestPlot,
    Callback = function(v) Config.AutoEquipBestPlot = v end,
})
TabMain:AddButton({
    Name = "Force Collect All Money Now (ดูดเงินทุกสล็อตทันที)",
    Icon = "💰",
    Callback = function()
        CollectAllMoney()
        Window:Notify({ Title = "Collect Money", Content = "Directly sucked balance from all slots!", Type = "success" })
    end,
})
TabMain:AddButton({
    Name = "Sweep All Slots (เดินกวาดแตะทุกสล็อต 1 วิ)",
    Icon = "🧹",
    Callback = function()
        pcall(function()
            local plotCtrl = Features and Features:FindFirstChild("Plot") and require(Features.Plot.PlotController)
            local p = plotCtrl and plotCtrl.plot
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if p and p:FindFirstChild("Slots") and hrp then
                local origCF = hrp.CFrame
                for _, slot in ipairs(p.Slots:GetChildren()) do
                    local bal = slot:FindFirstChild("Balance")
                    local hb = bal and bal:FindFirstChild("Hitbox")
                    if hb then
                        hrp.CFrame = hb.CFrame + Vector3.new(0, 2, 0)
                        task.wait(0.04)
                    end
                end
                hrp.CFrame = origCF
            end
        end)
        Window:Notify({ Title = "Sweep Slots", Content = "Swept all slots on your island!", Type = "success" })
    end,
})
TabMain:AddButton({
    Name = "Teleport to Island Spawn (วาร์ปไปเกาะตนเอง)",
    Icon = "📍",
    Callback = function()
        TeleportToPlot()
        Window:Notify({ Title = "Teleport", Content = "Teleported to your island!", Type = "info" })
    end,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB: HALLOWEEN EVENT (อีเวนต์ฮาโลวีน & PUMPKIN DICE)
-- ─────────────────────────────────────────────────────────────────────
local TabHalloween = Window:CreateTab({
    Name = "Halloween Event",
    Icon = "🎃",
    Subtitle = "Event Quests, Pumpkin Pass & Gacha",
})

TabHalloween:AddSection("ISLAND & FAST TELEPORTS (เกาะฮาโลวีน)")
TabHalloween:AddButton({
    Name = "🎃 Teleport to Halloween Island (วาร์ปไปเกาะฮาโลวีน)",
    Icon = "🎃",
    Callback = function()
        pcall(function()
            if HalloweenTeleportRF then
                HalloweenTeleportRF:InvokeServer("Island")
                Window:Notify({ Title = "Halloween", Content = "Teleported to Halloween Island!", Type = "success" })
            end
        end)
    end,
})
TabHalloween:AddButton({
    Name = "🏛️ Return to Hub Island (วาร์ปกลับเกาะหลัก)",
    Icon = "🏛️",
    Callback = function()
        pcall(function()
            if HalloweenTeleportRF then
                HalloweenTeleportRF:InvokeServer("Hub")
                Window:Notify({ Title = "Halloween", Content = "Returned to Main Hub!", Type = "info" })
            end
        end)
    end,
})

TabHalloween:AddSection("PUMPKIN PASS (แบทเทิลพาสฮาโลวีน)")
UIHandles.AutoClaimPumpkinPass = TabHalloween:AddToggle({
    Name = "Auto Claim Pumpkin Pass (กดรับของรางวัลพาสอัตโนมัติ)",
    Desc = "กดรับรางวัลทุกขั้นใน Pumpkin Pass ทันทีที่ปลดล็อก",
    Default = Config.AutoClaimPumpkinPass,
    Callback = function(v)
        Config.AutoClaimPumpkinPass = v
        Window:Notify({ Title = "Pumpkin Pass", Content = v and "Auto claim active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
TabHalloween:AddButton({
    Name = "🎁 Claim All Pumpkin Pass Rewards Now (กดรับรางวัลพาสทั้งหมดทันที)",
    Icon = "🎁",
    Callback = function()
        pcall(function()
            if PumpkinPassClaimAllRE then
                PumpkinPassClaimAllRE:FireServer()
                Window:Notify({ Title = "Pumpkin Pass", Content = "Claimed all unlocked pass rewards!", Type = "success" })
            end
        end)
    end,
})

TabHalloween:AddSection("PUMPKIN DICE GACHA (เต๋าฟักทองอีเวนต์)")
UIHandles.AutoRollPumpkinDice = TabHalloween:AddToggle({
    Name = "Auto Roll Pumpkin Dice (เปิดทอยเต๋าฟักทองอัตโนมัติ)",
    Desc = "ทอยเต๋าฮาโลวีนต่อเนื่องเพื่อรับยูนิตพิเศษลิมิเต็ด",
    Default = Config.AutoRollPumpkinDice,
    Callback = function(v)
        Config.AutoRollPumpkinDice = v
        Window:Notify({ Title = "Pumpkin Dice", Content = v and "Auto roll active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
UIHandles.PumpkinDiceRollMode = TabHalloween:AddDropdown({
    Name = "Roll Mode (โหมดการทอย)",
    Options = {
        "Multi (5 Rolls / 500 🎃)",
        "Single (1 Roll / 100 🎃)"
    },
    Default = Config.PumpkinDiceRollMode or "Multi (5 Rolls / 500 🎃)",
    Callback = function(v) Config.PumpkinDiceRollMode = v end,
})
TabHalloween:AddSlider({
    Name = "Pumpkin Roll Delay (ความเร็วการทอยฟักทอง)",
    Min = 0.1,
    Max = 1.0,
    Default = Config.PumpkinDiceDelay or 0.35,
    Increment = 0.05,
    Format = "%.2fs",
    Callback = function(v) Config.PumpkinDiceDelay = v end,
})
TabHalloween:AddButton({
    Name = "🎲 Roll Pumpkin Dice 5x Now (ทอยเต๋าฟักทอง 5 ครั้งทันที)",
    Icon = "🎲",
    Callback = function()
        pcall(function()
            if PumpkinDiceRollRF then
                PumpkinDiceRollRF:InvokeServer(5)
                Window:Notify({ Title = "Pumpkin Dice", Content = "Rolled 5x Pumpkin Dice!", Type = "info" })
            end
        end)
    end,
})

TabHalloween:AddSection("HALLOWEEN QUESTS & TRICK-OR-TREAT")
UIHandles.AutoClaimHalloweenQuests = TabHalloween:AddToggle({
    Name = "Auto Claim Halloween Quests (รับเควสต์ Daily & Hourly อัตโนมัติ)",
    Desc = "ตรวจสอบและกดรับเควสต์ฮาโลวีนทั้งรายวันและรายชั่วโมงทันทีที่ทำสำเร็จ",
    Default = Config.AutoClaimHalloweenQuests,
    Callback = function(v)
        Config.AutoClaimHalloweenQuests = v
        Window:Notify({ Title = "Halloween Quests", Content = v and "Auto claim active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
UIHandles.AutoKnockHalloweenDoors = TabHalloween:AddToggle({
    Name = "Auto Knock Trick-or-Treat Doors (เคาะประตูฮาโลวีนอัตโนมัติ)",
    Desc = "เคาะประตูบ้านผีสิงทั้ง 7 บานบนเกาะฮาโลวีนเพื่อรับแคนดี้และของรางวัล",
    Default = Config.AutoKnockHalloweenDoors,
    Callback = function(v)
        Config.AutoKnockHalloweenDoors = v
        Window:Notify({ Title = "Trick or Treat", Content = v and "Door knocker active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
TabHalloween:AddButton({
    Name = "📜 Claim All Quests Now (กดรับรางวัลเควสต์ฮาโลวีนทั้งหมดทันที)",
    Icon = "📜",
    Callback = function()
        pcall(function()
            if HalloweenQuestClaimRE then
                for id = 1, 6 do HalloweenQuestClaimRE:FireServer("Daily", id) end
                for id = 1, 5 do HalloweenQuestClaimRE:FireServer("Hourly", id) end
                Window:Notify({ Title = "Halloween Quests", Content = "Claimed Daily & Hourly quests!", Type = "success" })
            end
        end)
    end,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2: ECONOMY (เศรษฐกิจ & คลัง)
-- ─────────────────────────────────────────────────────────────────────
local TabEconomy = Window:CreateTab({
    Name = "Economy",
    Icon = "💰",
    Subtitle = "Auto Sell, Safe Storage & Potions",
})

TabEconomy:AddSection("AUTO SELL UNITS ENGINE")
UIHandles.AutoSellUnits = TabEconomy:AddToggle({
    Name = "Auto Sell Units (เปิดระบบขายตัวละครอัตโนมัติ)",
    Desc = "ขายตัวละครตามระดับ Rarity ที่เลือกเป็นชุดละ 50 ตัว ปลอดภัย",
    Default = Config.AutoSellUnits,
    Callback = function(v) Config.AutoSellUnits = v end,
})
UIHandles.SellCommon = TabEconomy:AddToggle({
    Name = "Sell Common (ขายระดับปกติ)",
    Default = Config.SelectedSellRarities["Common"],
    Callback = function(v) Config.SelectedSellRarities["Common"] = v end,
})
UIHandles.SellUncommon = TabEconomy:AddToggle({
    Name = "Sell Uncommon (ขายระดับไม่ธรรมดา)",
    Default = Config.SelectedSellRarities["Uncommon"],
    Callback = function(v) Config.SelectedSellRarities["Uncommon"] = v end,
})
UIHandles.SellRare = TabEconomy:AddToggle({
    Name = "Sell Rare (ขายระดับหายาก)",
    Default = Config.SelectedSellRarities["Rare"],
    Callback = function(v) Config.SelectedSellRarities["Rare"] = v end,
})
UIHandles.ProtectPlottedUnits = TabEconomy:AddToggle({
    Name = "Safety: Protect Plotted Units (ห้ามขายตัวบนเกาะ)",
    Desc = "ปลอดภัย 100% ตัวที่วางบนเกาะจะไม่ถูกขายเด็ดขาด",
    Default = Config.ProtectPlottedUnits,
    Callback = function(v) Config.ProtectPlottedUnits = v end,
})
UIHandles.ProtectTowerTeam = TabEconomy:AddToggle({
    Name = "Safety: Protect Tower Team (ห้ามขายทีมหอคอย)",
    Desc = "ตัวที่อยู่ในทีมหอคอยจะไม่ถูกขายเด็ดขาด",
    Default = Config.ProtectTowerTeam,
    Callback = function(v) Config.ProtectTowerTeam = v end,
})
UIHandles.ProtectLockedUnits = TabEconomy:AddToggle({
    Name = "Safety: Protect Locked Units (ห้ามขายตัวที่ล็อคไว้)",
    Desc = "ตัวที่กดปุ่มล็อคแม่กุญแจไว้จะไม่ถูกขาย",
    Default = Config.ProtectLockedUnits,
    Callback = function(v) Config.ProtectLockedUnits = v end,
})
UIHandles.ProtectGradeSPlus = TabEconomy:AddToggle({
    Name = "Safety: Protect Grade S+ Units (ห้ามขายเกรด S ขึ้นไป)",
    Desc = "ตัวที่มีเกรด S, S+, Z, 神 จะปลอดภัยเสมอ",
    Default = Config.ProtectGradeSPlus,
    Callback = function(v) Config.ProtectGradeSPlus = v end,
})
TabEconomy:AddButton({
    Name = "Force Sell Selected Units Now (ขายตัวตามเงื่อนไขทันที)",
    Icon = "💰",
    Callback = function()
        local count = sellSelectedUnits()
        Window:Notify({ Title = "Sell Units", Content = string.format("Sold %d units safely!", count), Type = "success" })
    end,
})

TabEconomy:AddSection("ระบบใช้ไอเทมอัตโนมัติ (Auto Use Items)")
UIHandles.AutoUseAllOwned = TabEconomy:AddToggle({
    Name = "ใช้น้ำยาทันทีที่มีในกระเป๋า (Auto Use All Owned)",
    Desc = "ตรวจพบบัฟหรือน้ำยาใดๆ ในกระเป๋าจะกดใช้ทันทีอัตโนมัติ (ไม่ต้องคอยติ๊กเลือกทีละขวด)",
    Default = Config.AutoUseAllOwned,
    Callback = function(v)
        Config.AutoUseAllOwned = v
        Window:Notify({
            Title = "2K Auto Boost",
            Content = v and "เปิดระบบใช้น้ำยาทันทีที่มีในกระเป๋าแล้ว" or "ปิดระบบใช้น้ำยาทันทีที่มีในกระเป๋า",
            Type = v and "success" or "warning"
        })
    end,
})

UIHandles.AutoUsePotions = TabEconomy:AddToggle({
    Name = "ใช้เฉพาะไอเทมที่เลือก (Auto Use Selected Items)",
    Desc = "กดใช้เฉพาะไอเทมและบัฟที่ติ๊กเลือกจากรายการด้านล่าง",
    Default = Config.AutoUsePotions,
    Callback = function(v)
        Config.AutoUsePotions = v
        Window:Notify({
            Title = "2K Auto Boost",
            Content = v and "เปิดระบบใช้ไอเทมที่เลือกแล้ว" or "ปิดระบบใช้ไอเทมที่เลือก",
            Type = v and "success" or "warning"
        })
    end,
})

local allBoostList = getAllBoostNames()
local PotionDropdownHandle
UIHandles.ActivePotions = TabEconomy:AddDropdown({
    Name = "เลือกไอเทม / บัฟ (Select Items)",
    Desc = "เลือกไอเทมที่ต้องการกดใช้ (เลือกได้มากกว่า 1 ชนิด)",
    Options = allBoostList,
    Multi = true,
    Default = Config.ActivePotions,
    Callback = function(val)
        Config.ActivePotions = val
    end,
})
PotionDropdownHandle = UIHandles.ActivePotions

UIHandles.ItemUseCondition = TabEconomy:AddDropdown({
    Name = "เงื่อนไขการใช้ (Condition)",
    Desc = "กำหนดจังหวะการกดใช้ไอเทม",
    Options = {
        "กดใช้ทันที / ซ้อนเวลา (Always Use)",
        "ใช้เมื่อบัฟหมด (When Expired)"
    },
    Default = Config.ItemUseCondition or "กดใช้ทันที / ซ้อนเวลา (Always Use)",
    Callback = function(v)
        Config.ItemUseCondition = v
    end,
})

UIHandles.PotionInterval = TabEconomy:AddSlider({
    Name = "ความถี่ตรวจสอบ (วินาที)",
    Desc = "ระยะเวลาระหว่างการตรวจเช็คไอเทม",
    Min = 1,
    Max = 10,
    Default = Config.PotionInterval or 2,
    Increment = 1,
    Format = "%d วินาที",
    Callback = function(v) Config.PotionInterval = v end,
})

TabEconomy:AddSection("เครื่องมือด่วน (Quick Actions)")
TabEconomy:AddButton({
    Name = "กดใช้น้ำยาทั้งหมดในกระเป๋าทันที (Use All In Bag Now)",
    Desc = "กดใช้ขวดยาทุกชนิดที่มีอยู่ในกระเป๋าตอนนี้ทันทีอย่างละ 1 ครั้ง",
    Icon = "⚡",
    Callback = function()
        local count = useAllOwnedPotionsNow()
        Window:Notify({
            Title = "2K Script",
            Content = count > 0 and string.format("กดใช้น้ำยาในกระเป๋าสำเร็จ %d ชนิด", count) or "ไม่มีน้ำยาในกระเป๋า",
            Type = count > 0 and "success" or "warning"
        })
    end,
})

TabEconomy:AddButton({
    Name = "เลือกเฉพาะไอเทมที่มีในคลัง (Select Owned)",
    Desc = "ติ๊กเลือกไอเทมทั้งหมดที่มีจำนวนมากกว่า 0 ในคลัง",
    Icon = "🎒",
    Callback = function()
        local count = selectOwnedPotions()
        if PotionDropdownHandle and PotionDropdownHandle.Set then
            PotionDropdownHandle:Set(Config.ActivePotions)
        end
        Window:Notify({
            Title = "2K Script",
            Content = string.format("เลือกไอเทมที่มีในกระเป๋า %d ชนิดเรียบร้อย", count),
            Type = "success"
        })
    end,
})

TabEconomy:AddButton({
    Name = "ยกเลิกที่เลือกทั้งหมด (Clear All)",
    Desc = "ยกเลิกการเลือกไอเทมทั้งหมด",
    Icon = "🧹",
    Callback = function()
        table.clear(Config.ActivePotions)
        if PotionDropdownHandle and PotionDropdownHandle.Set then
            PotionDropdownHandle:Set({})
        end
        Window:Notify({ Title = "2K Script", Content = "ล้างรายการไอเทมที่เลือกทั้งหมดแล้ว", Type = "info" })
    end,
})

TabEconomy:AddButton({
    Name = "กดใช้ที่เลือกทันที 1 ครั้ง (Use Now)",
    Desc = "กดใช้ไอเทมที่เลือกไว้ทั้งหมด 1 ครั้งทันที",
    Icon = "🧪",
    Callback = function()
        local count = useSelectedItemsNow()
        Window:Notify({
            Title = "2K Script",
            Content = count > 0 and string.format("กดใช้ไอเทมสำเร็จ %d ชนิด", count) or "ไม่มีไอเทมที่เลือกในคลัง",
            Type = count > 0 and "success" or "warning"
        })
    end,
})

TabEconomy:AddSection("ACTIVE BUFFS LIVE MONITOR")
local StatBuffMonitor = TabEconomy:AddStatCard({
    Title = "Active Buffs",
    Value = "Scanning...",
    Subtext = "Live in-game buffs & remaining timers",
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2.5: GACHA & REROLL SUPREME (ระบบสุ่มทั้งหมด)
-- ─────────────────────────────────────────────────────────────────────
local TabGacha = Window:CreateTab({
    Name = "Gacha & Reroll",
    Icon = "✨",
    Subtitle = "Dice, Grades, Traits & Spins Supreme",
})

local currentUnitOptions, currentUnitMap = getInventoryUnitOptions()

TabGacha:AddSection("LIVE GACHA TELEMETRY")
local StatGradeRerolls = TabGacha:AddStatCard({ Title = "Grade Rerolls", Value = "0", Subtext = "Upgrades this session", Progress = 0 })
local StatTraitRerolls = TabGacha:AddStatCard({ Title = "Trait Rerolls", Value = "0", Subtext = "Traits rolled this session", Progress = 0 })
local StatWheelSpins   = TabGacha:AddStatCard({ Title = "Wheel Spins", Value = "0", Subtext = "Spins used this session", Progress = 0 })

TabGacha:AddSection("🌟 SMART GRADE REROLL (ระบบสุ่มเกรดอัจฉริยะ)")
UIHandles.AutoRerollGrade = TabGacha:AddToggle({
    Name = "Auto Reroll Grade (เปิดสุ่มเกรดอัตโนมัติ)",
    Desc = "สุ่มเกรดตัวละครด้วย Gem จนกว่าจะถึงเกรดเป้าหมายแบบอัตโนมัติ",
    Default = Config.AutoRerollGrade,
    Callback = function(v)
        Config.AutoRerollGrade = v
        Window:Notify({ Title = "Grade Reroll", Content = v and "Grade reroll engine activated!" or "Paused.", Type = v and "success" or "warning" })
    end,
})

UIHandles.GradeRollMode = TabGacha:AddDropdown({
    Name = "Target Mode (เลือกกลุ่มเป้าหมายที่จะสุ่มเกรด)",
    Options = {
        "All Plotted Units",
        "Tower Team Units",
        "Selected Unit"
    },
    Default = Config.GradeRollMode,
    Callback = function(v)
        Config.GradeRollMode = v
        Window:Notify({ Title = "Grade Mode", Content = "Target Mode: " .. tostring(v), Type = "info" })
    end,
})

UIHandles.TargetGrade = TabGacha:AddDropdown({
    Name = "Target Grade Threshold (เกรดเป้าหมาย)",
    Options = {"神", "Z+", "Z", "S+", "S", "A+", "A", "B", "C"},
    Default = Config.TargetGrade,
    Callback = function(v) Config.TargetGrade = v end,
})

local dropGradeUnitRef = nil
dropGradeUnitRef = TabGacha:AddDropdown({
    Name = "Select Unit (เลือกตัวละครในคลังเฉพาะเจาะจง)",
    Options = currentUnitOptions,
    Default = currentUnitOptions[1] or "",
    Callback = function(val)
        local uId = currentUnitMap[val]
        if uId then
            Config.TargetGradeUnitKey = uId
        end
    end,
})

TabGacha:AddSlider({
    Name = "Grade Roll Delay (ความเร็วการสุ่มเกรด)",
    Min = 0.1,
    Max = 1.0,
    Default = Config.GradeRollDelay,
    Increment = 0.05,
    Format = "%.2fs",
    Callback = function(v) Config.GradeRollDelay = v end,
})

TabGacha:AddButton({
    Name = "⚡ Reroll Selected Unit Grade 1x (สุ่มเกรดตัวนี้ 1 ครั้ง)",
    Icon = "⚡",
    Callback = function()
        if RollGradeRE and Config.TargetGradeUnitKey and Config.TargetGradeUnitKey ~= "" then
            RollGradeRE:FireServer(Config.TargetGradeUnitKey, true)
            Window:Notify({ Title = "Grade Reroll", Content = "Fired 1x grade roll on selected unit!", Type = "info" })
        else
            Window:Notify({ Title = "Grade Reroll", Content = "กรุณาเลือกตัวละครจากคลังก่อน!", Type = "warning" })
        end
    end,
})

TabGacha:AddButton({
    Name = "🌟 Reroll All Plotted Units Grade 1x (สุ่มเกรดทุกตัวบนแท่น 1 รอบ)",
    Icon = "🌟",
    Callback = function()
        local rolled = 0
        pcall(function()
            if RollGradeRE and DataController and DataController.Slots then
                for slot = 1, 24 do
                    local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                    if sData and sData.unitId then
                        RollGradeRE:FireServer(sData.unitId, true)
                        rolled = rolled + 1
                    end
                end
            end
        end)
        Window:Notify({ Title = "Plot Grade Roll", Content = "Sent 1x roll to " .. tostring(rolled) .. " plotted units!", Type = "success" })
    end,
})

TabGacha:AddSection("🔒 SERVER GRADE PROTECTION (ระบบล็อกเกรดเซิร์ฟเวอร์)")
local protectGrades = {"神", "Z+", "Z", "S+", "S"}
for _, g in ipairs(protectGrades) do
    TabGacha:AddToggle({
        Name = "Lock Grade " .. g .. " (ล็อกเกรด " .. g .. " บนเซิร์ฟเวอร์)",
        Desc = "เปิดการป้องกันเกรด " .. g .. " ไม่ให้ถูกลบหรือสุ่มทับ",
        Default = Config.ServerProtectGrades[g] == true,
        Callback = function(v)
            Config.ServerProtectGrades[g] = v
            if SetGradeProtectedRE then
                pcall(function() SetGradeProtectedRE:FireServer(g, v) end)
            end
            Window:Notify({ Title = "Server Lock", Content = "Grade " .. g .. " lock set to " .. tostring(v), Type = "info" })
        end,
    })
end

TabGacha:AddSection("✨ TRAITS REROLL SUPREME (ระบบสุ่มคุณสมบัติพิเศษ - TRAITS STALL)")
UIHandles.AutoRerollTrait = TabGacha:AddToggle({
    Name = "Auto Reroll Trait (เปิดสุ่มคุณสมบัติพิเศษอัตโนมัติ)",
    Desc = "สุ่มคุณสมบัติ Trait อัตโนมัติจนกว่าจะได้ Trait เทพตามที่กำหนด",
    Default = Config.AutoRerollTrait,
    Callback = function(v)
        Config.AutoRerollTrait = v
        Window:Notify({ Title = "Trait Reroll", Content = v and "Trait reroll engine activated!" or "Paused.", Type = v and "success" or "warning" })
    end,
})

UIHandles.TraitRollMode = TabGacha:AddDropdown({
    Name = "Trait Target Mode (เลือกกลุ่มเป้าหมายที่จะสุ่ม Trait)",
    Options = {
        "All Plotted Units",
        "Tower Team Units",
        "Selected Unit"
    },
    Default = Config.TraitRollMode,
    Callback = function(v)
        Config.TraitRollMode = v
        Window:Notify({ Title = "Trait Mode", Content = "Target Mode: " .. tostring(v), Type = "info" })
    end,
})

UIHandles.TargetTrait = TabGacha:AddDropdown({
    Name = "Target Trait (คุณสมบัติเป้าหมาย)",
    Options = {
        "Godly",
        "Overpowered",
        "Celestial",
        "Cosmic",
        "Shiny",
        "Fortune",
        "Speedy",
        "Rich",
        "Strength",
        "Mythical",
        "Legendary",
        "Any Top Tier"
    },
    Default = Config.TargetTrait,
    Callback = function(v) Config.TargetTrait = v end,
})

local dropTraitUnitRef = nil
dropTraitUnitRef = TabGacha:AddDropdown({
    Name = "Select Unit (เลือกตัวละครในคลังสำหรับสุ่ม Trait)",
    Options = currentUnitOptions,
    Default = currentUnitOptions[1] or "",
    Callback = function(val)
        local uId = currentUnitMap[val]
        if uId then
            Config.TargetTraitUnitKey = uId
        end
    end,
})

TabGacha:AddSlider({
    Name = "Trait Roll Delay (ความเร็วการสุ่ม Trait)",
    Min = 0.1,
    Max = 1.0,
    Default = Config.TraitRollDelay,
    Increment = 0.05,
    Format = "%.2fs",
    Callback = function(v) Config.TraitRollDelay = v end,
})

TabGacha:AddButton({
    Name = "⚡ Reroll Selected Unit Trait 1x (สุ่ม Trait ตัวนี้ 1 ครั้ง)",
    Icon = "⚡",
    Callback = function()
        local rem, isRF = resolveTraitRemote()
        if rem and Config.TargetTraitUnitKey and Config.TargetTraitUnitKey ~= "" then
            pcall(function()
                if isRF then rem:InvokeServer(Config.TargetTraitUnitKey) else rem:FireServer(Config.TargetTraitUnitKey) end
            end)
            Window:Notify({ Title = "Trait Reroll", Content = "Fired 1x trait roll!", Type = "info" })
        else
            Window:Notify({ Title = "Trait Reroll", Content = "กรุณาเลือกตัวละครจากคลังก่อน!", Type = "warning" })
        end
    end,
})

TabGacha:AddButton({
    Name = "👑 Reroll All Plotted Units Trait 1x (สุ่ม Trait ทุกตัวบนแท่น 1 รอบ)",
    Icon = "👑",
    Callback = function()
        local rem, isRF = resolveTraitRemote()
        local rolled = 0
        if rem and DataController and DataController.Slots then
            pcall(function()
                for slot = 1, 24 do
                    local sData = DataController.Slots[tostring(slot)] and DataController.Slots[tostring(slot)]()
                    if sData and sData.unitId then
                        if isRF then rem:InvokeServer(sData.unitId) else rem:FireServer(sData.unitId) end
                        rolled = rolled + 1
                    end
                end
            end)
        end
        Window:Notify({ Title = "Plot Trait Roll", Content = "Sent 1x trait roll to " .. tostring(rolled) .. " plotted units!", Type = "success" })
    end,
})

TabGacha:AddButton({
    Name = "📍 Teleport to Traits Stall (NPC King)",
    Icon = "📍",
    Callback = function()
        pcall(function()
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(325, 12, 82) end
        end)
        Window:Notify({ Title = "Teleport", Content = "Teleported to Traits Stall (King)!", Type = "info" })
    end,
})

TabGacha:AddSection("🧬 QUIRKS SYSTEM (ระบบคุณสมบัติใหม่ UPD 8 / HALLOWEEN)")
UIHandles.AutoRerollQuirks = TabGacha:AddToggle({
    Name = "Auto Reroll Quirks (เปิดสุ่ม Quirk อัตโนมัติ)",
    Desc = "สุ่ม Quirk ต่อเนื่องจนกว่าจะได้ Quirk เทพที่เลือกไว้",
    Default = Config.AutoRerollQuirks,
    Callback = function(v)
        Config.AutoRerollQuirks = v
        Window:Notify({ Title = "Quirk Reroll", Content = v and "Quirk reroll engine active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
UIHandles.QuirkRollMode = TabGacha:AddDropdown({
    Name = "Quirk Target Mode (กลุ่มเป้าหมาย)",
    Options = {
        "All Plotted Units",
        "Selected Unit"
    },
    Default = Config.QuirkRollMode or "All Plotted Units",
    Callback = function(v) Config.QuirkRollMode = v end,
})
local allQuirkOptions = {
    "Fortune's Favor", "Midas Touch", "Prodigy", "Tycoon",
    "Fortune III", "Fortune II", "Fortune I",
    "Wealth III", "Wealth II", "Wealth I",
    "Gifted III", "Gifted II", "Gifted I",
    "Swift III", "Swift II", "Swift I",
    "Refined III", "Refined II", "Refined I"
}
TabGacha:AddDropdown({
    Name = "Target Quirks (เลือก Quirk ที่ต้องการล็อก)",
    Options = allQuirkOptions,
    Multi = true,
    Default = Config.SelectedTargetQuirks,
    Callback = function(chosen)
        Config.SelectedTargetQuirks = chosen
    end,
})
TabGacha:AddButton({
    Name = "🧬 Reroll Selected Unit Quirk 1x (สุ่ม Quirk ตัวที่เลือก 1 ครั้ง)",
    Icon = "🧬",
    Callback = function()
        if QuirkRollRE and Config.TargetTraitUnitKey and Config.TargetTraitUnitKey ~= "" then
            QuirkRollRE:FireServer(Config.TargetTraitUnitKey)
            Window:Notify({ Title = "Quirk Roll", Content = "Fired 1x Quirk roll!", Type = "info" })
        else
            Window:Notify({ Title = "Quirk Roll", Content = "กรุณาเลือกตัวละครก่อน!", Type = "warning" })
        end
    end,
})

TabGacha:AddSection("⚗️ UNIT FUSING (ระบบหลอมรวมยูนิต)")
TabGacha:AddButton({
    Name = "⚗️ Fuse 3 Identical Lowest Units (หลอมรวม 3 ตัวซ้ำระดับต่ำสุด)",
    Icon = "⚗️",
    Callback = function()
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
                        Window:Notify({ Title = "Unit Fusion", Content = "Fused 3x " .. name .. "!", Type = "success" })
                        return
                    end
                end
                Window:Notify({ Title = "Unit Fusion", Content = "ไม่พบยูนิตที่ซ้ำกัน 3 ตัวสำหรับหลอม", Type = "warning" })
            end
        end)
    end,
})

TabGacha:AddSection("🔄 INVENTORY UNIT CONTROLS (จัดการคลังตัวละคร)")
TabGacha:AddButton({
    Name = "🔄 Refresh Units List (รีเฟรชรายชื่อตัวละครในคลัง)",
    Icon = "🔄",
    Callback = function()
        currentUnitOptions, currentUnitMap = getInventoryUnitOptions()
        if dropGradeUnitRef and dropGradeUnitRef.Refresh then
            dropGradeUnitRef:Refresh(currentUnitOptions, true)
        end
        if dropTraitUnitRef and dropTraitUnitRef.Refresh then
            dropTraitUnitRef:Refresh(currentUnitOptions, true)
        end
        Window:Notify({ Title = "Units Refreshed", Content = "Loaded " .. tostring(#currentUnitOptions) .. " units from inventory!", Type = "success" })
    end,
})

TabGacha:AddSection("🎡 LUCKY WHEEL & GACHA REWARDS (วงล้อ & สุ่มของรางวัล)")
UIHandles.AutoSpinWheel = TabGacha:AddToggle({
    Name = "Auto Spin Lucky Wheel (หมุนวงล้อนำโชคอัตโนมัติ)",
    Desc = "ใช้สิทธิ์หมุนวงล้อฟรีทันทีที่พร้อมใช้งาน",
    Default = Config.AutoSpinWheel,
    Callback = function(v)
        Config.AutoSpinWheel = v
        Window:Notify({ Title = "Wheel Spin", Content = v and "Auto spin wheel active!" or "Paused.", Type = v and "success" or "warning" })
    end,
})

TabGacha:AddButton({
    Name = "🎡 Instant 10x Wheel Spins Burst (กดหมุนวงล้อรวดเดียว 10 ครั้ง)",
    Icon = "🎡",
    Callback = function()
        task.spawn(function()
            for i = 1, 10 do
                if SpinWheelRE then pcall(function() SpinWheelRE:FireServer() end) end
                task.wait(0.2)
            end
        end)
        Window:Notify({ Title = "Wheel Burst", Content = "Dispatched 10x spins burst!", Type = "success" })
    end,
})

TabGacha:AddButton({
    Name = "🎁 Claim All Free Gacha & Daily Rewards (กดรับรางวัลฟรีทั้งหมด)",
    Icon = "🎁",
    Callback = function()
        ClaimAllRewards()
        Window:Notify({ Title = "Claim Rewards", Content = "Claimed Daily, Offline, Spin and Group rewards!", Type = "success" })
    end,
})

TabGacha:AddSection("🎲 DICE ROLLER BURST SETTINGS (ตั้งค่าทอยเต๋าผสานพลัง)")
TabGacha:AddToggle({
    Name = "Hyper Burst Rolls (เปิดโหมดทอยรัวแพ็กเก็ต)",
    Desc = "ส่งคำสั่งทอยลูกเต๋าหลายชุดต่อ 1 รอบการทำงาน เพื่อเร่งความเร็วในการสุ่มขั้นสุด",
    Default = Config.BurstRolls,
    Callback = function(v) Config.BurstRolls = v end,
})

TabGacha:AddSlider({
    Name = "Burst Roll Multiplier (จำนวนแพ็กเก็ตทอยต่อรอบ)",
    Min = 1,
    Max = 10,
    Default = Config.BurstRollCount,
    Increment = 1,
    Format = "%dx",
    Callback = function(v) Config.BurstRollCount = v end,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 3: CONTENT (หอคอยดันเจี้ยน)
-- ─────────────────────────────────────────────────────────────────────
local TabContent = Window:CreateTab({
    Name = "Dungeons",
    Icon = "🏰",
    Subtitle = "Towers & Floor Climber",
})

TabContent:AddSection("TOWER DUNGEON SUPREME AUTOMATION")
UIHandles.AutoTowers = TabContent:AddToggle({
    Name = "Auto Towers (ลงหอคอยดันเจี้ยนอัตโนมัติ)",
    Desc = "ลงหอคอยอัตโนมัติ จัดทีมที่ดีที่สุด เคลียร์ชั้นต่อเนื่องความเร็วสูง (ลิมิตสูงสุด 200 ชั้น)",
    Default = Config.AutoTowers,
    Callback = function(v)
        Config.AutoTowers = v
        if not v and CancelTowerRF then
            pcall(function() CancelTowerRF:InvokeServer() end)
        end
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
    end,
})
UIHandles.SelectedTower = TabContent:AddDropdown({
    Name = "Select Tower (เลือกระดับหอคอย)",
    Options = TowerList,
    Default = Config.SelectedTower,
    Callback = function(selected)
        Config.SelectedTower = selected
        for idx, tName in ipairs(TowerList) do
            if tName == selected then
                towerCycleIndex = idx
                break
            end
        end
        lastSeenFloor = 0
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
        Window:Notify({ Title = "Tower Selected", Content = "Target Tower: " .. tostring(selected), Type = "info" })
    end,
})
UIHandles.AutoCycleTowers = TabContent:AddToggle({
    Name = "Auto Cycle All Towers (ลงวนทุกหอคอยอัตโนมัติ)",
    Desc = "ลงวนทุกหอคอยต่อเนื่องอัตโนมัติ (ครบทั้ง 7 หอคอย: Dragon -> Cursed -> Pirate -> Leaf -> Slayer -> Shadow -> Infinity)",
    Default = Config.AutoCycleTowers,
    Callback = function(v)
        Config.AutoCycleTowers = v
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
        Window:Notify({ Title = "Cycle Towers", Content = v and "เปิดโหมดลงวนทุกหอคอย!" or "ปิดโหมดลงวน (จะลงเฉพาะ " .. tostring(Config.SelectedTower) .. " เท่านั้น)", Type = v and "info" or "warning" })
    end,
})
TabContent:AddSection("📊 DUNGEON PRESET TIERS (ระบบกำหนดชั้นอัตโนมัติ)")
TabContent:AddStatCard({
    Title = "Preset Dungeons Cap",
    Value = "Infinity: 200 ชั้น | หอคอยทั่วไป: 100 ชั้น",
    Desc = "5 หอคอยแรก: 100F • Shadow: 150F • Infinity: 200F",
})
UIHandles.AutoTowerFloorDelay = TabContent:AddSlider({
    Name = "Floor Clear Speed (ความเร็วเคลียร์ชั้น - ดีเลย์)",
    Min = 0.05,
    Max = 1.0,
    Default = Config.AutoTowerFloorDelay,
    Increment = 0.05,
    Format = "%.2fs",
    Callback = function(v)
        Config.AutoTowerFloorDelay = v
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
    end,
})
UIHandles.AutoUseDamagePotionsInTower = TabContent:AddToggle({
    Name = "Auto Potions in Tower (กดใช้น้ำยาบัฟก่อนลงหอคอย)",
    Desc = "กดใช้น้ำยา Damage & Luck อัตโนมัติเพื่อเร่งความเร็วและโบนัสดรอป",
    Default = Config.AutoUseDamagePotionsInTower,
    Callback = function(v)
        Config.AutoUseDamagePotionsInTower = v
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
    end,
})
UIHandles.AutoRetryFailedFloor = TabContent:AddToggle({
    Name = "Auto Retry Failed Floor (ลองเคลียร์ชั้นที่ติดขัดซ้ำอัตโนมัติ)",
    Desc = "หากชั้นไหนสะดุด จะลองส่งแพ็กเก็ตเคลียร์ซ้ำ 3 ครั้งแทนการหลุดออกจากหอคอย",
    Default = Config.AutoRetryFailedFloor,
    Callback = function(v)
        Config.AutoRetryFailedFloor = v
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
    end,
})
UIHandles.HideTowerScreen = TabContent:AddToggle({
    Name = "Hide Tower Screen (ซ่อนหน้าจอต่อสู้หอคอย)",
    Desc = "ซ่อนหน้าจอต่อสู้หอคอยเพื่อความลื่นไหลและประหยัด FPS",
    Default = Config.HideTowerScreen,
    Callback = function(v)
        Config.HideTowerScreen = v
        if AutoSaveConfig then task.spawn(AutoSaveConfig) end
    end,
})

TabContent:AddSection("QUICK TOWER COMMANDS (ปุ่มคำสั่งด่วน)")
TabContent:AddButton({
    Name = "⚡ Instant Clear Current Floor (กดผ่านชั้นปัจจุบันทันที)",
    Icon = "⚡",
    Callback = function()
        local ok = instantClearCurrentFloor()
        Window:Notify({ Title = "Instant Clear", Content = ok and "ส่งคำสั่งผ่านชั้นปัจจุบันเรียบร้อย!" or "ไม่พบหอคอยที่กำลังเล่นอยู่", Type = ok and "success" or "warning" })
    end,
})
TabContent:AddButton({
    Name = "👑 Equip Best Tower Team (ใส่ทีมหอคอยที่ดีที่สุด)",
    Icon = "👑",
    Callback = function()
        if EquipBestTowerTeamRE then EquipBestTowerTeamRE:FireServer() end
        Window:Notify({ Title = "Tower Team", Content = "Equipped best tower units!", Type = "success" })
    end,
})
TabContent:AddButton({
    Name = "⏹ Cancel & Exit Tower (ออกจากหอคอยทันที)",
    Icon = "⏹",
    Callback = function()
        if CancelTowerRF then CancelTowerRF:InvokeServer() end
        Window:Notify({ Title = "Tower Cancelled", Content = "Exited current tower dungeon.", Type = "warning" })
    end,
})



-- ─────────────────────────────────────────────────────────────────────
-- TAB 4: PROGRESSION (พัฒนาการ & อัปเกรด)
-- ─────────────────────────────────────────────────────────────────────
local TabProgression = Window:CreateTab({
    Name = "Progression",
    Icon = "📈",
    Subtitle = "Rebirth, Skill Tree & Upgrades",
})

TabProgression:AddSection("AUTO REBIRTH ENGINE")
UIHandles.AutoRebirth = TabProgression:AddToggle({
    Name = "Auto Rebirth (จุติอัตโนมัติ)",
    Desc = "ตรวจสอบเงินและจุติอัตโนมัติทันทีที่ถึงราคา",
    Default = Config.AutoRebirth,
    Callback = function(v) Config.AutoRebirth = v end,
})
TabProgression:AddSlider({
    Name = "Target Rebirth (จุติถึงขั้นเป้าหมาย)",
    Min = 1,
    Max = 12,
    Default = Config.TargetRebirth,
    Increment = 1,
    Format = "Rebirth %d",
    Callback = function(v) Config.TargetRebirth = v end,
})
TabProgression:AddButton({
    Name = "Rebirth 1x Now (ทดลองกดจุติทันที 1 ครั้ง)",
    Icon = "⚡",
    Callback = function()
        checkAndRebirth()
        Window:Notify({ Title = "Rebirth", Content = "Sent rebirth request!", Type = "info" })
    end,
})

TabProgression:AddSection("SKILL TREE UPGRADE ENGINE")
TabProgression:AddToggle({
    Name = "Auto Buy Upgrades (ซื้ออัปเกรดอัตโนมัติ)",
    Desc = "ซื้อความสามารถใน Skill Tree อัตโนมัติ เรียงตามราคาที่ถูกที่สุดก่อน",
    Default = Config.AutoUpgrades,
    Callback = function(v)
        Config.AutoUpgrades = v
        Window:Notify({ Title = "Auto Upgrades", Content = v and "Upgrades purchasing started!" or "Paused.", Type = v and "success" or "warning" })
    end,
})
TabProgression:AddToggle({
    Name = "Focus: Luck & Fortune (เน้นอัปโชคและดวง)",
    Desc = "ซื้อสายโชคและดวงก่อนเป็นอันดับแรก",
    Default = Config.SelectedUpgradeCategories["Luck & Fortune"],
    Callback = function(v) Config.SelectedUpgradeCategories["Luck & Fortune"] = v end,
})
TabProgression:AddToggle({
    Name = "Focus: Roll Speed (เน้นความเร็วหมุน)",
    Desc = "ซื้อสายเพิ่มความเร็วทอยลูกเต๋าก่อน",
    Default = Config.SelectedUpgradeCategories["Roll Speed"],
    Callback = function(v) Config.SelectedUpgradeCategories["Roll Speed"] = v end,
})
TabProgression:AddToggle({
    Name = "Focus: Money (เน้นผลิตเงิน)",
    Desc = "ซื้อสายเพิ่มเงินก่อน",
    Default = Config.SelectedUpgradeCategories["Money"],
    Callback = function(v) Config.SelectedUpgradeCategories["Money"] = v end,
})

TabProgression:AddSection("DICE SHOP AUTOMATION")
TabProgression:AddToggle({
    Name = "Auto Buy New Dice (ซื้อลูกเต๋าใหม่)",
    Desc = "ซื้อลูกเต๋าที่ยังไม่มีในร้านค้าเมื่อเงินถึงอัตโนมัติ",
    Default = Config.AutoBuyDice,
    Callback = function(v) Config.AutoBuyDice = v end,
})

TabProgression:AddSection("SMART SLOT UPGRADE ENGINE")
TabProgression:AddToggle({
    Name = "Auto Upgrade Slots (เช็คราคาเงินจริง)",
    Desc = "ตรวจสอบเงินก่อนอัปเกรดเลเวลช่องวางยูนิต ป้องกันระบบค้าง",
    Default = Config.AutoUpgradeSlots,
    Callback = function(v) Config.AutoUpgradeSlots = v end,
})
UIHandles.TargetSlotLevel = TabProgression:AddSlider({
    Name = "Target Slot Level (อัปถึงเลเวลเป้าหมาย)",
    Min = 1,
    Max = 100,
    Default = Config.TargetSlotLevel,
    Increment = 1,
    Format = "Lv. %d",
    Callback = function(v) Config.TargetSlotLevel = v end,
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 5: SETTINGS (ผู้เล่น, วาร์ป & ตั้งค่า)
-- ─────────────────────────────────────────────────────────────────────
-- ─────────────────────────────────────────────────────────────────────
-- TAB 5: PLAYER & MOVEMENT PHYSICS
-- ─────────────────────────────────────────────────────────────────────
local TabPlayer = Window:CreateTab({
    Name = "Player",
    Icon = "🏃",
    Subtitle = "Physics, Movement & Reconnect Hacks",
})

TabPlayer:AddSection("MOVEMENT & PHYSICS HACKS")
TabPlayer:AddToggle({
    Name = "WalkSpeed Hack (เพิ่มความเร็ววิ่ง)",
    Default = Config.WalkSpeedEnabled,
    Callback = function(Value)
        Config.WalkSpeedEnabled = Value
        if not Value then
            pcall(function()
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end)
        end
    end
})

TabPlayer:AddSlider({
    Name = "WalkSpeed Value",
    Min = 16, Max = 250, Default = Config.WalkSpeedValue,
    Increment = 2, ValueName = "speed",
    Callback = function(Value) Config.WalkSpeedValue = Value end
})

TabPlayer:AddToggle({
    Name = "JumpPower Hack (เพิ่มพลังกระโดด)",
    Default = Config.JumpPowerEnabled,
    Callback = function(Value)
        Config.JumpPowerEnabled = Value
        if not Value then
            pcall(function()
                local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = 50 end
            end)
        end
    end
})

TabPlayer:AddSlider({
    Name = "JumpPower Value",
    Min = 50, Max = 350, Default = Config.JumpPowerValue,
    Increment = 5, ValueName = "power",
    Callback = function(Value) Config.JumpPowerValue = Value end
})

TabPlayer:AddToggle({
    Name = "Infinite Jump (กระโดดลอยฟ้าไม่จำกัด)",
    Desc = "กระโดดซ้ำกลางอากาศได้อย่างอิสระ",
    Default = Config.InfiniteJump,
    Callback = function(Value) Config.InfiniteJump = Value end
})

TabPlayer:AddToggle({
    Name = "Noclip (เดินทะลุกำแพง)",
    Desc = "เดินผ่านสิ่งกีดขวางทุกชนิดโดยไม่ติดขัด",
    Default = Config.Noclip,
    Callback = function(Value) Config.Noclip = Value end
})

TabPlayer:AddSection("FLY ENGINE")
local flyBodyVelocity, flyBodyGyro = nil, nil
TabPlayer:AddToggle({
    Name = "Flight Mode (บินอิสระตามมุมกล้อง)",
    Desc = "บินสำรวจแมพตามทิศทางมุมกล้อง",
    Default = Config.FlyEnabled,
    Callback = function(Value)
        Config.FlyEnabled = Value
        pcall(function()
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if Value then
                if hrp then
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.Name = "PB_FlyVelocity"
                    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    flyBodyVelocity.Velocity = Vector3.zero
                    flyBodyVelocity.Parent = hrp

                    flyBodyGyro = Instance.new("BodyGyro")
                    flyBodyGyro.Name = "PB_FlyGyro"
                    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                    flyBodyGyro.CFrame = hrp.CFrame
                    flyBodyGyro.Parent = hrp
                end
                if hum then hum.PlatformStand = true end
            else
                if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
                if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
                if hum then hum.PlatformStand = false end
            end
        end)
    end
})

TabPlayer:AddSlider({
    Name = "Fly Speed",
    Min = 10, Max = 250, Default = Config.FlySpeed,
    Increment = 5, ValueName = "speed",
    Callback = function(Value) Config.FlySpeed = Value end
})

TabPlayer:AddSection("ANTI-DISCONNECT & 24/7 AUTO RECONNECT")
TabPlayer:AddToggle({
    Name = "Auto Reconnect (เชื่อมต่อเซิร์ฟเวอร์ใหม่อัตโนมัติ)",
    Desc = "ตรวจจับหน้าต่างหลุด/เตะ แล้ว Reconnect กลับเข้าเซิร์ฟเวอร์เดิมทันที 24/7",
    Default = Config.AutoReconnect,
    Callback = function(Value) Config.AutoReconnect = Value end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 6: VISUALS & PERFORMANCE BOOSTER
-- ─────────────────────────────────────────────────────────────────────
local function toggleGodAura(enable)
    pcall(function()
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local existingAura = hrp:FindFirstChild("PB_AnimeGodAura")
        local existingHl = char:FindFirstChild("PB_AnimeGodHighlight")
        if enable then
            if not existingAura then
                local aura = Instance.new("ParticleEmitter")
                aura.Name = "PB_AnimeGodAura"
                aura.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(56, 189, 248)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168, 85, 247)),
                    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(236, 72, 153)),
                })
                aura.LightEmission = 1
                aura.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 1.2),
                    NumberSequenceKeypoint.new(1.0, 3.2),
                })
                aura.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0.0, 0.2),
                    NumberSequenceKeypoint.new(1.0, 1.0),
                })
                aura.Rate = 45
                aura.Speed = NumberRange.new(2, 6)
                aura.SpreadAngle = Vector2.new(180, 180)
                aura.Parent = hrp
            end
            if not existingHl then
                local hl = Instance.new("Highlight")
                hl.Name = "PB_AnimeGodHighlight"
                hl.FillColor = Color3.fromRGB(56, 189, 248)
                hl.FillTransparency = 0.65
                hl.OutlineColor = Color3.fromRGB(168, 85, 247)
                hl.OutlineTransparency = 0.1
                hl.Parent = char
            end
        else
            if existingAura then existingAura:Destroy() end
            if existingHl then existingHl:Destroy() end
        end
    end)
end


local TabVisuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "✨",
    Subtitle = "FPS Optimization, Lighting & Aura",
})

TabVisuals:AddSection("PERFORMANCE & FPS BOOSTER")
TabVisuals:AddToggle({
    Name = "FPS Booster (ลดกราฟิกลื่นไหล 60+ FPS)",
    Desc = "ปิดการเรนเดอร์เอฟเฟกต์หนัก ปรับพื้นผิว Low Graphics สำหรับปล่อยฟาร์มยาว",
    Default = Config.FPSBooster,
    Callback = function(Value)
        Config.FPSBooster = Value
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then terrain.Decoration = not Value end
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = not Value
        end)
    end
})

TabVisuals:AddSection("LIGHTING & ENVIRONMENT")
TabVisuals:AddToggle({
    Name = "FullBright / Night Vision (สว่างทั่วทั้งแมพ)",
    Desc = "มองเห็นชัดเจนในทุกพื้นที่ ไม่มีความมืดมารบกวน",
    Default = Config.FullBright,
    Callback = function(Value)
        Config.FullBright = Value
        pcall(function()
            local lighting = game:GetService("Lighting")
            if Value then
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.FogEnd = 1e5
                lighting.GlobalShadows = false
            else
                lighting.Brightness = 1
                lighting.ClockTime = 12
                lighting.FogEnd = 1000
                lighting.GlobalShadows = true
            end
        end)
    end
})

TabVisuals:AddSection("CHARACTER GOD AURA")
TabVisuals:AddToggle({
    Name = "God Aura & Neon Highlight (ออร่าเทพเรืองแสง)",
    Desc = "สร้างออร่าพาร์ติเคิลสีนีออนและแสงไฮไลต์รอบตัวละครสุดเท่",
    Default = Config.GodAura,
    Callback = function(Value)
        Config.GodAura = Value
        toggleGodAura(Value)
    end
})

local TabSettings = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙️",
    Subtitle = "Defense, Teleports & Script Controls",
})

TabSettings:AddSection("ANTI-DISCONNECT DEFENSE")
UIHandles.AntiAFK = TabSettings:AddToggle({
    Name = "Triple-Layer Anti-AFK (ป้องกันหลุด 24 ชม.)",
    Desc = "ทำลายสคริปต์เตะ 19 นาทีของเกม + บล็อก Idled 20 นาที 100%",
    Default = Config.AntiAFK,
    Callback = function(v) Config.AntiAFK = v end,
})

TabSettings:AddSection("FREE REWARDS")
UIHandles.AutoClaimRewards = TabSettings:AddToggle({
    Name = "Auto Claim Free Rewards (Daily, Offline, Spins)",
    Desc = "กดรับ Daily Reward, Offline Earnings, และหมุนวงล้อฟรีอัตโนมัติ",
    Default = Config.AutoClaimRewards,
    Callback = function(v) Config.AutoClaimRewards = v end,
})
TabSettings:AddButton({
    Name = "Claim All Free Gifts Now (กดรับของขวัญฟรีทันที)",
    Icon = "🎁",
    Callback = function()
        ClaimAllRewards()
        Window:Notify({ Title = "Gifts", Content = "Claimed Daily, Offline, and Wheel Spins!", Type = "success" })
    end,
})

TabSettings:AddSection("INTERFACE THEMES (8 THEMES DYNAMIC SWITCHER)")
UI.ThemeManager:ApplyToTab(TabSettings)

TabSettings:AddSection("CONFIGURATION (ระบบเซฟและโหลดคอนฟิกแบบ 2K)")

local currentProfileName = "default"

TabSettings:AddTextbox({
    Name = "ชื่อคอนฟิก (Profile Name)",
    Default = "default",
    Placeholder = "เช่น default, afk, towers...",
    Callback = function(val)
        currentProfileName = (val and val:gsub("%s+", "") ~= "") and val:gsub("%s+", "") or "default"
    end
})

TabSettings:AddButton({
    Name = "บันทึกการตั้งค่า (Save Config)",
    Icon = "💾",
    Callback = function()
        saveConfig(currentProfileName, false)
    end
})

TabSettings:AddButton({
    Name = "โหลดการตั้งค่า (Load Config)",
    Icon = "📂",
    Callback = function()
        loadConfig(currentProfileName, false)
    end
})

TabSettings:AddButton({
    Name = "รีเซ็ตค่าเริ่มต้น (Reset to Defaults)",
    Icon = "🔄",
    Callback = function()
        resetConfig()
    end
})

TabSettings:AddSection("WORLD TELEPORTS")
local ZonesList = {
    { Name = "Central Hub Area", Icon = "🏛️", Pos = Vector3.new(285, 4, 136) },
    { Name = "Shop Area", Icon = "🛒", Pos = Vector3.new(285, 4, -273) },
    { Name = "Dice Shop", Icon = "🎲", Pos = Vector3.new(285, 10, -305) },
    { Name = "General Item Shop", Icon = "🏪", Pos = Vector3.new(253, 10, -291) },
    { Name = "Selling Zone", Icon = "💰", Pos = Vector3.new(317, 10, -289) },
    { Name = "Aura Fuse Machine", Icon = "🧬", Pos = Vector3.new(323, 10, -54) },
    { Name = "Towers Portal", Icon = "🏰", Pos = Vector3.new(285, 21, 43) },
    { Name = "Quests NPC", Icon = "📜", Pos = Vector3.new(324, 12, 4) },
    { Name = "Traits Machine", Icon = "✨", Pos = Vector3.new(325, 12, 82) },
    { Name = "Grades Machine", Icon = "⭐", Pos = Vector3.new(245, 12, 84) },
    { Name = "Trading Zone", Icon = "🤝", Pos = Vector3.new(247, 12, 6) },
}
for _, zone in ipairs(ZonesList) do
    TabSettings:AddButton({
        Name = "Teleport: " .. zone.Name,
        Icon = zone.Icon,
        Callback = function()
            pcall(function()
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(zone.Pos + Vector3.new(0, 3, 0))
                    Window:Notify({ Title = "Teleport", Content = "Arrived at " .. zone.Name, Type = "info" })
                end
            end)
        end,
    })
end

TabSettings:AddSection("SCRIPT CONTROLS")
TabSettings:AddButton({
    Name = "Unload & Close Hub (ถอนการติดตั้งสคริปต์)",
    Icon = "✕",
    Callback = function()
        _G.AnimeDice_Cleanup()
    end,
})

-- ── 14. PLAYER PHYSICS, RECONNECT & GOD AURA ENGINE ──────────────────
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Config.WalkSpeedEnabled then
                    hum.WalkSpeed = Config.WalkSpeedValue or 16
                end
                if Config.JumpPowerEnabled then
                    hum.JumpPower = Config.JumpPowerValue or 50
                end
            end

            if Config.FlyEnabled and flyBodyVelocity and flyBodyGyro then
                local cam = workspace.CurrentCamera
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if cam and hrp then
                    local moveDir = Vector3.zero
                    local isKeyDown = function(k) return UserInputService:IsKeyDown(k) end
                    if isKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if isKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if isKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if isKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if isKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if isKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                    if moveDir.Magnitude > 0 then
                        flyBodyVelocity.Velocity = moveDir.Unit * (Config.FlySpeed or 50)
                    else
                        flyBodyVelocity.Velocity = Vector3.zero
                    end
                    flyBodyGyro.CFrame = cam.CFrame
                end
            end
        end)
        task.wait(0.1)
    end
end)

RunService.Stepped:Connect(function()
    if Running and Config.Noclip then
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

UserInputService.JumpRequest:Connect(function()
    if Running and Config.InfiniteJump then
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        task.wait(3.0)
        if Config.AutoReconnect then
            pcall(function()
                local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
                local promptOverlay = promptGui and promptGui:FindFirstChild("promptOverlay")
                if promptOverlay and #promptOverlay:GetChildren() > 0 then
                    local errorTitle = promptOverlay:FindFirstChild("ErrorTitle", true)
                    if errorTitle and errorTitle.Text ~= "" then
                        local ts = game:GetService("TeleportService")
                        ts:Teleport(game.PlaceId, LP)
                    end
                end
            end)
        end
    end
end)

-- LIVE TELEMETRY UPDATER
task.spawn(function()
    while Running and _G.AnimeDiceActiveToken == myToken do
        pcall(function()
            updateMoneyRate()

            local rolls = (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Rolls") and LP.leaderstats.Rolls.Value) or State.TotalRollsSession
            local money = (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Money") and tostring(LP.leaderstats.Money.Value)) or "0"
            local rebirth = (LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Rebirth") and tostring(LP.leaderstats.Rebirth.Value)) or "0"
            local rateFormatted = string.format("+$%s/s", tostring(math.floor(currentMoneyPerSec)))

            StatRolls:Set(tostring(rolls), nil, string.format("+%d this session", State.TotalRollsSession))
            StatCash:Set(money, Color3.fromRGB(250, 204, 21), "Cash in wallet")
            if StatRate and StatRate.Set then
                StatRate:Set(rateFormatted, Color3.fromRGB(34, 211, 238), "Live rate velocity")
            end
            StatRebirth:Set("Rebirth " .. rebirth, Theme.AccentPrimary, string.format("+%d this session", State.TotalRebirthsSession))
            StatPotions:Set(tostring(State.TotalPotionsUsedSession), Theme.AccentCyan, "Consumed potions")
            StatTowerStatus:Set(State.CurrentTowerStatus, Theme.AccentCyan, Config.SelectedTower)

            if StatBuffMonitor and StatBuffMonitor.Set then
                local buffsText = getActiveBuffsSummary()
                StatBuffMonitor:Set("Active", Color3.fromRGB(52, 211, 153), buffsText)
            end

            if StatGradeRerolls and StatGradeRerolls.Set then
                StatGradeRerolls:Set(tostring(State.GradeRerollsSession), Theme.AccentGold, "Upgrades this session")
            end
            if StatTraitRerolls and StatTraitRerolls.Set then
                StatTraitRerolls:Set(tostring(State.TraitRerollsSession), Theme.AccentPrimary, "Traits rolled this session")
            end
            if StatWheelSpins and StatWheelSpins.Set then
                StatWheelSpins:Set(tostring(State.WheelSpinsSession), Theme.AccentCyan, "Spins used this session")
            end
        end)
        task.wait(0.7)
    end
end)

Window:Notify({
    Title = "PROJECT BARUN",
    Content = "Anime Dice Pro Automation Hub loaded successfully!",
    Duration = 5,
    Type = "success",
})

print("[PROJECT BARUN] Anime Dice Pro Hub loaded with 2K Progression Engine & Aurora v3.0!")
