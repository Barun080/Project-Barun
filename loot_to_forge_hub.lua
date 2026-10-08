--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA EDITION v3.0        ║
    ║        Pure Luau • Neo-Cyber Glassmorphism • Ultra-Luxe Micro-FX         ║
    ║       Engineered by cook45 with Mimi Precision for Clack's Scripts       ║
    ║        Loot To Forge Master God Auto Farm & Smart Slicing Engine         ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S NEW IN AURORA v3.0]
    • Aurora ambient orbs inside the chassis (soft violet / cyan light bleed)
    • Orbiting gradient border (light sweeps around the window edge)
    • CanvasGroup chassis: true rounded clipping + whole-window fade in/out
    • Floating glass sidebar with gradient active-tab fill, glow pill & hover slide
    • Glass cards: vertical sheen, top highlight hairline, hover glow stroke
    • Toggle: gradient track, glow halo, spring knob
    • Slider: gradient fill, glow knob, floating live tooltip bubble
    • Button: press-scale + click ripple + sliding chevron
    • Dropdown: rotating arrow, selected-item highlight with check mark
    • Textbox: neon focus ring
    • Toasts: typed colors (info/success/warning/error), progress bar, stack glide
    • Smooth momentum dragging, hotkey toggle (RightShift by default)
    • 4-Layer 24/7 Anti-AFK & Anti-Kick Defense Engine
    • Token Lifecycle management with auto-cleanup of previous sessions
]]

-- ═══════════════════════════════════════════════════════════════════
-- 1. TOKEN LIFECYCLE & CLEANUP ENGINE
-- ═══════════════════════════════════════════════════════════════════
local myToken = tick()
_G.LootToForgeActiveToken = myToken

if _G.LootToForgeCleanup then
    pcall(_G.LootToForgeCleanup)
    task.wait(0.2)
end

local Running = true
_G.LootToForgeRunning = true

_G.LootToForgeCleanup = function()
    Running = false
    _G.LootToForgeRunning = false
    pcall(function()
        local h = gethui and gethui() or game:GetService("CoreGui")
        for _, g in ipairs(h:GetChildren()) do
            if g.Name == "ProjectBarunForge" or g.Name == "Orion" or g.Name == "ProjectBarun_LootToForge" then
                g:Destroy()
            end
        end
        local lp = game:GetService("Players").LocalPlayer
        local pg = lp and lp:FindFirstChild("PlayerGui")
        if pg then
            for _, g in ipairs(pg:GetChildren()) do
                if g.Name == "ProjectBarunForge" or g.Name == "Orion" or g.Name == "ProjectBarun_LootToForge" then
                    g:Destroy()
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- 2. CORE SERVICES & DEPENDENCIES
-- ═══════════════════════════════════════════════════════════════════
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local Players            = game:GetService("Players")
local HttpService        = game:GetService("HttpService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ═══════════════════════════════════════════════════════════════════
-- 3. 4-LAYER 24/7 ANTI-AFK & ANTI-KICK DEFENSE ENGINE
-- ═══════════════════════════════════════════════════════════════════
pcall(function()
    if getconnections then
        for _, c in ipairs(getconnections(LocalPlayer.Idled)) do
            pcall(function() c:Disable() end)
        end
    end
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            if vu then
                vu:CaptureController()
                vu:ClickButton2(Vector2.zero)
            end
        end)
    end)
end)

