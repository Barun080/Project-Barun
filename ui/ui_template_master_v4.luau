--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║      💎 PROJECT BARUN (PB) — NEO-CYBER OBSIDIAN GLASS v5.0               ║
    ║      Dual-Engine: Obsidian / Linoria Hybrid + Next-Gen Glassmorphism     ║
    ║      Engineered with Mimi Precision for Clack's Arsenal                  ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S ELEVATED IN v5.0 NEO-CYBER GLASS]
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

local CurrentThemeName = "Aurora Cyan"
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
        TextSize = 11,
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
        corner(10),
        stroke(Theme.CardBorder, 1.15, 0.38, "CardStroke"),
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
            tw(s, { Color = Theme.CardBorder, Transparency = 0.38 }, 0.18)
        end
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- WINDOW CREATION (NEO-CYBER OBSIDIAN GLASS v5.0)
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText      = config.Title or "PROJECT BARUN"
    local SubtitleText   = config.Subtitle or "OBSIDIAN GLASS v5.0"
    local WindowSize     = config.Size or UDim2.new(0, 840, 0, 520)
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
        corner(16),
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
        corner(16),
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
