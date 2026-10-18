--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║      💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA ELITE v4.5            ║
    ║      Dual-Engine: Obsidian / Linoria Hybrid + Neo-Cyber Glassmorphism    ║
    ║      Engineered by cook45 with Mimi Precision for Clack's Arsenal        ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S NEW IN v4.5 - OBSIDIAN HYBRID ENGINE]
    • Dual-Column Groupbox Architecture (Obsidian / Linoria style: AddLeftGroupbox & AddRightGroupbox)
    • Universal Element API: Supports both Barun object-config style AND Linoria (id, config) signature
    • Global State Registry: UI.Toggles & UI.Options (Toggles.Key.Value, Options.Key.Value, :OnChanged, :SetValue)
    • Inline Component Attachments: Toggle:AddKeybind() & Toggle:AddColorPicker() inline badges
    • Integrated SaveManager: Full JSON config system (save, load, delete, autoload, config GUI builder)
    • Integrated ThemeManager: 7 Cyber themes (Obsidian, Aurora Cyan, Amethyst, Crimson, Emerald, Amber, Nord)
    • Dynamic Live Theming: Instantly updates all accents, glows, and strokes in real-time
    • Desktop Hotkey (RightShift) + Mobile Floating Draggable Neon Orb (Dual-Mode)
    • Global Real-Time Search Bar: Live card & groupbox element filtering
    • Sleek Watermark System & Live Telemetry (FPS + Ping monitor)
    • 100% Backward Compatible with all v4.0 scripts