task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        task.wait(35)
        pcall(function()
            local vu = game:GetService("VirtualUser")
            if vu then
                vu:CaptureController()
                vu:ClickButton2(Vector2.zero)
            end
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- 4. 💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA EDITION v3.0
-- ═══════════════════════════════════════════════════════════════════
local Theme = {
    VoidBg          = Color3.fromRGB(10, 12, 18),
    SurfaceBg       = Color3.fromRGB(16, 18, 27),
    SidebarBg       = Color3.fromRGB(14, 16, 25),
    CardBg          = Color3.fromRGB(23, 26, 40),
    CardHover       = Color3.fromRGB(31, 35, 54),
    CardBorder      = Color3.fromRGB(44, 49, 74),
    CardBorderGlow  = Color3.fromRGB(96, 104, 160),
    InputBg         = Color3.fromRGB(15, 17, 27),

    AccentPrimary   = Color3.fromRGB(139, 92, 246),
    AccentSecondary = Color3.fromRGB(59, 130, 246),
    AccentCyan      = Color3.fromRGB(34, 211, 238),
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
    for k, v in pairs(props) do
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
    for i = 1, 10 do
        local s = 1 - (i - 1) * 0.09
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

-- ═════════════════════════════════════════════════════════════════
-- WINDOW CREATION
-- ═════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText    = config.Title or config.Name or "PROJECT BARUN"
    local SubtitleText = config.Subtitle or "LOOT TO FORGE • MASTER HUB v3.0"
    local WindowSize   = config.Size or UDim2.new(0, 720, 0, 500)
    local WindowName   = config.Name or "ProjectBarunForge"
    local ToggleKey    = config.ToggleKey or Enum.KeyCode.RightShift

    local okHui, huiTarget = pcall(function()
        return gethui and gethui()
    end)
    local ParentTarget = (okHui and huiTarget) or CoreGui

    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == WindowName or existing.Name == "ProjectBarunForge" or existing.Name == "Orion" then
            pcall(function() existing:Destroy() end)
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
            c:Disconnect()
        end
    end)

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

    local Main = make("CanvasGroup", {
        Name = "MainChassis",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        GroupTransparency = 1,
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

    orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
    orb(Main, Theme.AccentCyan, 400, UDim2.new(0.12, 0, 1.0, 0))
    orb(Main, Theme.AccentSecondary, 260, UDim2.new(0.62, 0, 0.55, 0))

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
                    ColorSequenceKeypoint.new(0.33, Theme.AccentCyan),
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
                ColorSequenceKeypoint.new(0.5, Theme.AccentCyan),
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

    local PB_LOGO_ASSET = "rbxassetid://71495519688848"
    local LOGO_FILE = "ProjectBarun_Logo.png"
    local LOGO_URL = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/Gemini_Generated_Image_7m1xbd7m1xbd7m1x.jpg"

    local LogoBadgeHolder = make("Frame", {
        Name = "LogoBadgeHolder",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundColor3 = WHITE,
        Parent = TopBar,
    }, {
        corner(10),
        stroke(Theme.AccentCyan, 1.4, 0.2, "LogoGlowStroke"),
        grad(Color3.fromRGB(30, 34, 60), Color3.fromRGB(12, 14, 24), 45),
        txt({
            Name = "FallbackText",
            Size = UDim2.new(1, 0, 1, 0),
            Text = "PB",
            Font = Theme.FontBlack,
            TextSize = 16,
            TextColor3 = Theme.AccentCyan,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 1,
        }),
        make("ImageLabel", {
            Name = "ProjectBarunLogo",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = PB_LOGO_ASSET,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 2,
        }, { corner(10) }),
    })
    local LogoStroke = LogoBadgeHolder.LogoGlowStroke

    txt({
        Name = "Title",
        Text = TitleText,
        Font = Theme.FontTitle,
        TextSize = 16,
        TextColor3 = WHITE,
        Position = UDim2.new(0, 64, 0, 11),
        Size = UDim2.new(0, 260, 0, 18),
        Parent = TopBar,
    }, {
        make("UIGradient", {
            Color = ColorSequence.new(WHITE, Color3.fromRGB(180, 225, 255)),
        }),
    })

    txt({
        Name = "Subtitle",
        Text = string.upper(SubtitleText),
        Font = Theme.FontBold,
        TextSize = 9,
        TextColor3 = Theme.AccentCyan,
        Position = UDim2.new(0, 64, 0, 31),
        Size = UDim2.new(0, 260, 0, 14),
        Parent = TopBar,
    })

    local PerfPill = make("Frame", {
        Name = "PerfPill",
        Size = UDim2.new(0, 156, 0, 26),
        Position = UDim2.new(1, -252, 0, 16),
        BackgroundColor3 = Theme.CardBg,
        BackgroundTransparency = 0.1,
        Parent = TopBar,
    }, {
        pill(),
        stroke(Theme.CardBorder, 1, 0.3),
        make("Frame", {
            Name = "Dot",
            Size = UDim2.new(0, 7, 0, 7),
            Position = UDim2.new(0, 12, 0.5, -3),
            BackgroundColor3 = Theme.Success,
        }, { pill() }),
        txt({
            Name = "PerfText",
            Text = "60 FPS  •  38 ms",
            Font = Theme.FontSemi,
            TextSize = 11,
            TextColor3 = Theme.TextBody,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2.new(0, 22, 0, 0),
            Size = UDim2.new(1, -28, 1, 0),
        }),
    })

    local WindowControls = make("Frame", {
        Size = UDim2.new(0, 70, 0, 28),
        Position = UDim2.new(1, -84, 0, 15),
        BackgroundTransparency = 1,
        Parent = TopBar,
    }, {
        make("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
        }),
    })

    local function controlButton(text, textColor, bg, border, hoverBg, hoverText, order)
        local b = make("TextButton", {
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = bg,
            Text = text,
            Font = Theme.FontTitle,
            TextColor3 = textColor,
            TextSize = text == "✕" and 11 or 16,
            AutoButtonColor = false,
            LayoutOrder = order,
            Parent = WindowControls,
        }, {
            corner(8),
            stroke(border, 1, 0.2),
        })
        b.MouseEnter:Connect(function()
            tw(b, { BackgroundColor3 = hoverBg, TextColor3 = hoverText }, 0.15)
        end)
        b.MouseLeave:Connect(function()
            tw(b, { BackgroundColor3 = bg, TextColor3 = textColor }, 0.15)
        end)
        return b
    end

    local MinBtn = controlButton("–", Theme.TextBody, Theme.CardBg, Theme.CardBorder, Theme.CardHover, WHITE, 1)
    local CloseBtn = controlButton("✕", Theme.Danger, Color3.fromRGB(38, 20, 28), Color3.fromRGB(80, 34, 46), Theme.Danger, WHITE, 2)

    local function makeDraggable(handle, target)
        local dragging, dragStart, startPos = false, nil, nil
        local goalX, goalY = nil, nil
        local api = { Moved = false }

        bind(handle.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                api.Moved = false
                dragStart = input.Position
                startPos = target.Position
                goalX, goalY = startPos.X.Offset, startPos.Y.Offset
            end
        end)
        bind(UserInputService.InputChanged, function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                if d.Magnitude > 4 then api.Moved = true end
                goalX = startPos.X.Offset + d.X
                goalY = startPos.Y.Offset + d.Y
            end
        end)
        bind(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        bind(RunService.RenderStepped, function(dt)
            if goalX then
                local cur = target.Position
                local a = 1 - math.exp(-dt * 20)
                local nx = cur.X.Offset + (goalX - cur.X.Offset) * a
                local ny = cur.Y.Offset + (goalY - cur.Y.Offset) * a
                if not dragging and math.abs(goalX - nx) < 0.4 and math.abs(goalY - ny) < 0.4 then
                    nx, ny = goalX, goalY
                    goalX = nil
                end
                target.Position = UDim2.new(startPos.X.Scale, nx, startPos.Y.Scale, ny)
            end
        end)
        return api
    end

    makeDraggable(TopBar, Root)

    local FloatingBadge = make("ImageButton", {
        Name = "FloatingBadge",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(0, 52, 0, 52),
        Position = UDim2.new(0, 50, 0, 146),
        BackgroundColor3 = WHITE,
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 30,
        Parent = ScreenGui,
    }, {
        make("UIScale", { Name = "Scale", Scale = 0 }),
        corner(15),
        stroke(Theme.AccentCyan, 2, 0.1, "BadgeStroke"),
        grad(Color3.fromRGB(28, 32, 56), Color3.fromRGB(10, 12, 20), 45),
        txt({
            Name = "BadgeFallback",
            Text = "PB",
            Font = Theme.FontBlack,
            TextSize = 20,
            TextColor3 = Theme.AccentCyan,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 30,
        }),
        make("ImageLabel", {
            Name = "BadgeLogo",
            Size = UDim2.new(1, -6, 1, -6),
            Position = UDim2.new(0, 3, 0, 3),
            BackgroundTransparency = 1,
            Image = PB_LOGO_ASSET,
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 31,
        }, { corner(12) }),
    })
    local BadgeScale = FloatingBadge.Scale
    local BadgeStroke = FloatingBadge.BadgeStroke
    local BadgeDrag = makeDraggable(FloatingBadge, FloatingBadge)

    task.spawn(function()
        local function applyLogo(asset)
            if LogoBadgeHolder.Parent and FloatingBadge.Parent then
                LogoBadgeHolder.ProjectBarunLogo.Image = asset
                FloatingBadge.BadgeLogo.Image = asset
            end
        end
        pcall(function()
            if getcustomasset and (isfile and isfile(LOGO_FILE)) then
                applyLogo(getcustomasset(LOGO_FILE))
            elseif getcustomasset and writefile and game.HttpGet then
                local imgBytes = game:HttpGet(LOGO_URL)
                if imgBytes and #imgBytes > 0 then
                    writefile(LOGO_FILE, imgBytes)
                    applyLogo(getcustomasset(LOGO_FILE))
                end
            end
        end)
    end)

    local visible, busy = false, false

    local function setVisible(state, showBadge)
        if busy or visible == state then return end
        busy = true
        visible = state

        if state then
            if FloatingBadge.Visible then
                tw(BadgeScale, { Scale = 0 }, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                task.wait(0.18)
                FloatingBadge.Visible = false
            end
            Root.Visible = true
            RootScale.Scale = 0.9
            tw(RootScale, { Scale = 1 }, 0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            tw(Main, { GroupTransparency = 0 }, 0.3)
            tw(BorderStroke, { Transparency = 0 }, 0.4)
            tw(Shadow, { ImageTransparency = 0.4 }, 0.4)
        else
            tw(RootScale, { Scale = 0.88 }, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tw(Main, { GroupTransparency = 1 }, 0.2)
            tw(BorderStroke, { Transparency = 1 }, 0.2)
            tw(Shadow, { ImageTransparency = 1 }, 0.2)
            task.wait(0.22)
            Root.Visible = false
            if showBadge then
                FloatingBadge.Visible = true
                BadgeScale.Scale = 0
                tw(BadgeScale, { Scale = 1 }, 0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end
        end
        busy = false
    end

    MinBtn.MouseButton1Click:Connect(function()
        task.spawn(setVisible, false, true)
    end)
    FloatingBadge.MouseButton1Click:Connect(function()
        if BadgeDrag.Moved then return end
        task.spawn(setVisible, true)
    end)
    bind(UserInputService.InputBegan, function(input, processed)
        if processed then return end
        if input.KeyCode == ToggleKey then
            task.spawn(setVisible, not visible, false)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        task.spawn(function()
            busy = true
            tw(RootScale, { Scale = 0.85 }, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            tw(Main, { GroupTransparency = 1 }, 0.22)
            tw(BorderStroke, { Transparency = 1 }, 0.2)
            tw(Shadow, { ImageTransparency = 1 }, 0.2)
            task.wait(0.26)
            ScreenGui:Destroy()
        end)
    end)

    do
        local t, acc, frames = 0, 0, 0
        local Stats = game:GetService("Stats")
        bind(RunService.Heartbeat, function(dt)
            t += dt

            OrbitGrad.Rotation = (t * 42) % 360

            local pulse = (math.sin(t * 2.2) + 1) / 2
            LogoStroke.Transparency = 0.45 - pulse * 0.3
            LogoStroke.Color = Theme.AccentCyan:Lerp(Theme.AccentPrimary, pulse)
            BadgeStroke.Transparency = 0.4 - pulse * 0.3
            BadgeStroke.Color = Theme.AccentCyan:Lerp(Theme.AccentPrimary, pulse)

            local cycle = (t % 4.5) / 4.5
            Shimmer.Position = UDim2.new(cycle * 1.4 - 0.2, -45, 0, 0)

            frames += 1
            acc += dt
            if acc >= 0.8 then
                local fps = math.floor(frames / acc + 0.5)
                frames, acc = 0, 0
                local ping = 0
                pcall(function()
                    ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                end)
                local color = fps >= 50 and Theme.Success or (fps >= 30 and Theme.Warning or Theme.Danger)
                PerfPill.PerfText.Text = string.format("%d FPS  •  %d ms", fps, ping)
                tw(PerfPill.Dot, { BackgroundColor3 = color }, 0.3)
            end
        end)
    end

    local Body = make("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -58),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Sidebar = make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 180, 1, -12),
        Position = UDim2.new(0, 10, 0, 4),
        BackgroundColor3 = Theme.SidebarBg,
        BackgroundTransparency = 0.3,
        Parent = Body,
    }, {
        corner(13),
        stroke(Theme.CardBorder, 1, 0.5),
    })

    local TabScroll = make("ScrollingFrame", {
        Name = "TabScroll",
        Size = UDim2.new(1, -12, 1, -70),
        Position = UDim2.new(0, 6, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.CardBorderGlow,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar,
    }, {
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
        }),
        make("UIPadding", { PaddingRight = UDim.new(0, 4) }),
    })

    local Footer = make("Frame", {
        Name = "PlayerChip",
        Size = UDim2.new(1, -16, 0, 46),
        Position = UDim2.new(0, 8, 1, -54),
        BackgroundColor3 = Theme.CardBg,
        BackgroundTransparency = 0.1,
        Parent = Sidebar,
    }, {
        corner(10),
        stroke(Theme.CardBorder, 1, 0.45),
        make("ImageLabel", {
            Name = "Avatar",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 8, 0.5, -15),
            BackgroundColor3 = Color3.fromRGB(30, 34, 54),
            Parent = nil,
        }, { pill(), stroke(Theme.AccentCyan, 1.2, 0.4) }),
        txt({
            Name = "PlayerName",
            Text = LocalPlayer.DisplayName,
            Font = Theme.FontSemi,
            TextSize = 12,
            TextColor3 = Theme.TextTitle,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.new(0, 46, 0, 7),
            Size = UDim2.new(1, -54, 0, 16),
        }),
        txt({
            Name = "PlayerTag",
            Text = "@" .. LocalPlayer.Name,
            Font = Theme.FontRegular,
            TextSize = 10,
            TextColor3 = Theme.TextDim,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.new(0, 46, 0, 23),
            Size = UDim2.new(1, -54, 0, 14),
        }),
    })
    Footer.Avatar.Parent = Footer

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok and img and Footer.Parent then
            Footer.Avatar.Image = img
        end
    end)

    local ContentHolder = make("Frame", {
        Name = "ContentHolder",
        Size = UDim2.new(1, -208, 1, -12),
        Position = UDim2.new(0, 200, 0, 4),
        BackgroundTransparency = 1,
        Parent = Body,
    })

    local WindowObj = {
        Tabs = {},
        CurrentTab = nil,
        MainFrame = Root,
        ScreenGui = ScreenGui,
        ToastHolder = ToastHolder,
    }

    function WindowObj:SetVisible(state)
        task.spawn(setVisible, state and true or false, false)
    end

    local ToastTypes = {
        info    = { Theme.AccentCyan, "⚡" },
        success = { Theme.Success, "✓" },
        warning = { Theme.Warning, "!" },
        error   = { Theme.Danger, "✕" },
    }

    function WindowObj:Notify(toast)
        toast = toast or {}
        local title = toast.Title or toast.Name or "System Notification"
        local desc  = toast.Content or ""
        local dur   = toast.Duration or toast.Time or 3.5
        local kind  = ToastTypes[string.lower(tostring(toast.Type or "info"))] or ToastTypes.info
        local color = kind[1]
        local icon  = toast.Icon or kind[2]

        local wrapper = make("Frame", {
            Size = UDim2.new(1, 0, 0, 72),
            BackgroundTransparency = 1,
            Parent = ToastHolder,
        })

        local card = make("Frame", {
            Size = UDim2.new(1, 0, 0, 70),
            Position = UDim2.new(1, 60, 0, 0),
            BackgroundColor3 = Theme.CardBg,
            BackgroundTransparency = 0.03,
            Parent = wrapper,
        }, {
            corner(12),
            stroke(color, 1.2, 0.45),
            make("UIGradient", {
                Color = ColorSequence.new(WHITE, Color3.fromRGB(200, 200, 218)),
                Rotation = 90,
            }),
            make("Frame", {
                Name = "Beacon",
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(0, 12, 0, 12),
                BackgroundColor3 = color,
                BackgroundTransparency = 0.82,
            }, {
                pill(),
                stroke(color, 1.2, 0.35),
                txt({
                    Text = icon,
                    Font = Theme.FontTitle,
                    TextSize = 14,
                    TextColor3 = color,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Size = UDim2.new(1, 0, 1, 0),
                }),
            }),
            txt({
                Text = title,
                Font = Theme.FontTitle,
                TextColor3 = Theme.TextTitle,
                TextSize = 13,
                Position = UDim2.new(0, 54, 0, 10),
                Size = UDim2.new(1, -64, 0, 18),
            }),
            txt({
                Text = desc,
                Font = Theme.FontRegular,
                TextColor3 = Theme.TextDim,
                TextSize = 11,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                Position = UDim2.new(0, 54, 0, 29),
                Size = UDim2.new(1, -64, 0, 28),
            }),
            make("Frame", {
                Size = UDim2.new(1, -24, 0, 2),
                Position = UDim2.new(0, 12, 1, -6),
                BackgroundColor3 = Theme.CardBorder,
                BackgroundTransparency = 0.5,
            }, {
                pill(),
                make("Frame", {
                    Name = "Fill",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = color,
                }, { pill() }),
            }),
        })

        tw(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back)
        local fill = card:FindFirstChild("Fill", true)
        if fill then
            tw(fill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear)
        end

        task.delay(dur, function()
            if not card.Parent then return end
            tw(card, { Position = UDim2.new(1, 60, 0, 0) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.wait(0.28)
            tw(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
            task.wait(0.22)
            wrapper:Destroy()
        end)
    end

    function WindowObj:MakeNotification(cfg)
        self:Notify(cfg)
    end

    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Category"
        local TabIcon = tabConfig.Icon or "✦"
        local TabSub  = tabConfig.Subtitle or ""

        if TabIcon:find("rbxassetid") then TabIcon = "✦" end

        local TabPage = make("ScrollingFrame", {
            Name = "Page_" .. TabName,
            Size = UDim2.new(1, -4, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.AccentPrimary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentHolder,
        }, {
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
            }),
            make("UIPadding", {
                PaddingTop = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 16),
                PaddingRight = UDim.new(0, 8),
            }),
        })

        make("Frame", {
            Name = "PageHeader",
            Size = UDim2.new(1, 0, 0, TabSub ~= "" and 46 or 34),
            BackgroundTransparency = 1,
            LayoutOrder = -1,
            Parent = TabPage,
        }, {
            txt({
                Text = TabName,
                Font = Theme.FontBlack,
                TextSize = 20,
                TextColor3 = WHITE,
                Position = UDim2.new(0, 2, 0, 0),
                Size = UDim2.new(1, 0, 0, 28),
            }, {
                make("UIGradient", {
                    Color = ColorSequence.new(WHITE, Color3.fromRGB(176, 205, 255)),
                }),
            }),
            txt({
                Text = TabSub,
                Font = Theme.FontRegular,
                TextSize = 11,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 2, 0, 27),
                Size = UDim2.new(1, 0, 0, 16),
                Visible = TabSub ~= "",
            }),
        })

        local TabBtn = make("TextButton", {
            Name = "Tab_" .. TabName,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll,
        }, {
            corner(10),
            stroke(Theme.CardBorder, 1, 1, "TabStroke"),
            make("Frame", {
                Name = "ActiveFill",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = WHITE,
                BackgroundTransparency = 1,
            }, {
                corner(10),
                make("UIGradient", {
                    Color = ColorSequence.new(Theme.AccentPrimary, Theme.AccentCyan),
                    Rotation = 0,
                }),
            }),
            make("Frame", {
                Name = "GlowIndicator",
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, 3, 0, 0),
                Position = UDim2.new(0, 0, 0.5, 0),
                BackgroundColor3 = WHITE,
            }, {
                pill(),
                grad(Theme.AccentCyan, Theme.AccentPrimary, 90),
            }),
            txt({
                Name = "Icon",
                Text = TabIcon,
                Font = Theme.FontBold,
                TextSize = 15,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2.new(0, 10, 0.5, -10),
                Size = UDim2.new(0, 22, 0, 20),
            }),
            txt({
                Name = "Label",
                Text = TabName,
                Font = Theme.FontSemi,
                TextSize = 13,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -44, 1, 0),
            }),
        })

        local TabObj = {
            Page = TabPage,
            Button = TabBtn,
            Name = TabName,
        }

        local function paintTab(t, active)
            local b = t.Button
            tw(b.ActiveFill, { BackgroundTransparency = active and 0.86 or 1 }, 0.25)
            tw(b.TabStroke, { Transparency = active and 0.55 or 1 }, 0.25)
            tw(b.Label, { TextColor3 = active and Theme.TextTitle or Theme.TextDim, Position = UDim2.new(0, 40, 0, 0) }, 0.2)
            tw(b.Icon, { TextColor3 = active and Theme.AccentCyan or Theme.TextDim }, 0.2)
            tw(b.GlowIndicator, {
                Size = UDim2.new(0, 3, 0, active and 22 or 0),
            }, 0.25, Enum.EasingStyle.Back)
        end

        local function activateTab()
            if WindowObj.CurrentTab == TabObj then return end
            for _, t in ipairs(WindowObj.Tabs) do
                t.Page.Visible = false
                paintTab(t, false)
            end
            TabPage.Visible = true
            TabPage.Position = UDim2.new(0, 0, 0, 14)
            tw(TabPage, { Position = UDim2.new(0, 0, 0, 0) }, 0.35, Enum.EasingStyle.Quart)
            paintTab(TabObj, true)
            WindowObj.CurrentTab = TabObj
        end

        TabBtn.MouseButton1Click:Connect(activateTab)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                tw(TabBtn, { BackgroundColor3 = Theme.CardHover, BackgroundTransparency = 0.55 }, 0.15)
                tw(TabBtn.Label, { TextColor3 = Theme.TextBody, Position = UDim2.new(0, 44, 0, 0) }, 0.18)
                tw(TabBtn.TabStroke, { Transparency = 0.7 }, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                tw(TabBtn, { BackgroundTransparency = 1 }, 0.15)
                tw(TabBtn.Label, { TextColor3 = Theme.TextDim, Position = UDim2.new(0, 40, 0, 0) }, 0.18)
                tw(TabBtn.TabStroke, { Transparency = 1 }, 0.15)
            end
        end)

        table.insert(WindowObj.Tabs, TabObj)
        if #WindowObj.Tabs == 1 then
            activateTab()
        end

        function TabObj:AddSection(secTitle)
            if type(secTitle) == "table" and secTitle.Name then
                secTitle = secTitle.Name
            end
            local SecFrame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabPage,
            }, {
                make("Frame", {
                    Size = UDim2.new(0, 3, 0, 14),
                    Position = UDim2.new(0, 2, 0.5, -7),
                    BackgroundColor3 = WHITE,
                }, {
                    pill(),
                    grad(Theme.AccentPrimary, Theme.AccentCyan, 90),
                }),
                txt({
                    Text = string.upper(tostring(secTitle)),
                    Font = Theme.FontTitle,
                    TextSize = 11,
                    TextColor3 = Theme.AccentCyan,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -14, 1, 0),
                }),
                make("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.CardBorderGlow,
                }, {
                    make("UIGradient", {
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0.5),
                            NumberSequenceKeypoint.new(1, 1),
                        }),
                    }),
                }),
            })
            return SecFrame
        end

        function TabObj:AddStatCard(cardConfig)
            cardConfig = cardConfig or {}
            local title    = cardConfig.Title or "Telemetry Metric"
            local initial  = cardConfig.Value or "0"
            local subtitle = cardConfig.Subtext or cardConfig.Desc or "Live Feed"
            local progress = cardConfig.Progress

            local card = makeCard(TabPage, progress ~= nil and 62 or 54, false)

            make("Frame", {
                Size = UDim2.new(0, 3, 1, -16),
                Position = UDim2.new(0, 8, 0, 8),
                BackgroundColor3 = WHITE,
                Parent = card,
            }, {
                pill(),
                grad(Theme.AccentPrimary, Theme.AccentCyan, 90),
            })

            txt({
                Text = title,
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 22, 0, 9),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = card,
            })
            txt({
                Name = "SubLabel",
                Text = subtitle,
                TextSize = 10,
                TextColor3 = Theme.AccentCyan,
                Position = UDim2.new(0, 22, 0, 27),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = card,
            })
            txt({
                Name = "ValueLabel",
                Text = tostring(initial),
                Font = Theme.FontTitle,
                TextSize = 18,
                TextColor3 = Theme.TextTitle,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.6, 0, 0, 0),
                Size = UDim2.new(0.4, -18, 0, 54),
                Parent = card,
            })

            local Meter
            if progress ~= nil then
                local track = make("Frame", {
                    Size = UDim2.new(1, -30, 0, 3),
                    Position = UDim2.new(0, 15, 1, -9),
                    BackgroundColor3 = Color3.fromRGB(34, 38, 56),
                    Parent = card,
                }, { pill() })
                Meter = make("Frame", {
                    Name = "Meter",
                    Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0),
                    BackgroundColor3 = WHITE,
                    Parent = track,
                }, {
                    pill(),
                    grad(Theme.AccentPrimary, Theme.AccentCyan, 0),
                })
            end

            local CardHandle = {}
            function CardHandle:Set(newVal, color, subText, newProgress)
                card.ValueLabel.Text = tostring(newVal)
                if color then tw(card.ValueLabel, { TextColor3 = color }, 0.25) end
                if subText then card.SubLabel.Text = tostring(subText) end
                if newProgress ~= nil and Meter then
                    tw(Meter, { Size = UDim2.new(math.clamp(newProgress, 0, 1), 0, 1, 0) }, 0.35)
                end
            end
            return CardHandle
        end

        TabObj.AddStat = TabObj.AddStatCard

        function TabObj:AddToggle(togConfig)
            togConfig = togConfig or {}
            local name     = togConfig.Name or "Toggle Switch"
            local desc     = togConfig.Desc or ""
            local default  = togConfig.Default or false
            local callback = togConfig.Callback or function() end

            local isToggled = default
            local cardHeight = desc ~= "" and 56 or 46
            local OFF_COLOR = Color3.fromRGB(34, 38, 56)

            local ToggleCard = makeCard(TabPage, cardHeight, true)
            hoverable(ToggleCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 13,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, desc ~= "" and 10 or 0),
                Size = UDim2.new(1, -90, 0, desc ~= "" and 18 or cardHeight),
                Parent = ToggleCard,
            })
            if desc ~= "" then
                txt({
                    Text = desc,
                    TextSize = 10,
                    TextColor3 = Theme.TextDim,
                    Position = UDim2.new(0, 16, 0, 29),
                    Size = UDim2.new(1, -90, 0, 16),
                    Parent = ToggleCard,
                })
            end

            local Track = make("Frame", {
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -58, 0.5, -12),
                BackgroundColor3 = OFF_COLOR,
                Parent = ToggleCard,
            }, {
                pill(),
                stroke(Theme.CardBorder, 1, 0.3, "TrackStroke"),
            })

            local OnFill = make("Frame", {
                Name = "OnFill",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = WHITE,
                BackgroundTransparency = isToggled and 0 or 1,
                Parent = Track,
            }, {
                pill(),
                grad(Theme.AccentPrimary, Theme.AccentCyan, 0),
            })

            local Knob = make("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = isToggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = WHITE,
                Parent = Track,
            }, { pill() })

            local TrackStroke = Track.TrackStroke
            local CardStroke = ToggleCard.CardStroke
            TrackStroke.Color = isToggled and Theme.AccentCyan or Theme.CardBorder
            TrackStroke.Thickness = isToggled and 2.4 or 1
            TrackStroke.Transparency = isToggled and 0.65 or 0.3

            local function syncVisual(fire)
                if isToggled then
                    tw(OnFill, { BackgroundTransparency = 0 }, 0.25)
                    tw(Knob, { Position = UDim2.new(1, -21, 0.5, -9) }, 0.32, Enum.EasingStyle.Back)
                    tw(TrackStroke, { Color = Theme.AccentCyan, Thickness = 2.4, Transparency = 0.65 }, 0.25)
                    tw(CardStroke, { Color = Theme.AccentPrimary, Transparency = 0.35 }, 0.25)
                else
                    tw(OnFill, { BackgroundTransparency = 1 }, 0.25)
                    tw(Knob, { Position = UDim2.new(0, 3, 0.5, -9) }, 0.32, Enum.EasingStyle.Back)
                    tw(TrackStroke, { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.3 }, 0.25)
                    tw(CardStroke, { Color = Theme.CardBorder, Transparency = 0.35 }, 0.25)
                end
                if fire then
                    task.spawn(callback, isToggled)
                end
            end

            if isToggled then
                CardStroke.Color = Theme.AccentPrimary
                CardStroke.Transparency = 0.35
            end

            ToggleCard.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                syncVisual(true)
            end)
            ToggleCard.MouseButton1Down:Connect(function()
                tw(Knob, { Size = UDim2.new(0, 22, 0, 18) }, 0.12)
            end)
            ToggleCard.MouseButton1Up:Connect(function()
                tw(Knob, { Size = UDim2.new(0, 18, 0, 18) }, 0.18)
            end)

            local ToggleHandle = {}
            function ToggleHandle:Set(val)
                isToggled = val and true or false
                syncVisual(true)
            end
            function ToggleHandle:Get()
                return isToggled
            end
            return ToggleHandle
        end

        function TabObj:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            local name     = sldConfig.Name or "Slider"
            local min      = sldConfig.Min or 0
            local max      = sldConfig.Max or 100
            local default  = math.clamp(sldConfig.Default or min, min, max)
            local inc      = sldConfig.Increment or 1
            local suffix   = sldConfig.ValueName or ""
            local callback = sldConfig.Callback or function() end

            local range = math.max(max - min, 1e-9)
            local decimals = 0
            do
                local s = tostring(inc)
                local dot = string.find(s, "%.")
                if dot then decimals = #s - dot end
            end
            local fmt = "%." .. decimals .. "f"
            local function fmtVal(v)
                return string.format(fmt, v) .. (suffix ~= "" and (" " .. suffix) or "")
            end

            local currentVal = default
            local lastFired = nil

            local SliderCard = makeCard(TabPage, 70, false)
            hoverable(SliderCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, 8),
                Size = UDim2.new(0.65, 0, 0, 16),
                Parent = SliderCard,
            })
            txt({
                Name = "ValText",
                Text = fmtVal(currentVal),
                Font = Theme.FontTitle,
                TextSize = 13,
                TextColor3 = Theme.AccentCyan,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(0.65, 0, 0, 8),
                Size = UDim2.new(0.35, -16, 0, 16),
                Parent = SliderCard,
            })

            local Hit = make("TextButton", {
                Size = UDim2.new(1, -32, 0, 26),
                Position = UDim2.new(0, 16, 0, 40),
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "",
                Parent = SliderCard,
            })

            local Rail = make("Frame", {
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 0.5, -3),
                BackgroundColor3 = Color3.fromRGB(32, 36, 54),
                Parent = Hit,
            }, { pill() })

            local fillRatio = (currentVal - min) / range
            local Fill = make("Frame", {
                Size = UDim2.new(fillRatio, 0, 1, 0),
                BackgroundColor3 = WHITE,
                Parent = Rail,
            }, {
                pill(),
                grad(Theme.AccentPrimary, Theme.AccentCyan, 0),
            })

            local Scrubber = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(fillRatio, 0, 0.5, 0),
                BackgroundColor3 = WHITE,
                ZIndex = 2,
                Parent = Rail,
            }, {
                pill(),
                stroke(Theme.AccentCyan, 2, 0.5, "Halo"),
            })

            local Tip = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(fillRatio, 0, 0, -8),
                Size = UDim2.new(0, 0, 0, 18),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Theme.AccentPrimary,
                BackgroundTransparency = 1,
                ZIndex = 3,
                Parent = Rail,
            }, {
                corner(6),
                make("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) }),
                txt({
                    Name = "TipText",
                    Text = fmtVal(currentVal),
                    Font = Theme.FontBold,
                    TextSize = 10,
                    TextColor3 = WHITE,
                    TextTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    AutomaticSize = Enum.AutomaticSize.X,
                    Size = UDim2.new(0, 0, 1, 0),
                    ZIndex = 4,
                }),
            })

            local function showTip(show)
                tw(Tip, { BackgroundTransparency = show and 0 or 1 }, 0.15)
                tw(Tip.TipText, { TextTransparency = show and 0 or 1 }, 0.15)
                tw(Scrubber.Halo, { Thickness = show and 4.5 or 2, Transparency = show and 0.6 or 0.5 }, 0.15)
                tw(Scrubber, { Size = show and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 14, 0, 14) }, 0.15)
            end

            local function applyValue(v, fire)
                local pct = (v - min) / range
                currentVal = v
                tw(Fill, { Size = UDim2.new(pct, 0, 1, 0) }, 0.07, Enum.EasingStyle.Sine)
                tw(Scrubber, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.07, Enum.EasingStyle.Sine)
                tw(Tip, { Position = UDim2.new(pct, 0, 0, -8) }, 0.07, Enum.EasingStyle.Sine)
                SliderCard.ValText.Text = fmtVal(v)
                Tip.TipText.Text = fmtVal(v)
                if fire and lastFired ~= v then
                    lastFired = v
                    task.spawn(callback, v)
                end
            end

            local function updateFromX(inputX)
                local railX = Rail.AbsolutePosition.X
                local railW = math.max(Rail.AbsoluteSize.X, 1)
                local pct = math.clamp((inputX - railX) / railW, 0, 1)
                local raw = min + range * pct
                local stepped = min + math.floor((raw - min) / inc + 0.5) * inc
                stepped = math.clamp(stepped, min, max)
                stepped = tonumber(string.format(fmt, stepped)) or stepped
                applyValue(stepped, true)
            end

            local isSliding = false
            Hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isSliding = true
                    showTip(true)
                    updateFromX(input.Position.X)
                end
            end)
            bind(UserInputService.InputChanged, function(input)
                if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateFromX(input.Position.X)
                end
            end)
            bind(UserInputService.InputEnded, function(input)
                if isSliding and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    isSliding = false
                    showTip(false)
                end
            end)

            local SliderHandle = {}
            function SliderHandle:Set(v)
                applyValue(math.clamp(v, min, max), true)
            end
            function SliderHandle:Get()
                return currentVal
            end
            return SliderHandle
        end

        function TabObj:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local name     = btnConfig.Name or "Execute Command"
            local icon     = btnConfig.Icon or "⚡"
            local callback = btnConfig.Callback or function() end

            local Btn = makeCard(TabPage, 44, true)
            Btn.ClipsDescendants = true
            hoverable(Btn, Theme.AccentCyan)

            local PressScale = make("UIScale", { Scale = 1, Parent = Btn })

            local Chip = make("Frame", {
                Name = "IconChip",
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(0, 10, 0.5, -13),
                BackgroundColor3 = Theme.AccentPrimary,
                BackgroundTransparency = 0.8,
                Parent = Btn,
            }, {
                corner(8),
                txt({
                    Text = icon,
                    Font = Theme.FontBold,
                    TextSize = 13,
                    TextColor3 = Theme.AccentCyan,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Size = UDim2.new(1, 0, 1, 0),
                }),
            })

            local TitleLbl = txt({
                Name = "Title",
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 46, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Parent = Btn,
            })

            local Chevron = txt({
                Name = "Chevron",
                Text = "›",
                Font = Theme.FontBold,
                TextSize = 20,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 16, 1, -2),
                Parent = Btn,
            })

            Btn.MouseEnter:Connect(function()
                tw(Chip, { BackgroundTransparency = 0.6 }, 0.15)
                tw(Chevron, { Position = UDim2.new(1, -24, 0, 0), TextColor3 = Theme.AccentCyan }, 0.18)
            end)
            Btn.MouseLeave:Connect(function()
                tw(Chip, { BackgroundTransparency = 0.8 }, 0.15)
                tw(Chevron, { Position = UDim2.new(1, -30, 0, 0), TextColor3 = Theme.TextDim }, 0.18)
                tw(PressScale, { Scale = 1 }, 0.15)
            end)

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    tw(PressScale, { Scale = 0.975 }, 0.08)

                    local rel = Vector2.new(input.Position.X, input.Position.Y) - Btn.AbsolutePosition
                    local ripple = make("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0, rel.X, 0, rel.Y),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = Theme.AccentCyan,
                        BackgroundTransparency = 0.7,
                        ZIndex = 0,
                        Parent = Btn,
                    }, { pill() })
                    local d = math.max(Btn.AbsoluteSize.X, 200) * 1.5
                    tw(ripple, { Size = UDim2.new(0, d, 0, d), BackgroundTransparency = 1 }, 0.55, Enum.EasingStyle.Quad)
                    task.delay(0.6, function()
                        ripple:Destroy()
                    end)
                end
            end)
            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    tw(PressScale, { Scale = 1 }, 0.2, Enum.EasingStyle.Back)
                end
            end)

            Btn.MouseButton1Click:Connect(function()
                task.spawn(callback)
            end)

            local BtnHandle = {}
            function BtnHandle:SetName(newName)
                TitleLbl.Text = tostring(newName)
            end
            return BtnHandle
        end

        function TabObj:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            local name     = dropConfig.Name or dropConfig.Title or "Dropdown Selection"
            local desc     = dropConfig.Desc or dropConfig.Description or ""
            local options  = dropConfig.Options or dropConfig.Values or {}
            local isMulti  = dropConfig.Multi or false
            local default  = dropConfig.Default or (isMulti and {} or options[1])
            local callback = dropConfig.Callback or function() end

            local isExpanded = false
            local selected = default
            if isMulti then
                if type(selected) ~= "table" then
                    selected = {}
                else
                    selected = table.clone(selected)
                end
            end

            local function getSelectedSummary()
                if isMulti then
                    local count = 0
                    for k, v in pairs(selected) do
                        if v == true or (type(k) == "number" and type(v) == "string") then
                            count = count + 1
                        end
                    end
                    if count == 0 then
                        return "เลือก 0 ชนิด"
                    else
                        return string.format("(เลือก %d ชนิด)", count)
                    end
                else
                    return tostring(selected or options[1] or "None")
                end
            end

            local cardHeight = desc ~= "" and 56 or 46
            local maxScrollH = math.min(#options * 32, 220)
            local expandedH = cardHeight + 8 + maxScrollH

            local DropCard = makeCard(TabPage, cardHeight, false)
            DropCard.ClipsDescendants = true
            hoverable(DropCard)

            local Header = make("TextButton", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, cardHeight),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = DropCard,
            })

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, desc ~= "" and 10 or 0),
                Size = UDim2.new(0.55, 0, 0, desc ~= "" and 18 or cardHeight),
                Parent = Header,
            })

            if desc ~= "" then
                txt({
                    Text = desc,
                    TextSize = 10,
                    TextColor3 = Theme.TextDim,
                    Position = UDim2.new(0, 16, 0, 29),
                    Size = UDim2.new(0.55, 0, 0, 16),
                    Parent = Header,
                })
            end

            local SelectedLabel = txt({
                Name = "SelectedText",
                Text = getSelectedSummary(),
                Font = Theme.FontBold,
                TextSize = 11,
                TextColor3 = Theme.AccentCyan,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -42, 1, 0),
                Parent = Header,
            })

            local ArrowLabel = txt({
                Name = "Arrow",
                Text = "▾",
                Font = Theme.FontBold,
                TextSize = 13,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Center,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, -20, 0.5, 0),
                Size = UDim2.new(0, 18, 0, 18),
                Parent = Header,
            })

            Header.MouseEnter:Connect(function()
                tw(DropCard, { BackgroundColor3 = Theme.CardHover }, 0.15)
                tw(DropCard.CardStroke, { Color = Theme.CardBorderGlow, Transparency = 0.1 }, 0.15)
            end)
            Header.MouseLeave:Connect(function()
                tw(DropCard, { BackgroundColor3 = Theme.CardBg }, 0.15)
                tw(DropCard.CardStroke, { Color = Theme.CardBorder, Transparency = 0.35 }, 0.15)
            end)

            make("Frame", {
                Size = UDim2.new(1, -24, 0, 1),
                Position = UDim2.new(0, 12, 0, cardHeight),
                BackgroundColor3 = Theme.CardBorderGlow,
                BackgroundTransparency = 0.7,
                Parent = DropCard,
            })

            local OptionsContainer = make("ScrollingFrame", {
                Size = UDim2.new(1, -24, 0, maxScrollH),
                Position = UDim2.new(0, 12, 0, cardHeight + 6),
                BackgroundTransparency = 1,
                ScrollBarThickness = 4,
                ScrollBarImageColor3 = Theme.AccentCyan,
                ScrollBarImageTransparency = 0.2,
                CanvasSize = UDim2.new(0, 0, 0, #options * 32),
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Parent = DropCard,
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                }),
            })

            local optionButtons = {}
            local function paintOptions()
                for opt, b in pairs(optionButtons) do
                    local active = false
                    if isMulti then
                        active = (selected[opt] == true)
                    else
                        active = (opt == selected)
                    end

                    tw(b, {
                        BackgroundColor3 = active and Theme.AccentPrimary or Color3.fromRGB(30, 34, 50),
                        BackgroundTransparency = active and 0.6 or 0.2,
                        TextColor3 = active and WHITE or Theme.TextBody,
                    }, 0.15)
                    b.Check.Visible = active
                end
            end

            local function setExpanded(state)
                isExpanded = state
                tw(DropCard, { Size = UDim2.new(1, 0, 0, state and expandedH or cardHeight) }, state and 0.3 or 0.24, Enum.EasingStyle.Quart)
                tw(ArrowLabel, { Rotation = state and 180 or 0, TextColor3 = state and Theme.AccentCyan or Theme.TextDim }, 0.25)
            end

            for i, opt in ipairs(options) do
                local OptBtn = make("TextButton", {
                    Size = UDim2.new(1, -8, 0, 28),
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                    BackgroundTransparency = 0.2,
                    Text = "  " .. tostring(opt),
                    Font = Theme.FontRegular,
                    TextSize = 11,
                    TextColor3 = Theme.TextBody,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    Parent = OptionsContainer,
                }, {
                    corner(7),
                    txt({
                        Name = "Check",
                        Text = "✓",
                        Font = Theme.FontBold,
                        TextSize = 12,
                        TextColor3 = Theme.AccentCyan,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Position = UDim2.new(0, 0, 0, 0),
                        Size = UDim2.new(1, -10, 1, 0),
                        Visible = false,
                    }),
                })
                optionButtons[opt] = OptBtn

                OptBtn.MouseButton1Click:Connect(function()
                    if isMulti then
                        selected[opt] = not selected[opt]
                        SelectedLabel.Text = getSelectedSummary()
                        paintOptions()
                        task.spawn(callback, selected)
                    else
                        selected = opt
                        SelectedLabel.Text = tostring(opt)
                        paintOptions()
                        setExpanded(false)
                        task.spawn(callback, selected)
                    end
                end)
                OptBtn.MouseEnter:Connect(function()
                    local active = isMulti and (selected[opt] == true) or (opt == selected)
                    if not active then
                        tw(OptBtn, { BackgroundColor3 = Theme.AccentPrimary, BackgroundTransparency = 0.55, TextColor3 = WHITE }, 0.12)
                    end
                end)
                OptBtn.MouseLeave:Connect(function()
                    local active = isMulti and (selected[opt] == true) or (opt == selected)
                    if not active then
                        tw(OptBtn, { BackgroundColor3 = Color3.fromRGB(30, 34, 50), BackgroundTransparency = 0.2, TextColor3 = Theme.TextBody }, 0.12)
                    end
                end)
            end
            paintOptions()

            Header.MouseButton1Click:Connect(function()
                setExpanded(not isExpanded)
            end)

            local DropHandle = {}
            function DropHandle:Set(newVal)
                if isMulti then
                    if type(newVal) == "table" then
                        selected = table.clone(newVal)
                    else
                        selected = {}
                    end
                    SelectedLabel.Text = getSelectedSummary()
                    paintOptions()
                    task.spawn(callback, selected)
                else
                    if optionButtons[newVal] then
                        selected = newVal
                        SelectedLabel.Text = tostring(newVal)
                        paintOptions()
                        task.spawn(callback, selected)
                    end
                end
            end
            function DropHandle:Get()
                return selected
            end
            return DropHandle
        end

        function TabObj:AddTextbox(txtConfig)
            txtConfig = txtConfig or {}
            local name     = txtConfig.Name or "Input Key / Text"
            local default  = txtConfig.Default or ""
            local place    = txtConfig.Placeholder or txtConfig.PlaceholderText or "Enter value..."
            local callback = txtConfig.Callback or function() end

            local BoxCard = makeCard(TabPage, 48, false)
            hoverable(BoxCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.45, 0, 1, 0),
                Parent = BoxCard,
            })

            local Input = make("TextBox", {
                Size = UDim2.new(0, 170, 0, 30),
                Position = UDim2.new(1, -184, 0.5, -15),
                BackgroundColor3 = Theme.InputBg,
                Text = tostring(default),
                PlaceholderText = place,
                PlaceholderColor3 = Theme.TextDim,
                Font = Theme.FontRegular,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                Parent = BoxCard,
            }, {
                corner(8),
                make("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
                stroke(Theme.CardBorder, 1, 0.1, "InputStroke"),
            })

            Input.Focused:Connect(function()
                tw(Input.InputStroke, { Color = Theme.AccentCyan, Thickness = 1.6, Transparency = 0 }, 0.2)
                tw(Input, { BackgroundColor3 = Color3.fromRGB(18, 21, 34) }, 0.2)
            end)
            Input.FocusLost:Connect(function(enter)
                tw(Input.InputStroke, { Color = Theme.CardBorder, Thickness = 1, Transparency = 0.1 }, 0.2)
                tw(Input, { BackgroundColor3 = Theme.InputBg }, 0.2)
                task.spawn(callback, Input.Text, enter)
            end)

            local BoxHandle = {}
            function BoxHandle:Set(v)
                Input.Text = tostring(v)
            end
            function BoxHandle:Get()
                return Input.Text
            end
            return BoxHandle
        end

        function TabObj:AddLabel(labelText)
            local card = make("Frame", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundColor3 = Theme.CardBg,
                Parent = TabPage
            }, {
                corner(10),
                stroke(Theme.CardBorder, 1.1, 0.35),
                make("Frame", {
                    Size = UDim2.new(0, 3, 1, -12),
                    Position = UDim2.new(0, 8, 0, 6),
                    BackgroundColor3 = Theme.AccentCyan
                }, {
                    pill()
                }),
                txt({
                    Name = "LabelText",
                    Text = tostring(labelText or ""),
                    Font = Theme.FontSemi,
                    TextSize = 12,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -28, 1, 0),
                })
            })
            local handle = {}
            function handle:Set(newText)
                if card and card:FindFirstChild("LabelText") then
                    card.LabelText.Text = tostring(newText or "")
                end
            end
            return handle
        end

        TabObj.MakeTab = TabObj.CreateTab
        return TabObj
    end

    WindowObj.MakeTab = WindowObj.CreateTab

    task.defer(function()
        setVisible(true)
    end)

    return WindowObj
