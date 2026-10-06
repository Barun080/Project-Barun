local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

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
    local WindowSize   = config.Size or UDim2.new(0, 720, 0, 480)
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
        TextSize = 16,
        TextColor3 = WHITE,
        Position = UDim2.new(0, 64, 0, 11),
        Size = UDim2.new(0, 220, 0, 18),
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
        Size = UDim2.new(0, 220, 0, 14),
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
            TextSize = 11,
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
                Position = UDim2.new(0, 054, 0, 10),
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

        -- Sidebar tab button
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

        -- ─────────────────────────────────────────────────────────────
        -- 6. ACCORDION DROPDOWN
        -- ─────────────────────────────────────────────────────────────
        function TabObj:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            local name     = dropConfig.Name or "Dropdown Selection"
            local options  = dropConfig.Options or {}
            local default  = dropConfig.Default or options[1]
            local callback = dropConfig.Callback or function() end

            local isExpanded = false
            local selected = default
            local expandedH = 58 + (#options * 32)

            local DropCard = makeCard(TabPage, 46, false)
            DropCard.ClipsDescendants = true

            local Header = make("TextButton", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = DropCard,
            }, {
                txt({
                    Text = name,
                    Font = Theme.FontSemi,
                    TextSize = 12,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 16, 0, 0),
                    Size = UDim2.new(0.5, 0, 1, 0),
                }),
                txt({
                    Name = "SelectedText",
                    Text = tostring(selected),
                    Font = Theme.FontBold,
                    TextSize = 11,
                    TextColor3 = Theme.AccentCyan,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0.4, 0, 0, 0),
                    Size = UDim2.new(0.6, -40, 1, 0),
                }),
                txt({
                    Name = "Arrow",
                    Text = "▾",
                    Font = Theme.FontBold,
                    TextSize = 13,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(1, -20, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                }),
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
                Position = UDim2.new(0, 12, 0, 46),
                BackgroundColor3 = Theme.CardBorderGlow,
                BackgroundTransparency = 0.7,
                Parent = DropCard,
            })

            local OptionsContainer = make("Frame", {
                Size = UDim2.new(1, -24, 0, math.max(#options * 32 - 4, 0)),
                Position = UDim2.new(0, 12, 0, 54),
                BackgroundTransparency = 1,
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
                    local active = (opt == selected)
                    tw(b, {
                        BackgroundColor3 = active and Theme.AccentPrimary or Color3.fromRGB(30, 34, 50),
                        BackgroundTransparency = active and 0.7 or 0.2,
                        TextColor3 = active and WHITE or Theme.TextBody,
                    }, 0.15)
                    b.Check.Visible = active
                end
            end

            local function setExpanded(state)
                isExpanded = state
                tw(DropCard, { Size = UDim2.new(1, 0, 0, state and expandedH or 46) }, state and 0.3 or 0.24, Enum.EasingStyle.Quart)
                tw(Header.Arrow, { Rotation = state and 180 or 0, TextColor3 = state and Theme.AccentCyan or Theme.TextDim }, 0.25)
            end

            for i, opt in ipairs(options) do
                local OptBtn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                    BackgroundTransparency = 0.2,
                    Text = tostring(opt),
                    Font = Theme.FontRegular,
                    TextSize = 11,
                    TextColor3 = Theme.TextBody,
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
                    selected = opt
                    Header.SelectedText.Text = tostring(opt)
                    paintOptions()
                    setExpanded(false)
                    task.spawn(callback, selected)
                end)
                OptBtn.MouseEnter:Connect(function()
                    if opt ~= selected then
                        tw(OptBtn, { BackgroundColor3 = Theme.AccentPrimary, BackgroundTransparency = 0.55, TextColor3 = WHITE }, 0.12)
                    end
                end)
                OptBtn.MouseLeave:Connect(function()
                    if opt ~= selected then
                        tw(OptBtn, { BackgroundColor3 = Color3.fromRGB(30, 34, 50), BackgroundTransparency = 0.2, TextColor3 = Theme.TextBody }, 0.12)
                    end
                end)
            end
            paintOptions()

            Header.MouseButton1Click:Connect(function()
                setExpanded(not isExpanded)
            end)

            local DropHandle = {}
            function DropHandle:Set(opt)
                if optionButtons[opt] then
                    selected = opt
                    Header.SelectedText.Text = tostring(opt)
                    paintOptions()
                    task.spawn(callback, selected)
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

        return TabObj
    end

    -- Intro animation
    task.defer(function()
        setVisible(true)
    end)

    return WindowObj
end

-- ═════════════════════════════════════════════════════════════════════
-- 🐜 BUILD AN ANT EMPIRE — ENTERPRISE AUTOMATION ENGINE
-- ═════════════════════════════════════════════════════════════════════
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

-- ─── Configuration Table (ALL DEFAULT TO FALSE ON INITIAL LOAD) ─────
local Config = {
    -- Auto Farming
    AutoCollectFood = false,
    FoodCollectDelay = 0.5,
    AutoRollAnt = false,
    RollAntDelay = 0.3,
    AutoSellFood = false,
    AutoDiscardTrash = false,
    
    -- Nest & Slots
    AutoUnlockSlots = false,
    AutoUpgradeNests = false,
    AutoCompost = false,
    AutoBuyEquipSlots = false,
    
    -- Utilities & Safety
    AutoRebirth = false,
    FastCollectMode = false,
    AutoEquipBest = false,
    AntiAFK = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false,
    NoClip = false,
}

local UIHandles = {}
local Window = nil

-- ─── Room & Player Discovery ─────────────────────────────────────────
local cachedRoom = nil
local function getPlayerRoom()
    if cachedRoom and cachedRoom.Parent then
        return cachedRoom
    end
    local rooms = Workspace:FindFirstChild("Rooms")
    if not rooms then return nil end

    local myName = LocalPlayer.Name
    local myDisplay = LocalPlayer.DisplayName
    
    for _, room in ipairs(rooms:GetChildren()) do
        -- Check PlayerMessage Billboard
        local pMsg = room:FindFirstChild("PlayerMessage")
        if pMsg then
            local bb = pMsg:FindFirstChildOfClass("BillboardGui")
            if bb then
                for _, lbl in ipairs(bb:GetDescendants()) do
                    if lbl:IsA("TextLabel") and (lbl.Text:find(myName) or lbl.Text:find(myDisplay)) then
                        cachedRoom = room
                        return room
                    end
                end
            end
        end
        -- Check _RollRuntime presence (only current player's room creates _RollRuntime client-side)
        if room:FindFirstChild("_RollRuntime") and room:FindFirstChild("_SummonPreview") then
            cachedRoom = room
            return room
        end
    end
    -- Fallback default Room 2 if matched
    if rooms:FindFirstChild("2") then
        cachedRoom = rooms["2"]
        return cachedRoom
    end
    return nil
end

-- ─── Safe ProximityPrompt Activation ─────────────────────────────────
local function safeTriggerPrompt(prompt)
    if not prompt or not prompt.Enabled then return false end
    pcall(function()
        if typeof(fireproximityprompt) == "function" then
            fireproximityprompt(prompt, 0)
        elseif prompt.InputHoldBegin then
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration + 0.05)
            prompt:InputHoldEnd()
        end
    end)
    return true
end

-- ─── Safe Button Activation in PlayerGui ─────────────────────────────
local function safeClickButton(btn)
    if not btn or not btn.Visible then return false end
    pcall(function()
        if typeof(firesignal) == "function" then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        else
            local events = {"MouseButton1Down", "MouseButton1Up", "MouseButton1Click", "Activated"}
            for _, ev in ipairs(events) do
                if btn[ev] then
                    pcall(function() firesignal(btn[ev]) end)
                end
            end
        end
    end)
    return true
end

-- ─── 2K BULLETPROOF CONFIGURATION ENGINE (ROOT FILE NO-FOLDER SAFE) ──
local function getCleanConfigFilename(profileName)
    local p = tostring(profileName or "default"):gsub("[^%w_%-]", "")
    if p == "" then p = "default" end
    return "PB_AntEmpire_Config_" .. p .. ".json"
end

local function serializeConfig()
    return {
        AutoCollectFood   = Config.AutoCollectFood == true,
        FoodCollectDelay  = tonumber(Config.FoodCollectDelay) or 0.5,
        AutoRollAnt       = Config.AutoRollAnt == true,
        RollAntDelay      = tonumber(Config.RollAntDelay) or 0.3,
        AutoSellFood      = Config.AutoSellFood == true,
        AutoDiscardTrash  = Config.AutoDiscardTrash == true,
        AutoUnlockSlots   = Config.AutoUnlockSlots == true,
        AutoUpgradeNests  = Config.AutoUpgradeNests == true,
        AutoCompost       = Config.AutoCompost == true,
        AutoBuyEquipSlots = Config.AutoBuyEquipSlots == true,
        AutoRebirth       = Config.AutoRebirth == true,
        FastCollectMode   = Config.FastCollectMode == true,
        AutoEquipBest     = Config.AutoEquipBest == true,
        AntiAFK           = Config.AntiAFK == true,
        WalkSpeed         = tonumber(Config.WalkSpeed) or 16,
        JumpPower         = tonumber(Config.JumpPower) or 50,
        InfJump           = Config.InfJump == true,
        NoClip            = Config.NoClip == true,
    }
end

local function notifyUser(title, text, kind)
    pcall(function()
        if Window and Window.Notify then
            Window:Notify({ Title = title, Content = text, Type = kind or "info" })
        end
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3.5
        })
    end)
end

local function saveConfig(profileName, silent)
    local fileName = getCleanConfigFilename(profileName)
    local data = serializeConfig()
    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if not encodeOk or not encoded then
        if not silent then notifyUser("PB Config Error", "JSON Encode ล้มเหลว", "error") end
        return false
    end

    local writeOk, writeErr = pcall(function()
        writefile(fileName, encoded)
    end)
    if writeOk then
        if not silent then
            notifyUser("PB Config", "บันทึกการตั้งค่าลงเครื่องเรียบร้อย! (" .. fileName .. ")", "success")
            print("[PB AntEmpire] Config saved to " .. fileName)
        end
        return true
    else
        if not silent then
            notifyUser("PB Config Error", "บันทึกไฟล์ล้มเหลว: " .. tostring(writeErr), "error")
            warn("[PB AntEmpire] Save error: " .. tostring(writeErr))
        end
        return false
    end
end

local function loadConfig(profileName, silent)
    local fileName = getCleanConfigFilename(profileName)
    if not (readfile and isfile and isfile(fileName)) then
        if not silent then
            notifyUser("PB Config", "ไม่พบไฟล์คอนฟิกบนเครื่อง (" .. fileName .. ")", "warning")
            warn("[PB AntEmpire] Config file not found: " .. fileName)
        end
        return false
    end

    local readOk, content = pcall(function()
        return readfile(fileName)
    end)
    if not readOk or not content or #content == 0 then
        if not silent then notifyUser("PB Config Error", "อ่านไฟล์คอนฟิกไม่สำเร็จ", "error") end
        return false
    end

    local parseOk, parsed = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    if not parseOk or type(parsed) ~= "table" then
        if not silent then notifyUser("PB Config Error", "การแปลงข้อมูล JSON ผิดพลาด", "error") end
        return false
    end

    for k, v in pairs(parsed) do
        Config[k] = v
    end

    -- UI Handles Synchronization
    if UIHandles.AutoCollectFood then pcall(function() UIHandles.AutoCollectFood:Set(Config.AutoCollectFood) end) end
    if UIHandles.AutoRollAnt then pcall(function() UIHandles.AutoRollAnt:Set(Config.AutoRollAnt) end) end
    if UIHandles.AutoSellFood then pcall(function() UIHandles.AutoSellFood:Set(Config.AutoSellFood) end) end
    if UIHandles.AutoDiscardTrash then pcall(function() UIHandles.AutoDiscardTrash:Set(Config.AutoDiscardTrash) end) end
    if UIHandles.AutoUnlockSlots then pcall(function() UIHandles.AutoUnlockSlots:Set(Config.AutoUnlockSlots) end) end
    if UIHandles.AutoUpgradeNests then pcall(function() UIHandles.AutoUpgradeNests:Set(Config.AutoUpgradeNests) end) end
    if UIHandles.AutoCompost then pcall(function() UIHandles.AutoCompost:Set(Config.AutoCompost) end) end
    if UIHandles.AutoBuyEquipSlots then pcall(function() UIHandles.AutoBuyEquipSlots:Set(Config.AutoBuyEquipSlots) end) end
    if UIHandles.AutoEquipBest then pcall(function() UIHandles.AutoEquipBest:Set(Config.AutoEquipBest) end) end
    if UIHandles.FastCollectMode then pcall(function() UIHandles.FastCollectMode:Set(Config.FastCollectMode) end) end
    if UIHandles.AntiAFK then pcall(function() UIHandles.AntiAFK:Set(Config.AntiAFK) end) end
    if UIHandles.WalkSpeed then pcall(function() UIHandles.WalkSpeed:Set(Config.WalkSpeed) end) end
    if UIHandles.JumpPower then pcall(function() UIHandles.JumpPower:Set(Config.JumpPower) end) end
    if UIHandles.InfJump then pcall(function() UIHandles.InfJump:Set(Config.InfJump) end) end
    if UIHandles.NoClip then pcall(function() UIHandles.NoClip:Set(Config.NoClip) end) end

    if not silent then
        notifyUser("PB Config", "โหลดการตั้งค่าสำเร็จ! (" .. fileName .. ")", "success")
        print("[PB AntEmpire] Config loaded from " .. fileName)
    end
    return true
end

local function resetConfig()
    Config.AutoCollectFood   = false
    Config.FoodCollectDelay  = 0.5
    Config.AutoRollAnt       = false
    Config.RollAntDelay      = 0.3
    Config.AutoSellFood      = false
    Config.AutoDiscardTrash  = false
    Config.AutoUnlockSlots   = false
    Config.AutoUpgradeNests  = false
    Config.AutoCompost       = false
    Config.AutoBuyEquipSlots = false
    Config.AutoRebirth       = false
    Config.FastCollectMode   = false
    Config.AutoEquipBest     = false
    Config.AntiAFK           = false
    Config.WalkSpeed         = 16
    Config.JumpPower         = 50
    Config.InfJump           = false
    Config.NoClip            = false

    for k, handle in pairs(UIHandles) do
        if handle and handle.Set and Config[k] ~= nil then
            pcall(function() handle:Set(Config[k]) end)
        end
    end
    notifyUser("PB Config", "รีเซ็ตการตั้งค่าเป็นค่าเริ่มต้นแล้ว (ปิดทั้งหมด)", "info")
end

-- ─── CREATE WINDOW ───────────────────────────────────────────────────
Window = UI:CreateWindow({
    Title = "PROJECT BARUN",
    Subtitle = "BUILD AN ANT EMPIRE • MASTER HUB v1.0",
    DefaultTab = "Auto Farm",
    Name = "PB_AntEmpire_Hub",
    Size = UDim2.new(0, 740, 0, 490),
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ═════════════════════════════════════════════════════════════════════
-- 📑 TAB 1: AUTO FARM & HARVEST
-- ═════════════════════════════════════════════════════════════════════
local TabFarm = Window:CreateTab({
    Name = "Auto Farm",
    Icon = "🌾",
    Subtitle = "ระบบเก็บอาหาร สุ่มมด และขายอัตโนมัติ",
})

TabFarm:AddSection({ Title = "📊 LIVE ROOM STATUS • สถานะห้อง", Icon = "🏡" })
local StatRoom = TabFarm:AddStatCard({ Title = "CURRENT ROOM", Value = "Scanning...", Sub = "Owner detected" })
local StatCash = TabFarm:AddStatCard({ Title = "PLAYER CASH", Value = "$ 0", Sub = "Leaderstats" })
local StatEff  = TabFarm:AddStatCard({ Title = "HARVEST EFF", Value = "0 /s", Sub = "Current Efficiency" })

task.spawn(function()
    while true do
        pcall(function()
            local r = getPlayerRoom()
            if r then
                StatRoom:Set("Room " .. r.Name, Theme.AccentCyan, "Active Station")
            else
                StatRoom:Set("Searching...", Theme.Warning, "Waiting for room")
            end

            local ls = LocalPlayer:FindFirstChild("leaderstats")
            if ls then
                if ls:FindFirstChild("Cash") then
                    StatCash:Set(tostring(ls.Cash.Value), Theme.Success, "Total Gold/Cash")
                end
                if ls:FindFirstChild("EFF") then
                    StatEff:Set(tostring(ls.EFF.Value) .. "/s", Theme.AccentPrimary, "Total Efficiency")
                end
            end
        end)
        task.wait(1.5)
    end
end)

TabFarm:AddSection({ Title = "⚡ HARVEST AUTOMATION • เก็บเกี่ยวอัตโนมัติ", Icon = "⚡" })

UIHandles.AutoCollectFood = TabFarm:AddToggle({
    Name = "Auto Collect Food (เก็บอาหารอัตโนมัติ)",
    Desc = "ดูด/กดรับอาหารในรังอัตโนมัติแบบต่อเนื่องผ่าน ProximityPrompt",
    Default = false,
    Callback = function(v)
        Config.AutoCollectFood = v
        saveConfig("default", true)
    end
})

UIHandles.FastCollectMode = TabFarm:AddToggle({
    Name = "Fast Collect Mode (โหมดเก็บความเร็วสูง)",
    Desc = "เพิ่มความถี่ในการกดเก็บอาหารแบบทันที (Zero Delay)",
    Default = false,
    Callback = function(v)
        Config.FastCollectMode = v
        saveConfig("default", true)
    end
})

TabFarm:AddSlider({
    Name = "Collect Interval Delay (หน่วงเวลาเก็บอาหาร)",
    Min = 0.1,
    Max = 2.0,
    Default = 0.5,
    Increment = 0.1,
    ValueName = "s",
    Callback = function(v)
        Config.FoodCollectDelay = v
    end
})

UIHandles.AutoSellFood = TabFarm:AddToggle({
    Name = "Auto Sell Food (ขายอาหารอัตโนมัติ)",
    Desc = "กดขายอาหารเมื่อพร้อมเพื่อแลกรับ Cash ทันที",
    Default = false,
    Callback = function(v)
        Config.AutoSellFood = v
        saveConfig("default", true)
    end
})

UIHandles.AutoDiscardTrash = TabFarm:AddToggle({
    Name = "Auto Discard Trash / Rubbish (ทิ้งเศษขยะ)",
    Desc = "กดสละสิทธิ์อาหารชั้นต่ำเพื่อล้างคิวอาหารทันที",
    Default = false,
    Callback = function(v)
        Config.AutoDiscardTrash = v
        saveConfig("default", true)
    end
})

TabFarm:AddSection({ Title = "🎲 ROLL & SUMMON • สุ่มตัวมด", Icon = "🎲" })

UIHandles.AutoRollAnt = TabFarm:AddToggle({
    Name = "Auto Roll Ant (สุ่มมดอัตโนมัติ)",
    Desc = "กด Roll Ant ที่แท่นสุ่มมดอัตโนมัติทันทีที่มีอาหาร/เงินพอ",
    Default = false,
    Callback = function(v)
        Config.AutoRollAnt = v
        saveConfig("default", true)
    end
})

TabFarm:AddSlider({
    Name = "Roll Ant Delay (หน่วงเวลาสุ่มมด)",
    Min = 0.1,
    Max = 1.5,
    Default = 0.3,
    Increment = 0.05,
    ValueName = "s",
    Callback = function(v)
        Config.RollAntDelay = v
    end
})

-- ═════════════════════════════════════════════════════════════════════
-- 🏰 TAB 2: NEST & UPGRADES
-- ═════════════════════════════════════════════════════════════════════
local TabNest = Window:CreateTab({
    Name = "Nest & Upgrades",
    Icon = "🏰",
    Subtitle = "อัปเกรดรัง ปลดล็อกช่อง และหมักปุ๋ย",
})

TabNest:AddSection({ Title = "🔓 UNLOCK & UPGRADE NEST • ปลดล็อกและอัปเกรด", Icon = "🔓" })

UIHandles.AutoUnlockSlots = TabNest:AddToggle({
    Name = "Auto Unlock Ant Slots (ปลดล็อกช่องมดอัตโนมัติ)",
    Desc = "ตรวจสอบและกด Unlock ช่องวางมดในรังทุกเทียร์ทันทีที่มีเงินพอ",
    Default = false,
    Callback = function(v)
        Config.AutoUnlockSlots = v
        saveConfig("default", true)
    end
})

UIHandles.AutoUpgradeNests = TabNest:AddToggle({
    Name = "Auto Upgrade Nest & Gacha Stand (อัปเกรดรัง & แท่นสุ่ม)",
    Desc = "กดอัปเกรดระดับรัง (蚁巢) และแท่นสุ่ม (抽奖台) อัตโนมัติ",
    Default = false,
    Callback = function(v)
        Config.AutoUpgradeNests = v
        saveConfig("default", true)
    end
})

UIHandles.AutoCompost = TabNest:AddToggle({
    Name = "Auto Compost Machine (อัปเกรดและดึงคันโยกปุ๋ยหมัก)",
    Desc = "ปลดล็อกและสั่งเดินเครื่องหมักปุ๋ย Compost Machine ($100K)",
    Default = false,
    Callback = function(v)
        Config.AutoCompost = v
        saveConfig("default", true)
    end
})

TabNest:AddSection({ Title = "🐜 INVENTORY & EQUIP • จัดทีมมด", Icon = "🐜" })

UIHandles.AutoEquipBest = TabNest:AddToggle({
    Name = "Auto Equip Best Ants (ใส่มดที่ดีที่สุดอัตโนมัติ)",
    Desc = "กดปุ่ม Equip Best Btn บนหน้าจอทันทีที่มีมดตัวเก่งกว่า",
    Default = false,
    Callback = function(v)
        Config.AutoEquipBest = v
        saveConfig("default", true)
    end
})

TabNest:AddButton({
    Name = "Equip Best Now (กดใส่มดที่ดีที่สุดทันที)",
    Icon = "⭐",
    Callback = function()
        local hud = LocalPlayer.PlayerGui:FindFirstChild("HUDContainer")
        local btn = hud and hud:FindFirstChild("HUDPanel") and hud.HUDPanel:FindFirstChild("Top") and hud.HUDPanel.Top:FindFirstChild("EquipBestBtn")
        if btn then
            safeClickButton(btn)
            notifyUser("PB AntEmpire", "กดใส่มดที่แข็งแกร่งที่สุดเรียบร้อยแล้ว!", "success")
        else
            notifyUser("PB AntEmpire", "ไม่พบปุ่ม Equip Best บนหน้าจอ", "warning")
        end
    end
})

TabNest:AddButton({
    Name = "Teleport to Player Nest (วาร์ปกลับห้องของตนเอง)",
    Icon = "🚀",
    Callback = function()
        local r = getPlayerRoom()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if r and hrp then
            local targetPos = r:FindFirstChild("BaseGround") or r:FindFirstChild("FoodSpawnPart") or r.PrimaryPart
            if targetPos then
                hrp.CFrame = targetPos.CFrame + Vector3.new(0, 5, 0)
                notifyUser("PB AntEmpire", "วาร์ปกลับมารังของคุณแล้ว!", "success")
            end
        else
            notifyUser("PB AntEmpire", "ยังไม่พบห้องหรือตัวละครผู้เล่น", "warning")
        end
    end
})

-- ═════════════════════════════════════════════════════════════════════
-- ⚙️ TAB 3: PLAYER & UTILITIES
-- ═════════════════════════════════════════════════════════════════════
local TabUtil = Window:CreateTab({
    Name = "Utilities",
    Icon = "⚙️",
    Subtitle = "ระบบเสริมความสะดวก และการเคลื่อนไหว",
})

TabUtil:AddSection({ Title = "🛡️ ANTI-AFK & SAFETY • ป้องกันการหลุด", Icon = "🛡️" })

UIHandles.AntiAFK = TabUtil:AddToggle({
    Name = "Anti-AFK (ป้องกันเกมเตะเมื่ออยู่เฉย)",
    Desc = "ดักจับ Idled Event และคลิกเสมือนเพื่อฟาร์มข้ามคืนได้ยาวนาน",
    Default = false,
    Callback = function(v)
        Config.AntiAFK = v
        saveConfig("default", true)
    end
})

-- Anti-AFK Connection
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

TabUtil:AddSection({ Title = "🏃 MOVEMENT SPEED • ปรับแต่งตัวละคร", Icon = "🏃" })

UIHandles.WalkSpeed = TabUtil:AddSlider({
    Name = "WalkSpeed (ความเร็วเดิน)",
    Min = 16,
    Max = 150,
    Default = 16,
    Increment = 1,
    ValueName = " spd",
    Callback = function(v)
        Config.WalkSpeed = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
})

UIHandles.JumpPower = TabUtil:AddSlider({
    Name = "JumpPower (แรงกระโดด)",
    Min = 50,
    Max = 250,
    Default = 50,
    Increment = 5,
    ValueName = " pwr",
    Callback = function(v)
        Config.JumpPower = v
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = v
        end
    end
})

UIHandles.InfJump = TabUtil:AddToggle({
    Name = "Infinite Jump (กระโดดลอยฟ้าไม่จำกัด)",
    Desc = "กระโดดกลางอากาศต่อเนื่องได้ไม่จำกัด",
    Default = false,
    Callback = function(v)
        Config.InfJump = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

UIHandles.NoClip = TabUtil:AddToggle({
    Name = "NoClip (เดินทะลุกำแพง)",
    Desc = "ปิดฟิสิกส์การชนของตัวละครเพื่อเดินผ่านสิ่งกีดขวาง",
    Default = false,
    Callback = function(v)
        Config.NoClip = v
    end
})

RunService.Stepped:Connect(function()
    if Config.NoClip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Keep speed applied after respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        if Config.WalkSpeed > 16 then hum.WalkSpeed = Config.WalkSpeed end
        if Config.JumpPower > 50 then
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpPower
        end
    end
end)

-- ═════════════════════════════════════════════════════════════════════
-- 💾 TAB 4: SETTINGS & CONFIGURATION
-- ═════════════════════════════════════════════════════════════════════
local TabSettings = Window:CreateTab({
    Name = "Settings",
    Icon = "💾",
    Subtitle = "บันทึกและโหลดคอนฟิกตามมาตรฐาน 2K",
})

TabSettings:AddSection({ Title = "📁 PROFILE MANAGEMENT • จัดการคอนฟิก", Icon = "📁" })

local currentProfile = "default"
TabSettings:AddTextbox({
    Name = "Profile Name (ชื่อคอนฟิก)",
    Default = "default",
    Placeholder = "พิมพ์ชื่อโปรไฟล์คอนฟิก...",
    Callback = function(txt)
        currentProfile = txt ~= "" and txt or "default"
    end
})

TabSettings:AddButton({
    Name = "Save Config (บันทึกคอนฟิก)",
    Icon = "💾",
    Callback = function()
        saveConfig(currentProfile, false)
    end
})

TabSettings:AddButton({
    Name = "Load Config (โหลดคอนฟิก)",
    Icon = "📂",
    Callback = function()
        loadConfig(currentProfile, false)
    end
})

TabSettings:AddButton({
    Name = "Reset Defaults (รีเซ็ตค่าเริ่มต้น)",
    Icon = "🔄",
    Callback = function()
        resetConfig()
    end
})

TabSettings:AddButton({
    Name = "Delete Config (ลบไฟล์คอนฟิก)",
    Icon = "🗑️",
    Callback = function()
        local fileName = getCleanConfigFilename(currentProfile)
        if delfile and isfile and isfile(fileName) then
            delfile(fileName)
            notifyUser("PB Config", "ลบไฟล์ " .. fileName .. " แล้ว", "info")
        else
            notifyUser("PB Config", "ไม่พบไฟล์ที่จะลบ (" .. fileName .. ")", "warning")
        end
    end
})

-- ═════════════════════════════════════════════════════════════════════
-- 🔄 BACKGROUND AUTOMATION WORKERS (ALL GATED BEHIND CONFIG FLAGS)
-- ═════════════════════════════════════════════════════════════════════

-- 1. Auto Collect Food Worker
task.spawn(function()
    while true do
        if Config.AutoCollectFood then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("PlayerFood") then
                    local p = r.PlayerFood:FindFirstChild("Prompt")
                    local prompt = p and p:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        safeTriggerPrompt(prompt)
                    end
                end
            end)
        end
        local d = Config.FastCollectMode and 0.08 or (Config.FoodCollectDelay or 0.5)
        task.wait(d)
    end
end)

-- 2. Auto Roll Ant Worker
task.spawn(function()
    while true do
        if Config.AutoRollAnt then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("_RollRuntime") then
                    local roll = r._RollRuntime:FindFirstChild("RollAnt")
                    local prompt = roll and roll:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        safeTriggerPrompt(prompt)
                    end
                end
            end)
        end
        task.wait(Config.RollAntDelay or 0.3)
    end
end)

-- 3. Auto Sell Food Worker
task.spawn(function()
    while true do
        if Config.AutoSellFood then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("PlayerFood") then
                    local sp = r.PlayerFood:FindFirstChild("SellPrompt")
                    local prompt = sp and sp:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        safeTriggerPrompt(prompt)
                    end
                end
            end)
        end
        task.wait(1.0)
    end
end)

-- 4. Auto Discard Trash Worker
task.spawn(function()
    while true do
        if Config.AutoDiscardTrash then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("PlayerFood") then
                    local rub = r.PlayerFood:FindFirstChild("Rubbish")
                    local prompt = rub and rub:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        safeTriggerPrompt(prompt)
                    end
                end
            end)
        end
        task.wait(1.5)
    end
end)

-- 5. Auto Unlock Slots & Upgrade Nests Worker
task.spawn(function()
    while true do
        if Config.AutoUnlockSlots or Config.AutoUpgradeNests then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("AntPos") and Config.AutoUnlockSlots then
                    for _, d in ipairs(r.AntPos:GetDescendants()) do
                        if d:IsA("ProximityPrompt") and d.Enabled and (d.Name == "UnlockPrompt" or d.ActionText:find("Unlock")) then
                            safeTriggerPrompt(d)
                            task.wait(0.2)
                        end
                    end
                end
                
                if r and Config.AutoUpgradeNests then
                    local nest = r:FindFirstChild("蚁巢")
                    local nestUpgr = nest and nest:FindFirstChild("Upgrade")
                    local p1 = nestUpgr and nestUpgr:FindFirstChildOfClass("ProximityPrompt")
                    if p1 and p1.Enabled then safeTriggerPrompt(p1) end

                    local gacha = r:FindFirstChild("抽奖台")
                    local gachaUpgr = gacha and gacha:FindFirstChild("Upgrade")
                    local p2 = gachaUpgr and gachaUpgr:FindFirstChildOfClass("ProximityPrompt")
                    if p2 and p2.Enabled then safeTriggerPrompt(p2) end
                end
            end)
        end
        task.wait(2.0)
    end
end)