--]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local StatsService     = game:GetService("Stats")
local HttpService      = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ─── Color Palettes & Preset Themes ─────────────────────────────────
local Themes = {
    ["Aurora Cyan"] = {
        VoidBg          = Color3.fromRGB(10, 12, 18),
        SurfaceBg       = Color3.fromRGB(16, 18, 27),
        SidebarBg       = Color3.fromRGB(14, 16, 25),
        CardBg          = Color3.fromRGB(23, 26, 40),
        CardHover       = Color3.fromRGB(31, 35, 54),
        CardBorder      = Color3.fromRGB(44, 49, 74),
        CardBorderGlow  = Color3.fromRGB(96, 104, 160),
        InputBg         = Color3.fromRGB(15, 17, 27),
        AccentPrimary   = Color3.fromRGB(139, 92, 246), -- Neon Purple
        AccentSecondary = Color3.fromRGB(59, 130, 246),  -- Cyber Blue
        Accent          = Color3.fromRGB(34, 211, 238),  -- Electric Cyan
        AccentGlow      = Color3.fromRGB(168, 85, 247),
        TextTitle       = Color3.fromRGB(248, 250, 252),
        TextBody        = Color3.fromRGB(203, 213, 225),
        TextDim         = Color3.fromRGB(110, 124, 148),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Obsidian Dark"] = {
        VoidBg          = Color3.fromRGB(10, 10, 12),
        SurfaceBg       = Color3.fromRGB(15, 15, 18),
        SidebarBg       = Color3.fromRGB(13, 13, 16),
        CardBg          = Color3.fromRGB(20, 20, 25),
        CardHover       = Color3.fromRGB(28, 28, 36),
        CardBorder      = Color3.fromRGB(40, 40, 52),
        CardBorderGlow  = Color3.fromRGB(120, 120, 145),
        InputBg         = Color3.fromRGB(14, 14, 18),
        AccentPrimary   = Color3.fromRGB(140, 140, 160),
        AccentSecondary = Color3.fromRGB(90, 90, 110),
        Accent          = Color3.fromRGB(200, 200, 220),
        AccentGlow      = Color3.fromRGB(160, 160, 185),
        TextTitle       = Color3.fromRGB(250, 250, 252),
        TextBody        = Color3.fromRGB(210, 210, 220),
        TextDim         = Color3.fromRGB(115, 115, 130),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Cyber Amethyst"] = {
        VoidBg          = Color3.fromRGB(12, 10, 20),
        SurfaceBg       = Color3.fromRGB(18, 14, 30),
        SidebarBg       = Color3.fromRGB(15, 12, 26),
        CardBg          = Color3.fromRGB(26, 20, 44),
        CardHover       = Color3.fromRGB(36, 28, 60),
        CardBorder      = Color3.fromRGB(56, 42, 90),
        CardBorderGlow  = Color3.fromRGB(147, 85, 247),
        InputBg         = Color3.fromRGB(16, 12, 26),
        AccentPrimary   = Color3.fromRGB(168, 85, 247),
        AccentSecondary = Color3.fromRGB(124, 58, 237),
        Accent          = Color3.fromRGB(192, 132, 252),
        AccentGlow      = Color3.fromRGB(216, 180, 254),
        TextTitle       = Color3.fromRGB(250, 245, 255),
        TextBody        = Color3.fromRGB(220, 210, 235),
        TextDim         = Color3.fromRGB(130, 115, 155),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Blood Crimson"] = {
        VoidBg          = Color3.fromRGB(16, 8, 12),
        SurfaceBg       = Color3.fromRGB(24, 12, 18),
        SidebarBg       = Color3.fromRGB(20, 10, 15),
        CardBg          = Color3.fromRGB(34, 16, 24),
        CardHover       = Color3.fromRGB(48, 22, 34),
        CardBorder      = Color3.fromRGB(80, 32, 50),
        CardBorderGlow  = Color3.fromRGB(225, 29, 72),
        InputBg         = Color3.fromRGB(20, 10, 15),
        AccentPrimary   = Color3.fromRGB(244, 63, 94),
        AccentSecondary = Color3.fromRGB(225, 29, 72),
        Accent          = Color3.fromRGB(251, 113, 133),
        AccentGlow      = Color3.fromRGB(253, 164, 175),
        TextTitle       = Color3.fromRGB(255, 245, 247),
        TextBody        = Color3.fromRGB(235, 210, 218),
        TextDim         = Color3.fromRGB(150, 110, 125),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Emerald Matrix"] = {
        VoidBg          = Color3.fromRGB(8, 16, 12),
        SurfaceBg       = Color3.fromRGB(12, 24, 18),
        SidebarBg       = Color3.fromRGB(10, 20, 15),
        CardBg          = Color3.fromRGB(16, 36, 26),
        CardHover       = Color3.fromRGB(24, 50, 36),
        CardBorder      = Color3.fromRGB(36, 80, 56),
        CardBorderGlow  = Color3.fromRGB(16, 185, 129),
        InputBg         = Color3.fromRGB(10, 22, 16),
        AccentPrimary   = Color3.fromRGB(16, 185, 129),
        AccentSecondary = Color3.fromRGB(5, 150, 105),
        Accent          = Color3.fromRGB(52, 211, 153),
        AccentGlow      = Color3.fromRGB(110, 231, 183),
        TextTitle       = Color3.fromRGB(245, 255, 250),
        TextBody        = Color3.fromRGB(210, 235, 225),
        TextDim         = Color3.fromRGB(110, 150, 130),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Golden Amber"] = {
        VoidBg          = Color3.fromRGB(16, 14, 8),
        SurfaceBg       = Color3.fromRGB(24, 20, 12),
        SidebarBg       = Color3.fromRGB(20, 17, 10),
        CardBg          = Color3.fromRGB(36, 30, 18),
        CardHover       = Color3.fromRGB(50, 42, 24),
        CardBorder      = Color3.fromRGB(80, 66, 36),
        CardBorderGlow  = Color3.fromRGB(245, 158, 11),
        InputBg         = Color3.fromRGB(22, 18, 12),
        AccentPrimary   = Color3.fromRGB(245, 158, 11),
        AccentSecondary = Color3.fromRGB(217, 119, 6),
        Accent          = Color3.fromRGB(251, 191, 36),
        AccentGlow      = Color3.fromRGB(253, 224, 71),
        TextTitle       = Color3.fromRGB(255, 252, 245),
        TextBody        = Color3.fromRGB(235, 230, 215),
        TextDim         = Color3.fromRGB(150, 140, 115),
        Success         = Color3.fromRGB(52, 211, 153),
        Warning         = Color3.fromRGB(251, 191, 36),
        Danger          = Color3.fromRGB(251, 85, 115),
    },
    ["Nord Frost"] = {
        VoidBg          = Color3.fromRGB(12, 15, 20),
        SurfaceBg       = Color3.fromRGB(18, 22, 30),
        SidebarBg       = Color3.fromRGB(15, 19, 26),
        CardBg          = Color3.fromRGB(26, 32, 44),
        CardHover       = Color3.fromRGB(36, 44, 60),
        CardBorder      = Color3.fromRGB(54, 66, 90),
        CardBorderGlow  = Color3.fromRGB(129, 161, 193),
        InputBg         = Color3.fromRGB(16, 20, 28),
        AccentPrimary   = Color3.fromRGB(129, 161, 193),
        AccentSecondary = Color3.fromRGB(94, 129, 172),
        Accent          = Color3.fromRGB(136, 192, 208),
        AccentGlow      = Color3.fromRGB(143, 188, 187),
        TextTitle       = Color3.fromRGB(248, 250, 252),
        TextBody        = Color3.fromRGB(216, 222, 233),
        TextDim         = Color3.fromRGB(120, 134, 156),
        Success         = Color3.fromRGB(163, 190, 140),
        Warning         = Color3.fromRGB(235, 203, 139),
        Danger          = Color3.fromRGB(191, 97, 106),
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
    ThemeTrackers  = {}, -- Holds objects for live theme updates
}
UI.__index = UI

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
            BackgroundTransparency = 0.965,
            Parent = holder,
        }, { pill() })
    end
    return holder