end

UI.MakeWindow = UI.CreateWindow
UI.Init = function() end
function UI:MakeNotification(cfg)
    cfg = cfg or {}
    if _G.PB_ActiveWindow and _G.PB_ActiveWindow.Notify then
        _G.PB_ActiveWindow:Notify({
            Title = cfg.Name or cfg.Title or "PROJECT BARUN",
            Content = cfg.Content or "",
            Duration = cfg.Time or cfg.Duration or 3.5,
            Type = cfg.Type or "info"
        })
    end
end

local OrionLib = UI

-- ═══════════════════════════════════════════════════════════════════
-- 5. SETTINGS / CONFIGURATION STATE
-- ═══════════════════════════════════════════════════════════════════
local Settings = {
    -- Train
    AutoTrain            = false,
    AutoTrainBestZone    = false,
    TrainAreaIndex       = 1,
    TrainDelay           = 0.15,

    -- Stage & Ore
    AutoStageOre         = false,
    AutoMaxStage         = false,
    StageName            = "Stage_27",
    StageDelay           = 0.35,
    AutoClaimOre         = false,
    SilentKillMobs       = false,

    -- Forge (Engineered with 2SKI Smart Slicing)
    AutoForge            = false,
    ForgeType            = "All", -- "Weapon" | "Armor" | "Hat" | "All"
    MinOreToForge        = 4,
    ForgeDelay           = 0.6,
    OreQualityMode       = "Best", -- "Best" | "Low"
    AutoEquipBestAfter   = false,

    -- Auto Equip Best Gear
    AutoEquipBest        = false,

    -- Enhance & Safe Sell
    AutoEnhance          = false,
    UseProtect           = false,
    AutoSellTrashGear    = false,

    -- SuperLoot & Dungeon
    AutoSuperLoot        = false,
    AutoDungeon          = false,
    TargetDungeonRound   = 1,

    -- Claims & Economy
    AutoClaimRewards     = false,
    AutoUpgrade          = false,
    AutoRebirth          = false,
    AutoLuckRoll         = false,
    LuckDelay            = 2,

    -- Combat
    AutoAttack           = false,
    AttackDelay          = 0.1,
}

