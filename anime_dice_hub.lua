--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║        💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA EDITION v3.0        ║
    ║        Pure Luau • Neo-Cyber Glassmorphism • Ultra-Luxe Micro-FX         ║
    ║       Engineered by cook45 with Mimi Precision for Clack's Scripts       ║
    ╚══════════════════════════════════════════════════════════════════════════╝

    [WHAT'S NEW IN v3.0]
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

    [API — unchanged from v2.0, fully backward compatible]
    UI:CreateWindow({ Title, Subtitle, Size, Name, ToggleKey })
    Window:Notify({ Title, Content, Icon, Duration, Type })
    Window:CreateTab({ Name, Icon, Subtitle })
    Tab:AddSection / AddStatCard / AddToggle / AddSlider / AddButton / AddDropdown / AddTextbox
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

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
    FontBold        = Enum.Font.GothamBold, -- (v2.0 referenced this but never defined it)
    FontBlack       = Enum.Font.GothamBlack,
    FontSemi        = Enum.Font.GothamMedium,
    FontRegular     = Enum.Font.Gotham,
}

local WHITE = Color3.fromRGB(255, 255, 255)
local SHADOW_ASSET = "rbxassetid://1316045217"

local UI = {}
UI.__index = UI

-- ─── Core helpers ───────────────────────────────────────────────────
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
    for k, v in pairs(props) do
        p[k] = v
    end
    return make("TextLabel", p, children)
end

-- Faux radial glow: stacked translucent circles (no external asset needed)
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

