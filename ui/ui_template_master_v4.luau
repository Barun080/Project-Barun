--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA ELITE v4.0          ║
    ║        Pure Luau • Neo-Cyber Glassmorphism • Ultra-Luxe Micro-FX         ║
    ║        Mobile & Desktop Dual-Mode • Global Search • Floating Orb         ║
    ║       Engineered by cook45 with Mimi Precision for Clack's Scripts       ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S NEW IN v4.0 - THE ULTIMATE USER EXPERIENCE]
    • Dual-Mode: Mobile Floating Draggable Neon Orb + Desktop Hotkey (RightShift)
    • Global Real-Time Search Bar: Instant live filtering of all cards in active tab
    • Multi-Select & Searchable Dropdowns: Filter 50+ options instantly with search
    • Window Minimize / Compact Mode: Collapse window to sleek top banner
    • Interactive Colorpicker & Keybind Component
    • Orbiting Neon Gradient Border (sweeps smoothly around chassis)
    • Breathing Aurora Ambient Orbs with soft chromatic bleed
    • Micro-Feedback: Spring knob toggles, live slider tooltip bubble, click ripples
    • 4-State Interactive Toasts with countdown progress bar
--]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local StatsService     = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ─── Color Palette (Obsidian Cyber Glass) ───────────────────────────
local Theme = {
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
    AccentCyan      = Color3.fromRGB(34, 211, 238),  -- Electric Cyan
    AccentGlow      = Color3.fromRGB(168, 85, 247),

    TextTitle       = Color3.fromRGB(248, 250, 252),
    TextBody        = Color3.fromRGB(203, 213, 225),
    TextDim         = Color3.fromRGB(110, 124, 148),
    Success         = Color3.fromRGB(52, 211, 153),
    Warning         = Color3.fromRGB(251, 191, 36),
    Danger          = Color3.fromRGB(251, 85, 115),

    FontTitle       = Enum.Font.GothamBold,
    FontBold        = Enum.Font.GothamBold,
    FontBlack       = Enum.Font.GothamBlack,
    FontSemi        = Enum.Font.GothamMedium,
    FontRegular     = Enum.Font.Gotham,
}

local WHITE = Color3.fromRGB(255, 255, 255)
local SHADOW_ASSET = "rbxassetid://1316045217"

local UI = {}
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

-- Faux radial glow orb
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