-- ═══════════════════════════════════════════════════════════════════
-- 6. SERVICES & REMOTES
-- ═══════════════════════════════════════════════════════════════════
local Remote = ReplicatedStorage:WaitForChild("Remote", 10)
local function R(folder, name)
    local f = Remote and Remote:FindFirstChild(folder)
    return f and f:FindFirstChild(name)
end

local TrainRE_Start       = R("Train",      "StartTrainRE")
local TrainRE_Once        = R("Train",      "TrainOnceRE")
local TrainRE_IntoArea    = R("Train",      "IntoAutoTrainRE")
local TrainRE_ExitArea    = R("Train",      "ExitAutoTrainRE")
local StageRF_Finish      = R("Stage",      "StageFinishedRF")
local StageRF_GetOre      = R("Stage",      "GetOreRF")
local StageRE_Claim       = R("Stage",      "ClaimedAllOreRE")
local OnlineRE_Claim      = R("Online",     "TryClaimRE")
local UpdateRE_Claim      = R("UpdateLog",  "TryClaimUPDRewardRE")
local OfflineRE_Claim     = R("Offline",    "TryClaimOfflineRewardRE")
local DungeonRE_Claim     = R("Dungeon",    "TryClaimDailyDunTicRE")
local DungeonRF_Into      = R("Dungeon",    "TryIntoDungeonRF")
local UpgradeRE           = R("Upgrade",    "UpgradeOnceRE")
local ForgeRF             = R("Forge",      "ForgeRF")
local BackpackRF_GetData  = R("Backpack",   "GetDataRF")
local BackpackRE_TryEquip = R("Backpack",   "TryEquipItemRE")
local BackpackRE_SellItem = R("Backpack",   "TrySellItemRE")
local BackpackRE_SellAll  = R("Backpack",   "TrySellAllRE")
local BackpackRF_Enhance  = R("Backpack",   "EnhantEquipmentRF")
local ClassRE_Luck        = R("Class",      "LuckOnceRE")
local RebirthRE           = R("Rebirth",    "TryRebirthRE")
local AttackRE_Enemy      = R("Attack",     "AttackEnemyServiceRE")
local AttackRE_Kill       = R("Attack",     "KillEnemyRE")
local SuperLootRE_Kill    = R("SuperLoot",  "KillSuperLootRE")
local ProfileRF           = R("Profile",    "GetTotalDataRF")