-- Glass card factory (shared by every widget)
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
        make("Frame", { -- top highlight hairline
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
-- WINDOW CREATION
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText    = config.Title or "PROJECT BARUN"
    local SubtitleText = config.Subtitle or "PB CYBER ENGINE v3.0"
    local WindowSize   = config.Size or UDim2.new(0, 840, 0, 520)
    local WindowName   = config.Name or "ApexScriptHub"
    local ToggleKey    = config.ToggleKey or Enum.KeyCode.RightShift

    local okHui, huiTarget = pcall(function()
        return gethui and gethui()
    end)
    local ParentTarget = (okHui and huiTarget) or CoreGui

    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == WindowName then
            existing:Destroy()
        end
    end

    -- Global connection tracker (cleaned up automatically on destroy)
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

    -- ─── Root (scales/animates as one unit) ──────────────────────────
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

    -- Chassis is a CanvasGroup => rounded clipping + group fade
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

    -- Aurora ambient orbs
    orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
    orb(Main, Theme.AccentCyan, 400, UDim2.new(0.12, 0, 1.0, 0))
    orb(Main, Theme.AccentSecondary, 260, UDim2.new(0.62, 0, 0.55, 0))

    -- Orbiting gradient border (sibling above chassis so the stroke is never clipped)
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

    -- Neon accent line + moving shimmer
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

    -- Toast HUD
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
        make("Frame", { -- fading divider
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

    -- ─── Logo (cached asset, downloaded asynchronously so the UI opens instantly) ───
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
        TextSize = 15,
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
        TextSize = 8.5,
        TextColor3 = Theme.AccentCyan,
        Position = UDim2.new(0, 64, 0, 31),
        Size = UDim2.new(0, 260, 0, 14),
        Parent = TopBar,
    })

    -- Live performance pill
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
            TextSize = 10,
            TextColor3 = Theme.TextBody,
            TextXAlignment = Enum.TextXAlignment.Center,
            Position = UDim2.new(0, 22, 0, 0),
            Size = UDim2.new(1, -28, 1, 0),
        }),
    })

    -- Window controls
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

    -- ─── Smooth momentum dragging ────────────────────────────────────
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

    -- ─── Floating minimized badge ────────────────────────────────────
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

    -- Async logo load (cache first, download second)
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

    -- ─── Show / hide / minimize ──────────────────────────────────────
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

    -- ─── Single shared animation + telemetry loop ────────────────────
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

            -- shimmer sweeps every ~4.5s
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

    -- ─── Body (floating sidebar + content) ───────────────────────────
    local Body = make("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -58),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        Parent = Main,
    })

    local Sidebar = make("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 200, 1, -12),
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

    -- Sidebar footer: player chip
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
            TextSize = 11,
            TextColor3 = Theme.TextTitle,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Position = UDim2.new(0, 46, 0, 7),
            Size = UDim2.new(1, -54, 0, 16),
        }),
        txt({
            Name = "PlayerTag",
            Text = "@" .. LocalPlayer.Name,
            Font = Theme.FontRegular,
            TextSize = 9.5,
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
        Size = UDim2.new(1, -232, 1, -12),
        Position = UDim2.new(0, 220, 0, 4),
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

    -- ─── Toast HUD ───────────────────────────────────────────────────
    local ToastTypes = {
        info    = { Theme.AccentCyan, "⚡" },
        success = { Theme.Success, "✓" },
        warning = { Theme.Warning, "!" },
        error   = { Theme.Danger, "✕" },
    }

    function WindowObj:Notify(toast)
        toast = toast or {}
        local title = toast.Title or "System Notification"
        local desc  = toast.Content or ""
        local dur   = toast.Duration or 3.5
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
            make("Frame", { -- beacon
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
                    TextSize = 13,
                    TextColor3 = color,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Size = UDim2.new(1, 0, 1, 0),
                }),
            }),
            txt({
                Text = title,
                Font = Theme.FontTitle,
                TextColor3 = Theme.TextTitle,
                TextSize = 12,
                Position = UDim2.new(0, 054, 0, 10),
                Size = UDim2.new(1, -64, 0, 18),
            }),
            txt({
                Text = desc,
                Font = Theme.FontRegular,
                TextColor3 = Theme.TextDim,
                TextSize = 10,
                TextWrapped = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                Position = UDim2.new(0, 54, 0, 29),
                Size = UDim2.new(1, -64, 0, 28),
            }),
            make("Frame", { -- progress track
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

    -- ═════════════════════════════════════════════════════════════════
    -- TAB CONSTRUCTOR
    -- ═════════════════════════════════════════════════════════════════
    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Category"
        local TabIcon = tabConfig.Icon or "✦"
        local TabSub  = tabConfig.Subtitle or ""

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

        -- Page header
        make("Frame", {
            Name = "PageHeader",
            Size = UDim2.new(1, 0, 0, TabSub ~= "" and 40 or 28),
            BackgroundTransparency = 1,
            LayoutOrder = -1,
            Parent = TabPage,
        }, {
            txt({
                Text = TabName,
                Font = Theme.FontBlack,
                TextSize = 16,
                TextColor3 = WHITE,
                Position = UDim2.new(0, 2, 0, 0),
                Size = UDim2.new(1, 0, 0, 24),
            }, {
                make("UIGradient", {
                    Color = ColorSequence.new(WHITE, Color3.fromRGB(176, 205, 255)),
                }),
            }),
            txt({
                Text = TabSub,
                Font = Theme.FontRegular,
                TextSize = 10,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 2, 0, 24),
                Size = UDim2.new(1, 0, 0, 14),
                Visible = TabSub ~= "",
            }),
        })

        -- Sidebar tab button
        local TabBtn = make("TextButton", {
            Name = "Tab_" .. TabName,
            Size = UDim2.new(1, 0, 0, 38),
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
                TextSize = 14,
                TextColor3 = Theme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2.new(0, 10, 0.5, -10),
                Size = UDim2.new(0, 22, 0, 20),
            }),
            txt({
                Name = "Label",
                Text = TabName,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 38, 0, 0),
                Size = UDim2.new(1, -42, 1, 0),
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

        -- ─────────────────────────────────────────────────────────────
        -- 1. SECTION DIVIDER
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddSection(secTitle)
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
                    TextSize = 10,
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

        -- ─────────────────────────────────────────────────────────────
        -- 2. STAT CARD (with optional live meter)
        -- ─────────────────────────────────────────────────────────────
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
                TextSize = 10.5,
                TextColor3 = Theme.TextDim,
                Position = UDim2.new(0, 22, 0, 9),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = card,
            })
            txt({
                Name = "SubLabel",
                Text = subtitle,
                TextSize = 9.5,
                TextColor3 = Theme.AccentCyan,
                Position = UDim2.new(0, 22, 0, 27),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = card,
            })
            txt({
                Name = "ValueLabel",
                Text = tostring(initial),
                Font = Theme.FontTitle,
                TextSize = 15,
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

        -- ─────────────────────────────────────────────────────────────
        -- 3. TOGGLE
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddToggle(togConfig)
            togConfig = togConfig or {}
            local name     = togConfig.Name or "Toggle Switch"
            local desc     = togConfig.Desc or ""
            local default  = togConfig.Default or false
            local callback = togConfig.Callback or function() end

            local isToggled = default
            local cardHeight = desc ~= "" and 52 or 44
            local OFF_COLOR = Color3.fromRGB(34, 38, 56)

            local ToggleCard = makeCard(TabPage, cardHeight, true)
            hoverable(ToggleCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, desc ~= "" and 9 or 0),
                Size = UDim2.new(1, -90, 0, desc ~= "" and 17 or cardHeight),
                Parent = ToggleCard,
            })
            if desc ~= "" then
                txt({
                    Text = desc,
                    TextSize = 9.5,
                    TextColor3 = Theme.TextDim,
                    Position = UDim2.new(0, 16, 0, 27),
                    Size = UDim2.new(1, -90, 0, 15),
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

        -- ─────────────────────────────────────────────────────────────
        -- 4. PRECISION SLIDER
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            local name     = sldConfig.Name or "Parameter Adjustment"
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
                TextSize = 11,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, 8),
                Size = UDim2.new(0.65, 0, 0, 16),
                Parent = SliderCard,
            })
            txt({
                Name = "ValText",
                Text = fmtVal(currentVal),
                Font = Theme.FontTitle,
                TextSize = 11.5,
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
                    TextSize = 9,
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

        -- ─────────────────────────────────────────────────────────────
        -- 5. NEO BUTTON (press-scale + ripple)
        -- ─────────────────────────────────────────────────────────────
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
                    TextSize = 12,
                    TextColor3 = Theme.AccentCyan,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Size = UDim2.new(1, 0, 1, 0),
                }),
            })

            local TitleLbl = txt({
                Name = "Title",
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 46, 0, 0),
                Size = UDim2.new(1, -80, 1, 0),
                Parent = Btn,
            })

            local Chevron = txt({
                Name = "Chevron",
                Text = "›",
                Font = Theme.FontBold,
                TextSize = 16,
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

        -- ─────────────────────────────────────────────────────────────
        -- 6. ACCORDION DROPDOWN (MULTI-SELECT + SMOOTH SCROLLING 2K ENGINE)
        -- ─────────────────────────────────────────────────────────────
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

            local cardHeight = desc ~= "" and 52 or 44
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

            make("Frame", { -- divider
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

        -- ─────────────────────────────────────────────────────────────
        -- 7. CYBER TEXTBOX (neon focus ring)
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddTextbox(txtConfig)
            txtConfig = txtConfig or {}
            local name     = txtConfig.Name or "Input Key / Text"
            local default  = txtConfig.Default or ""
            local place    = txtConfig.Placeholder or "Enter value..."
            local callback = txtConfig.Callback or function() end

            local BoxCard = makeCard(TabPage, 48, false)
            hoverable(BoxCard)

            txt({
                Text = name,
                Font = Theme.FontSemi,
                TextSize = 11.5,
                TextColor3 = Theme.TextTitle,
                Position = UDim2.new(0, 16, 0, 0),
                Size = UDim2.new(0.45, 0, 1, 0),
                Parent = BoxCard,
            })

            local Input = make("TextBox", {
                Size = UDim2.new(0, 180, 0, 30),
                Position = UDim2.new(1, -194, 0.5, -15),
                BackgroundColor3 = Theme.InputBg,
                Text = tostring(default),
                PlaceholderText = place,
                PlaceholderColor3 = Theme.TextDim,
                Font = Theme.FontRegular,
                TextSize = 11,
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

        -- ─────────────────────────────────────────────────────────────
        -- 8. CYBER PARAGRAPH / INFO BANNER
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddParagraph(paraConfig)
            paraConfig = paraConfig or {}
            local pTitle   = paraConfig.Title or paraConfig.Name or ""
            local pContent = paraConfig.Content or paraConfig.Desc or ""

            local ParaCard = make("Frame", {
                Name = "ParagraphCard",
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.CardBg,
                BackgroundTransparency = 0.05,
                Parent = TabPage,
            }, {
                corner(10),
                stroke(Theme.CardBorder, 1, 0.2),
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14),
                }),
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 4),
                }),
            })

            if pTitle ~= "" then
                txt({
                    Name = "ParaTitle",
                    Text = pTitle,
                    Font = Theme.FontBold,
                    TextSize = 13,
                    TextColor3 = Theme.AccentCyan,
                    Size = UDim2.new(1, 0, 0, 18),
                    Parent = ParaCard,
                })
            end

            local ContentLabel = txt({
                Name = "ParaContent",
                Text = pContent,
                Font = Theme.FontRegular,
                TextSize = 11,
                TextColor3 = Theme.TextDim,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                TextWrapped = true,
                Parent = ParaCard,
            })

            local ParaHandle = {}
            function ParaHandle:SetTitle(t)
                local titleLbl = ParaCard:FindFirstChild("ParaTitle")
                if titleLbl then
                    titleLbl.Text = tostring(t)
                end
            end
            function ParaHandle:SetContent(c)
                ContentLabel.Text = tostring(c)
            end
            function ParaHandle:Set(t, c)
                if t then ParaHandle:SetTitle(t) end
                if c then ParaHandle:SetContent(c) end
            end
            return ParaHandle
        end

        return TabObj
    end

    -- Intro animation
    task.defer(function()
        setVisible(true)
    end)

    return WindowObj