-- 6. Auto Compost Machine Worker
task.spawn(function()
    while true do
        if Config.AutoCompost then
            pcall(function()
                local r = getPlayerRoom()
                if r and r:FindFirstChild("PlayerFood") then
                    local cm = r.PlayerFood:FindFirstChild("CompostMachine")
                    local prompt = cm and cm:FindFirstChildOfClass("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        safeTriggerPrompt(prompt)
                    end
                end
                -- Also trigger HUD CompostMachine PullLever if UI open
                local hud = LocalPlayer.PlayerGui:FindFirstChild("HUDContainer")
                local lever = hud and hud:FindFirstChild("CompostMachine") and hud.CompostMachine.Main:FindFirstChild("PullLever")
                if lever and lever.Visible then
                    safeClickButton(lever)
                end
            end)
        end
        task.wait(3.0)
    end
end)

-- 7. Auto Equip Best Worker
task.spawn(function()
    while true do
        if Config.AutoEquipBest then
            pcall(function()
                local hud = LocalPlayer.PlayerGui:FindFirstChild("HUDContainer")
                local btn = hud and hud:FindFirstChild("HUDPanel") and hud.HUDPanel:FindFirstChild("Top") and hud.HUDPanel.Top:FindFirstChild("EquipBestBtn")
                if btn and btn.Visible then
                    safeClickButton(btn)
                end
            end)
        end
        task.wait(5.0)
    end
end)

print("[PROJECT BARUN] Build An Ant Empire Master Hub v1.0 Loaded Successfully.")