local Bindable_EnemyHit   = Remote and Remote:FindFirstChild("Attack") and Remote.Attack:FindFirstChild("EnemyHitBE")

local TrainCTRL, EnemyCTRL, HPCTRL, OreHelper, WeaponHelper, ArmorHelper, RarityHelper, UpgradeHelper
pcall(function() TrainCTRL   = require(ReplicatedStorage.CTRL.TrainCTRL) end)
pcall(function() EnemyCTRL   = require(ReplicatedStorage.CTRL.EnemyCTRL) end)
pcall(function() HPCTRL      = require(ReplicatedStorage.CTRL.HPCTRL) end)
pcall(function() OreHelper   = require(ReplicatedStorage.Config.Ore.Helper) end)
pcall(function() WeaponHelper= require(ReplicatedStorage.Config.Weapon.Helper) end)
pcall(function() ArmorHelper = require(ReplicatedStorage.Config.Armor.Helper) end)
pcall(function() RarityHelper= require(ReplicatedStorage.Config.Rarity.Helper) end)
pcall(function() UpgradeHelper= require(ReplicatedStorage.Config.Upgrade.Helper) end)

local function safe(fn)
    local ok, err = pcall(fn)
    if not ok then warn("[Hub] " .. tostring(err)) end
end

-- ═══════════════════════════════════════════════════════════════════
-- 7. GAMEPASS BYPASS INJECTOR
-- ═══════════════════════════════════════════════════════════════════
local GamePassMap = {
    [1962630901] = "VIP",
    [1963566878] = "SuperLuck",
    [1965960643] = "CommonLuck",
    [1963764856] = "MoreOre",
    [1982474360] = "UltraLuck",
    [1962564854] = "SkipForge",
}

