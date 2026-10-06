    -- ╔══════════════════════════════════════════════════════════════════╗
    -- ║   👻 PROJECT BARUN — GHOST DRIVER [ALPHA] GOD AUTO FARM HUB      ║
    -- ║   Architected with Project Barun (PB) Core Philosophy            ║
    -- ║   Developed by cook45 for clack with Mimi Engine                 ║
    -- ╚══════════════════════════════════════════════════════════════════╝

    -- ═══════════════════════════════════════════════════════════════════
    -- 1. TOKEN LIFECYCLE & STATE MANAGEMENT (PB System)
    -- ═══════════════════════════════════════════════════════════════════
    local myToken = tick()
    _G.GhostDriverActiveToken = myToken

    if _G.GhostDriverCleanup then
        pcall(_G.GhostDriverCleanup)
        task.wait(0.2)
    end

    _G.GhostDriverRunning = true
    local Connections = {}

    _G.GhostDriverCleanup = function()
        _G.GhostDriverRunning = false
        for _, conn in ipairs(Connections) do
            pcall(function() conn:Disconnect() end)
        end
        -- Destroy old ScreenGuis
        pcall(function()
            local h = gethui and gethui() or game:GetService("CoreGui")
            for _, g in ipairs(h:GetChildren()) do
                if g.Name == "ProjectBarunHub" or g.Name == "Orion" then
                    g:Destroy()
                end
            end
        end)
    end

    -- ═══════════════════════════════════════════════════════════════════
    -- 💎 PROJECT BARUN (PB) OBSIDIAN GLASS — AURORA EDITION v3.0
    -- Pure Luau • Neo-Cyber Glassmorphism • Ultra-Luxe Micro-FX
    -- Engineered by cook45 with Mimi Precision for Clack's Scripts
    -- ═══════════════════════════════════════════════════════════════════
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

    local LocalPlayerRef = Players.LocalPlayer or Players.PlayerAdded:Wait()

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

    local function tw(inst, props, dur, style, dir)
        local info = TweenInfo.new(dur or 0.28, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
        local t = TweenService:Create(inst, info, props)
        t:Play()
        return t
    end

    local function make(className, properties, children)
        local inst = Instance.new(className)
        if inst:IsA("GuiObject") then inst.BorderSizePixel = 0 end
        if inst:IsA("TextLabel") then inst.BackgroundTransparency = 1 end
        for k, v in pairs(properties or {}) do inst[k] = v end
        for _, child in ipairs(children or {}) do child.Parent = inst end
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
        for k, v in pairs(props or {}) do p[k] = v end
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

    local PB_UI = {}
    local CurrentActiveWindow = nil

    function PB_UI:CreateWindow(config)
        config = config or {}
        local TitleText    = config.Title or config.Name or "PROJECT BARUN | Ghost Driver"
        local SubtitleText = config.Subtitle or "PB AURORA GLASS ENGINE • v3.0"
        local WindowSize   = config.Size or UDim2.new(0, 720, 0, 480)
        local WindowName   = config.ConfigFolder or "ProjectBarunHub"
        local ToggleKey    = config.ToggleKey or Enum.KeyCode.RightShift

        local okHui, huiTarget = pcall(function() return gethui and gethui() end)
        local ParentTarget = (okHui and huiTarget) or CoreGui

        for _, existing in ipairs(ParentTarget:GetChildren()) do
            if existing.Name == WindowName or existing.Name == "ProjectBarunHub" or existing.Name == "Orion" then
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
            for _, c in ipairs(Conns) do pcall(function() c:Disconnect() end) end
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

        -- Aurora ambient light orbs inside chassis
        orb(Main, Theme.AccentPrimary, 460, UDim2.new(0.92, 0, 0.02, 0))
        orb(Main, Theme.AccentCyan, 400, UDim2.new(0.12, 0, 1.0, 0))
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

        -- Neon accent bar + traveling shimmer
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

        -- TopBar
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

        -- Logo Engine (Project Barun Official Asset)
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

        -- Live performance pill (FPS + Ping)
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
                Text = "60 FPS  •  35 ms",
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextBody,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2.new(0, 22, 0, 0),
                Size = UDim2.new(1, -28, 1, 0),
            }),
        })

        -- Window controls (Min / Close)
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
            b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = hoverBg, TextColor3 = hoverText }, 0.15) end)
            b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = bg, TextColor3 = textColor }, 0.15) end)
            return b
        end

        local MinBtn = controlButton("–", Theme.TextBody, Theme.CardBg, Theme.CardBorder, Theme.CardHover, WHITE, 1)
        local CloseBtn = controlButton("✕", Theme.Danger, Color3.fromRGB(38, 20, 28), Color3.fromRGB(80, 34, 46), Theme.Danger, WHITE, 2)

        -- Smooth momentum dragging
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

        -- Floating minimized badge
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

        -- Async logo loader
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

        -- Visibility controller
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

        MinBtn.MouseButton1Click:Connect(function() task.spawn(setVisible, false, true) end)
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

        -- Ambient & Telemetry Loop
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

        -- Body (Sidebar + Content)
        local Body = make("Frame", {
            Name = "Body",
            Size = UDim2.new(1, 0, 1, -58),
            Position = UDim2.new(0, 0, 0, 58),
            BackgroundTransparency = 1,
            Parent = Main,
        })

        local Sidebar = make("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, 185, 1, -12),
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

        -- Sidebar Player Profile Chip
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
                Text = LocalPlayerRef.DisplayName,
                Font = Theme.FontSemi,
                TextSize = 12,
                TextColor3 = Theme.TextTitle,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.new(0, 46, 0, 7),
                Size = UDim2.new(1, -54, 0, 16),
            }),
            txt({
                Name = "PlayerTag",
                Text = "@" .. LocalPlayerRef.Name,
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
                return Players:GetUserThumbnailAsync(LocalPlayerRef.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end)
            if ok and img and Footer.Parent then
                Footer.Avatar.Image = img
            end
        end)

        local ContentHolder = make("Frame", {
            Name = "ContentHolder",
            Size = UDim2.new(1, -213, 1, -12),
            Position = UDim2.new(0, 205, 0, 4),
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
        CurrentActiveWindow = WindowObj

        function WindowObj:SetVisible(state)
            task.spawn(setVisible, state and true or false, false)
        end

        local ToastTypes = {
            info    = { Theme.AccentCyan, "⚡" },
            success = { Theme.Success, "✓" },
            warning = { Theme.Warning, "!" },
            error   = { Theme.Danger, "✕" },
        }

        local ActiveToastsList = {}
        function WindowObj:Notify(toast)
            toast = toast or {}
            local title = toast.Title or toast.Name or "System Notification"
            local desc  = toast.Content or ""
            local dur   = toast.Duration or toast.Time or 3.5
            local kind  = ToastTypes[string.lower(tostring(toast.Type or "info"))] or ToastTypes.info
            local color = kind[1]
            local icon  = toast.Icon or kind[2]

            if #ActiveToastsList >= 3 then
                local oldest = table.remove(ActiveToastsList, 1)
                if oldest and oldest.Parent then
                    pcall(function() oldest:Destroy() end)
                end
            end

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

            table.insert(ActiveToastsList, wrapper)

            tw(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.45, Enum.EasingStyle.Back)
            local fill = card:FindFirstChild("Fill", true)
            if fill then tw(fill, { Size = UDim2.new(0, 0, 1, 0) }, dur, Enum.EasingStyle.Linear) end

            task.delay(dur, function()
                if not card.Parent then return end
                tw(card, { Position = UDim2.new(1, 60, 0, 0) }, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                task.wait(0.28)
                tw(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                task.wait(0.22)
                local idx = table.find(ActiveToastsList, wrapper)
                if idx then table.remove(ActiveToastsList, idx) end
                wrapper:Destroy()
            end)
        end

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

            function TabObj:AddLabel(labelText)
                local card = makeCard(TabPage, 44, false)
                hoverable(card)

                make("Frame", {
                    Size = UDim2.new(0, 3, 1, -14),
                    Position = UDim2.new(0, 8, 0, 7),
                    BackgroundColor3 = Theme.AccentCyan,
                    Parent = card,
                }, { pill() })

                local lbl = txt({
                    Name = "LabelText",
                    Text = tostring(labelText or ""),
                    Font = Theme.FontSemi,
                    TextSize = 12,
                    TextColor3 = Theme.TextTitle,
                    Position = UDim2.new(0, 20, 0, 0),
                    Size = UDim2.new(1, -28, 1, 0),
                    Parent = card,
                })

                local handle = {}
                function handle:Set(newText)
                    if lbl and lbl.Parent then
                        lbl.Text = tostring(newText or "")
                    end
                end
                return handle
            end

            function TabObj:AddStatCard(cardConfig)
                cardConfig = cardConfig or {}
                local title    = cardConfig.Title or "Telemetry Metric"
                local initial  = cardConfig.Value or "0"
                local subtitle = cardConfig.Subtext or "Live Feed"
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

            function TabObj:AddBanner(imageAsset, bannerHeight)
                bannerHeight = bannerHeight or 120
                local targetAsset = imageAsset or PB_LOGO_ASSET
                if tostring(targetAsset):find("71495519688848") and PB_LOGO_ASSET then
                    targetAsset = PB_LOGO_ASSET
                end

                local BannerCard = make("Frame", {
                    Size = UDim2.new(1, 0, 0, bannerHeight),
                    BackgroundColor3 = Theme.CardBg,
                    ClipsDescendants = true,
                    Parent = TabPage
                }, {
                    corner(12),
                    stroke(Theme.AccentCyan, 1.2, 0.25),
                    make("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 28, 48)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 18, 30)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 18, 46))
                        }),
                        Rotation = 25
                    }),
                    make("Frame", {
                        Name = "BannerFallbackContainer",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        ZIndex = 1
                    }, {
                        txt({
                            Text = "⚡ PROJECT BARUN ⚡",
                            Font = Theme.FontTitle,
                            TextSize = 18,
                            TextColor3 = Theme.AccentCyan,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            Position = UDim2.new(0, 0, 0.35, -10),
                            Size = UDim2.new(1, 0, 0, 24),
                        }),
                        txt({
                            Text = "GHOST DRIVER ENGINE • ULTIMATE AUTO HIGHWAY",
                            Font = Theme.FontBold,
                            TextSize = 10,
                            TextColor3 = Theme.AccentPrimary,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            Position = UDim2.new(0, 0, 0.58, 0),
                            Size = UDim2.new(1, 0, 0, 16),
                        })
                    }),
                    make("ImageLabel", {
                        Name = "BannerImage",
                        Size = UDim2.new(1, 0, 1, 0),
                        Position = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1,
                        Image = tostring(targetAsset),
                        ScaleType = Enum.ScaleType.Fit,
                        ZIndex = 2
                    })
                })
                return BannerCard
            end

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
                local name     = sldConfig.Name or "Parameter Adjustment"
                local min      = sldConfig.Min or 0
                local max      = sldConfig.Max or 100
                local default  = math.clamp(sldConfig.Default or min, min, max)
                local inc      = sldConfig.Increment or 1
                local suffix   = sldConfig.ValueName or ""
                local customCol= sldConfig.Color
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
                    TextColor3 = customCol or Theme.AccentCyan,
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
                    grad(Theme.AccentPrimary, customCol or Theme.AccentCyan, 0),
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
                    stroke(customCol or Theme.AccentCyan, 2, 0.5, "Halo"),
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
                        task.delay(0.6, function() ripple:Destroy() end)
                    end
                end)
                Btn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        tw(PressScale, { Scale = 1 }, 0.2, Enum.EasingStyle.Back)
                    end
                end)

                Btn.MouseButton1Click:Connect(function() task.spawn(callback) end)

                local BtnHandle = {}
                function BtnHandle:SetName(newName)
                    TitleLbl.Text = tostring(newName)
                end
                return BtnHandle
            end

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

                make("Frame", {
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

                Header.MouseButton1Click:Connect(function() setExpanded(not isExpanded) end)

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

            TabObj.MakeTab = TabObj.CreateTab
            return TabObj
        end

        WindowObj.MakeTab = WindowObj.CreateTab

        task.defer(function()
            setVisible(true)
        end)

        return WindowObj
    end

    PB_UI.MakeWindow = PB_UI.CreateWindow
    function PB_UI:MakeNotification(toastConfig)
        if CurrentActiveWindow and CurrentActiveWindow.Notify then
            CurrentActiveWindow:Notify(toastConfig)
        end
    end
    PB_UI.Init = function() end

    local OrionLib = PB_UI

    -- ─── Services ─────────────────────────────────────────────────────
    local Players            = game:GetService("Players")
    local ReplicatedStorage  = game:GetService("ReplicatedStorage")
    local RunService         = game:GetService("RunService")
    local UserInputService   = game:GetService("UserInputService")
    local HttpService        = game:GetService("HttpService")
    local LocalPlayer        = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local CarSpeedLimitsModule = ReplicatedStorage:FindFirstChild("CarSpeedLimits")

    -- Clean environment initialization (no intrusive engine metamethod hooks)

    -- ─── Remotes ──────────────────────────────────────────────────────
    local RemotesFolder      = ReplicatedStorage:WaitForChild("Remotes", 5)
    local NetFolder          = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Remotes") and ReplicatedStorage.Packages.Remotes:FindFirstChild("Networking")

    local Remote_SpawnCar    = RemotesFolder and RemotesFolder:FindFirstChild("SpawnCarEvent")
    local Remote_RemoveCar   = RemotesFolder and RemotesFolder:FindFirstChild("RemoveCar")
    local Remote_GarageData  = RemotesFolder and RemotesFolder:FindFirstChild("RequestGarageData")
    local Remote_Nitrous     = RemotesFolder and RemotesFolder:FindFirstChild("NitrousFire")
    local Remote_ClaimDaily  = NetFolder and NetFolder:FindFirstChild("RF/DailyLoginClaim")
    local Remote_ClaimFree   = NetFolder and NetFolder:FindFirstChild("RF/ClaimFreeCar")
    local Remote_RewardStatus= (NetFolder and NetFolder:FindFirstChild("RF/GetRewardStatus")) or (RemotesFolder and RemotesFolder:FindFirstChild("GetRewardStatus"))
    local Remote_PoliceBusted= NetFolder and NetFolder:FindFirstChild("RE/Police/PoliceBusted")
    local Remote_AFKBonus    = NetFolder and NetFolder:FindFirstChild("RE/AFK/AFKBonus")
    local Remote_TrafficSwerve = (RemotesFolder and RemotesFolder:FindFirstChild("TrafficSwerveEvent")) or ReplicatedStorage:FindFirstChild("TrafficSwerveEvent")

    -- Additional Reward & Quest Remotes
    local Remote_ClaimUpdateLog   = RemotesFolder and RemotesFolder:FindFirstChild("ClaimUpdateLog")
    local Remote_GetDailyQuests   = RemotesFolder and RemotesFolder:FindFirstChild("GetDailyQuests")
    local Remote_ClaimDailyQuest  = RemotesFolder and RemotesFolder:FindFirstChild("ClaimDailyQuest")
    local Remote_GetQuestsByScope = RemotesFolder and RemotesFolder:FindFirstChild("GetQuestsByScope")
    local Remote_ClaimQuestByScope= RemotesFolder and RemotesFolder:FindFirstChild("ClaimQuestByScope")

    -- ─── Script Settings ──────────────────────────────────────────────
    local Settings = {
        -- Vehicle Tuning & Speed
        VehicleSpeedBoost    = false,
        BoostMultiplier      = 1.3,
        InfiniteNitrous      = false,     -- Default ON: ไนตรัสไม่จำกัด
        VehicleFly           = false,
        FlySpeed             = 120,

        -- Anti-Police & Godmode
        AntiBusted           = false,     -- Default ON: กันตำรวจจับ 100%
        NoCollisionTraffic   = false,     -- Default ON: ทะลุรถ AI & ผู้เล่น
        GhostGodMode         = false,     -- Default ON: ตัวถังรถเป็นผี ทะลุกำแพง/สิ่งกีดขวาง
        AutoEscapePolice     = false,     -- Auto Escape Police Pursuit mode
        PoliceTargetCash     = 50000,     -- Target cash goal before activating 100% Anti-Busted
        PoliceBustedActivated= false,     -- Flag indicating target cash reached and 100% protection active

        -- Auto Farming & Economy (Grand Loop 96,000+ studs / 26.8 km!)
        AutoDriveFarm        = false,     -- Default ON: ฟาร์มอัตโนมัติทันทีที่รันสคริป
        FarmDriveSpeed       = 240,      -- High-speed stable farm speed
        FarmPercent          = 1.0,      -- Full loop or custom route percent
        FarmLane             = "Lane 2 (Center)",
        LoopMode             = "Infinite Loop (วิ่งวนลูปไฮเวย์รอบโลกต่อเนื่อง)",
        AutoBankCombo        = false,     -- Default ON: บันทึกแต้มเงินอัตโนมัติ
        AutoKeepCombo        = false,    -- Do not spam combo remotes by default
        AutoSwerveCloseCall  = false,    -- Disabled to prevent server-side spam kicks
        AutoRespawnCar       = false,     -- Default ON: เสกและขึ้นรถใหม่อัตโนมัติถ้ารถหาย/พัง
        AutoClaimDaily       = false,
        AutoClaimFreeCar     = false,
        AutoAFKBonus         = false,    -- Safe default: off
        AntiAFK              = false,     -- 24/7 Anti-Idle disconnect protector (client safe)
        PerformanceMode      = false,    -- GPU/CPU saver (disables 3D rendering for overnight AFK)

        -- Selected Car to Spawn
        SelectedCar          = "Shelly LZ1",

        -- Advanced Smooth Physics & Adaptive Cornering Engine
        AdaptiveCornering    = true,     -- เข้าโค้งเนียนสมูท ป้องกันหลุดโค้ง
        CornerSlowdown       = true,     -- ชะลอความเร็วเล็กน้อยตอนเจอโค้งหักศอก
        SmoothSteerFactor    = 0.22,     -- ความนุ่มนวลของการหักเลี้ยว (0.15 - 0.40)
        LookaheadLead        = 38,       -- ระยะคำนวณถนนล่วงหน้า (studs)
        HoverSuspension      = true,     -- ระบบยกตัวลอยเหนือถนน กันจม & ลดแรงสั่นสะเทือน 100% (เปิดถาวร)
        RideHeightOffset     = 2.3,      -- ความสูงลอยเหนือถนน 2.3 studs ตายตัว
        RigidChassisLock     = true,     -- ล็อกโมเดลและล้อทั้งคันให้แข็งเป็นแผงเดียว สไลด์พร้อมกันไม่ย้วย
    }
    _G.GhostDriverSettings = Settings

    -- ─── Config Persistence Engine (Save / Load) ──────────────────────
    local CONFIG_FILE = "ProjectBarun_GhostDriver.json"

    local function SaveConfig()
        if writefile then
            local ok, err = pcall(function()
                local dataToSave = {
                    VehicleSpeedBoost = Settings.VehicleSpeedBoost,
                    BoostMultiplier = Settings.BoostMultiplier,
                    InfiniteNitrous = Settings.InfiniteNitrous,
                    NoCollisionTraffic = Settings.NoCollisionTraffic,
                    GhostGodMode = Settings.GhostGodMode,
                    AutoEscapePolice = Settings.AutoEscapePolice,
                    PoliceTargetCash = Settings.PoliceTargetCash,
                    FarmDriveSpeed = Settings.FarmDriveSpeed,
                    FarmLane = Settings.FarmLane,
                    LoopMode = Settings.LoopMode,
                    AutoBankCombo = Settings.AutoBankCombo,
                    AutoKeepCombo = Settings.AutoKeepCombo,
                    AutoRespawnCar = Settings.AutoRespawnCar,
                    AntiAFK = Settings.AntiAFK,
                    PerformanceMode = Settings.PerformanceMode,
                    SelectedCar = Settings.SelectedCar,
                    AdaptiveCornering = Settings.AdaptiveCornering,
                    CornerSlowdown = Settings.CornerSlowdown,
                    SmoothSteerFactor = Settings.SmoothSteerFactor,
                    LookaheadLead = Settings.LookaheadLead,
                    HoverSuspension = Settings.HoverSuspension,
                    RideHeightOffset = Settings.RideHeightOffset,
                    RigidChassisLock = Settings.RigidChassisLock
                }
                writefile(CONFIG_FILE, HttpService:JSONEncode(dataToSave))
            end)
            return ok
        end
        return false
    end

    local function LoadConfig()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local ok, content = pcall(readfile, CONFIG_FILE)
            if ok and content and #content > 0 then
                local okJson, decoded = pcall(function() return HttpService:JSONDecode(content) end)
                if okJson and type(decoded) == "table" then
                    for k, v in pairs(decoded) do
                        if Settings[k] ~= nil then
                            Settings[k] = v
                        end
                    end
                    return true
                end
            end
        end
        return false
    end

    -- Auto-load saved config on startup
    pcall(LoadConfig)

    -- ─── Telemetry & Live Statistics ──────────────────────────────────
    local Telemetry = {
        StartTime       = tick(),
        StartCash       = 0,
        CurrentCash     = 0,
        CashEarned      = 0,
        TotalDistance   = 0,
        SpeedMPH        = 0,
        LoopsCompleted  = 0,
        CurrentWaypoint = 1,
        EvadedVehicles  = 0,
        StatusText      = "Initializing..."
    }

    local function safe(fn)
        local ok, err = pcall(fn)
        if not ok then warn("[GhostDriver] " .. tostring(err)) end
    end

    -- ═══════════════════════════════════════════════════════════════════
    -- 2. VEHICLE RESOLVER HELPERS & RESILIENT AUTO-MOUNT
    -- ═══════════════════════════════════════════════════════════════════
    local function updateSelectedCarFromCar(car)
        if not car then return end
        local pName = LocalPlayer.Name
        local raw = car.Name
        local clean = raw:gsub("^" .. pName .. "_", ""):gsub("^" .. pName, "")
        if #clean >= 2 then
            Settings.SelectedCar = clean
        end
    end

    local function getPlayerCar()
        local pName = LocalPlayer.Name
        local char = LocalPlayer.Character
        -- 1. Check if seated directly in a car
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            local carModel = hum.SeatPart:FindFirstAncestorOfClass("Model")
            if carModel and carModel ~= char then
                updateSelectedCarFromCar(carModel)
                return carModel
            end
        end
        -- 2. Check workspace children for player car
        for _, model in ipairs(workspace:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                if model.Name == pName .. "_" .. (Settings.SelectedCar or "") 
                or model.Name:find(pName) 
                or model:GetAttribute("Owner") == pName then
                    updateSelectedCarFromCar(model)
                    return model
                end
            end
        end
        -- 3. Fallback to workspace.Cars
        local cars = workspace:FindFirstChild("Cars")
        if cars then
            for _, model in ipairs(cars:GetChildren()) do
                if model:IsA("Model") and (model.Name:find(pName) or model:GetAttribute("Owner") == pName) then
                    updateSelectedCarFromCar(model)
                    return model
                end
            end
        end
        return nil
    end

    local function getDriveSeat()
        local car = getPlayerCar()
        if not car then return nil end
        local seat = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("VehicleSeat", true)
        return seat
    end

    local function mountDriveSeat(seat)
        if not seat then return false end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health <= 0 or not hrp then return false end
        if hum.SeatPart == seat then return true end

        if LocalPlayer.RequestStreamAroundAsync then
            pcall(function()
                LocalPlayer:RequestStreamAroundAsync(seat.Position, 2)
            end)
        end

        if seat.Occupant and seat.Occupant ~= hum then
            pcall(function()
                if seat.Occupant.Health <= 0 then
                    seat.Occupant.SeatPart = nil
                end
            end)
        end

        hrp.CFrame = seat.CFrame + Vector3.new(0, 2.0, 0)
        task.wait(0.08)
        seat:Sit(hum)
        return hum.SeatPart == seat
    end

    local function ensureCarAndSeat()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 or not hrp then return nil, nil end

        local car = getPlayerCar()
        local seat = getDriveSeat()

        local needSpawn = false
        if not car or not seat then
            needSpawn = true
        elseif (seat.Position - hrp.Position).Magnitude > 1500 and hum.SeatPart ~= seat then
            -- Player respawned at city lobby far away from abandoned car
            needSpawn = true
        end

        if needSpawn and Remote_SpawnCar then
            if Remote_RemoveCar then
                pcall(function() Remote_RemoveCar:FireServer() end)
            end
            task.wait(0.5)
            local carToSpawn = Settings.SelectedCar or "Shelly LZ1"
            pcall(function() Remote_SpawnCar:FireServer(carToSpawn) end)
            task.wait(1.4)
            car = getPlayerCar()
            seat = getDriveSeat()
        end

        if car and seat and hum.SeatPart ~= seat then
            mountDriveSeat(seat)
        end
        return car, seat
    end

    -- ═══════════════════════════════════════════════════════════════════
    -- 3. ROAD NETWORK ENGINE & PERSISTENT CACHE
    -- ═══════════════════════════════════════════════════════════════════
    local RoadData = _G.ProjectBarun_RoadCache or {
        Loaded = false,
        Lanes = {},
        TotalPoints = 0,
        TotalLength = 0,
        CumDist = {}
    }

    local function loadRoadNetwork()
        if RoadData.Loaded and #RoadData.Lanes > 0 then return true end
        
        if _G.ProjectBarun_RoadCache and _G.ProjectBarun_RoadCache.Loaded then
            RoadData = _G.ProjectBarun_RoadCache
            return true
        end

        local remote = NetFolder and NetFolder:FindFirstChild("RF/PoliceRoadLanes")
        if not remote then
            local pkgs = ReplicatedStorage:FindFirstChild("Packages")
            local r = pkgs and pkgs:FindFirstChild("Remotes")
            local net = r and r:FindFirstChild("Networking")
            remote = net and net:FindFirstChild("RF/PoliceRoadLanes")
        end

        if remote then
            local ok, lanes = false, nil
            local finished = false
            task.spawn(function()
                local s, res = pcall(function() return remote:InvokeServer() end)
                if s then lanes = res; ok = true end
                finished = true
            end)

            local startWait = tick()
            while not finished and (tick() - startWait < 5.0) do
                task.wait(0.1)
            end

            if ok and type(lanes) == "table" and #lanes >= 2 then
                RoadData.Lanes = lanes
                RoadData.TotalPoints = #lanes[2]
                local totalDist = 0
                local cum = {}
                local l2 = lanes[2]
                for i = 1, #l2 do
                    local nextI = (i % #l2) + 1
                    local p1 = l2[i]
                    local p2 = l2[nextI]
                    local dist = (Vector3.new(p2[1], p2[2] or 63.2, p2[3]) - Vector3.new(p1[1], p1[2] or 63.2, p1[3])).Magnitude
                    totalDist = totalDist + dist
                    table.insert(cum, totalDist)
                end
                RoadData.TotalLength = totalDist
                RoadData.CumDist = cum
                RoadData.Loaded = true
                _G.ProjectBarun_RoadCache = RoadData
                print(string.format("[GhostDriver] Road Network loaded: %d points, %.1f studs (%.2f KM)", RoadData.TotalPoints, totalDist, totalDist * 0.28 / 1000))
                return true
            end
        end
        return false
    end

    local function findRoadFrame(currentPos, hintIdx)
        if not RoadData.Loaded then
            if not loadRoadNetwork() then return nil end
        end

        local l2 = RoadData.Lanes[2]
        if not l2 or #l2 == 0 then return nil end
        local total = #l2
        local bestSegIdx = 1
        local bestDistSq = 1e12
        local bestT = 0
        local bestCenter = Vector3.zero
        local bestDir = Vector3.new(0, 0, -1)

        local cx = currentPos.X
        local cz = currentPos.Z

        local function evaluateSegment(i)
            local nextI = (i % total) + 1
            local p1 = l2[i]
            local p2 = l2[nextI]
            if not p1 or not p2 then return end

            local x1, y1, z1 = p1[1], p1[2] or 63.2, p1[3]
            local x2, y2, z2 = p2[1], p2[2] or 63.2, p2[3]

            local dx = x2 - x1
            local dy = y2 - y1
            local dz = z2 - z1
            local segLenSq = (dx * dx) + (dz * dz)

            local t = 0
            if segLenSq > 0.001 then
                t = math.clamp(((cx - x1) * dx + (cz - z1) * dz) / segLenSq, 0, 1)
            end

            local projX = x1 + dx * t
            local projY = y1 + dy * t
            local projZ = z1 + dz * t

            local distSq = ((cx - projX) * (cx - projX)) + ((cz - projZ) * (cz - projZ))
            if distSq < bestDistSq then
                bestDistSq = distSq
                bestSegIdx = i
                bestT = t
                bestCenter = Vector3.new(projX, projY, projZ)
                local len3D = math.sqrt((dx * dx) + (dy * dy) + (dz * dz))
                if len3D > 0.001 then
                    bestDir = Vector3.new(dx / len3D, dy / len3D, dz / len3D)
                end
            end
        end

        local usedLocal = false
        if hintIdx and hintIdx >= 1 and hintIdx <= total then
            for offset = -4, 8 do
                local idx = ((hintIdx + offset - 1) % total) + 1
                evaluateSegment(idx)
            end
            if bestDistSq < (90 * 90) then
                usedLocal = true
            end
        end

        if not usedLocal then
            bestDistSq = 1e12
            for i = 1, total do
                evaluateSegment(i)
            end
        end

        local flatDir = Vector3.new(bestDir.X, 0, bestDir.Z)
        if flatDir.Magnitude > 0.001 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, -1) end
        local roadNormal = Vector3.new(-flatDir.Z, 0, flatDir.X)
        local curPt = Vector3.new(l2[bestSegIdx][1], l2[bestSegIdx][2] or 63.2, l2[bestSegIdx][3])
        local nextPt = Vector3.new(l2[(bestSegIdx % total) + 1][1], l2[(bestSegIdx % total) + 1][2] or 63.2, l2[(bestSegIdx % total) + 1][3])

        return {
            Index = bestSegIdx,
            NextIndex = (bestSegIdx % total) + 1,
            CenterPos = bestCenter,
            Direction = bestDir,
            Normal = roadNormal,
            DistanceToCenter = math.sqrt(bestDistSq),
            CurPt = curPt,
            NextPt = nextPt,
            T = bestT
        }
    end

    -- ═══════════════════════════════════════════════════════════════════
    -- 4. FARM MANAGER & RESILIENT SUPERVISOR ENGINE
    -- ═══════════════════════════════════════════════════════════════════
    local FarmManager = {
        WorkerThread = nil,
        LastPos = nil,
        StuckTicks = 0,
        LastMoveTick = tick(),
        LastCheckedPos = nil,
        CurrentWaypointIdx = 1,
        CurrentLaneOffset = 0,
        TargetLane = 0,
        LastLaneChangeTick = 0,
        LastStreamIdx = -1,
        LoopDistanceTraveled = 0,
        LastCloseCallTick = 0,
        LastNitroTick = 0,
        CachedObstacles = {},
        LastObstacleCacheTick = 0,
        TrackedForwardObstacles = {},
        WasDriving = false
    }

    function FarmManager.UnfreezeVehicle()
        local car = getPlayerCar()
        local seat = getDriveSeat()
        if not car or not seat then return end

        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored then
                part.Anchored = false
            end
        end

        if car:GetAttribute("Handbrake") then car:SetAttribute("Handbrake", false) end
        if seat:GetAttribute("Handbrake") then seat:SetAttribute("Handbrake", false) end

        local vals = car:FindFirstChild("Values")
        if vals then
            local pb = vals:FindFirstChild("PBrake") or vals:FindFirstChild("Handbrake")
            if pb and pb:IsA("BoolValue") and pb.Value == true then pb.Value = false end
            local ign = vals:FindFirstChild("Ignition")
            if ign and ign:IsA("BoolValue") and ign.Value == false then ign.Value = true end
            local brk = vals:FindFirstChild("Brake")
            if brk and brk:IsA("NumberValue") and brk.Value > 0 then brk.Value = 0 end
            local thr = vals:FindFirstChild("Throttle")
            if thr and thr:IsA("NumberValue") and thr.Value == 0 then thr.Value = 1 end
        end
    end

    function FarmManager.SetRigidLock(car, seat, enable)
        if not car then return end
        if not enable then
            for _, p in ipairs(car:GetDescendants()) do
                if p:IsA("BasePart") then
                    local w = p:FindFirstChild("GD_RigidWeld")
                    if w then pcall(function() w:Destroy() end) end
                end
            end
            return
        end

        if not seat then return end
        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") and part ~= seat then
                local name = part.Name:lower()
                local parentName = part.Parent and part.Parent.Name:lower() or ""
                local isWheelOrSuspension = name:find("wheel") or name:find("tire") or name:find("rim") 
                    or name:find("hub") or name:find("steer") or name:find("spindle") or name:find("caliper")
                    or parentName:find("wheel") or parentName:find("suspension")

                if isWheelOrSuspension then
                    local weldTag = part:FindFirstChild("GD_RigidWeld")
                    if not weldTag or not weldTag:IsA("WeldConstraint") or weldTag.Part0 ~= seat or weldTag.Part1 ~= part then
                        if weldTag then pcall(function() weldTag:Destroy() end) end
                        local weld = Instance.new("WeldConstraint")
                        weld.Name = "GD_RigidWeld"
                        weld.Part0 = seat
                        weld.Part1 = part
                        weld.Parent = part
                    end
                end
            end
        end
    end

    function FarmManager.Stop()
        Settings.AutoDriveFarm = false
        Settings.AutoEscapePolice = false
        FarmManager.WasDriving = false

        safe(function()
            local seat = getDriveSeat()
            local car = getPlayerCar()
            FarmManager.SetRigidLock(car, seat, false)
            if seat then
                seat.AssemblyLinearVelocity = Vector3.zero
                seat.AssemblyAngularVelocity = Vector3.zero
                seat.Throttle = 0
                seat.ThrottleFloat = 0
                seat.SteerFloat = 0
            end
            if car then
                local vals = car:FindFirstChild("Values")
                if vals then
                    local pb = vals:FindFirstChild("PBrake") or vals:FindFirstChild("Handbrake")
                    if pb and pb:IsA("BoolValue") then pb.Value = true end
                end
            end
        end)
    end

    function FarmManager.Start()
        Settings.AutoDriveFarm     = true
        Settings.NoCollisionTraffic = true
        Settings.GhostGodMode      = true
        Settings.HoverSuspension   = true
        Settings.RigidChassisLock  = true
        Settings.AntiBusted        = true
        Settings.InfiniteNitrous   = true
        Settings.AutoBankCombo     = true
        Settings.AutoRespawnCar    = true
        Settings.AntiAFK           = true
        Settings.AdaptiveCornering = true
        Settings.CornerSlowdown    = true
        FarmManager.StuckTicks     = 0
        FarmManager.LastPos        = nil
        FarmManager.UnfreezeVehicle()

        local initCar = getPlayerCar()
        local initSeat = getDriveSeat()
        if Settings.RigidChassisLock then
            FarmManager.SetRigidLock(initCar, initSeat, true)
        end

        task.spawn(function()
            local car = getPlayerCar()
            if not car and Remote_SpawnCar then
                Remote_SpawnCar:FireServer(Settings.SelectedCar or "Wulfbrecht RZ7")
                task.wait(1.5)
                car = getPlayerCar()
            end
            local seat = getDriveSeat()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if seat and hum and hum.SeatPart ~= seat then
                if hrp then hrp.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0) end
                seat:Sit(hum)
            end
            FarmManager.UnfreezeVehicle()
            if Settings.RigidChassisLock then
                FarmManager.SetRigidLock(car, seat, true)
            end
        end)

        if not FarmManager.WorkerThread or coroutine.status(FarmManager.WorkerThread) == "dead" then
            FarmManager.LaunchWorker()
        end
    end

    function FarmManager.StepDrive()
        local car, seat = ensureCarAndSeat()
        if not car or not seat then return end

        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.SeatPart ~= seat then return end

        -- Ensure rigid chassis lock is active on current vehicle (Throttled for performance)
        if Settings.RigidChassisLock and (FarmManager.LastLockedCar ~= car or tick() - (FarmManager.LastRigidLockTick or 0) > 2.5) then
            FarmManager.LastRigidLockTick = tick()
            FarmManager.LastLockedCar = car
            FarmManager.SetRigidLock(car, seat, true)
        end

        local currentPos = seat.Position

        -- Track distance traveled & real-time stuck state (Timer-based, prevents false 0.25s stuck loops!)
        if not FarmManager.LastMoveTick then FarmManager.LastMoveTick = tick() end
        if not FarmManager.LastCheckedPos then FarmManager.LastCheckedPos = currentPos end

        if FarmManager.LastPos then
            local stepDist = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(FarmManager.LastPos.X, 0, FarmManager.LastPos.Z)).Magnitude
            if stepDist < 200 then
                FarmManager.LoopDistanceTraveled = FarmManager.LoopDistanceTraveled + stepDist
            end
        end
        FarmManager.LastPos = currentPos

        -- Check position progression every 1.0 second (Requires 4.0 studs delta)
        local movedDelta = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(FarmManager.LastCheckedPos.X, 0, FarmManager.LastCheckedPos.Z)).Magnitude
        if movedDelta > 4.0 then
            FarmManager.LastMoveTick = tick()
            FarmManager.LastCheckedPos = currentPos
            FarmManager.StuckTicks = 0
        else
            -- Only trigger recovery if truly stopped for >= 4.0 continuous seconds!
            if tick() - FarmManager.LastMoveTick >= 4.0 then
                FarmManager.StuckTicks = 30
            end
        end

        -- 3. Resolve Current Road Position on Official 96,000 Studs Track
        local frame = findRoadFrame(currentPos, FarmManager.CurrentWaypointIdx)
        if not frame then
            task.wait(0.2)
            return
        end

        FarmManager.CurrentWaypointIdx = frame.Index

        -- Proactive World Streaming Ahead
        if LocalPlayer.RequestStreamAroundAsync and math.abs(frame.Index - FarmManager.LastStreamIdx) >= 4 then
            FarmManager.LastStreamIdx = frame.Index
            local streamAheadIdx = ((frame.Index + 5) % RoadData.TotalPoints) + 1
            local aheadPt = RoadData.Lanes[2][streamAheadIdx]
            if aheadPt then
                task.spawn(function()
                    pcall(function()
                        LocalPlayer:RequestStreamAroundAsync(Vector3.new(aheadPt[1], 64.0, aheadPt[3]), 2)
                    end)
                end)
            end
        end

        -- Fallback / Off-track & Anti-Void / Broken Wheel Auto-Respawn Recovery
        local distY = currentPos.Y - frame.CenterPos.Y
        local curPivot = car:GetPivot()
        local isFlipped = curPivot.UpVector.Y < 0.40 or seat.CFrame.UpVector.Y < 0.40
        local isFalling = distY < -20.0 or distY > 60.0
        local isOffTrack = frame.DistanceToCenter > 95.0

        -- Check if any wheel detached from vehicle
        local hasBrokenWheel = false
        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("wheel") or part.Name:lower():find("tire")) then
                if (part.Position - seat.Position).Magnitude > 20.0 then
                    hasBrokenWheel = true
                    break
                end
            end
        end

        if isFlipped or isFalling or isOffTrack or hasBrokenWheel or FarmManager.StuckTicks >= 25 then
            FarmManager.StuckTicks = 0
            FarmManager.LastMoveTick = tick()
            FarmManager.LastCheckedPos = currentPos
            FarmManager.UnfreezeVehicle()

            -- If car has a detached/broken wheel, respawn fresh car immediately!
            if hasBrokenWheel and Remote_SpawnCar then
                if Remote_RemoveCar then pcall(function() Remote_RemoveCar:FireServer() end) end
                task.wait(0.5)
                Remote_SpawnCar:FireServer(Settings.SelectedCar or "Shelly LZ1")
                task.wait(1.5)
                return
            end

            local rideH = Settings.RideHeightOffset or 2.3
            local safePt = frame.CenterPos + (frame.Normal * FarmManager.CurrentLaneOffset) + Vector3.new(0, rideH + 0.6, 0)
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(safePt, 2)
                task.wait(0.04)
            end
            local flatDir = Vector3.new(frame.Direction.X, 0, frame.Direction.Z)
            if flatDir.Magnitude < 0.001 then flatDir = Vector3.new(0, 0, -1) else flatDir = flatDir.Unit end
            car:PivotTo(CFrame.lookAt(safePt, safePt + flatDir))
            seat.AssemblyLinearVelocity = flatDir * 120 + Vector3.new(0, 8, 0)
            seat.AssemblyAngularVelocity = Vector3.zero
            task.wait(0.12)
            return
        end

        -- Unlock A-Chassis parking brakes & unanchor parts if vehicle was frozen
        FarmManager.UnfreezeVehicle()

        -- Proactive Car Ghosting: Ghost entire car 100% while hovering for frictionless 320 MPH glide
        if Settings.GhostGodMode or Settings.AutoDriveFarm then
            for _, p in ipairs(car:GetDescendants()) do
                if p:IsA("BasePart") then
                    if p.CanCollide then p.CanCollide = false end
                    if p.CanTouch then p.CanTouch = false end
                end
            end
        end

        -- 4. Intelligent Radar & 3-Lane Dynamic Obstacle Evasion Engine (Original Police-Era System)
        local rightDist = 9999
        local centerDist = 9999
        local leftDist = 9999
        local currentLaneObstacleDist = 9999
        local nearestObsDist = 9999
        local nearestObsLateral = 0

        local CAR_HALF_WIDTH = 4.5
        local SAFETY_MARGIN = 5.5
        local RADAR_MAX_DIST = 850.0

        local carVecFromCenter = currentPos - frame.CenterPos
        local carCurrentRoadOffset = carVecFromCenter:Dot(frame.Normal)

        local function checkObstacle(obj)
            if not obj or obj == car or obj == LocalPlayer.Character then return end
            local obsPos = nil
            if obj:IsA("BasePart") then
                obsPos = obj.Position
            elseif obj:IsA("Model") then
                if obj.PrimaryPart then
                    obsPos = obj.PrimaryPart.Position
                else
                    local hb = obj:FindFirstChild("CoreHitbox") or obj:FindFirstChild("Body")
                    if hb and hb:IsA("BasePart") then
                        obsPos = hb.Position
                    else
                        local bp = obj:FindFirstChildWhichIsA("BasePart", true)
                        if bp then
                            obsPos = bp.Position
                        else
                            local okP, piv = pcall(function() return obj:GetPivot() end)
                            if okP and piv then obsPos = piv.Position end
                        end
                    end
                end
            end
            if not obsPos then return end

            local toObs = obsPos - currentPos
            local forwardDist = toObs:Dot(frame.Direction)

            if forwardDist > -20 and forwardDist < RADAR_MAX_DIST then
                local obsVecFromCenter = obsPos - frame.CenterPos
                local obsLaneOffset = obsVecFromCenter:Dot(frame.Normal)

                if forwardDist < nearestObsDist then
                    nearestObsDist = forwardDist
                    nearestObsLateral = obsLaneOffset
                end

                local lateralDiffToCar = math.abs(obsLaneOffset - carCurrentRoadOffset)
                local lateralDiffToTarget = math.abs(obsLaneOffset - FarmManager.CurrentLaneOffset)
                if (lateralDiffToCar < (CAR_HALF_WIDTH + SAFETY_MARGIN)) or (lateralDiffToTarget < (CAR_HALF_WIDTH + SAFETY_MARGIN)) then
                    if forwardDist > 0 and forwardDist < currentLaneObstacleDist then
                        currentLaneObstacleDist = forwardDist
                    end
                end

                -- Proactive collision nullifier on obstacle when in proximity
                if forwardDist < 250 and (lateralDiffToCar < 20 or lateralDiffToTarget < 20) then
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part.CanCollide then part.CanCollide = false end
                            part.CollisionGroup = "TrafficBox"
                        end
                    end
                end

                -- Trigger close call points when passing near traffic
                if Settings.AutoSwerveCloseCall and Remote_TrafficSwerve and forwardDist > 0 and forwardDist < 45 and lateralDiffToCar < 18 then
                        if tick() - FarmManager.LastCloseCallTick > 0.35 then
                            FarmManager.LastCloseCallTick = tick()
                            pcall(function()
                                local swerveSide = (obsLaneOffset > carCurrentRoadOffset) and "Left" or "Right"
                                Remote_TrafficSwerve:FireServer(obj, swerveSide)
                            end)
                        end
                    end

                    -- Independent 3-Lane Obstruction Checks
                    local blockRadius = CAR_HALF_WIDTH + SAFETY_MARGIN
                    if math.abs(obsLaneOffset - (-13.5)) < blockRadius then
                        if forwardDist < leftDist then leftDist = forwardDist end
                    end
                    if math.abs(obsLaneOffset - 0.0) < blockRadius then
                        if forwardDist < centerDist then centerDist = forwardDist end
                    end
                    if math.abs(obsLaneOffset - 13.5) < blockRadius then
                        if forwardDist < rightDist then rightDist = forwardDist end
                    end
                end
            end

        -- Scan AI Traffic Folders (Exact game folders + dynamic fallbacks)
        for _, folderName in ipairs({"TrafficFolder", "TrafficBoxes", "more tarffic", "PoliceWalls", "Cars", "Traffic", "AITraffic", "TrafficAI", "LocalTraffic"}) do
            local f = workspace:FindFirstChild(folderName)
            if f then
                for _, inst in ipairs(f:GetChildren()) do
                    checkObstacle(inst)
                end
            end
        end

        -- Scan other player vehicles & police in workspace
        local pName = LocalPlayer.Name
        for _, m in ipairs(workspace:GetChildren()) do
            if m:IsA("Model") and not m.Name:find(pName) then
                local mNameLower = m.Name:lower()
                if m:FindFirstChildWhichIsA("VehicleSeat", true) or m.Name:find("_") or mNameLower:find("police") or mNameLower:find("traffic") then
                    checkObstacle(m)
                end
            end
        end

        -- Lane Selection Decision: Center Lane is Primary Base Lane
        local SAFE_DISTANCE = 650
        local baseLaneOffset = 0.0
        if Settings.FarmLane and (Settings.FarmLane:find("Left") or Settings.FarmLane:find("Lane 1")) then
            baseLaneOffset = -13.5
        elseif Settings.FarmLane and (Settings.FarmLane:find("Right") or Settings.FarmLane:find("Lane 3")) then
            baseLaneOffset = 13.5
        end

        local targetLaneOffset = baseLaneOffset
        local baseDist = (baseLaneOffset == 0.0) and centerDist or ((baseLaneOffset < 0) and leftDist or rightDist)

        if baseDist >= SAFE_DISTANCE then
            targetLaneOffset = baseLaneOffset
        else
            local leftClear = (leftDist >= SAFE_DISTANCE)
            local centerClear = (centerDist >= SAFE_DISTANCE)
            local rightClear = (rightDist >= SAFE_DISTANCE)

            if centerClear and baseLaneOffset ~= 0.0 then
                targetLaneOffset = 0.0
            elseif rightClear and leftClear then
                if FarmManager.CurrentLaneOffset < -2.0 then
                    targetLaneOffset = -13.5
                elseif FarmManager.CurrentLaneOffset > 2.0 then
                    targetLaneOffset = 13.5
                else
                    targetLaneOffset = (rightDist >= leftDist) and 13.5 or -13.5
                end
            elseif rightClear and not leftClear then
                targetLaneOffset = 13.5
            elseif leftClear and not rightClear then
                targetLaneOffset = -13.5
            elseif centerClear then
                targetLaneOffset = 0.0
            else
                if centerDist >= leftDist and centerDist >= rightDist then
                    targetLaneOffset = 0.0
                elseif rightDist >= leftDist and rightDist >= centerDist then
                    targetLaneOffset = 13.5
                else
                    targetLaneOffset = -13.5
                end
            end
        end

        -- Decisive Lateral Pull: Speed-Scaled Dynamic Evasion (Tuned for up to 320 MPH)
        local offsetDiff = targetLaneOffset - FarmManager.CurrentLaneOffset
        local isDodging = (math.abs(offsetDiff) > 0.8) or (currentLaneObstacleDist < 380)
        if math.abs(offsetDiff) > 0.03 then
            local pullUrgency = 0.30
            local maxStep = 2.2

            local speedRatio = math.clamp((forwardSpeed or 250) / 250, 1.0, 1.5)

            if currentLaneObstacleDist < 180 or math.abs(offsetDiff) > 5.0 then
                -- Close-quarter emergency evasion: Crisp, immediate lane switch
                pullUrgency = 0.65
                maxStep = 4.8 * speedRatio
            elseif currentLaneObstacleDist < 320 or math.abs(offsetDiff) > 3.0 then
                -- Proactive lane transition
                pullUrgency = 0.48
                maxStep = 3.6 * speedRatio
            end

            local step = math.clamp(offsetDiff * pullUrgency, -maxStep, maxStep)
            FarmManager.CurrentLaneOffset = FarmManager.CurrentLaneOffset + step
        end

        -- 5. Route Distance & Reset Check
        local maxAllowedDist = RoadData.TotalLength * (Settings.FarmPercent or 1.0)
        if not Settings.LoopMode:find("Infinite") and FarmManager.LoopDistanceTraveled >= maxAllowedDist then
            FarmManager.LoopDistanceTraveled = 0
            local pgui = LocalPlayer:FindFirstChild("PlayerGui")
            local comboUI = pgui and pgui:FindFirstChild("InGameHUD") and pgui.InGameHUD:FindFirstChild("ComboUI")
            if comboUI then
                local closeBtn = comboUI:FindFirstChild("Close", true)
                if closeBtn and closeBtn.Visible and firesignal then firesignal(closeBtn.MouseButton1Click) end
                local reviveBtn = comboUI:FindFirstChild("Revive", true)
                if reviveBtn and reviveBtn.Visible and firesignal then firesignal(reviveBtn.MouseButton1Click) end
            end

            local startPos = Vector3.new(-3498.0, 63.2, -957.0)
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(startPos, 2)
                task.wait(0.2)
            end
            seat.AssemblyLinearVelocity = Vector3.zero
            seat.AssemblyAngularVelocity = Vector3.zero
            car:PivotTo(CFrame.lookAt(startPos, startPos + Vector3.new(0, 0, -10)))
            FarmManager.CurrentLaneOffset = 0
            task.wait(0.25)
            return
        end

        -- 6. Precision Navigation & High-Speed Pure Pursuit Propulsion
        local maxAllowedStuds = 320
        if CarSpeedLimitsModule then
            local okL, limits = pcall(require, CarSpeedLimitsModule)
            if okL and type(limits) == "table" and limits.ceilingFor then
                local okC, ceil = pcall(limits.ceilingFor, car)
                if okC and type(ceil) == "number" and ceil > 50 then
                    maxAllowedStuds = ceil * 0.85
                end
            end
        end
        local speedMPH = math.clamp(Settings.FarmDriveSpeed or 170, 80, 320)
        local forwardSpeed = math.min(speedMPH * 1.467, maxAllowedStuds)

        -- Anti-Plow Speed Cushioning during urgent lateral swerve
        if currentLaneObstacleDist < 200 and math.abs(offsetDiff) > 0.8 then
            forwardSpeed = forwardSpeed * 0.65
        end

        -- Predictive Curvature & Adaptive Cornering Engine
        local curveAngleDeg = 0
        local aheadIdx = ((frame.Index + 2) % RoadData.TotalPoints) + 1
        local aheadPt = RoadData.Lanes[2][aheadIdx]
        if aheadPt then
            local aheadVec = Vector3.new(aheadPt[1] - frame.CenterPos.X, 0, aheadPt[3] - frame.CenterPos.Z).Unit
            local currentDirFlat = Vector3.new(frame.Direction.X, 0, frame.Direction.Z).Unit
            local dotVal = math.clamp(currentDirFlat:Dot(aheadVec), -1, 1)
            curveAngleDeg = math.deg(math.acos(dotVal))
        end

        if Settings.CornerSlowdown and curveAngleDeg > 22 then
            local slowdownFactor = math.clamp(1.0 - ((curveAngleDeg - 22) / 60), 0.55, 0.95)
            forwardSpeed = forwardSpeed * slowdownFactor
        end

        local dynamicLead = Settings.LookaheadLead or 38
        local baseLookahead = math.clamp(forwardSpeed * 0.18, dynamicLead * 0.7, dynamicLead * 1.4)
        local lookaheadDist = isDodging and math.clamp(baseLookahead * 0.50, 12, 22) or baseLookahead
        local aimLateral = FarmManager.CurrentLaneOffset
        if isDodging then
            aimLateral = (FarmManager.CurrentLaneOffset * 0.22) + (targetLaneOffset * 0.78)
        end

        local targetPathPos = frame.CenterPos + (frame.Direction * lookaheadDist) + (frame.Normal * aimLateral)

        -- Multi-Point Road Surface Detection & Hover Altitude Resolver (Anti-Sink & Anti-Vibration Engine)
        local rayOrigin = Vector3.new(currentPos.X, currentPos.Y + 14.0, currentPos.Z)
        local rayDir = Vector3.new(0, -35.0, 0)
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local ignoreList = { LocalPlayer.Character }
        if car then table.insert(ignoreList, car) end
        rayParams.FilterDescendantsInstances = ignoreList
        rayParams.IgnoreWater = true

        local roadHit = workspace:Raycast(rayOrigin, rayDir, rayParams)
        local groundY = (roadHit and roadHit.Position) and roadHit.Position.Y or frame.CenterPos.Y
        local targetRideHeight = Settings.RideHeightOffset or 2.3
        local desiredHoverY = groundY + targetRideHeight

        -- Lookahead road target altitude
        local roadAheadY = frame.CenterPos.Y + targetRideHeight
        local aheadHit = workspace:Raycast(Vector3.new(targetPathPos.X, frame.CenterPos.Y + 16.0, targetPathPos.Z), Vector3.new(0, -32.0, 0), rayParams)
        if aheadHit and aheadHit.Position then
            roadAheadY = aheadHit.Position.Y + targetRideHeight
        end
        targetPathPos = Vector3.new(targetPathPos.X, roadAheadY, targetPathPos.Z)

        -- Road Forward Direction and Lateral Alignment (Pure-Yaw Highway Steering)
        local roadDir = Vector3.new(frame.Direction.X, 0, frame.Direction.Z).Unit
        local roadNormal = Vector3.new(-roadDir.Z, 0, roadDir.X)

        -- Gentle lateral steering correction towards target lane (clamped to max ±8 degrees)
        local carFromCenter = currentPos - frame.CenterPos
        local currentRoadOffset = carFromCenter:Dot(roadNormal)
        local lateralDiff = aimLateral - currentRoadOffset
        local steerCorrection = math.clamp(lateralDiff * 0.025, -0.14, 0.14)

        -- Target Heading: Strictly follows road tangent with subtle lane drift
        local targetHeading = (roadDir + (roadNormal * steerCorrection)).Unit

        -- Hover Altitude: Hold exact 2.3 studs clearance above road surface
        local targetHoverAltitude = groundY + targetRideHeight

        -- Orient Entire Vehicle Body Solidly with Road
        local curPivot = car:GetPivot()
        local currentLook = Vector3.new(curPivot.LookVector.X, 0, curPivot.LookVector.Z).Unit
        local headingAlignment = currentLook:Dot(targetHeading)

        local targetRot = CFrame.lookAt(Vector3.zero, targetHeading, Vector3.yAxis)
        local curRot = curPivot.Rotation
        local steerFactor = math.clamp(Settings.SmoothSteerFactor or 0.22, 0.15, 0.35)
        local blendedRot = (headingAlignment < 0.65 or curPivot.UpVector.Y < 0.60) and targetRot or curRot:Lerp(targetRot, steerFactor)

        -- Smoothly update vehicle position & orientation as a unified whole
        local targetCFrame = CFrame.new(currentPos.X, targetHoverAltitude, currentPos.Z) * blendedRot
        car:PivotTo(targetCFrame)

        -- Apply linear velocity AFTER PivotTo along targetHeading
        seat.AssemblyLinearVelocity = targetHeading * forwardSpeed
        seat.AssemblyAngularVelocity = Vector3.zero

        seat.Throttle = 1
        seat.ThrottleFloat = 1
        seat.SteerFloat = 0

        -- Controlled Nitrous injection
        if Settings.InfiniteNitrous and Remote_Nitrous and (tick() - FarmManager.LastNitroTick > 2.0) then
            FarmManager.LastNitroTick = tick()
            Remote_Nitrous:FireServer(true)
        end

        -- Auto Bank / Revive combo & bypass Crash screen
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        local comboUI = pgui and pgui:FindFirstChild("InGameHUD") and pgui.InGameHUD:FindFirstChild("ComboUI")
        if comboUI and comboUI.Visible then
            local reviveBtn = comboUI:FindFirstChild("Revive", true)
            if reviveBtn and firesignal then
                pcall(function() firesignal(reviveBtn.MouseButton1Click) end)
                pcall(function() firesignal(reviveBtn.Activated) end)
            end
            local closeBtn = comboUI:FindFirstChild("Close", true)
            if closeBtn and firesignal then
                pcall(function() firesignal(closeBtn.MouseButton1Click) end)
                pcall(function() firesignal(closeBtn.Activated) end)
            end
            comboUI.Visible = false
            if Remote_RestoreCombo then
                pcall(function() Remote_RestoreCombo:FireServer() end)
            end
        end

        -- Update Live Telemetry Metrics
        Telemetry.SpeedMPH = math.floor(forwardSpeed / 1.467)
        Telemetry.TotalDistance = math.floor(FarmManager.LoopDistanceTraveled)
        Telemetry.CurrentWaypoint = frame.Index
        local laneName = "Center"
        if FarmManager.CurrentLaneOffset > 5 then laneName = "Right" elseif FarmManager.CurrentLaneOffset < -5 then laneName = "Left" end
        Telemetry.StatusText = string.format("Cruising %d MPH | Lane %s", Telemetry.SpeedMPH, laneName)
    end


    function FarmManager.LaunchWorker()
        FarmManager.WorkerThread = task.spawn(function()
            while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
                if Settings.AutoDriveFarm then
                    FarmManager.WasDriving = true
                    local ok, err = pcall(function()
                        FarmManager.StepDrive()
                    end)
                    if not ok then
                        warn("[GhostDriver Worker Safe Error] " .. tostring(err))
                        task.wait(0.2)
                    end
                    RunService.Heartbeat:Wait()
                else
                    if FarmManager.WasDriving then
                        FarmManager.WasDriving = false
                        FarmManager.Stop()
                    end
                    task.wait(0.2)
                end
            end
        end)
    end

    -- ═══════════════════════════════════════════════════════════════════
    -- 3. UI SETUP (Orion Glassy)
    -- ═══════════════════════════════════════════════════════════════════
    local Window = OrionLib:MakeWindow({
        Name = "PROJECT BARUN | Ghost Driver",
        HidePremium = true,
        SaveConfig = false,
        ConfigFolder = "ProjectBarunHub"
    })

    local TabDash    = Window:MakeTab({ Name = "Live Dashboard",  Icon = "📊" })
    local TabVehicle = Window:MakeTab({ Name = "Vehicle & Tune",  Icon = "🏎️" })
    local TabPolice  = Window:MakeTab({ Name = "Police & Defense", Icon = "🚨" })
    local TabFarm    = Window:MakeTab({ Name = "Farm & Economy",   Icon = "💰" })
    local TabTP      = Window:MakeTab({ Name = "Teleports",        Icon = "🌐" })
    local TabConfig  = Window:MakeTab({ Name = "Settings & Save",  Icon = "⚙️" })

    -- ─── Tab: Live Dashboard & Telemetry ──────────────────────────────
    TabDash:AddBanner("rbxassetid://71495519688848", 130)

    TabDash:AddSection({ Name = "⚡ Quick Control (ปุ่มเดียวเปิดครบทุกระบบ)" })

    TabDash:AddToggle({
        Name = "⚡ MASTER AUTO FARM (เปิดครบจบในปุ่มเดียว)",
        Default = Settings.AutoDriveFarm,
        Callback = function(Value)
            if Value then
                FarmManager.Start()
            else
                FarmManager.Stop()
            end
        end
    })

    TabDash:AddSection({ Name = "🚀 Real-time Telemetry & Farm Metrics" })

    local Dash_Speed    = TabDash:AddLabel("⚡ Current Speed: 0 MPH (0 km/h)")
    local Dash_Dist     = TabDash:AddLabel("🛣️ Distance Traveled: 0 Studs (0.00 KM)")
    local Dash_Cash     = TabDash:AddLabel("💰 Cash Earned: +$0 (~$0 / hr)")
    local Dash_Sector   = TabDash:AddLabel("📍 Road Progress: Point 1 / 412 (Sector: Starting)")
    local Dash_Traffic  = TabDash:AddLabel("🛡️ AI Traffic Evaded: 0 Cars")
    local Dash_Status   = TabDash:AddLabel("🟢 System Status: Active Grand Loop Farm")

    TabDash:AddSection({ Name = "⚙️ Overnight AFK Controls" })

    TabDash:AddToggle({
        Name = "GPU/CPU Saver Mode (ปิดเรนเดอร์ 3D พักการ์ดจอ สำหรับฟาร์มข้ามคืน)",
        Default = Settings.PerformanceMode,
        Callback = function(Value)
            Settings.PerformanceMode = Value
            pcall(function()
                RunService:Set3dRenderingEnabled(not Value)
            end)
        end
    })

    -- Safe Anti-Idle & Heartbeat Keepalive (Replaces dangerous LocalPlayer.Idled:Connect / VirtualUser to bypass BAC)
    task.spawn(function()
        local heartbeatRemote = NetFolder and NetFolder:FindFirstChild("RE/Activity/InputHeartbeat")
        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            if Settings.AntiAFK then
                pcall(function()
                    if heartbeatRemote then
                        heartbeatRemote:FireServer()
                    end
                end)
            end
            task.wait(15)
        end
    end)

    -- ─── Tab: Vehicle & Tune ──────────────────────────────────────────
    TabVehicle:AddSection({ Name = "Car Spawner" })

    TabVehicle:AddDropdown({
        Name = "Select Car to Spawn",
        Default = "Voss RT8",
        Options = {"Voss RT8", "Wulfbrecht RZ7", "StarterCar", "Voss RTREE"},
        Callback = function(Value) Settings.SelectedCar = Value end
    })

    TabVehicle:AddButton({
        Name = "Spawn Selected Car (เรียกรถออกมาทันที)",
        Callback = function()
            if Remote_SpawnCar then
                Remote_SpawnCar:FireServer(Settings.SelectedCar)
            end
        end
    })

    TabVehicle:AddButton({
        Name = "Despawn Car (เก็บรถ)",
        Callback = function()
            if Remote_RemoveCar then
                Remote_RemoveCar:FireServer()
            end
        end
    })

    TabVehicle:AddButton({
        Name = "Enter Driver Seat (วาปขึ้นเบาะคนขับทันที)",
        Callback = function()
            safe(function()
                local seat = getDriveSeat()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if seat and hum then
                    seat:Sit(hum)
                end
            end)
        end
    })

    TabVehicle:AddSection({ Name = "Vehicle Performance & Engine Tune" })

    TabVehicle:AddToggle({
        Name = "Speed & Acceleration Boost (เร่งเครื่องแรงพิเศษ)",
        Default = Settings.VehicleSpeedBoost,
        Callback = function(Value) Settings.VehicleSpeedBoost = Value end
    })

    TabVehicle:AddSlider({
        Name = "Boost Power Multiplier",
        Min = 1.0, Max = 4.0, Default = Settings.BoostMultiplier, Color = Color3.fromRGB(0, 200, 255),
        Increment = 0.1, ValueName = "x",
        Callback = function(Value) Settings.BoostMultiplier = Value end
    })

    TabVehicle:AddToggle({
        Name = "Infinite Nitrous (ไนตรัสยิงรัวไม่จำกัด)",
        Default = Settings.InfiniteNitrous,
        Callback = function(Value) Settings.InfiniteNitrous = Value end
    })

    -- ─── Tab: Police & Defense ────────────────────────────────────────
    TabPolice:AddSection({ Name = "🚨 Auto Escape Police (หนีตำรวจ & ล็อคเงินเป้าหมาย)" })

    TabPolice:AddToggle({
        Name = "Auto Escape Police (เปิดระบบหนีตำรวจอัตโนมัติ)",
        Default = Settings.AutoEscapePolice,
        Callback = function(Value)
            Settings.AutoEscapePolice = Value
            if Value then
                Settings.PoliceBustedActivated = false
                Settings.AutoDriveFarm = true
                Settings.NoCollisionTraffic = true
                Settings.GhostGodMode = true
                FarmManager.Start()
            else
                Settings.AutoEscapePolice = false
                Settings.PoliceBustedActivated = false
            end
        end
    })

    TabPolice:AddTextbox({
        Name = "Target Cash ($) (ตั้งเป้าหมายเงินที่ต้องการหนี)",
        Default = tostring(Settings.PoliceTargetCash or 50000),
        TextDisappear = false,
        Callback = function(Value)
            local n = tonumber(Value)
            if n and n > 0 then
                Settings.PoliceTargetCash = n
                Settings.PoliceBustedActivated = false
            end
        end
    })

    local PoliceStatusLabel = TabPolice:AddLabel("🛡️ Status: Standby")

    -- ─── Tab: Farm & Economy ──────────────────────────────────────────
    TabFarm:AddSection({ Name = "⚡ Auto Farm" })

    TabFarm:AddToggle({
        Name = "⚡ Auto Farm (เปิด/ปิด)",
        Default = Settings.AutoDriveFarm,
        Callback = function(Value)
            if Value then
                FarmManager.Start()
            else
                FarmManager.Stop()
            end
        end
    })

    TabFarm:AddSlider({
        Name = "Farm Drive Speed (ความเร็วขับฟาร์ม)",
        Min = 120, Max = 320, Default = Settings.FarmDriveSpeed, Color = Color3.fromRGB(0, 255, 150),
        Increment = 10, ValueName = "MPH",
        Callback = function(Value) Settings.FarmDriveSpeed = Value end
    })

    -- ─── Tab: Teleports ───────────────────────────────────────────────
    TabTP:AddSection({ Name = "Quick Waypoints (Map Update)" })

    local function tpTo(cf)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = cf
        end
    end

    TabTP:AddButton({
        Name = "Highway Entrance (หัวถนนหลัก Z = -957)",
        Callback = function()
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(Vector3.new(-3498.0, 64.0, -957.0), 2)
                task.wait(0.2)
            end
            tpTo(CFrame.new(-3498.0, 65.0, -957.0))
        end
    })

    TabTP:AddButton({
        Name = "City Lobby Respawn (จุดเกิดเมือง)",
        Callback = function() tpTo(CFrame.new(-3610.1, 137.5, -24.4)) end
    })

    TabTP:AddButton({
        Name = "Ocean Bridge Sector (สะพานข้ามทะเล X = -12318)",
        Callback = function()
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(Vector3.new(-12318.0, 64.0, -17076.0), 2)
                task.wait(0.2)
            end
            tpTo(CFrame.new(-12318.0, 65.0, -17076.0))
        end
    })

    TabTP:AddButton({
        Name = "Desert Loop Sector (โซนทะเลทราย Z = -14010)",
        Callback = function()
            if LocalPlayer.RequestStreamAroundAsync then
                LocalPlayer:RequestStreamAroundAsync(Vector3.new(-30081.0, 64.0, -14010.0), 2)
                task.wait(0.2)
            end
            tpTo(CFrame.new(-30081.0, 65.0, -14010.0))
        end
    })

    -- ─── Tab: Settings & Config System ───────────────────────────────
    TabConfig:AddSection({ Name = "💾 Configuration Profile Management" })

    TabConfig:AddButton({
        Name = "Save Settings (บันทึกการตั้งค่าลงเครื่อง)",
        Callback = function()
            local success = SaveConfig()
            if success then
                OrionLib:MakeNotification({
                    Name = "💾 Settings Saved",
                    Content = "บันทึกการตั้งค่าทั้งหมดลงใน " .. CONFIG_FILE .. " สำเร็จ!",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            else
                OrionLib:MakeNotification({
                    Name = "⚠️ Save Failed",
                    Content = "ไม่สามารถบันทึกไฟล์ได้ (Executor อาจไม่รองรับ writefile)",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            end
        end
    })

    TabConfig:AddButton({
        Name = "Load Settings (โหลดการตั้งค่าจากเครื่อง)",
        Callback = function()
            local success = LoadConfig()
            if success then
                OrionLib:MakeNotification({
                    Name = "📂 Settings Loaded",
                    Content = "โหลดการตั้งค่าจากไฟล์ " .. CONFIG_FILE .. " เรียบร้อย!",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            else
                OrionLib:MakeNotification({
                    Name = "⚠️ Load Failed",
                    Content = "ไม่พบไฟล์ที่บันทึกไว้ หรืออ่านไฟล์ล้มเหลว",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            end
        end
    })



    -- ═══════════════════════════════════════════════════════════════════
    -- 4. INDEPENDENT EXECUTION LOOPS 
    -- ═══════════════════════════════════════════════════════════════════

    -- Loop 1: Vehicle Engine & Nitrous Booster Loop
    task.spawn(function()
        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            if (Settings.VehicleSpeedBoost or Settings.InfiniteNitrous) and not Settings.AutoDriveFarm then
                safe(function()
                    local car = getPlayerCar()
                    if car then
                        local seat = getDriveSeat()
                        if seat and seat.Occupant then
                            -- Speed Boost via AssemblyLinearVelocity (Capped to CarSpeedLimits ceiling to prevent BAC-5511)
                            if Settings.VehicleSpeedBoost and seat.ThrottleFloat and seat.ThrottleFloat > 0 then
                                local boost = (Settings.BoostMultiplier or 1.3) - 1.0
                                if boost > 0 then
                                    local forward = seat.CFrame.LookVector
                                    local maxStuds = 300
                                    if CarSpeedLimitsModule then
                                        local okL, limits = pcall(require, CarSpeedLimitsModule)
                                        if okL and type(limits) == "table" and limits.ceilingFor then
                                            local okC, ceil = pcall(limits.ceilingFor, car)
                                            if okC and type(ceil) == "number" and ceil > 50 then
                                                maxStuds = ceil * 0.82
                                            end
                                        end
                                    end
                                    local newVel = seat.AssemblyLinearVelocity + (forward * (boost * 2.5))
                                    if newVel.Magnitude > maxStuds then
                                        newVel = newVel.Unit * maxStuds
                                    end
                                    seat.AssemblyLinearVelocity = newVel
                                end
                            end

                            -- Infinite Nitrous injectionฟ
                            if Settings.InfiniteNitrous and Remote_Nitrous then
                                Remote_Nitrous:FireServer(true)
                            end
                        end
                    end
                end)
                task.wait(0.05)
            else
                task.wait(0.5)
            end
        end
    end)

    -- Loop 2: Auto Police Escape & Dynamic Anti-Busted Engine
    task.spawn(function()
        -- Hook / Intercept PoliceBusted UI
        pcall(function()
            local pGui = LocalPlayer:WaitForChild("PlayerGui", 5)
            local bustedUI = pGui and pGui:FindFirstChild("PoliceBustedUI")
            if bustedUI then
                bustedUI:GetPropertyChangedSignal("Enabled"):Connect(function()
                    local isProtected = Settings.AntiBusted or (Settings.AutoEscapePolice and Settings.PoliceBustedActivated)
                    if isProtected and bustedUI.Enabled then
                        bustedUI.Enabled = false
                    end
                end)
            end
        end)

        local leaderstats = LocalPlayer:WaitForChild("leaderstats", 10)
        local cashVal = leaderstats and leaderstats:WaitForChild("Cash", 10)

        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            safe(function()
                if Settings.AutoEscapePolice then
                    local curCash = cashVal and cashVal.Value or Telemetry.CurrentCash or 0
                    local target = Settings.PoliceTargetCash or 50000

                    -- When earned cash / current cash reaches or exceeds target
                    if curCash >= target and not Settings.PoliceBustedActivated then
                        Settings.PoliceBustedActivated = true
                        Settings.AntiBusted = true -- Activate 100% immune from arrest

                        -- Dismiss any currently open Busted Screen immediately
                        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                        local bustedUI = pGui and pGui:FindFirstChild("PoliceBustedUI")
                        if bustedUI then bustedUI.Enabled = false end

                        -- Ensure AutoDriveFarm is engaged to drive safely until route completion
                        if not Settings.AutoDriveFarm then
                            Settings.AutoDriveFarm = true
                        end

                        pcall(function()
                            OrionLib:MakeNotification({
                                Name = "🚨 Police Target Reached!",
                                Content = string.format("เงินถึงเป้าแล้ว ($%s) -> เปิดระบบกันจับ 100% วิ่งจนจบลูป!", tostring(target)),
                                Image = "rbxassetid://4483345998",
                                Time = 5
                            })
                        end)
                    end
                end
            end)
            task.wait(0.5)
        end
    end)

    -- Loop 3: Universal Vehicle & Barrier No-Collision Engine (Anti-Crash & Ghosting)
    task.spawn(function()
        local function disableModelCollisions(model)
            for _, p in ipairs(model:GetDescendants()) do
                if p:IsA("BasePart") then
                    if p.CanCollide then p.CanCollide = false end
                end
            end
        end

        local function hookFolder(folder)
            if not folder then return end
            folder.ChildAdded:Connect(function(child)
                task.wait()
                if child:IsA("BasePart") then
                    child.CanCollide = false
                elseif child:IsA("Model") then
                    disableModelCollisions(child)
                end
            end)
        end

        local folders = {
            workspace:FindFirstChild("TrafficFolder"),
            workspace:FindFirstChild("TrafficBoxes"),
            workspace:FindFirstChild("more tarffic"),
            workspace:FindFirstChild("PoliceWalls"),
            workspace:FindFirstChild("Cars"),
        }
        for _, f in ipairs(folders) do hookFolder(f) end

        workspace.ChildAdded:Connect(function(child)
            if child.Name == "TrafficFolder" or child.Name == "TrafficBoxes" or child.Name == "more tarffic" or child.Name == "Cars" then
                hookFolder(child)
            end
        end)

        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            if Settings.NoCollisionTraffic or Settings.AutoDriveFarm or Settings.GhostGodMode then
                safe(function()
                    local pName = LocalPlayer.Name
                    local char = LocalPlayer.Character

                    -- 1. All Other Players Cars & Police Cars in Workspace
                    for _, m in ipairs(workspace:GetChildren()) do
                        if m:IsA("Model") and m ~= char and not m.Name:find(pName) then
                            local isVehicle = m:FindFirstChildWhichIsA("VehicleSeat", true) 
                                or m.Name:find("_") 
                                or m.Name:lower():find("police")
                            if isVehicle then
                                disableModelCollisions(m)
                            end
                        end
                    end

                    -- 2. All Traffic Folders & Barriers
                    for _, folder in ipairs({
                        workspace:FindFirstChild("TrafficFolder"),
                        workspace:FindFirstChild("TrafficBoxes"),
                        workspace:FindFirstChild("more tarffic"),
                        workspace:FindFirstChild("PoliceWalls"),
                        workspace:FindFirstChild("Cars"),
                    }) do
                        if folder then
                            for _, inst in ipairs(folder:GetChildren()) do
                                if inst:IsA("BasePart") and inst.CanCollide then
                                    inst.CanCollide = false
                                elseif inst:IsA("Model") then
                                    disableModelCollisions(inst)
                                end
                            end
                        end
                    end

                    -- 3. Player Car Body Ghosting (Preserve Wheels & DriveSeat CanCollide so car stays on the road!)
                    if Settings.GhostGodMode or Settings.AutoDriveFarm then
                        local myCar = getPlayerCar()
                        if myCar then
                            for _, p in ipairs(myCar:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    local pNameLower = p.Name:lower()
                                    local isWheelOrSeat = (p.Name == "DriveSeat") 
                                        or p:IsA("VehicleSeat")
                                        or pNameLower:find("wheel")
                                        or pNameLower:find("tire")
                                        or (p.Parent and p.Parent.Name:lower():find("wheel"))
                                    if not isWheelOrSeat then
                                        if p.CanCollide then p.CanCollide = false end
                                        if p.CanTouch then p.CanTouch = false end
                                    else
                                        if not p.CanCollide then p.CanCollide = true end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.06)
            else
                task.wait(1.0)
            end
        end
    end)

    -- Loop 4: Auto Combo & AFK Bonus
    task.spawn(function()
        local lastAFKTick = 0
        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            -- Safe AFK bonus claim (minimum 60s interval to prevent rate limit kicks)
            if Settings.AutoAFKBonus and Remote_AFKBonus and (tick() - lastAFKTick > 60) then
                lastAFKTick = tick()
                safe(function()
                    Remote_AFKBonus:FireServer()
                end)
            end

            task.wait(2.0)
        end
    end)

    -- ═══════════════════════════════════════════════════════════════════
    -- 5. GRAND LOOP AUTO FARM WORKER & WATCHDOG SUPERVISOR
    -- ═══════════════════════════════════════════════════════════════════
    -- Start farm worker if setting was enabled by default
    if Settings.AutoDriveFarm then
        FarmManager.Start()
    end

    -- Character Respawn Lifecycle Listener (Auto-remount immediately on death/respawn)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        if not _G.GhostDriverRunning or _G.GhostDriverActiveToken ~= myToken then return end
        task.wait(1.2)
        if Settings.AutoDriveFarm then
            safe(function()
                ensureCarAndSeat()
                if not FarmManager.WorkerThread or coroutine.status(FarmManager.WorkerThread) == "dead" then
                    FarmManager.Start()
                end
            end)
        end
    end)

    -- Watchdog Supervisor: Continuously monitors health, auto-revives worker, unfreezes 0 MPH, and mounts car
    task.spawn(function()
        local zeroSpeedTicks = 0
        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            task.wait(1.5)
            if Settings.AutoDriveFarm then
                -- 1. Auto-revive worker if thread crashed or terminated
                if not FarmManager.WorkerThread or coroutine.status(FarmManager.WorkerThread) == "dead" then
                    warn("[GhostDriver Watchdog] Farm thread was dead or uninitialized. Reviving now...")
                    FarmManager.Start()
                end

                -- 2. Detect unseated or missing car state & automatically resolve
                local car = getPlayerCar()
                local seat = getDriveSeat()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

                if not car or not seat or (hum and hum.SeatPart ~= seat) then
                    ensureCarAndSeat()
                    zeroSpeedTicks = 0
                elseif car and seat and hum and hum.SeatPart == seat then
                    local speed = seat.AssemblyLinearVelocity.Magnitude
                    if speed < 5 then
                        zeroSpeedTicks = zeroSpeedTicks + 1
                    else
                        zeroSpeedTicks = 0
                    end

                    -- If stationary for >= 6.0 seconds while Auto Farm is ON, execute forced unfreeze
                    if zeroSpeedTicks >= 4 then
                        zeroSpeedTicks = 0
                        FarmManager.UnfreezeVehicle()
                        local frame = findRoadFrame(seat.Position)
                        if frame then
                            local rideH = Settings.RideHeightOffset or 2.3
                            local safePt = frame.CenterPos + (frame.Normal * FarmManager.CurrentLaneOffset) + Vector3.new(0, rideH + 0.6, 0)
                            local flatDir = Vector3.new(frame.Direction.X, 0, frame.Direction.Z).Unit
                            car:PivotTo(CFrame.lookAt(safePt, safePt + flatDir))
                            seat.AssemblyLinearVelocity = flatDir * 140 + Vector3.new(0, 8, 0)
                            seat.AssemblyAngularVelocity = Vector3.zero
                            seat.Throttle = 1
                            seat.ThrottleFloat = 1
                        end
                    end
                else
                    zeroSpeedTicks = 0
                end
            else
                zeroSpeedTicks = 0
            end
        end
    end)

    -- Loop 6: Real-Time Telemetry & Orion Dashboard HUD Updater
    task.spawn(function()
        local leaderstats = LocalPlayer:WaitForChild("leaderstats", 5)
        local cashVal = leaderstats and leaderstats:WaitForChild("Cash", 5)
        if cashVal and Telemetry.StartCash == 0 then
            Telemetry.StartCash = cashVal.Value
        end

        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            safe(function()
                local curCash = cashVal and cashVal.Value or 0
                Telemetry.CurrentCash = curCash
                if Telemetry.StartCash == 0 and curCash > 0 then
                    Telemetry.StartCash = curCash
                end
                Telemetry.CashEarned = math.max(0, curCash - Telemetry.StartCash)

                local elapsedHours = (tick() - Telemetry.StartTime) / 3600
                local cashRate = elapsedHours > 0.005 and math.floor(Telemetry.CashEarned / elapsedHours) or 0

                local speedKmh = math.floor(Telemetry.SpeedMPH * 1.60934)
                local distKm = Telemetry.TotalDistance * 0.28 / 1000

                -- Update Orion Labels
                -- Update Orion Labels safely
                pcall(function()
                    if Dash_Speed and Dash_Speed.Set then
                        Dash_Speed:Set(string.format("⚡ Current Speed: %d MPH (%d km/h)", Telemetry.SpeedMPH, speedKmh))
                    end
                    if Dash_Dist and Dash_Dist.Set then
                        Dash_Dist:Set(string.format("🛣️ Distance Traveled: %s Studs (%.2f KM)", tostring(Telemetry.TotalDistance), distKm))
                    end
                    if Dash_Cash and Dash_Cash.Set then
                        Dash_Cash:Set(string.format("💰 Cash Earned: +$%s (~$%s / hr)", tostring(Telemetry.CashEarned), tostring(cashRate)))
                    end
                    if Dash_Sector and Dash_Sector.Set then
                        local sector = "Urban Highway"
                        if Telemetry.CurrentWaypoint > 250 then sector = "Desert Sector"
                        elseif Telemetry.CurrentWaypoint > 120 then sector = "Ocean Bridge" end
                        Dash_Sector:Set(string.format("📍 Progress: Point %d / %d (Sector: %s)", Telemetry.CurrentWaypoint, RoadData.TotalPoints > 0 and RoadData.TotalPoints or 412, sector))
                    end
                    if Dash_Traffic and Dash_Traffic.Set then
                        Dash_Traffic:Set(string.format("🛡️ AI Traffic Evaded: %d Vehicles", Telemetry.EvadedVehicles))
                    end
                    if Dash_Status and Dash_Status.Set then
                        Dash_Status:Set("🟢 Status: " .. Telemetry.StatusText)
                    end
                    if PoliceStatusLabel and PoliceStatusLabel.Set then
                        if Settings.AutoEscapePolice then
                            local targetStr = tostring(Settings.PoliceTargetCash or 50000)
                            local curStr = tostring(curCash)
                            if Settings.PoliceBustedActivated then
                                PoliceStatusLabel:Set("🛡️ Status: เป้าสำเร็จ ($" .. targetStr .. ") -> กันจับ 100% วิ่งจนจบลูป!")
                            else
                                PoliceStatusLabel:Set("🚨 Status: กำลังหนีตำรวจ... (เงิน: $" .. curStr .. " / $" .. targetStr .. ")")
                            end
                        else
                            PoliceStatusLabel:Set("🛡️ Status: Standby (ยังไม่ได้เปิดระบบ)")
                        end
                    end
                end)
            end)
            task.wait(0.6)
        end
    end)

    OrionLib:Init()
    print("[GhostDriver] 👻 Hub Initialized Successfully!")