end

local function makeCard(parent, height, interactive)
    local props = {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Theme.CardBg,
        BackgroundTransparency = 0.04,
        Parent = parent,
    }
    if interactive then
        props.AutoButtonColor = false
        props.Text = ""
    end

    return make(interactive and "TextButton" or "Frame", props, {
        corner(10),
        stroke(Theme.CardBorder, 1.1, 0.35, "CardStroke"),
        make("UIGradient", {
            Name = "Sheen",
            Color = ColorSequence.new(WHITE, Color3.fromRGB(205, 205, 222)),
            Rotation = 90,
        }),
        make("Frame", {
            Name = "Highlight",
            Size = UDim2.new(1, -24, 0, 1),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = WHITE,
            BackgroundTransparency = 0.82,
        }, {
            make("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
            }),
        }),
    })
end

local function hoverable(card, accent)
    local s = card:FindFirstChild("CardStroke")
    card.MouseEnter:Connect(function()
        tw(card, { BackgroundColor3 = Theme.CardHover }, 0.16)
        if s then tw(s, { Color = accent or Theme.CardBorderGlow, Transparency = 0.05 }, 0.16) end
    end)
    card.MouseLeave:Connect(function()
        tw(card, { BackgroundColor3 = Theme.CardBg }, 0.16)
        if s then tw(s, { Color = Theme.CardBorder, Transparency = 0.35 }, 0.16) end
    end)
end