local function applyGamePassBypass()
    pcall(function()
        local ProfileData = require(ReplicatedStorage.ProfileData)
        local pemStore = ProfileData and ProfileData.GetStoreData and ProfileData.GetStoreData("Pem")
        if pemStore and type(pemStore) == "table" then
            for _, pemKey in pairs(GamePassMap) do pemStore[pemKey] = true end
            pemStore["AutoTrainArea_9"] = true
            pemStore["AutoTrainArea_10"] = true
            pemStore["AutoTrainArea_11"] = true
        end
    end)

    if hookmetamethod and newcclosure and getnamecallmethod then
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if self == MarketplaceService and method == "UserOwnsGamePassAsync" then
                    local args = {...}
                    local gpId = args[2] or args[1]
                    if type(gpId) == "number" and GamePassMap[gpId] then return true end
                end
                return oldNamecall(self, ...)
            end))
        end)
    end
end
safe(applyGamePassBypass)

-- ═══════════════════════════════════════════════════════════════════
-- 8. BACKPACK SANITIZER (Prevents in-game ForgeGUI Line 508 Crash)
-- ═══════════════════════════════════════════════════════════════════
local BackpackData
pcall(function()
    local bModule = ReplicatedStorage:WaitForChild("LocalData", 5):WaitForChild("BackpackData", 5)
    BackpackData = require(bModule)
    if BackpackData and BackpackData.GetData then
        local origGetData = BackpackData.GetData
        BackpackData.GetData = function(...)
            local res = origGetData(...)
            if res and type(res.have) == "table" then
                for _, item in pairs(res.have) do
                    if item.Type == "Ore" and type(item.ID) ~= "string" then
                        item.Type = "Material"
                    end
                end
            end
            return res
        end
    end
end)

local function getBackpackData()
    local data = nil
    pcall(function()
        if BackpackData and BackpackData.GetData then
            local d = BackpackData.GetData()
            if d and d.have then data = d.have end
        end
    end)
    if not data and BackpackRF_GetData then
        pcall(function()
            local r = BackpackRF_GetData:InvokeServer()
            if type(r) == "table" then data = r.have or r end
        end)
    end
    if not data and ProfileRF then
        pcall(function()
            local p = ProfileRF:InvokeServer()
            if p and p.Backpack and p.Backpack.have then data = p.Backpack.have end
        end)
    end
    return data or {}
end

-- ═══════════════════════════════════════════════════════════════════
-- 9. SMART FORGE ENGINE (2SKI Slicing Architecture)
-- ═══════════════════════════════════════════════════════════════════
local forgeCycleIndex = 1