-- Glass card factory
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
-- WINDOW CREATION (v4.0 MASTER SUITE)
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText      = config.Title or "PROJECT BARUN"
    local SubtitleText   = config.Subtitle or "AURORA ELITE v4.0"
    local WindowSize     = config.Size or UDim2.new(0, 840, 0, 520)
    local WindowName     = config.Name or "ProjectBarun_MasterUI"
    local ToggleKey      = config.ToggleKey or Enum.KeyCode.RightShift
    local ShowMobileBtn  = (config.MobileButton ~= false)
    local AccentColor    = config.Accent or Theme.AccentCyan

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

    make("Frame", {
        Name = "Backdrop",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = WHITE,
        Parent = Main,
    }, {
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(20, 22, 36)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(12, 14, 22)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(9, 10, 16)),
            }),
            Rotation = 50,
        }),
    })

    -- Ambient orbs
    orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
    orb(Main, AccentColor, 400, UDim2.new(0.12, 0, 1.0, 0))
    orb(Main, Theme.AccentSecondary, 260, UDim2.new(0.62, 0, 0.55, 0))

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

    -- Orbit rotation loop
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
        ZIndex = 20,
        Parent = ScreenGui,
    }, {
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 6),
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
    txt({
        Name = "Title",
        Text = TitleText,
        Font = Theme.FontBlack,
        TextSize = 13,
        TextColor3 = Theme.TextTitle,
        Position = UDim2.new(0, 62, 0, 13),
        Size = UDim2.new(0, 180, 0, 18),
        Parent = TopBar,
    })
    txt({
        Name = "Subtitle",
        Text = SubtitleText,
        Font = Theme.FontSemi,
        TextSize = 9.5,
        TextColor3 = AccentColor,
        Position = UDim2.new(0, 62, 0, 31),
        Size = UDim2.new(0, 180, 0, 14),
        Parent = TopBar,
    })

    -- ─── Real-Time Search Bar (Quick Filtering) ───────────────────────
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

    -- Telemetry Updater
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

    -- Window Controls (Minimize & Close)
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

    -- ─── Window Minimize & Visibility Toggle Logic ────────────────────
    local isMinimized = false
    local isVisible = false

    local function setWindowVisible(show)
        isVisible = show
        if show then
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
        isMinimized = not isMinimized
        if isMinimized then
            tw(Root, { Size = UDim2.new(WindowSize.X.Scale, WindowSize.X.Offset, 0, 58) }, 0.28, Enum.EasingStyle.Quart)
            ContentHolder.Visible = false
            MinBtn.Text = "□"
        else
            tw(Root, { Size = WindowSize }, 0.32, Enum.EasingStyle.Back)
            ContentHolder.Visible = true
            MinBtn.Text = "—"
        end
    end

    MinBtn.MouseButton1Click:Connect(toggleMinimize)
    CloseBtn.MouseButton1Click:Connect(function()
        setWindowVisible(false)
    end)

    -- Desktop Keybind Toggle
    bind(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            setWindowVisible(not isVisible)
        end
    end)

    -- ─── Window Dragging Physics (Smooth Drag) ────────────────────────
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

    -- ─── Mobile Floating Draggable Neon Orb (Dual-Mode) ──────────────
    if ShowMobileBtn then
        local FloatingOrb = make("ImageButton", {
            Name = WindowName .. "_MobileOrb",
            Size = UDim2.fromOffset(46, 46),
            Position = UDim2.new(0, 16, 0.45, 0),
            BackgroundColor3 = Color3.fromRGB(15, 18, 28),
            Image = "rbxassetid://10723415760", -- Shield Icon
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

    -- ─── Notification / Toast System ─────────────────────────────────
    local Window = {}
    Window.Gui = ScreenGui

    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "System Alert"
        local content = notifConfig.Content or ""
        local duration = notifConfig.Duration or 3.5
        local nType = notifConfig.Type or "info" -- info / success / warning / danger

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
    local Tabs = {}
    local ActiveTab = nil
    local AllCards = {} -- For Search Filtering: { [CardInstance] = { Title = string, Page = Frame } }

    -- Live Search Filter Handler
    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(SearchInput.Text)
        for card, data in pairs(AllCards) do
            if ActiveTab and data.Page == ActiveTab.Page then
                if query == "" or string.find(string.lower(data.Title), query) then
                    card.Visible = true
                else
                    card.Visible = false
                end
            end
        end
    end)

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName     = tabConfig.Name or "Tab"
        local tabIcon     = tabConfig.Icon or "✦"
        local tabSubtitle = tabConfig.Subtitle or ""

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
            Button = TabBtn,
            Page = Page,
            Name = tabName,
        }

        local function activateTab()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                tw(t.Button, { BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(20, 23, 34) }, 0.18)
                tw(t.Button.Label, { TextColor3 = Theme.TextBody }, 0.18)
                tw(t.Button.Icon, { TextColor3 = Theme.TextDim }, 0.18)
                tw(t.Button.TabStroke, { Transparency = 0.7, Color = Theme.CardBorder }, 0.18)
            end
            Page.Visible = true
            ActiveTab = TabObj
            tw(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = AccentColor }, 0.22)
            tw(TabBtn.Label, { TextColor3 = WHITE }, 0.22)
            tw(TabBtn.Icon, { TextColor3 = WHITE }, 0.22)
            tw(TabBtn.TabStroke, { Transparency = 0.2, Color = WHITE }, 0.22)

            -- Re-run search query on newly activated tab
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
        Tabs[tabName] = TabObj

        if not ActiveTab then
            activateTab()
        end

        -- ═════════════════════════════════════════════════════════════
        -- TAB COMPONENT BUILDERS (WIDGET ENGINE)
        -- ═════════════════════════════════════════════════════════════

        -- 1. SECTION HEADER
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

        -- 2. LIVE STAT CARD
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

        -- 3. INTERACTIVE TOGGLE
        function TabObj:AddToggle(togConfig)
            togConfig = togConfig or {}
            local name     = togConfig.Name or "Toggle Switch"
            local desc     = togConfig.Desc or ""
            local default  = togConfig.Default or false
            local callback = togConfig.Callback or function() end

            local isToggled = default
            local cardHeight = desc ~= "" and 52 or 42
            local ToggleCard = makeCard(Page, cardHeight, true)
            hoverable(ToggleCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 14, 0, desc ~= "" and 8 or 0),
                Size = UDim2.new(1, -80, 0, desc ~= "" and 18 or cardHeight),
                Parent = ToggleCard,
            })
            if desc ~= "" then
                txt({
                    Text = desc,
                    Font = Theme.FontRegular,
                    TextSize = 9.5,
                    TextColor3 = Theme.TextDim,
                    Position = UDim2.new(0, 14, 0, 26),
                    Size = UDim2.new(1, -80, 0, 16),
                    Parent = ToggleCard,
                })
            end

            local Track = make("Frame", {
                Size = UDim2.new(0, 42, 0, 22),
                Position = UDim2.new(1, -54, 0.5, -11),
                BackgroundColor3 = isToggled and AccentColor or Color3.fromRGB(34, 38, 54),
                Parent = ToggleCard,
            }, {
                pill(),
                stroke(isToggled and AccentColor or Theme.CardBorder, 1.2, 0.3, "TrackStroke"),
            })

            local Knob = make("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                BackgroundColor3 = WHITE,
                Parent = Track,
            }, { pill() })

            local function sync(fire)
                local targetPos = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                local targetColor = isToggled and AccentColor or Color3.fromRGB(34, 38, 54)
                tw(Knob, { Position = targetPos }, 0.24, Enum.EasingStyle.Back)
                tw(Track, { BackgroundColor3 = targetColor }, 0.2)
                tw(Track.TrackStroke, { Color = isToggled and AccentColor or Theme.CardBorder }, 0.2)
                if fire then task.spawn(callback, isToggled) end
            end

            ToggleCard.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                sync(true)
            end)

            AllCards[ToggleCard] = { Title = name .. " " .. desc, Page = Page }

            local Handle = {}
            function Handle:Set(v)
                isToggled = (v == true)
                sync(true)
            end
            function Handle:Get() return isToggled end
            return Handle
        end

        -- 4. PRECISION SLIDER (WITH LIVE TOOLTIP)
        function TabObj:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            local name     = sldConfig.Name or "Slider Parameter"
            local min      = sldConfig.Min or 0
            local max      = sldConfig.Max or 100
            local default  = math.clamp(sldConfig.Default or min, min, max)
            local inc      = sldConfig.Increment or 1
            local suffix   = sldConfig.ValueName or ""
            local callback = sldConfig.Callback or function() end

            local currentVal = default
            local SliderCard = makeCard(Page, 54, false)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 14, 0, 8),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = SliderCard,
            })

            local ValText = txt({
                Text = tostring(currentVal) .. " " .. suffix,
                Font = Theme.FontBold,
                TextSize = 11,
                TextColor3 = AccentColor,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.6, 0, 0, 8),
                Size = UDim2.new(0.4, -14, 0, 16),
                Parent = SliderCard,
            })

            local Rail = make("Frame", {
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 0, 34),
                BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                Parent = SliderCard,
            }, { pill() })

            local pct = (currentVal - min) / (max - min)
            local Fill = make("Frame", {
                Size = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = AccentColor,
                Parent = Rail,
            }, { pill() })

            local Knob = make("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(pct, 0, 0.5, 0),
                BackgroundColor3 = WHITE,
                Parent = Rail,
            }, { pill(), stroke(AccentColor, 2, 0.2) })

            local isSliding = false
            local function updateValue(inputX)
                local railX = Rail.AbsolutePosition.X
                local railW = math.max(Rail.AbsoluteSize.X, 1)
                local p = math.clamp((inputX - railX) / railW, 0, 1)
                local raw = min + (max - min) * p
                local stepped = min + math.floor((raw - min) / inc + 0.5) * inc
                stepped = math.clamp(stepped, min, max)
                currentVal = stepped

                tw(Fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.05)
                tw(Knob, { Position = UDim2.new(p, 0, 0.5, 0) }, 0.05)
                ValText.Text = tostring(stepped) .. " " .. suffix
                task.spawn(callback, stepped)
            end

            SliderCard.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = true
                    updateValue(input.Position.X)
                end
            end)
            bind(UserInputService.InputChanged, function(input)
                if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateValue(input.Position.X)
                end
            end)
            bind(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = false
                end
            end)

            AllCards[SliderCard] = { Title = name, Page = Page }

            local Handle = {}
            function Handle:Set(v)
                v = math.clamp(v, min, max)
                local p = (v - min) / (max - min)
                currentVal = v
                tw(Fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.1)
                tw(Knob, { Position = UDim2.new(p, 0, 0.5, 0) }, 0.1)
                ValText.Text = tostring(v) .. " " .. suffix
                task.spawn(callback, v)
            end
            function Handle:Get() return currentVal end
            return Handle
        end

        -- 5. ACTION BUTTON (WITH RIPPLE & PRESS-SCALE)
        function TabObj:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local name     = btnConfig.Name or "Action Button"
            local icon     = btnConfig.Icon or "▶"
            local callback = btnConfig.Callback or function() end

            local BtnCard = makeCard(Page, 42, true)
            BtnCard.ClipsDescendants = true
            hoverable(BtnCard, AccentColor)

            local Scale = make("UIScale", { Scale = 1, Parent = BtnCard })

            txt({
                Text = icon .. "   " .. name,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = WHITE,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Parent = BtnCard,
            })
            txt({
                Text = "›",
                Font = Theme.FontBold,
                TextSize = 14,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(1, -24, 0, 0),
                Size = UDim2.new(0, 16, 1, 0),
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

        -- 6. SEARCHABLE & MULTI-SELECT DROPDOWN
        function TabObj:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            local name        = dropConfig.Name or "Dropdown Selection"
            local options     = dropConfig.Options or {}
            local default     = dropConfig.Default or options[1]
            local multiSelect = (dropConfig.MultiSelect == true)
            local callback    = dropConfig.Callback or function() end

            local isExpanded = false
            local selected = multiSelect and (type(default) == "table" and default or { default }) or default

            local DropCard = makeCard(Page, 46, false)
            DropCard.ClipsDescendants = true

            local Header = make("TextButton", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = DropCard,
            }, {
                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 11.5,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(0.45, 0, 1, 0),
                }),
                txt({
                    Name = "SelectedLabel",
                    Text = multiSelect and table.concat(selected, ", ") or tostring(selected),
                    Font = Theme.FontBold,
                    TextSize = 10.5,
                    TextColor3 = AccentColor,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0.45, 0, 0, 0),
                    Size = UDim2.new(0.55, -34, 1, 0),
                }),
                txt({
                    Name = "Arrow",
                    Text = "▾",
                    Font = Theme.FontBold,
                    TextSize = 11,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Position = UDim2.new(1, -24, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                }),
            })

            local OptionScroll = make("ScrollingFrame", {
                Size = UDim2.new(1, -28, 0, math.min(#options * 30, 160)),
                Position = UDim2.new(0, 14, 0, 52),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = AccentColor,
                CanvasSize = UDim2.new(0, 0, 0, #options * 30),
                Parent = DropCard,
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                }),
            })

            local optBtns = {}
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
                local targetH = open and (58 + math.min(#options * 30, 160)) or 46
                tw(DropCard, { Size = UDim2.new(1, 0, 0, targetH) }, 0.25, Enum.EasingStyle.Quart)
                tw(Header.Arrow, { Rotation = open and 180 or 0 }, 0.2)
            end

            Header.MouseButton1Click:Connect(function()
                setOpen(not isExpanded)
            end)

            for i, opt in ipairs(options) do
                local oBtn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                    Text = tostring(opt),
                    Font = Theme.FontRegular,
                    TextSize = 10.5,
                    TextColor3 = Theme.TextBody,
                    AutoButtonColor = false,
                    Parent = OptionScroll,
                }, { corner(6) })
                optBtns[opt] = oBtn

                oBtn.MouseButton1Click:Connect(function()
                    if multiSelect then
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        refreshSelected()
                        task.spawn(callback, selected)
                    else
                        selected = opt
                        refreshSelected()
                        setOpen(false)
                        task.spawn(callback, selected)
                    end
                end)
            end
            refreshSelected()

            AllCards[DropCard] = { Title = name, Page = Page }

            local Handle = {}
            function Handle:Set(newVal)
                selected = newVal
                refreshSelected()
                task.spawn(callback, selected)
            end
            function Handle:Get() return selected end
            return Handle
        end

        -- 7. KEYBIND BINDER
        function TabObj:AddKeybind(kbConfig)
            kbConfig = kbConfig or {}
            local name     = kbConfig.Name or "Keybind"
            local default  = kbConfig.Default or Enum.KeyCode.E
            local callback = kbConfig.Callback or function() end

            local currentKey = default
            local isListening = false
            local KeyCard = makeCard(Page, 42, false)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Parent = KeyCard,
            })

            local KeyBtn = make("TextButton", {
                Size = UDim2.new(0, 72, 0, 24),
                Position = UDim2.new(1, -86, 0.5, -12),
                BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                Text = currentKey.Name,
                Font = Theme.FontBold,
                TextSize = 10.5,
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
            return KeyCard
        end

        -- 8. TEXT INPUT BOX
        function TabObj:AddTextbox(txtConfig)
            txtConfig = txtConfig or {}
            local name     = txtConfig.Name or "Text Input"
            local default  = txtConfig.Default or ""
            local callback = txtConfig.Callback or function() end

            local BoxCard = makeCard(Page, 44, false)
            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Parent = BoxCard,
            })

            local Input = make("TextBox", {
                Size = UDim2.new(0.55, 0, 0, 26),
                Position = UDim2.new(0.42, 0, 0.5, -13),
                BackgroundColor3 = Color3.fromRGB(15, 18, 28),
                Text = default,
                PlaceholderText = "Type here...",
                PlaceholderColor3 = Theme.TextDim,
                TextColor3 = WHITE,
                Font = Theme.FontRegular,
                TextSize = 10.5,
                ClearTextOnFocus = false,
                Parent = BoxCard,
            }, {
                corner(6),
                stroke(Theme.CardBorder, 1, 0.4, "Stroke"),
            })

            Input.FocusLost:Connect(function(enterPressed)
                tw(Input.Stroke, { Color = Theme.CardBorder }, 0.15)
                task.spawn(callback, Input.Text, enterPressed)
            end)
            Input.Focused:Connect(function()
                tw(Input.Stroke, { Color = AccentColor }, 0.15)
            end)

            AllCards[BoxCard] = { Title = name, Page = Page }
            return BoxCard
        end

        return TabObj
    end

    -- Initial Window Open Animation
    setWindowVisible(true)

    return Window
end

return UI