-- ═════════════════════════════════════════════════════════════════════
-- WINDOW CREATION (AURORA ELITE v4.5 MASTER SUITE)
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText      = config.Title or "PROJECT BARUN"
    local SubtitleText   = config.Subtitle or "AURORA ELITE v4.5"
    local WindowSize     = config.Size or UDim2.new(0, 840, 0, 520)
    local WindowName     = config.Name or "ProjectBarun_MasterUI"
    local ToggleKey      = config.ToggleKey or config.MenuKeybind or Enum.KeyCode.RightShift
    local ShowMobileBtn  = (config.MobileButton ~= false)
    local AccentColor    = config.Accent or Theme.Accent

    local okHui, huiTarget = pcall(function() return gethui and gethui() end)
    local ParentTarget = (okHui and huiTarget) or CoreGui

    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == WindowName or existing.Name == WindowName .. "_MobileOrb" then
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

    ScreenGui.Destroying:Connect(function()
        for _, c in ipairs(Conns) do
            pcall(function() c:Disconnect() end)
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
        make("UIScale", { Name = "Scale", Scale = 0.9 }),
    })
    local RootScale = Root.Scale

    local Shadow = make("ImageLabel", {
        Name = "AmbientShadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        Size = UDim2.new(1, 76, 1, 76),
        BackgroundTransparency = 1,
        Image = SHADOW_ASSET,
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        Parent = Root,
    })

    -- Chassis
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
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 22, 36)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(12, 14, 22)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(9, 10, 16)),
            }),
            Rotation = 50,
        }),
    })

    -- Ambient orbs
    local Orb1 = orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
    local Orb2 = orb(Main, AccentColor, 400, UDim2.new(0.12, 0, 1.0, 0))
    local Orb3 = orb(Main, Theme.AccentSecondary, 260, UDim2.new(0.62, 0, 0.55, 0))

    -- Orbiting neon border
    local BorderFrame = make("Frame", {
        Name = "Border",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 10,
        Parent = Root,
    }, {
        corner(16),
        make("UIStroke", {
            Name = "Stroke",
            Color = WHITE,
            Thickness = 1.5,
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
                    NumberSequenceKeypoint.new(0.0, 0.1),
                    NumberSequenceKeypoint.new(0.5, 0.78),
                    NumberSequenceKeypoint.new(1.0, 0.1),
                }),
            }),
        }),
    })
    local BorderStroke = BorderFrame.Stroke
    local OrbitGrad = BorderStroke.Orbit

    bind(RunService.RenderStepped, function()
        OrbitGrad.Rotation = (OrbitGrad.Rotation + 0.35) % 360
    end)

    -- Top neon accent line with shimmer
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
                NumberSequenceKeypoint.new(0.15, 0),
                NumberSequenceKeypoint.new(0.85, 0),
                NumberSequenceKeypoint.new(1.0, 1),
            }),
        }),
    })
    local Shimmer = make("Frame", {
        Name = "Shimmer",
        Size = UDim2.new(0, 90, 1, 0),
        Position = UDim2.new(0, -90, 0, 0),
        BackgroundColor3 = WHITE,
        Parent = NeonTopLine,
    }, {
        make("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0.0, 1),
                NumberSequenceKeypoint.new(0.5, 0.35),
                NumberSequenceKeypoint.new(1.0, 1),
            }),
        }),
    })
    task.spawn(function()
        while ScreenGui.Parent do
            Shimmer.Position = UDim2.new(0, -90, 0, 0)
            local t = TweenService:Create(Shimmer, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(1, 40, 0, 0)
            })
            t:Play()
            t.Completed:Wait()
            task.wait(1.5)
        end
    end)

    -- Toast HUD Stack
    local ToastHolder = make("Frame", {
        Name = "ToastHolder",
        Size = UDim2.new(0, 310, 1, -40),
        Position = UDim2.new(1, -330, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = 25,
        Parent = ScreenGui,
    }, {
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 6),
        }),
    })

    -- ─── Watermark System ───────────────────────────────────────────
    local WatermarkFrame = make("Frame", {
        Name = "Watermark",
        Size = UDim2.new(0, 260, 0, 26),
        Position = UDim2.new(0, 20, 0, 12),
        BackgroundColor3 = Color3.fromRGB(15, 18, 28),
        BackgroundTransparency = 0.2,
        Visible = false,
        ZIndex = 30,
        Parent = ScreenGui,
    }, {
        corner(8),
        stroke(AccentColor, 1.2, 0.4, "WmStroke"),
        txt({
            Name = "WmText",
            Text = "PROJECT BARUN | Obsidian Glass v4.5",
            Font = Theme.FontBold,
            TextSize = 10,
            TextColor3 = WHITE,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
        }),
    })

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
                    NumberSequenceKeypoint.new(0.2, 0.55),
                    NumberSequenceKeypoint.new(0.8, 0.55),
                    NumberSequenceKeypoint.new(1.0, 1),
                }),
            }),
        }),
    })

    -- Logo Badge
    local LogoBadgeHolder = make("Frame", {
        Name = "LogoBadgeHolder",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundColor3 = WHITE,
        Parent = TopBar,
    }, {
        corner(10),
        stroke(AccentColor, 1.4, 0.2, "LogoGlowStroke"),
        grad(Color3.fromRGB(30, 34, 60), Color3.fromRGB(12, 14, 24), 45),
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

    -- Titles
    local TitleLabel = txt({
        Name = "Title",
        Text = TitleText,
        Font = Theme.FontBlack,
        TextSize = 13,
        TextColor3 = Theme.TextTitle,
        Position = UDim2.new(0, 62, 0, 13),
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

    -- ─── Real-Time Search Bar ────────────────────────────────────────
    local SearchBoxHolder = make("Frame", {
        Name = "SearchBoxHolder",
        Size = UDim2.new(0, 165, 0, 30),
        Position = UDim2.new(0, 245, 0.5, -15),
        BackgroundColor3 = Theme.InputBg,
        Parent = TopBar,
    }, {
        corner(8),
        stroke(Theme.CardBorder, 1, 0.3, "SearchStroke"),
        txt({
            Name = "SearchIcon",
            Text = "🔍",
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            TextSize = 10,
            TextColor3 = Theme.TextDim,
            TextXAlignment = Enum.TextXAlignment.Center,
        }),
    })

    local SearchInput = make("TextBox", {
        Name = "SearchInput",
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 26, 0, 0),
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
        tw(SearchBoxHolder.SearchStroke, { Color = AccentColor, Transparency = 0.1 }, 0.18)
    end)
    SearchInput.FocusLost:Connect(function()
        tw(SearchBoxHolder.SearchStroke, { Color = Theme.CardBorder, Transparency = 0.3 }, 0.18)
    end)

    -- Live Telemetry Pill
    local TelemetryCard = make("Frame", {
        Name = "TelemetryCard",
        Size = UDim2.new(0, 160, 0, 28),
        Position = UDim2.new(1, -260, 0.5, -14),
        BackgroundColor3 = Color3.fromRGB(20, 23, 36),
        Parent = TopBar,
    }, {
        corner(8),
        stroke(Theme.CardBorder, 1, 0.35),
        txt({
            Name = "PingLabel",
            Text = "Ping: --",
            Font = Theme.FontSemi,
            TextSize = 9.5,
            TextColor3 = AccentColor,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.5, -10, 1, 0),
        }),
        txt({
            Name = "FpsLabel",
            Text = "FPS: --",
            Font = Theme.FontSemi,
            TextSize = 9.5,
            TextColor3 = Theme.Success,
            TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0.5, -10, 1, 0),
        }),
    })

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
            TelemetryCard.FpsLabel.Text = string.format("FPS: %d", fps)
            TelemetryCard.PingLabel.Text = string.format("Ping: %dms", ping)
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
        BackgroundColor3 = Color3.fromRGB(34, 38, 56),
        Text = "—",
        TextColor3 = Theme.TextBody,
        Font = Theme.FontBold,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = WindowControls,
    }, { corner(7), stroke(Theme.CardBorder, 1, 0.4) })

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
        Size = UDim2.new(0, 175, 1, -16),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundColor3 = Theme.SidebarBg,
        BackgroundTransparency = 0.25,
        Parent = ContentHolder,
    }, {
        corner(12),
        stroke(Theme.CardBorder, 1, 0.4),
        make("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
        }),
    })

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

    local PagesContainer = make("Frame", {
        Name = "PagesContainer",
        Size = UDim2.new(1, -210, 1, -16),
        Position = UDim2.new(0, 196, 0, 8),
        BackgroundTransparency = 1,
        Parent = ContentHolder,
    })

    -- ─── Minimize & Visibility Logic ─────────────────────────────────
    local isVisible = false

    local function setWindowVisible(show)
        isVisible = show
        if show then
            Root.Size = WindowSize
            ContentHolder.Visible = true
            Root.Visible = true
            tw(RootScale, { Scale = 1 }, 0.32, Enum.EasingStyle.Back)
            tw(BorderStroke, { Transparency = 0 }, 0.28)
            tw(Shadow, { ImageTransparency = 0.4 }, 0.35)
        else
            tw(RootScale, { Scale = 0.9 }, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tw(BorderStroke, { Transparency = 1 }, 0.22)
            tw(Shadow, { ImageTransparency = 1 }, 0.22)
            task.delay(0.24, function()
                if not isVisible then Root.Visible = false end
            end)
        end
    end

    local function toggleMinimize()
        setWindowVisible(false)
    end

    MinBtn.MouseButton1Click:Connect(toggleMinimize)
    CloseBtn.MouseButton1Click:Connect(function()
        setWindowVisible(false)
    end)

    bind(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            setWindowVisible(not isVisible)
        end
    end)

    -- Window Dragging Physics
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

    -- Mobile Floating Orb
    local FloatingOrb = nil
    if ShowMobileBtn then
        FloatingOrb = make("ImageButton", {
            Name = WindowName .. "_MobileOrb",
            Size = UDim2.fromOffset(46, 46),
            Position = UDim2.new(0, 16, 0.45, 0),
            BackgroundColor3 = Color3.fromRGB(15, 18, 28),
            Image = "rbxassetid://10723415760",
            ImageColor3 = AccentColor,
            AutoButtonColor = false,
            Parent = ScreenGui,
        }, {
            pill(),
            stroke(AccentColor, 1.8, 0.15, "OrbStroke"),
        })

        local orbDrag = false
        local orbStart = Vector2.zero
        local orbPos = UDim2.new()
        local orbMoved = false

        FloatingOrb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                orbDrag = true
                orbStart = input.Position
                orbPos = FloatingOrb.Position
                orbMoved = false

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        orbDrag = false
                        task.delay(0.08, function() orbMoved = false end)
                    end
                end)
            end
        end)

        bind(UserInputService.InputChanged, function(input)
            if orbDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - orbStart
                if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
                    orbMoved = true
                    FloatingOrb.Position = UDim2.new(
                        orbPos.X.Scale,
                        orbPos.X.Offset + delta.X,
                        orbPos.Y.Scale,
                        orbPos.Y.Offset + delta.Y
                    )
                end
            end
        end)

        FloatingOrb.MouseButton1Click:Connect(function()
            if not orbMoved then
                setWindowVisible(not isVisible)
            end
        end)
    end

    -- ─── Window Object ───────────────────────────────────────────────
    local Window = {
        Gui            = ScreenGui,
        Root           = Root,
        Toggles        = UI.Toggles,
        Options        = UI.Options,
        Tabs           = {},
        ActiveTab      = nil,
        Conns          = Conns,
    }

    function Window:SetWatermark(text)
        WatermarkFrame.WmText.Text = tostring(text)
        local bounds = WatermarkFrame.WmText.TextBounds
        WatermarkFrame.Size = UDim2.new(0, math.max(bounds.X + 24, 140), 0, 26)
    end

    function Window:SetWatermarkVisibility(vis)
        WatermarkFrame.Visible = (vis == true)
    end

    function Window:SetKeybind(key)
        ToggleKey = key
    end

    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "System Alert"
        local content = notifConfig.Content or notifConfig.Text or ""
        local duration = notifConfig.Duration or notifConfig.Time or 3.5
        local nType = notifConfig.Type or "info"

        local typeColors = {
            info    = AccentColor,
            success = Theme.Success,
            warning = Theme.Warning,
            danger  = Theme.Danger,
        }
        local accent = typeColors[nType] or AccentColor

        local Toast = make("Frame", {
            Name = "ToastCard",
            Size = UDim2.new(1, 0, 0, 56),
            BackgroundColor3 = Color3.fromRGB(18, 21, 32),
            Parent = ToastHolder,
        }, {
            corner(10),
            stroke(accent, 1.2, 0.25),
            txt({
                Text = title,
                Font = Theme.FontBold,
                TextSize = 11.5,
                TextColor3 = WHITE,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(1, -28, 0, 16),
            }),
            txt({
                Text = content,
                Font = Theme.FontRegular,
                TextSize = 10,
                TextColor3 = Theme.TextBody,
                Position = UDim2.new(0, 14, 0, 26),
                Size = UDim2.new(1, -28, 0, 20),
            }),
            make("Frame", {
                Name = "ProgressBar",
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                BackgroundColor3 = accent,
            }, { pill() }),
        })

        tw(Toast.ProgressBar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
        task.delay(duration, function()
            if Toast and Toast.Parent then
                tw(Toast, { BackgroundTransparency = 1 }, 0.24)
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
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Color3.fromRGB(20, 23, 34),
            BackgroundTransparency = 0.6,
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll,
        }, {
            corner(8),
            stroke(Theme.CardBorder, 1, 0.7, "TabStroke"),
            txt({
                Name = "Icon",
                Text = tabIcon,
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(0, 20, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Center,
            }),
            txt({
                Name = "Label",
                Text = tabName,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextBody,
                Position = UDim2.new(0, 34, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
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
                tw(t.Button, { BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(20, 23, 34) }, 0.18)
                tw(t.Button.Label, { TextColor3 = Theme.TextBody }, 0.18)
                tw(t.Button.Icon, { TextColor3 = Theme.TextDim }, 0.18)
                tw(t.Button.TabStroke, { Transparency = 0.7, Color = Theme.CardBorder }, 0.18)
            end
            Page.Visible = true
            Window.ActiveTab = TabObj
            tw(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = AccentColor }, 0.22)
            tw(TabBtn.Label, { TextColor3 = WHITE }, 0.22)
            tw(TabBtn.Icon, { TextColor3 = WHITE }, 0.22)
            tw(TabBtn.TabStroke, { Transparency = 0.2, Color = WHITE }, 0.22)

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
                    stroke(isToggled and AccentColor or Theme.CardBorder, 1.2, 0.3, "TrackStroke"),
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
                        Size = UDim2.new(0, 32, 0, 18),
                        BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                        Text = keyName == "Unknown" and "[NONE]" or "[" .. keyName .. "]",
                        Font = Theme.FontBold,
                        TextSize = 9,
                        TextColor3 = AccentColor,
                        AutoButtonColor = false,
                        LayoutOrder = -1,
                        Parent = AccessoryStack,
                    }, { corner(4), stroke(Theme.CardBorder, 1, 0.4) })

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
                    }, { corner(4), stroke(Theme.CardBorder, 1, 0.4) })

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

                local ValText = txt({
                    Text = tostring(currentVal) .. suffix,
                    Font = Theme.FontBold,
                    TextSize = 10.5,
                    TextColor3 = AccentColor,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(0.65, 0, 0, 6),
                    Size = UDim2.new(0.35, -12, 0, 16),
                    Parent = SliderCard,
                })

                local Rail = make("Frame", {
                    Size = UDim2.new(1, -24, 0, 5),
                    Position = UDim2.new(0, 12, 0, 31),
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                    Parent = SliderCard,
                }, { pill() })

                local pct = (max == min) and 0 or (currentVal - min) / (max - min)
                local Fill = make("Frame", {
                    Size = UDim2.new(pct, 0, 1, 0),
                    BackgroundColor3 = AccentColor,
                    Parent = Rail,
                }, { pill() })

                local Knob = make("Frame", {
                    Size = UDim2.new(0, 12, 0, 12),
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
                            b.BackgroundColor3 = active and AccentColor or Color3.fromRGB(30, 34, 50)
                            b.TextColor3 = active and WHITE or Theme.TextBody
                        end
                    else
                        Header.SelectedLabel.Text = tostring(selected)
                        for opt, b in pairs(optBtns) do
                            local active = (opt == selected)
                            b.BackgroundColor3 = active and AccentColor or Color3.fromRGB(30, 34, 50)
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
                            BackgroundColor3 = Color3.fromRGB(30, 34, 50),
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
                        tw(Scale, { Scale = 0.97 }, 0.08)
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
                    BackgroundColor3 = Color3.fromRGB(15, 18, 28),
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
                    stroke(Theme.CardBorder, 1, 0.4, "Stroke"),
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
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                    Text = typeof(currentKey) == "EnumItem" and currentKey.Name or tostring(currentKey),
                    Font = Theme.FontBold,
                    TextSize = 10,
                    TextColor3 = AccentColor,
                    AutoButtonColor = false,
                    Parent = KeyCard,
                }, { corner(6), stroke(Theme.CardBorder, 1, 0.4, "KStroke") })

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
                    BackgroundTransparency = 0.5,
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
                BackgroundTransparency = 0.1,
                Parent = targetColumn,
            }, {
                corner(10),
                stroke(Theme.CardBorder, 1.1, 0.4, "GbStroke"),
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                }),
            })

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
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
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
-- INTEGRATED THEME MANAGER
-- ═════════════════════════════════════════════════════════════════════
UI.ThemeManager = {
    Themes = Themes,
}

function UI.ThemeManager:SetTheme(themeName)
    local t = Themes[themeName]
    if not t then return end
    UI.CurrentTheme = themeName
    for k, v in pairs(t) do Theme[k] = v end
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

-- ═════════════════════════════════════════════════════════════════════
-- INTEGRATED SAVE MANAGER (JSON CONFIG ENGINE)
-- ═════════════════════════════════════════════════════════════════════
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