local function executeForgeNow(forgeType, minOres)
    if not ForgeRF then return false, "No Forge Remote" end
    local have = getBackpackData()
    forgeType = forgeType or Settings.ForgeType or "All"
    minOres = minOres or Settings.MinOreToForge or 4

    local oreEntries = {}
    local totalOres = 0
    for uuid, item in pairs(have) do
        if type(item) == "table" and type(item.ID) == "string" and (item.Type == "Ore" or item.ID:find("Ore")) then
            local pwr = 0
            if OreHelper and OreHelper.GetPower then
                pcall(function() pwr = OreHelper.GetPower(item.ID) or 0 end)
            end
            local count = (type(item.Number) == "number" and item.Number > 0) and item.Number or 1
            totalOres = totalOres + count
            table.insert(oreEntries, { uuid = uuid, count = count, power = pwr })
        end
    end

    if totalOres < 4 then
        return false, "Not enough ores (Minimum 4 required)"
    end

    if Settings.OreQualityMode == "Best" then
        table.sort(oreEntries, function(a, b) return a.power > b.power end)
    else
        table.sort(oreEntries, function(a, b) return a.power < b.power end)
    end

    local actualSlot = "Weapon"
    local isRotate = (forgeType == "All")

    if isRotate then
        local cycleSlots = { "Weapon", "Armor", "Hat" }
        actualSlot = cycleSlots[((forgeCycleIndex - 1) % #cycleSlots) + 1]
    elseif forgeType == "Hat" then
        actualSlot = "Hat"
    elseif forgeType == "Armor" then
        actualSlot = "Armor"
    else
        actualSlot = "Weapon"
    end

    local serverConfigType = "Weapon"
    local targetOreCount = 4

    if actualSlot == "Weapon" then
        serverConfigType = "Weapon"
        targetOreCount = math.clamp(totalOres, 4, 13)
    elseif actualSlot == "Hat" then
        serverConfigType = "Armor"
        targetOreCount = (totalOres >= 16) and 16 or 4
    elseif actualSlot == "Armor" then
        serverConfigType = "Armor"
        if totalOres >= 23 then
            targetOreCount = 23
        elseif totalOres >= 11 then
            targetOreCount = 11
        else
            targetOreCount = math.clamp(totalOres, 4, 11)
        end
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

    if collected < 4 then
        return false, "Slicing failed"
    end

    local ok, res = pcall(function()
        return ForgeRF:InvokeServer({
            ConfigType = serverConfigType,
            UUIDList = oreList
        })
    end)

    if ok and res then
        if isRotate then forgeCycleIndex = forgeCycleIndex + 1 end
        if Settings.AutoEquipBestAfter then
            task.delay(0.25, function()
                safe(function() equipBestGearNow(actualSlot) end)
            end)
        end
        return true, actualSlot, collected
    end

    return false, "Forge invoke failed"
end

-- ═══════════════════════════════════════════════════════════════════
-- 10. AUTO EQUIP BEST GEAR
-- ═══════════════════════════════════════════════════════════════════
function calculateGearScore(item)
    if not item or not item.ID then return -1 end
    local basePower = 0
    if item.Type == "Weapon" and WeaponHelper and WeaponHelper.GetDesignPower then
        pcall(function() basePower = WeaponHelper.GetDesignPower(item.ID) or 0 end)
    elseif (item.Type == "Armor" or item.Type == "Hat") and ArmorHelper and ArmorHelper.GetDesignPower then
        pcall(function() basePower = ArmorHelper.GetDesignPower(item.ID) or 0 end)
    end
    local rarityLevel = 1
    if RarityHelper and RarityHelper.GetRarityLevel then
        pcall(function() rarityLevel = RarityHelper.GetRarityLevel(item.ID) or 1 end)
    end
    local affixNum = (item.MainAffix and tonumber(item.MainAffix.Number)) or 0
    local enhance = tonumber(item.EnchanceNum) or 0
    return (rarityLevel * 1e12) + (basePower * 1e9) + affixNum + (enhance * 10)
end

function equipBestGearNow(targetSlot)
    if not BackpackRE_TryEquip then return end
    local have = getBackpackData()
    local targets = (targetSlot == "All" or not targetSlot) and {"Weapon", "Armor", "Hat"} or {targetSlot}

    for _, slot in ipairs(targets) do
        local bestUuid = nil
        local bestScore = -1
        for uuid, item in pairs(have) do
            if item.Type == slot then
                local score = calculateGearScore(item)
                if score > bestScore then
                    bestScore = score
                    bestUuid = uuid
                end
            end
        end
        if bestUuid then
            pcall(function() BackpackRE_TryEquip:FireServer(bestUuid, slot) end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- 11. TRAIN MULTIPLIER ZONES CONFIG
-- ═══════════════════════════════════════════════════════════════════
local TrainAreaConfig = {
    { Id = 1,  Name = "Train_1 (x1.5 Power | Reb 0)",  Rebirth = 0,  PadPos = Vector3.new(-53.0, 3.0, -41.0), DummyPos = Vector3.new(-53.0, 3.0, -45.0) },
    { Id = 2,  Name = "Train_2 (x2 Power | Reb 2)",    Rebirth = 2,  PadPos = Vector3.new(-53.0, 3.0, -20.9), DummyPos = Vector3.new(-53.0, 3.0, -25.0) },
    { Id = 3,  Name = "Train_3 (x4 Power | Reb 5)",    Rebirth = 5,  PadPos = Vector3.new(-53.0, 3.0, 21.4),  DummyPos = Vector3.new(-53.0, 3.0, 26.0) },
    { Id = 4,  Name = "Train_4 (x6 Power | Reb 9)",    Rebirth = 9,  PadPos = Vector3.new(-53.0, 3.0, 43.25), DummyPos = Vector3.new(-53.0, 3.0, 48.0) },
    { Id = 5,  Name = "Train_5 (x8 Power | Reb 12)",   Rebirth = 12, PadPos = Vector3.new(-80.0, 8.6, 21.29), DummyPos = Vector3.new(-80.0, 8.6, 26.0) },
    { Id = 6,  Name = "Train_6 (x10 Power | Reb 15)",  Rebirth = 15, PadPos = Vector3.new(-80.0, 9.1, -20.90),DummyPos = Vector3.new(-80.0, 9.1, -25.0) },
    { Id = 7,  Name = "Train_7 (x15 Power | Reb 18)",  Rebirth = 18, PadPos = Vector3.new(-108.0, 12.7, 32.24),DummyPos = Vector3.new(-108.0, 12.7, 37.0) },
    { Id = 8,  Name = "Train_8 (x25 Power | Reb 21)",  Rebirth = 21, PadPos = Vector3.new(-106.0, 10.6, -31.00),DummyPos = Vector3.new(-106.0, 10.6, -35.0) },
}

local function getBestTrainZone()
    local ProfileData = require(ReplicatedStorage.ProfileData)
    local pd = ProfileData and ProfileData.GetTotalData and ProfileData.GetTotalData()
    local curReb = pd and pd.Eco and tonumber(pd.Eco.rebirth) or 0
    local best = TrainAreaConfig[1]
    for _, z in ipairs(TrainAreaConfig) do
        if curReb >= z.Rebirth then best = z end
    end
    return best
end

-- ═══════════════════════════════════════════════════════════════════
-- 12. WINDOW & TAB CREATION (AURORA v3.0)
-- ═══════════════════════════════════════════════════════════════════
local Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    Subtitle = "LOOT TO FORGE • MASTER HUB v3.0",
    Size = UDim2.fromOffset(720, 500),
    Name = "ProjectBarunForge",
    ToggleKey = Enum.KeyCode.RightShift,
})
_G.PB_ActiveWindow = Window

local TabFarming = Window:CreateTab({ Name = "Farming & Stage", Icon = "⚡", Subtitle = "Stage, Mobs & Ore Mining" })
local TabForge   = Window:CreateTab({ Name = "Forge & Gear",    Icon = "💎", Subtitle = "Smart 2SKI Slicing & Auto Equip" })
local TabCombat  = Window:CreateTab({ Name = "Combat & Train",  Icon = "⚔️", Subtitle = "Auto Training & Enemy Slaying" })
local TabMisc    = Window:CreateTab({ Name = "Misc & Upgrades", Icon = "⚙️", Subtitle = "Economy, Upgrades & SuperLoot" })
local TabConfig  = Window:CreateTab({ Name = "Settings & Save",  Icon = "💾", Subtitle = "Persistent JSON Profile Engine" })

-- ─────────────────────────────────────────────────────────────────────
-- TAB 1: FARMING & STAGE
-- ─────────────────────────────────────────────────────────────────────
TabFarming:AddSection("LIVE TELEMETRY")
local StatRebirth = TabFarming:AddStatCard({ Title = "Current Rebirth", Value = "0", Subtext = "Live Player Rebirth" })
local StatBestZone = TabFarming:AddStatCard({ Title = "Best Multiplier Zone", Value = "Zone 1", Subtext = "Optimal Training Multiplier" })
local StatBackpackOres = TabFarming:AddStatCard({ Title = "Ores in Backpack", Value = "0", Subtext = "Ready to Forge" })

TabFarming:AddSection("STAGE AUTOMATION")
TabFarming:AddToggle({
    Name = "Auto Stage & Claim Ore",
    Desc = "เคลียร์ด่านและเก็บแร่ทั้งหมดส่งตรงเข้าคลังอัตโนมัติ",
    Default = Settings.AutoStageOre,
    Callback = function(Value)
        Settings.AutoStageOre = Value
        Window:Notify({ Title = "Auto Stage", Content = Value and "Active!" or "Paused.", Type = Value and "success" or "warning" })
    end
})

TabFarming:AddToggle({
    Name = "Auto Max Stage (ลุยด่านสูงสุดอัตโนมัติ)",
    Desc = "ดันด่านระดับสูงสุดที่ผ่านได้เพื่อรับแร่คุณภาพสูง",
    Default = Settings.AutoMaxStage,
    Callback = function(Value) Settings.AutoMaxStage = Value end
})

TabFarming:AddTextbox({
    Name = "Specific Stage Name",
    Placeholder = "e.g. Stage_27",
    Default = Settings.StageName,
    Callback = function(Value) Settings.StageName = Value end
})

TabFarming:AddToggle({
    Name = "Silent Insta-Kill Mobs (สังหารม็อบในสเตจทันที)",
    Desc = "ยิงสัญญาณดาเมจ 1e30 สังหารม็อบทั้งฉากแบบไร้รอยต่อ",
    Default = Settings.SilentKillMobs,
    Callback = function(Value) Settings.SilentKillMobs = Value end
})

TabFarming:AddSlider({
    Name = "Stage Delay",
    Min = 0.15, Max = 2.0, Default = Settings.StageDelay,
    Increment = 0.05, ValueName = "sec",
    Callback = function(Value) Settings.StageDelay = Value end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 2: FORGE & GEAR
-- ─────────────────────────────────────────────────────────────────────
TabForge:AddSection("SMART FORGE ENGINE (2SKI SMART SLICING)")
TabForge:AddToggle({
    Name = "Auto Forge (หลอมอัตโนมัติ)",
    Desc = "เปิดระบบหลอมแร่อัจฉริยะ เลือกลำดับแร่และการคำนวณขั้นสูง",
    Default = Settings.AutoForge,
    Callback = function(Value)
        Settings.AutoForge = Value
        Window:Notify({ Title = "Auto Forge", Content = Value and "Forge Engine Active!" or "Forge Engine Paused.", Type = Value and "success" or "warning" })
    end
})

TabForge:AddDropdown({
    Name = "Forge Mode",
    Desc = "เลือกประเภทของอุปกรณ์ที่ต้องการหลอม",
    Default = "All",
    Options = {"All", "Weapon", "Armor", "Hat"},
    Callback = function(Value) Settings.ForgeType = Value end
})

TabForge:AddDropdown({
    Name = "Ore Quality Priority",
    Desc = "เลือกว่าจะใช้แร่เกรดสูงสุดหรือต่ำสุดก่อน",
    Default = "Best",
    Options = {"Best", "Low"},
    Callback = function(Value) Settings.OreQualityMode = Value end
})

TabForge:AddSlider({
    Name = "Min Ores To Forge (เกมนี้ต้องการขั้นต่ำ 4)",
    Min = 4, Max = 23, Default = Settings.MinOreToForge,
    Increment = 1, ValueName = "ores",
    Callback = function(Value) Settings.MinOreToForge = Value end
})

TabForge:AddSlider({
    Name = "Forge Loop Delay",
    Min = 0.2, Max = 2.0, Default = Settings.ForgeDelay,
    Increment = 0.1, ValueName = "sec",
    Callback = function(Value) Settings.ForgeDelay = Value end
})

TabForge:AddSection("GEAR MANAGEMENT")
TabForge:AddButton({
    Name = "Equip Best Gear Now (สวมใส่อุปกรณ์ที่ดีที่สุดทันที)",
    Icon = "💎",
    Callback = function()
        equipBestGearNow("All")
        Window:Notify({ Title = "Equip Gear", Content = "Equipped best weapon, armor, and hat!", Type = "success" })
    end
})

TabForge:AddToggle({
    Name = "Auto Equip Best After Forge",
    Desc = "ตรวจสอบและสวมใส่ชิ้นที่ดีกว่าทันทีหลังจากหลอมสำเร็จ",
    Default = Settings.AutoEquipBestAfter,
    Callback = function(Value) Settings.AutoEquipBestAfter = Value end
})

TabForge:AddToggle({
    Name = "Auto Enhance Equipped Weapon",
    Desc = "อัปเกรดตีบวกอาวุธที่กำลังสวมใส่ต่อเนื่อง",
    Default = Settings.AutoEnhance,
    Callback = function(Value) Settings.AutoEnhance = Value end
})

TabForge:AddToggle({
    Name = "Use Protection Item (หินกันแตก)",
    Desc = "ใช้หินป้องกันอุปกรณ์เสียหายขณะตีบวก",
    Default = Settings.UseProtect,
    Callback = function(Value) Settings.UseProtect = Value end
})

TabForge:AddToggle({
    Name = "Auto Sell Trash Gear (ขายขยะอุปกรณ์ - ไม่แตะต้องแร่)",
    Desc = "สแกนขายเฉพาะอาวุธ/เกราะ/หมวกที่มีค่าสเตตัสต่ำ ไม่ขายแร่เด็ดขาด",
    Default = Settings.AutoSellTrashGear,
    Callback = function(Value) Settings.AutoSellTrashGear = Value end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 3: COMBAT & TRAIN
-- ─────────────────────────────────────────────────────────────────────
TabCombat:AddSection("TRAINING AUTOMATION")
TabCombat:AddToggle({
    Name = "Auto Train (ฟันดาบเก็บพลัง)",
    Desc = "ส่งคำสั่งฝึกซ้อมความเร็วสูงต่อเนื่อง",
    Default = Settings.AutoTrain,
    Callback = function(Value) Settings.AutoTrain = Value end
})

TabCombat:AddToggle({
    Name = "Auto Best Multiplier Zone (ยืนแท่นคูณสูงสุดที่ปลดล็อค)",
    Desc = "วาร์ปและส่งคำสั่งเข้าแท่นที่ให้ตัวคูณพลังสูงสุดตาม Rebirth",
    Default = Settings.AutoTrainBestZone,
    Callback = function(Value) Settings.AutoTrainBestZone = Value end
})

TabCombat:AddSlider({
    Name = "Manual Train Zone (1-8)",
    Min = 1, Max = 8, Default = Settings.TrainAreaIndex,
    Increment = 1, ValueName = "Zone",
    Callback = function(Value) Settings.TrainAreaIndex = Value end
})

TabCombat:AddSection("BOSS & WORLD COMBAT")
TabCombat:AddToggle({
    Name = "Auto Attack Nearby Enemies",
    Desc = "โจมตีและส่งดาเมจใส่ม็อบรอบข้างอัตโนมัติ",
    Default = Settings.AutoAttack,
    Callback = function(Value) Settings.AutoAttack = Value end
})

TabCombat:AddToggle({
    Name = "Auto SuperLoot Hunter",
    Desc = "ค้นหาและสังหารกล่องสมบัติ SuperLoot ทันทีที่เกิด",
    Default = Settings.AutoSuperLoot,
    Callback = function(Value) Settings.AutoSuperLoot = Value end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 4: MISC & UPGRADES
-- ─────────────────────────────────────────────────────────────────────
TabMisc:AddSection("AUTOMATION & ECONOMY")
TabMisc:AddToggle({
    Name = "Auto Claim All Rewards (Online, Update, Offline, Ticket)",
    Desc = "กดรับรางวัลออนไลน์ อัปเดต และตั๋วดันเจี้ยนอัตโนมัติ",
    Default = Settings.AutoClaimRewards,
    Callback = function(Value) Settings.AutoClaimRewards = Value end
})

TabMisc:AddToggle({
    Name = "Auto Upgrades (Train / OrePack / Luck)",
    Desc = "อัปเกรดความสามารถสายฝึกซ้อม ความจุแร่ และดวงอัตโนมัติ",
    Default = Settings.AutoUpgrade,
    Callback = function(Value) Settings.AutoUpgrade = Value end
})

TabMisc:AddToggle({
    Name = "Auto Rebirth (จุติอัตโนมัติเมื่อครบเงื่อนไข)",
    Desc = "จุติตัวละครเพื่อรับตัวคูณพลังถาวร",
    Default = Settings.AutoRebirth,
    Callback = function(Value) Settings.AutoRebirth = Value end
})

TabMisc:AddToggle({
    Name = "Auto Class Luck Roll",
    Desc = "สุ่มคลาสเพื่อรับดวงโบนัส",
    Default = Settings.AutoLuckRoll,
    Callback = function(Value) Settings.AutoLuckRoll = Value end
})

-- ─────────────────────────────────────────────────────────────────────
-- TAB 5: SETTINGS & CONFIGURATION PROFILES (SAVE & LOAD)
-- ─────────────────────────────────────────────────────────────────────
TabConfig:AddSection("💾 CONFIGURATION PROFILES")

local CONFIG_FILE = "PB_LootToForge_Config.json"
local currentProfile = "default"

local ConfigManager = {}
do
    local function getCleanFilename(name)
        if name and name ~= "" and name ~= "default" then
            local sanitized = name:gsub("[^%w_%-]", "")
            if sanitized ~= "" then
                return "PB_LootToForge_" .. sanitized .. ".json"
            end
        end
        return CONFIG_FILE
    end

    function ConfigManager.Save(name)
        if not writefile then return false, "Executor lacks writefile" end
        local path = getCleanFilename(name)
        local clean = {}
        for k, v in pairs(Settings) do
            local t = type(v)
            if t == "boolean" or t == "number" or t == "string" or t == "table" then
                clean[k] = v
            end
        end
        local ok, encoded = pcall(function() return HttpService:JSONEncode(clean) end)
        if not ok or not encoded then return false, "JSON Encode failed" end
        local wOk, wErr = pcall(function() writefile(path, encoded) end)
        return wOk, wOk and path or tostring(wErr)
    end

    function ConfigManager.Load(name)
        local path = getCleanFilename(name)
        if not (isfile and readfile and isfile(path)) then return false, "File not found" end
        local rOk, content = pcall(function() return readfile(path) end)
        if not rOk or not content or content == "" then return false, "Read failed" end
        local dOk, decoded = pcall(function() return HttpService:JSONDecode(content) end)
        if not dOk or type(decoded) ~= "table" then return false, "JSON Decode failed" end
        for k, v in pairs(decoded) do
            Settings[k] = v
        end
        return true, path
    end
end

TabConfig:AddTextbox({
    Name = "Profile Name (ชื่อคอนฟิก)",
    Placeholder = "e.g. default",
    Default = "default",
    Callback = function(val)
        currentProfile = (val and val:gsub("%s+", "") ~= "") and val:gsub("%s+", "") or "default"
    end
})

TabConfig:AddButton({
    Name = "💾 Save Config (บันทึกคอนฟิก)",
    Icon = "💾",
    Callback = function()
        local ok, path = ConfigManager.Save(currentProfile)
        if ok then
            Window:Notify({
                Title = "Config Saved",
                Content = "บันทึกการตั้งค่าลงไฟล์ " .. currentProfile .. " สำเร็จ!",
                Type = "success"
            })
        else
            Window:Notify({
                Title = "Save Failed",
                Content = tostring(path),
                Type = "error"
            })
        end
    end
})

TabConfig:AddButton({
    Name = "📂 Load Config (โหลดคอนฟิก)",
    Icon = "📂",
    Callback = function()
        local ok, path = ConfigManager.Load(currentProfile)
        if ok then
            Window:Notify({
                Title = "Config Loaded",
                Content = "โหลดการตั้งค่าจากไฟล์ " .. currentProfile .. " เรียบร้อย!",
                Type = "success"
            })
        else
            Window:Notify({
                Title = "Load Failed",
                Content = tostring(path),
                Type = "error"
            })
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- 13. EXECUTION THREADS
-- ═══════════════════════════════════════════════════════════════════

-- Thread 1: Auto Train & Best Multiplier Zone
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoTrain or Settings.AutoTrainBestZone then
            safe(function()
                if Settings.AutoTrainBestZone then
                    local target = getBestTrainZone()
                    if target then
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - target.PadPos).Magnitude > 6 then
                            hrp.CFrame = CFrame.lookAt(target.PadPos + Vector3.new(0, 2, 0), target.DummyPos)
                        end
                        if LocalPlayer:GetAttribute("AutoTrainAreaID") ~= target.Id and TrainRE_IntoArea then
                            TrainRE_IntoArea:FireServer(target.Id)
                        end
                    end
                end

                if TrainCTRL and TrainCTRL.TrainOnce then TrainCTRL.TrainOnce() end
                if TrainRE_Once then TrainRE_Once:FireServer() end
            end)
            task.wait(Settings.TrainDelay)
        else
            task.wait(0.5)
        end
    end
end)

-- Thread 2: Auto Stage Clearing + Silent Mobs Kill + Auto Sweep
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoStageOre and StageRF_Finish then
            safe(function()
                local stageId = Settings.StageName
                if Settings.AutoMaxStage then
                    pcall(function()
                        local ProfileData = require(ReplicatedStorage.ProfileData)
                        local pd = ProfileData and ProfileData.GetTotalData()
                        local pass = pd and pd.Stats and pd.Stats.StagePass or 0
                        stageId = "Stage_" .. tostring(math.clamp(pass + 1, 1, 27))
                    end)
                end

                local ok, loot = pcall(function() return StageRF_Finish:InvokeServer(stageId) end)
                if ok and type(loot) == "table" then
                    for oreKey in pairs(loot) do
                        if StageRF_GetOre then StageRF_GetOre:InvokeServer(oreKey) end
                    end
                    if StageRE_Claim then StageRE_Claim:FireServer() end
                end

                if Settings.SilentKillMobs and Bindable_EnemyHit then
                    local ef = workspace:FindFirstChild("EnemyFolder")
                    if ef then
                        for _, enemy in ipairs(ef:GetChildren()) do
                            local uuid = enemy:GetAttribute("UUID") or enemy.Name
                            Bindable_EnemyHit:Fire(uuid, 1e30)
                            if EnemyCTRL and EnemyCTRL.HurtEnemy then EnemyCTRL.HurtEnemy(uuid, 1e30) end
                        end
                    end
                end
            end)
            task.wait(Settings.StageDelay)
        else
            task.wait(0.5)
        end
    end
end)

-- Thread 3: Dedicated Smart Auto Forge
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoForge then
            safe(function()
                executeForgeNow(Settings.ForgeType, Settings.MinOreToForge)
            end)
            task.wait(Settings.ForgeDelay or 0.6)
        else
            task.wait(0.5)
        end
    end
end)

-- Thread 4: Auto Enhance Equipped Weapon
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoEnhance and BackpackRF_Enhance and ProfileRF then
            safe(function()
                local prof = ProfileRF:InvokeServer()
                if prof and prof.Backpack and prof.Backpack.equiped then
                    local eq = prof.Backpack.equiped.Weapon
                    if eq then
                        BackpackRF_Enhance:InvokeServer(eq, { UseProtect = Settings.UseProtect })
                    end
                end
            end)
            task.wait(1.5)
        else
            task.wait(1.0)
        end
    end
end)

-- Thread 5: Safe Auto Sell Trash Gear
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoSellTrashGear and BackpackRE_SellItem then
            safe(function()
                local have = getBackpackData()
                for uuid, item in pairs(have) do
                    if item.Type == "Weapon" or item.Type == "Armor" or item.Type == "Hat" then
                        local isEquipped = false
                        pcall(function()
                            if BackpackData and BackpackData.IsEquipedUUID then
                                isEquipped = BackpackData.IsEquipedUUID(uuid)
                            end
                        end)
                        if not isEquipped then
                            local score = calculateGearScore(item)
                            if score < 5e11 then
                                BackpackRE_SellItem:FireServer(uuid)
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end)
            task.wait(4.0)
        else
            task.wait(2.0)
        end
    end
end)

-- Thread 6: Rewards & Claim Automation
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoClaimRewards then
            safe(function()
                if OnlineRE_Claim then for i = 1, 12 do OnlineRE_Claim:FireServer(i) end end
                if UpdateRE_Claim then UpdateRE_Claim:FireServer() end
                if OfflineRE_Claim then OfflineRE_Claim:FireServer() end
                if DungeonRE_Claim then DungeonRE_Claim:FireServer() end
            end)
            task.wait(5.0)
        else
            task.wait(2.0)
        end
    end
end)

-- Thread 7: Auto Upgrades & Rebirth
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoUpgrade and UpgradeRE then
            safe(function()
                UpgradeRE:FireServer("Train")
                UpgradeRE:FireServer("OrePack")
                UpgradeRE:FireServer("Luck")
            end)
            task.wait(3.0)
        end
        if Settings.AutoRebirth and RebirthRE then
            safe(function() RebirthRE:FireServer() end)
            task.wait(3.0)
        end
        task.wait(1.0)
    end
end)

-- Thread 8: Auto SuperLoot Hunter
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoSuperLoot and SuperLootRE_Kill then
            safe(function()
                local slf = workspace:FindFirstChild("SuperLootFolder")
                if slf then
                    for _, cat in ipairs(slf:GetChildren()) do
                        for _, loot in ipairs(cat:GetChildren()) do
                            local id = loot:GetAttribute("SuperLootID") or loot.Name
                            SuperLootRE_Kill:FireServer(id)
                        end
                    end
                end
            end)
            task.wait(3.0)
        else
            task.wait(2.0)
        end
    end
end)