end


-- ═════════════════════════════════════════════════════════════════════
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
    "Cursed Tower",
    "Pirate Tower",
    "Hidden Leaf Tower",
    "Slayer Tower",
    "Shadow Tower",
    "Infinity Tower"
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
    HideTowerScreen             = false,
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

    pcall(function()
        local plotCtrl = Features and Features:FindFirstChild("Plot") and require(Features.Plot.PlotController)
        local p = plotCtrl and plotCtrl.plot
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if p and p:FindFirstChild("Slots") and hrp and firetouchinterest then
            for _, slot in ipairs(p.Slots:GetChildren()) do
                local bal = slot:FindFirstChild("Balance")
                local hitbox = bal and bal:FindFirstChild("Hitbox")
                if hitbox then
                    firetouchinterest(hrp, hitbox, 0)
                    firetouchinterest(hrp, hitbox, 1)
                end
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
            task.wait(1.5)
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

            local burstCount = Config.BurstRolls and math.clamp(tonumber(Config.BurstRollCount) or 3, 1, 10) or 1
            for b = 1, burstCount do
                local success = pcall(function()
                    RollService.RF.RollDice:InvokeServer()
                end)
                if success then
                    State.TotalRollsSession = State.TotalRollsSession + 1
                end
            end
            task.wait(duration)
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
                uv4.ActionWaitTime.damageEnemy = 0.05
                uv4.ActionWaitTime.damagePlayer = 0.05
                uv4.ActionWaitTime.floorStarted = 0.05
                uv4.ActionWaitTime.floorCompleted = 0.05
            end
        end
    end)