-- Thread 9: Combat Attack
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        if Settings.AutoAttack then
            safe(function()
                local ef = workspace:FindFirstChild("EnemyFolder")
                if ef then
                    for _, enemy in ipairs(ef:GetChildren()) do
                        local hum = enemy:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            if AttackRE_Enemy then AttackRE_Enemy:FireServer(enemy) end
                            if AttackRE_Kill  then AttackRE_Kill:FireServer(enemy) end
                        end
                    end
                end
            end)
            task.wait(Settings.AttackDelay)
        else
            task.wait(0.5)
        end
    end
end)

-- Thread 10: Real-time Telemetry Live Feed
task.spawn(function()
    while Running and _G.LootToForgeActiveToken == myToken do
        safe(function()
            local ProfileData = require(ReplicatedStorage.ProfileData)
            local pd = ProfileData and ProfileData.GetTotalData and ProfileData.GetTotalData()
            local curReb = pd and pd.Eco and tonumber(pd.Eco.rebirth) or 0
            if StatRebirth then StatRebirth:Set(tostring(curReb), Theme.AccentCyan, "Player Rebirth Count") end

            local bestZone = getBestTrainZone()
            if StatBestZone and bestZone then StatBestZone:Set(bestZone.Name, Theme.Success, "Best Multiplier Zone") end

            local have = getBackpackData()
            local oreCount = 0
            for _, item in pairs(have) do
                if type(item) == "table" and type(item.ID) == "string" and (item.Type == "Ore" or item.ID:find("Ore")) then
                    local count = (type(item.Number) == "number" and item.Number > 0) and item.Number or 1
                    oreCount = oreCount + count
                end
            end
            if StatBackpackOres then StatBackpackOres:Set(tostring(oreCount), Theme.Warning, "Total Ores Available") end
        end)
        task.wait(1.5)
    end
end)

Window:Notify({
    Title = "PROJECT BARUN",
    Content = "Loot To Forge Hub v3.0 Loaded Successfully!",
    Type = "success",
    Duration = 4.0
})