end

speedUpTowerCombat()

local function isPlayerInTower()
    local root = LP.PlayerGui:FindFirstChild("Root")
    local screen = root and root.Tower and root.Tower:FindFirstChild("Screen")
    local hidden = screen and screen.Parent and screen.Parent:FindFirstChild("Hidden")
    return (screen and screen.Visible == true) or (hidden and hidden.Visible == true)
end

local function getRealTowerFloor()
    local root = LP.PlayerGui:FindFirstChild("Root")
    local screen = root and root.Tower and root.Tower:FindFirstChild("Screen")
    local hidden = screen and screen.Parent and screen.Parent:FindFirstChild("Hidden")
    local fText = (screen and screen:FindFirstChild("Floor") and screen.Floor.Text)
        or (hidden and hidden:FindFirstChild("Floor", true) and hidden:FindFirstChild("Floor", true).Text)
    if fText then
        local num = fText:match("%d+")
        if num then return tonumber(num) or 1, fText end
    end
    return 1, "Floor 1"
end

local function activateInGameAutoButton()
    local root = LP.PlayerGui:FindFirstChild("Root")
    local screen = root and root.Tower and root.Tower:FindFirstChild("Screen")
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
    if TowersNet and TowersNet:FindFirstChild("RE") and TowersNet.RE:FindFirstChild("SetAutoTower") then
        pcall(function() TowersNet.RE.SetAutoTower:FireServer(true) end)
    end
end

local function startTowerLegit(towerName)
    if isPlayerInTower() then return true end

    -- 1. Equip best team first
    if EquipBestTowerTeamRE then
        pcall(function() EquipBestTowerTeamRE:FireServer() end)
        task.wait(0.2)
    end

    -- 2. Ensure combat accelerator is patched
    speedUpTowerCombat()

    -- 3. Enter selected tower strictly as chosen by user (with name variations support)
    local variations = { towerName }
    if towerName == "Hidden Leaf Tower" then table.insert(variations, "Leaf Tower") end
    if towerName == "Leaf Tower" then table.insert(variations, "Hidden Leaf Tower") end
    if towerName == "Slayer Tower" then table.insert(variations, "Demon Slayer Tower") end
    if towerName == "Shadow Tower" then table.insert(variations, "Solo Tower") end

    for _, name in ipairs(variations) do
        if TowerController and TowerController.startTower then
            pcall(function() TowerController.startTower(name) end)
        end
        if PlayTowerRF then
            pcall(function() PlayTowerRF:InvokeServer(name) end)
        end
        task.wait(0.3)
        if isPlayerInTower() then
            return true
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
                    local root = LP.PlayerGui:FindFirstChild("Root")
                    local screen = root and root.Tower and root.Tower:FindFirstChild("Screen")
                    local hidden = screen and screen.Parent and screen.Parent:FindFirstChild("Hidden")
                    if Config.HideTowerScreen and screen and screen.Visible and hidden and firesignal then
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

                    State.CurrentTowerStatus = "กำลังเข้า " .. tostring(towerName) .. " (ระบบของจริง)..."

                    if Config.AutoUseDamagePotionsInTower then
                        UsePotion("Damage IV")
                        UsePotion("Damage III")
                        UsePotion("Luck IV")
                    end

                    local started = startTowerLegit(towerName)
                    if started then
                        State.CurrentTowerStatus = "ต่อสู้ใน " .. tostring(towerName) .. " สำเร็จ!"
                        task.wait(1.5)
                        activateInGameAutoButton()
                    else
                        State.CurrentTowerStatus = string.format("หอคอย '%s' ยังไม่ปลดล็อก กำลังรอรอบถัดไป...", tostring(towerName))
                        if Config.AutoCycleTowers == true then
                            towerCycleIndex = towerCycleIndex + 1
                        end
                        task.wait(2.5)
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
    Subtitle = "ANIME DICE • MASTER HUB v3.5",
    DefaultTab = "Main Farm",
    Size = UDim2.fromOffset(840, 520),
    Accent = Color3.fromRGB(56, 189, 248),
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
