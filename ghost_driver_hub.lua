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
    -- 💎 PROJECT BARUN (PB) OBSIDIAN GLASS UI ENGINE v2.0
    -- ═══════════════════════════════════════════════════════════════════
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")

    local Theme = {
        VoidBg          = Color3.fromRGB(11, 13, 19),
        SurfaceBg       = Color3.fromRGB(16, 18, 27),
        SidebarBg       = Color3.fromRGB(13, 15, 23),
        CardBg          = Color3.fromRGB(22, 25, 38),
        CardHover       = Color3.fromRGB(28, 32, 49),
        CardBorder      = Color3.fromRGB(42, 46, 68),
        CardBorderGlow  = Color3.fromRGB(80, 88, 130),
        AccentPrimary   = Color3.fromRGB(139, 92, 246),
        AccentSecondary = Color3.fromRGB(59, 130, 246),
        AccentCyan      = Color3.fromRGB(6, 182, 212),
        TextTitle       = Color3.fromRGB(248, 250, 252),
        TextBody        = Color3.fromRGB(203, 213, 225),
        TextDim         = Color3.fromRGB(100, 116, 139),
        Success         = Color3.fromRGB(34, 197, 94),
        Warning         = Color3.fromRGB(245, 158, 11),
        Danger          = Color3.fromRGB(244, 63, 94),
        FontTitle       = Enum.Font.GothamBold,
        FontSemi        = Enum.Font.GothamMedium,
        FontRegular     = Enum.Font.Gotham,
    }

    local function tw(inst, props, dur, style, dir)
        local info = TweenInfo.new(dur or 0.28, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
        local t = TweenService:Create(inst, info, props)
        t:Play()
        return t
    end

    local function make(className, properties, children)
        local inst = Instance.new(className)
        for k, v in pairs(properties or {}) do inst[k] = v end
        for _, child in ipairs(children or {}) do child.Parent = inst end
        return inst
    end

    local PB_UI = {}
    function PB_UI:CreateWindow(config)
        config = config or {}
        local TitleText    = config.Name or config.Title or "PROJECT BARUN | Ghost Driver"
        local SubtitleText = config.Subtitle or "NEXT-GEN GOD ENGINE • v2.0"
        local WindowSize   = config.Size or UDim2.new(0, 720, 0, 480)
        local ParentTarget = (gethui and gethui()) or CoreGui

        for _, existing in ipairs(ParentTarget:GetChildren()) do
            if existing.Name == "ProjectBarunHub" or existing.Name == "Orion" then
                pcall(function() existing:Destroy() end)
            end
        end

        local ScreenGui = make("ScreenGui", {
            Name = "ProjectBarunHub",
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Parent = ParentTarget
        })

        local ShadowBackdrop = make("ImageLabel", {
            Name = "AmbientShadow",
            Size = UDim2.new(0, WindowSize.X.Offset + 64, 0, WindowSize.Y.Offset + 64),
            Position = UDim2.new(0.5, -(WindowSize.X.Offset + 64) / 2, 0.5, -(WindowSize.Y.Offset + 64) / 2),
            BackgroundTransparency = 1,
            Image = "rbxassetid://1316045217",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.35,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(10, 10, 118, 118),
            Parent = ScreenGui
        })

        local MainFrame = make("Frame", {
            Name = "MainChassis",
            Size = WindowSize,
            Position = UDim2.new(0.5, -WindowSize.X.Offset / 2, 0.5, -WindowSize.Y.Offset / 2),
            BackgroundColor3 = Theme.VoidBg,
            BorderSizePixel = 0,
            Parent = ScreenGui
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 16) }),
            make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.4, Transparency = 0.15 }),
            make("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(18, 20, 30)),
                    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(11, 13, 19))
                }),
                Rotation = 45
            })
        })

        local NeonTopLine = make("Frame", {
            Name = "NeonAccentBar",
            Size = UDim2.new(1, -32, 0, 2),
            Position = UDim2.new(0, 16, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Parent = MainFrame
        }, {
            make("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0.0, Theme.AccentPrimary),
                    ColorSequenceKeypoint.new(0.5, Theme.AccentCyan),
                    ColorSequenceKeypoint.new(1.0, Theme.AccentSecondary)
                })
            })
        })

        local ToastHolder = make("Frame", {
            Name = "ToastHolder",
            Size = UDim2.new(0, 310, 1, -40),
            Position = UDim2.new(1, -330, 0, 20),
            BackgroundTransparency = 1,
            Parent = ScreenGui
        }, {
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 10)
            })
        })

        local TopBar = make("Frame", {
            Name = "TopBar",
            Size = UDim2.new(1, 0, 0, 58),
            BackgroundColor3 = Theme.SidebarBg,
            BorderSizePixel = 0,
            Parent = MainFrame
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 16) }),
            make("Frame", {
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 1, -16),
                BackgroundColor3 = Theme.SidebarBg,
                BorderSizePixel = 0
            }),
            make("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.CardBorder,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0
            })
        })

        -- Official PROJECT BARUN Logo Asset Engine (GitHub Raw + Local Cache + Safe Fallback)
        local PB_LOGO_ASSET = "rbxassetid://71495519688848"
        pcall(function()
            local logoFileName = "ProjectBarun_Logo.png"
            if getcustomasset and (isfile and isfile(logoFileName)) then
                PB_LOGO_ASSET = getcustomasset(logoFileName)
            elseif getcustomasset and writefile and game.HttpGet then
                local rawUrl = "https://raw.githubusercontent.com/Barun080/Project-Barun/main/Gemini_Generated_Image_7m1xbd7m1xbd7m1x.jpg"
                local imgBytes = game:HttpGet(rawUrl)
                if imgBytes and #imgBytes > 0 then
                    writefile(logoFileName, imgBytes)
                    PB_LOGO_ASSET = getcustomasset(logoFileName)
                end
            end
        end)

        local LogoIconHolder = make("Frame", {
            Name = "LogoHolder",
            Size = UDim2.new(0, 36, 0, 36),
            Position = UDim2.new(0, 14, 0, 11),
            BackgroundColor3 = Color3.fromRGB(18, 20, 32),
            Parent = TopBar
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 8) }),
            make("UIStroke", { Color = Theme.AccentCyan, Thickness = 1.2, Transparency = 0.2 }),
            make("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 28, 48)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 14, 24))
                }),
                Rotation = 45
            }),
            make("TextLabel", {
                Name = "FallbackText",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "PB",
                Font = Theme.FontTitle,
                TextSize = 15,
                TextColor3 = Theme.AccentCyan,
                ZIndex = 1
            }),
            make("ImageLabel", {
                Name = "ProjectBarunLogo",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Image = PB_LOGO_ASSET,
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = 2
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 8) })
            })
        })

        make("TextLabel", {
            Text = TitleText,
            Font = Theme.FontTitle,
            TextSize = 16,
            TextColor3 = Theme.TextTitle,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 56, 0, 12),
            Size = UDim2.new(0, 260, 0, 18),
            BackgroundTransparency = 1,
            Parent = TopBar
        })

        make("TextLabel", {
            Text = string.upper(SubtitleText),
            Font = Theme.FontBold,
            TextSize = 9,
            TextColor3 = Theme.AccentCyan,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 56, 0, 32),
            Size = UDim2.new(0, 260, 0, 14),
            BackgroundTransparency = 1,
            Parent = TopBar
        })

        local PerfPill = make("Frame", {
            Size = UDim2.new(0, 160, 0, 26),
            Position = UDim2.new(1, -250, 0, 16),
            BackgroundColor3 = Theme.CardBg,
            Parent = TopBar
        }, {
            make("UICorner", { CornerRadius = UDim.new(1, 0) }),
            make("UIStroke", { Color = Theme.CardBorder, Thickness = 1 }),
            make("TextLabel", {
                Name = "PerfText",
                Text = "🟢 60 FPS  •  38ms",
                Font = Theme.FontSemi,
                TextSize = 11,
                TextColor3 = Theme.TextBody,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1
            })
        })

        task.spawn(function()
            local Stats = game:GetService("Stats")
            while ScreenGui.Parent do
                local fps = math.floor(1 / math.max(0.001, RunService.RenderStepped:Wait()))
                local ping = 40
                pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                if PerfPill and PerfPill:FindFirstChild("PerfText") then
                    local icon = fps >= 50 and "🟢" or (fps >= 30 and "🟡" or "🔴")
                    PerfPill.PerfText.Text = string.format("%s %d FPS  •  %dms", icon, fps, ping)
                end
                task.wait(1.2)
            end
        end)

        local WindowControls = make("Frame", {
            Size = UDim2.new(0, 70, 0, 28),
            Position = UDim2.new(1, -82, 0, 15),
            BackgroundTransparency = 1,
            Parent = TopBar
        }, {
            make("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 8)
            })
        })

        local MinBtn = make("TextButton", {
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = Theme.CardBg,
            Text = "-",
            Font = Theme.FontTitle,
            TextColor3 = Theme.TextBody,
            TextSize = 15,
            AutoButtonColor = false,
            Parent = WindowControls
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 8) }),
            make("UIStroke", { Color = Theme.CardBorder, Thickness = 1 })
        })

        local CloseBtn = make("TextButton", {
            Size = UDim2.new(0, 28, 0, 28),
            BackgroundColor3 = Color3.fromRGB(38, 20, 28),
            Text = "✕",
            Font = Theme.FontTitle,
            TextColor3 = Theme.Danger,
            TextSize = 11,
            AutoButtonColor = false,
            Parent = WindowControls
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 8) }),
            make("UIStroke", { Color = Color3.fromRGB(70, 30, 40), Thickness = 1 })
        })

        local dragging, dragStart, startPos
        TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                MainFrame.Position = targetPos
                ShadowBackdrop.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset - 32, targetPos.Y.Scale, targetPos.Y.Offset - 32)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        local Body = make("Frame", {
            Name = "Body",
            Size = UDim2.new(1, 0, 1, -58),
            Position = UDim2.new(0, 0, 0, 58),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = MainFrame
        })

        local FloatingBadge = make("ImageButton", {
            Name = "FloatingBadge",
            Size = UDim2.new(0, 52, 0, 52),
            Position = UDim2.new(0, 24, 0, 120),
            BackgroundColor3 = Color3.fromRGB(15, 17, 26),
            AutoButtonColor = false,
            Visible = false,
            ZIndex = 100,
            Parent = ScreenGui
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 14) }),
            make("UIStroke", { Color = Theme.AccentCyan, Thickness = 2, Transparency = 0.1 }),
            make("UIGradient", {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 28, 48)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 20))
                }),
                Rotation = 45
            }),
            make("TextLabel", {
                Name = "BadgeFallback",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "PB",
                Font = Theme.FontTitle,
                TextSize = 20,
                TextColor3 = Theme.AccentCyan,
                ZIndex = 100
            }),
            make("ImageLabel", {
                Name = "BadgeLogo",
                Size = UDim2.new(1, -6, 1, -6),
                Position = UDim2.new(0, 3, 0, 3),
                BackgroundTransparency = 1,
                Image = PB_LOGO_ASSET,
                ScaleType = Enum.ScaleType.Fit,
                ZIndex = 101
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 12) })
            })
        })

        -- Dragging logic for Floating Badge
        local badgeDragging, badgeDragStart, badgeStartPos
        FloatingBadge.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                badgeDragging = true
                badgeDragStart = input.Position
                badgeStartPos = FloatingBadge.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if badgeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - badgeDragStart
                FloatingBadge.Position = UDim2.new(
                    badgeStartPos.X.Scale, badgeStartPos.X.Offset + delta.X,
                    badgeStartPos.Y.Scale, badgeStartPos.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                badgeDragging = false
            end
        end)

        local isMinimized = false
        local function toggleMinimize()
            isMinimized = not isMinimized
            if isMinimized then
                tw(MainFrame, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                tw(ShadowBackdrop, { ImageTransparency = 1 }, 0.2)
                task.wait(0.25)
                MainFrame.Visible = false
                ShadowBackdrop.Visible = false
                FloatingBadge.Visible = true
                FloatingBadge.Size = UDim2.new(0, 0, 0, 0)
                tw(FloatingBadge, { Size = UDim2.new(0, 52, 0, 52) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                tw(FloatingBadge, { Size = UDim2.new(0, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                task.wait(0.2)
                FloatingBadge.Visible = false
                MainFrame.Visible = true
                ShadowBackdrop.Visible = true
                tw(MainFrame, { Size = WindowSize, BackgroundTransparency = 0 }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tw(ShadowBackdrop, { ImageTransparency = 0.35 }, 0.28)
                Body.Visible = true
            end
        end

        MinBtn.MouseButton1Click:Connect(toggleMinimize)
        FloatingBadge.MouseButton1Click:Connect(toggleMinimize)

        CloseBtn.MouseButton1Click:Connect(function()
            tw(MainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = MainFrame.Position + UDim2.new(0, WindowSize.X.Offset/2, 0, WindowSize.Y.Offset/2) }, 0.25)
            tw(ShadowBackdrop, { ImageTransparency = 1 }, 0.2)
            task.wait(0.28)
            ScreenGui:Destroy()
        end)

        local Sidebar = make("Frame", {
            Name = "Sidebar",
            Size = UDim2.new(0, 190, 1, 0),
            BackgroundColor3 = Theme.SidebarBg,
            BorderSizePixel = 0,
            Parent = Body
        }, {
            make("UICorner", { CornerRadius = UDim.new(0, 16) }),
            make("Frame", {
                Size = UDim2.new(0, 16, 1, 0),
                Position = UDim2.new(1, -16, 0, 0),
                BackgroundColor3 = Theme.SidebarBg,
                BorderSizePixel = 0
            }),
            make("Frame", {
                Size = UDim2.new(0, 1, 1, 0),
                Position = UDim2.new(1, -1, 0, 0),
                BackgroundColor3 = Theme.CardBorder,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0
            })
        })

        local TabScroll = make("ScrollingFrame", {
            Name = "TabScroll",
            Size = UDim2.new(1, -16, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.CardBorder,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = Sidebar
        }, {
            make("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 6)
            })
        })

        TabScroll.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, TabScroll.UIListLayout.AbsoluteContentSize.Y + 20)
        end)

        local ContentHolder = make("Frame", {
            Name = "ContentHolder",
            Size = UDim2.new(1, -202, 1, -14),
            Position = UDim2.new(0, 196, 0, 8),
            BackgroundTransparency = 1,
            Parent = Body
        })

        local WindowObj = {
            Tabs = {},
            CurrentTab = nil,
            MainFrame = MainFrame,
            ScreenGui = ScreenGui,
            ToastHolder = ToastHolder
        }

        function WindowObj:Notify(toast)
            toast = toast or {}
            local title = toast.Title or "Notice"
            local desc  = toast.Content or ""
            local icon  = toast.Icon or "⚡"
            local dur   = toast.Duration or 3.5

            local card = make("Frame", {
                Size = UDim2.new(1, 0, 0, 66),
                BackgroundColor3 = Theme.CardBg,
                Position = UDim2.new(1, 50, 0, 0),
                Parent = ToastHolder
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 12) }),
                make("UIStroke", { Color = Theme.AccentPrimary, Thickness = 1.2, Transparency = 0.3 }),
                make("Frame", {
                    Size = UDim2.new(0, 4, 1, -16),
                    Position = UDim2.new(0, 8, 0, 8),
                    BackgroundColor3 = Theme.AccentCyan
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) })
                }),
                make("TextLabel", {
                    Text = icon,
                    Font = Theme.FontTitle,
                    TextSize = 16,
                    Position = UDim2.new(0, 20, 0, 12),
                    Size = UDim2.new(0, 20, 0, 20),
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Text = title,
                    Font = Theme.FontTitle,
                    TextColor3 = Theme.TextTitle,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 46, 0, 12),
                    Size = UDim2.new(1, -54, 0, 18),
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Text = desc,
                    Font = Theme.FontRegular,
                    TextColor3 = Theme.TextDim,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 46, 0, 32),
                    Size = UDim2.new(1, -54, 0, 26),
                    TextWrapped = true,
                    BackgroundTransparency = 1
                })
            })

            tw(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart)
            task.delay(dur, function()
                tw(card, { Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1 }, 0.28)
                task.wait(0.3)
                pcall(function() card:Destroy() end)
            end)
        end

        function WindowObj:CreateTab(tabConfig)
            tabConfig = tabConfig or {}
            local TabName = tabConfig.Name or "Category"
            local TabIcon = tabConfig.Icon or "✦"
            if TabIcon == "" or TabIcon:find("rbxassetid") then
                TabIcon = "⚡"
            end

            local TabPage = make("ScrollingFrame", {
                Name = "Page_" .. TabName,
                Size = UDim2.new(1, -6, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Theme.AccentPrimary,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                Visible = false,
                Parent = ContentHolder
            }, {
                make("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8)
                }),
                make("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 16),
                    PaddingRight = UDim.new(0, 8)
                })
            })

            TabPage.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabPage.CanvasSize = UDim2.new(0, 0, 0, TabPage.UIListLayout.AbsoluteContentSize.Y + 24)
            end)

            local TabBtn = make("TextButton", {
                Name = "Tab_" .. TabName,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.CardBg,
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = TabScroll
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                make("UIStroke", {
                    Name = "TabStroke",
                    Color = Theme.CardBorder,
                    Thickness = 1,
                    Transparency = 1
                }),
                make("Frame", {
                    Name = "GlowIndicator",
                    Size = UDim2.new(0, 3, 0, 0),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundColor3 = Theme.AccentCyan,
                    BorderSizePixel = 0
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) })
                }),
                make("TextLabel", {
                    Name = "Icon",
                    Text = TabIcon,
                    TextSize = 14,
                    Position = UDim2.new(0, 12, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    TextColor3 = Theme.TextDim,
                    BackgroundTransparency = 1,
                    Font = Theme.FontBold
                }),
                make("TextLabel", {
                    Name = "Label",
                    Text = TabName,
                    Font = Theme.FontSemi,
                    TextSize = 12,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 40, 0, 0),
                    Size = UDim2.new(1, -44, 1, 0),
                    BackgroundTransparency = 1
                })
            })

            local TabObj = {
                Page = TabPage,
                Button = TabBtn,
                Name = TabName
            }

            local function activateTab()
                for _, t in ipairs(WindowObj.Tabs) do
                    t.Page.Visible = false
                    tw(t.Button, { BackgroundTransparency = 1 }, 0.2)
                    t.Button.Label.TextColor3 = Theme.TextDim
                    t.Button.Icon.TextColor3 = Theme.TextDim
                    local s = t.Button:FindFirstChild("TabStroke")
                    if s then tw(s, { Transparency = 1 }, 0.2) end
                    tw(t.Button.GlowIndicator, { Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0) }, 0.2)
                end
                TabPage.Visible = true
                tw(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.CardBg }, 0.25)
                TabBtn.Label.TextColor3 = Theme.TextTitle
                TabBtn.Icon.TextColor3 = Theme.AccentCyan
                local activeStroke = TabBtn:FindFirstChild("TabStroke")
                if activeStroke then tw(activeStroke, { Color = Theme.CardBorder, Transparency = 0.4 }, 0.25) end
                tw(TabBtn.GlowIndicator, { Size = UDim2.new(0, 3, 0, 22), Position = UDim2.new(0, 0, 0.5, -11) }, 0.25)
                WindowObj.CurrentTab = TabObj
            end

            TabBtn.MouseButton1Click:Connect(activateTab)

            TabBtn.MouseEnter:Connect(function()
                if WindowObj.CurrentTab ~= TabObj then
                    tw(TabBtn, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.CardHover }, 0.15)
                    TabBtn.Label.TextColor3 = Theme.TextBody
                    local s = TabBtn:FindFirstChild("TabStroke")
                    if s then tw(s, { Transparency = 0.6 }, 0.15) end
                end
            end)
            TabBtn.MouseLeave:Connect(function()
                if WindowObj.CurrentTab ~= TabObj then
                    tw(TabBtn, { BackgroundTransparency = 1 }, 0.15)
                    TabBtn.Label.TextColor3 = Theme.TextDim
                    local s = TabBtn:FindFirstChild("TabStroke")
                    if s then tw(s, { Transparency = 1 }, 0.15) end
                end
            end)

            if #WindowObj.Tabs == 0 then
                activateTab()
            end
            table.insert(WindowObj.Tabs, TabObj)

            -- Component: Section
            function TabObj:AddSection(secTitle)
                if type(secTitle) == "table" and secTitle.Name then
                    secTitle = secTitle.Name
                end
                local SecFrame = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Parent = TabPage
                }, {
                    make("Frame", {
                        Size = UDim2.new(0, 4, 0, 14),
                        Position = UDim2.new(0, 0, 0.5, -7),
                        BackgroundColor3 = Theme.AccentCyan
                    }, {
                        make("UICorner", { CornerRadius = UDim.new(1, 0) })
                    }),
                    make("TextLabel", {
                        Text = string.upper(tostring(secTitle)),
                        Font = Theme.FontTitle,
                        TextSize = 11,
                        TextColor3 = Theme.AccentCyan,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -12, 1, 0),
                        BackgroundTransparency = 1
                    }),
                    make("Frame", {
                        Size = UDim2.new(1, 0, 0, 1),
                        Position = UDim2.new(0, 0, 1, -1),
                        BackgroundColor3 = Theme.CardBorder,
                        BackgroundTransparency = 0.65
                    })
                })
                return SecFrame
            end

            -- Component: Label / Stat
            function TabObj:AddLabel(labelText)
                local card = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = Theme.CardBg,
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                    make("Frame", {
                        Size = UDim2.new(0, 3, 1, -12),
                        Position = UDim2.new(0, 8, 0, 6),
                        BackgroundColor3 = Theme.AccentCyan
                    }, {
                        make("UICorner", { CornerRadius = UDim.new(1, 0) })
                    }),
                    make("TextLabel", {
                        Name = "LabelText",
                        Text = tostring(labelText or ""),
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 20, 0, 0),
                        Size = UDim2.new(1, -28, 1, 0),
                        BackgroundTransparency = 1
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

            -- Component: Image Banner
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
                    make("UICorner", { CornerRadius = UDim.new(0, 12) }),
                    make("UIStroke", { Color = Theme.AccentCyan, Thickness = 1.2, Transparency = 0.25 }),
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
                        make("TextLabel", {
                            Text = "⚡ PROJECT BARUN ⚡",
                            Font = Theme.FontTitle,
                            TextSize = 18,
                            TextColor3 = Theme.AccentCyan,
                            Position = UDim2.new(0, 0, 0.35, -10),
                            Size = UDim2.new(1, 0, 0, 24),
                            BackgroundTransparency = 1
                        }),
                        make("TextLabel", {
                            Text = "GHOST DRIVER ENGINE • ULTIMATE AUTO HIGHWAY",
                            Font = Theme.FontBold,
                            TextSize = 10,
                            TextColor3 = Theme.AccentPrimary,
                            Position = UDim2.new(0, 0, 0.58, 0),
                            Size = UDim2.new(1, 0, 0, 16),
                            BackgroundTransparency = 1
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

            -- Component: Toggle
            function TabObj:AddToggle(togConfig)
                togConfig = togConfig or {}
                local name     = togConfig.Name or "Toggle"
                local desc     = togConfig.Desc or ""
                local default  = togConfig.Default or false
                local callback = togConfig.Callback or function() end

                local isToggled = default
                local cardHeight = desc ~= "" and 52 or 42

                local ToggleCard = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, cardHeight),
                    BackgroundColor3 = Theme.CardBg,
                    AutoButtonColor = false,
                    Text = "",
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Name = "CardStroke", Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                    make("TextLabel", {
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 16, 0, desc ~= "" and 8 or 0),
                        Size = UDim2.new(1, -80, 0, desc ~= "" and 18 or cardHeight),
                        BackgroundTransparency = 1
                    })
                })

                if desc ~= "" then
                    make("TextLabel", {
                        Text = desc,
                        Font = Theme.FontRegular,
                        TextSize = 10,
                        TextColor3 = Theme.TextDim,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 16, 0, 26),
                        Size = UDim2.new(1, -80, 0, 16),
                        BackgroundTransparency = 1,
                        Parent = ToggleCard
                    })
                end

                local Track = make("Frame", {
                    Size = UDim2.new(0, 42, 0, 22),
                    Position = UDim2.new(1, -56, 0.5, -11),
                    BackgroundColor3 = isToggled and Theme.AccentPrimary or Color3.fromRGB(36, 40, 56),
                    Parent = ToggleCard
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    make("UIStroke", {
                        Color = isToggled and Theme.AccentCyan or Theme.CardBorder,
                        Thickness = 1,
                        Transparency = 0.4
                    })
                })

                local Knob = make("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Track
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local function syncVisual(fire)
                    if isToggled then
                        tw(Track, { BackgroundColor3 = Theme.AccentPrimary }, 0.22)
                        tw(Track.UIStroke, { Color = Theme.AccentCyan }, 0.22)
                        tw(Knob, { Position = UDim2.new(1, -19, 0.5, -8) }, 0.22, Enum.EasingStyle.Quart)
                        tw(ToggleCard.CardStroke, { Color = Theme.AccentPrimary, Transparency = 0.5 }, 0.22)
                    else
                        tw(Track, { BackgroundColor3 = Color3.fromRGB(36, 40, 56) }, 0.22)
                        tw(Track.UIStroke, { Color = Theme.CardBorder }, 0.22)
                        tw(Knob, { Position = UDim2.new(0, 3, 0.5, -8) }, 0.22, Enum.EasingStyle.Quart)
                        tw(ToggleCard.CardStroke, { Color = Theme.CardBorder, Transparency = 0.3 }, 0.22)
                    end
                    if fire then task.spawn(callback, isToggled) end
                end

                ToggleCard.MouseButton1Click:Connect(function()
                    isToggled = not isToggled
                    syncVisual(true)
                end)

                local handle = {}
                function handle:Set(val)
                    isToggled = val
                    syncVisual(true)
                end
                return handle
            end

            -- Component: Slider
            function TabObj:AddSlider(sldConfig)
                sldConfig = sldConfig or {}
                local name      = sldConfig.Name or "Slider"
                local min       = sldConfig.Min or 0
                local max       = sldConfig.Max or 100
                local default   = math.clamp(sldConfig.Default or min, min, max)
                local inc       = sldConfig.Increment or 1
                local suffix    = sldConfig.ValueName or ""
                local callback  = sldConfig.Callback or function() end

                local currentVal = default

                local SliderCard = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 54),
                    BackgroundColor3 = Theme.CardBg,
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                    make("TextLabel", {
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 16, 0, 8),
                        Size = UDim2.new(0.65, 0, 0, 16),
                        BackgroundTransparency = 1
                    }),
                    make("TextLabel", {
                        Name = "ValText",
                        Text = tostring(currentVal) .. (suffix ~= "" and (" " .. suffix) or ""),
                        Font = Theme.FontTitle,
                        TextSize = 12,
                        TextColor3 = Theme.AccentCyan,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Position = UDim2.new(0.65, 0, 0, 8),
                        Size = UDim2.new(0.35, -16, 0, 16),
                        BackgroundTransparency = 1
                    })
                })

                local Rail = make("TextButton", {
                    Size = UDim2.new(1, -32, 0, 7),
                    Position = UDim2.new(0, 16, 0, 34),
                    BackgroundColor3 = Color3.fromRGB(34, 38, 54),
                    AutoButtonColor = false,
                    Text = "",
                    Parent = SliderCard
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) })
                })

                local fillRatio = (currentVal - min) / (max - min)
                local Fill = make("Frame", {
                    Size = UDim2.new(fillRatio, 0, 1, 0),
                    BackgroundColor3 = Theme.AccentPrimary,
                    Parent = Rail
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    make("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.0, Theme.AccentPrimary),
                            ColorSequenceKeypoint.new(1.0, Theme.AccentCyan)
                        })
                    })
                })

                local Scrubber = make("Frame", {
                    Size = UDim2.new(0, 13, 0, 13),
                    Position = UDim2.new(fillRatio, -6, 0.5, -6),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Rail
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    make("UIStroke", { Color = Theme.AccentCyan, Thickness = 2 })
                })

                local isSliding = false
                local function updateSlider(inputX)
                    local railX = Rail.AbsolutePosition.X
                    local railW = Rail.AbsoluteSize.X
                    local pct = math.clamp((inputX - railX) / railW, 0, 1)
                    local rawVal = min + (max - min) * pct
                    local stepped = math.floor((rawVal / inc) + 0.5) * inc
                    stepped = math.clamp(stepped, min, max)

                    currentVal = stepped
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    Scrubber.Position = UDim2.new(pct, -6, 0.5, -6)
                    SliderCard.ValText.Text = tostring(currentVal) .. (suffix ~= "" and (" " .. suffix) or "")
                    task.spawn(callback, currentVal)
                end

                Rail.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = true
                        updateSlider(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false
                    end
                end)
            end

            -- Component: Dropdown
            function TabObj:AddDropdown(dropConfig)
                dropConfig = dropConfig or {}
                local name      = dropConfig.Name or "Dropdown"
                local options   = dropConfig.Options or {}
                local default   = dropConfig.Default or options[1]
                local callback  = dropConfig.Callback or function() end

                local isExpanded = false
                local selected   = default

                local DropCard = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = Theme.CardBg,
                    ClipsDescendants = true,
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 })
                })

                local Header = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropCard
                }, {
                    make("TextLabel", {
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 16, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BackgroundTransparency = 1
                    }),
                    make("TextLabel", {
                        Name = "SelectedText",
                        Text = tostring(selected) .. "  ▾",
                        Font = Theme.FontBold,
                        TextSize = 11,
                        TextColor3 = Theme.AccentCyan,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Position = UDim2.new(0.5, 0, 0, 0),
                        Size = UDim2.new(0.5, -16, 1, 0),
                        BackgroundTransparency = 1
                    })
                })

                local OptionsContainer = make("Frame", {
                    Size = UDim2.new(1, -24, 0, #options * 30),
                    Position = UDim2.new(0, 12, 0, 44),
                    BackgroundTransparency = 1,
                    Parent = DropCard
                }, {
                    make("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 4)
                    })
                })

                for _, opt in ipairs(options) do
                    local OptBtn = make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = Color3.fromRGB(30, 34, 50),
                        Text = tostring(opt),
                        Font = Theme.FontRegular,
                        TextSize = 11,
                        TextColor3 = Theme.TextBody,
                        AutoButtonColor = false,
                        Parent = OptionsContainer
                    }, {
                        make("UICorner", { CornerRadius = UDim.new(0, 6) })
                    })

                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        Header.SelectedText.Text = tostring(opt) .. "  ▾"
                        isExpanded = false
                        tw(DropCard, { Size = UDim2.new(1, 0, 0, 42) }, 0.22)
                        task.spawn(callback, selected)
                    end)
                end

                Header.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    if isExpanded then
                        local targetH = 50 + (#options * 30)
                        tw(DropCard, { Size = UDim2.new(1, 0, 0, targetH) }, 0.25, Enum.EasingStyle.Quart)
                        Header.SelectedText.Text = tostring(selected) .. "  ▴"
                    else
                        tw(DropCard, { Size = UDim2.new(1, 0, 0, 42) }, 0.22, Enum.EasingStyle.Quart)
                        Header.SelectedText.Text = tostring(selected) .. "  ▾"
                    end
                end)
            end

            -- Component: Button
            function TabObj:AddButton(btnConfig)
                btnConfig = btnConfig or {}
                local name      = btnConfig.Name or "Button"
                local callback  = btnConfig.Callback or function() end

                local Btn = make("TextButton", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = Theme.CardBg,
                    AutoButtonColor = false,
                    Text = "",
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Name = "BtnStroke", Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.25 }),
                    make("UIGradient", {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 30, 46)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 22, 34))
                        }),
                        Rotation = 90
                    }),
                    make("TextLabel", {
                        Text = "⚡",
                        Font = Theme.FontBold,
                        TextSize = 13,
                        Position = UDim2.new(0, 14, 0.5, -10),
                        Size = UDim2.new(0, 20, 0, 20),
                        TextColor3 = Theme.AccentCyan,
                        BackgroundTransparency = 1
                    }),
                    make("TextLabel", {
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 38, 0, 0),
                        Size = UDim2.new(1, -46, 1, 0),
                        BackgroundTransparency = 1
                    })
                })

                local btnStroke = Btn:FindFirstChild("BtnStroke")
                Btn.MouseEnter:Connect(function()
                    tw(Btn, { BackgroundColor3 = Theme.CardHover }, 0.15)
                    if btnStroke then tw(btnStroke, { Color = Theme.AccentCyan, Transparency = 0 }, 0.15) end
                end)

                Btn.MouseLeave:Connect(function()
                    tw(Btn, { BackgroundColor3 = Theme.CardBg }, 0.15)
                    if btnStroke then tw(btnStroke, { Color = Theme.CardBorder, Transparency = 0.25 }, 0.15) end
                end)

                Btn.MouseButton1Click:Connect(function()
                    tw(Btn, { Size = UDim2.new(1, -4, 0, 40) }, 0.08)
                    task.wait(0.08)
                    tw(Btn, { Size = UDim2.new(1, 0, 0, 42) }, 0.12)
                    task.spawn(callback)
                end)
            end

            -- Component: Textbox
            function TabObj:AddTextbox(txtConfig)
                txtConfig = txtConfig or {}
                local name      = txtConfig.Name or "Input"
                local default   = txtConfig.Default or ""
                local place     = txtConfig.Placeholder or "Enter value..."
                local callback  = txtConfig.Callback or function() end

                local BoxCard = make("Frame", {
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundColor3 = Theme.CardBg,
                    Parent = TabPage
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                    make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                    make("TextLabel", {
                        Text = name,
                        Font = Theme.FontSemi,
                        TextSize = 12,
                        TextColor3 = Theme.TextTitle,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 16, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BackgroundTransparency = 1
                    })
                })

                local Input = make("TextBox", {
                    Size = UDim2.new(0, 160, 0, 28),
                    Position = UDim2.new(1, -174, 0.5, -14),
                    BackgroundColor3 = Color3.fromRGB(28, 32, 48),
                    Text = tostring(default),
                    PlaceholderText = place,
                    PlaceholderColor3 = Theme.TextDim,
                    Font = Theme.FontRegular,
                    TextSize = 12,
                    TextColor3 = Theme.TextTitle,
                    ClearTextOnFocus = false,
                    Parent = BoxCard
                }, {
                    make("UICorner", { CornerRadius = UDim.new(0, 8) }),
                    make("UIStroke", { Name = "InputStroke", Color = Theme.CardBorder, Thickness = 1 })
                })

                Input.Focused:Connect(function()
                    tw(Input.InputStroke, { Color = Theme.AccentCyan }, 0.2)
                end)
                Input.FocusLost:Connect(function(enter)
                    tw(Input.InputStroke, { Color = Theme.CardBorder }, 0.2)
                    task.spawn(callback, Input.Text, enter)
                end)
            end

            TabObj.MakeTab = TabObj.CreateTab
            return TabObj
        end

        WindowObj.MakeTab = WindowObj.CreateTab
        return WindowObj
    end

    PB_UI.MakeWindow = PB_UI.CreateWindow
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
        InfiniteNitrous      = false,
        VehicleFly           = false,
        FlySpeed             = 120,

        -- Anti-Police & Godmode
        AntiBusted           = false,
        NoCollisionTraffic   = true,      -- All AI traffic & vehicles pass through without collision
        GhostGodMode         = true,      -- Car body parts ghosted (pass through all walls & cars 100%)
        AutoEscapePolice     = false,     -- Auto Escape Police Pursuit mode
        PoliceTargetCash     = 50000,     -- Target cash goal before activating 100% Anti-Busted
        PoliceBustedActivated= false,     -- Flag indicating target cash reached and 100% protection active

        -- Auto Farming & Economy (Grand Loop 96,000+ studs / 26.8 km!)
        AutoDriveFarm        = false,     -- Safe default: user activates via GUI when seated
        FarmDriveSpeed       = 170,      -- Safe, legitimate high-speed farm speed
        FarmPercent          = 1.0,      -- Full loop or custom route percent
        FarmLane             = "Lane 2 (Center)",
        LoopMode             = "Infinite Loop (วิ่งวนลูปไฮเวย์รอบโลกต่อเนื่อง)",
        AutoBankCombo        = true,
        AutoKeepCombo        = false,    -- Do not spam combo remotes by default
        AutoSwerveCloseCall  = false,    -- Disabled to prevent server-side spam kicks
        AutoRespawnCar       = false,
        AutoClaimDaily       = false,
        AutoClaimFreeCar     = false,
        AutoAFKBonus         = false,    -- Safe default: off
        AntiAFK              = true,     -- 24/7 Anti-Idle disconnect protector (client safe)
        PerformanceMode      = false,    -- GPU/CPU saver (disables 3D rendering for overnight AFK)

        -- Selected Car to Spawn
        SelectedCar          = "Voss RT8",

        -- Advanced Smooth Physics & Adaptive Cornering Engine
        AdaptiveCornering    = true,     -- เข้าโค้งเนียนสมูท ป้องกันหลุดโค้ง
        CornerSlowdown       = true,     -- ชะลอความเร็วเล็กน้อยตอนเจอโค้งหักศอก
        SmoothSteerFactor    = 0.22,     -- ความนุ่มนวลของการหักเลี้ยว (0.15 - 0.40)
        LookaheadLead        = 38,       -- ระยะคำนวณถนนล่วงหน้า (studs)
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
                    LookaheadLead = Settings.LookaheadLead
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
    -- 2. VEHICLE RESOLVER HELPERS
    -- ═══════════════════════════════════════════════════════════════════
    local function getPlayerCar()
        local pName = LocalPlayer.Name
        local char = LocalPlayer.Character
        -- 1. Check if seated directly in a car
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and hum.SeatPart:IsA("VehicleSeat") then
            local carModel = hum.SeatPart:FindFirstAncestorOfClass("Model")
            if carModel and carModel ~= char then
                return carModel
            end
        end
        -- 2. Check workspace children for player car
        for _, model in ipairs(workspace:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                if model.Name == pName .. "_" .. (Settings.SelectedCar or "") 
                or model.Name:find(pName) 
                or model:GetAttribute("Owner") == pName then
                    return model
                end
            end
        end
        -- 3. Fallback to workspace.Cars
        local cars = workspace:FindFirstChild("Cars")
        if cars then
            for _, model in ipairs(cars:GetChildren()) do
                if model:IsA("Model") and (model.Name:find(pName) or model:GetAttribute("Owner") == pName) then
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

    TabDash:AddSection({ Name = "🚀 Real-time Telemetry & Farm Metrics" })

    local Dash_Speed    = TabDash:AddLabel("⚡ Current Speed: 0 MPH (0 km/h)")
    local Dash_Dist     = TabDash:AddLabel("🛣️ Distance Traveled: 0 Studs (0.00 KM)")
    local Dash_Cash     = TabDash:AddLabel("💰 Cash Earned: +$0 (~$0 / hr)")
    local Dash_Sector   = TabDash:AddLabel("📍 Road Progress: Point 1 / 412 (Sector: Starting)")
    local Dash_Traffic  = TabDash:AddLabel("🛡️ AI Traffic Evaded: 0 Cars")
    local Dash_Status   = TabDash:AddLabel("🟢 System Status: Active Grand Loop Farm")

    TabDash:AddSection({ Name = "⚙️ Advanced Protections & Overnight AFK Controls" })

    TabDash:AddToggle({
        Name = "Ghost Godmode (ตัวถังรถทะลุสิ่งกีดขวาง/กำแพง/รถชาวบ้าน 100%)",
        Default = Settings.GhostGodMode,
        Callback = function(Value) Settings.GhostGodMode = Value end
    })

    TabDash:AddToggle({
        Name = "Adaptive Cornering (คำนวณโค้งล่วงหน้า & เอียงตัวรถเข้าโค้ง)",
        Default = Settings.AdaptiveCornering,
        Callback = function(Value) Settings.AdaptiveCornering = Value end
    })

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

    TabDash:AddToggle({
        Name = "24/7 Anti-AFK (กันหลุด 20 นาที ปลอดภัยไม่โดนแบน)",
        Default = Settings.AntiAFK,
        Callback = function(Value) Settings.AntiAFK = Value end
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

    TabVehicle:AddToggle({
        Name = "No Traffic Collision (ทะลุรถชาวบ้านไม่ชน)",
        Default = Settings.NoCollisionTraffic,
        Callback = function(Value) Settings.NoCollisionTraffic = Value end
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
            else
                Settings.AutoEscapePolice = false
                Settings.AutoDriveFarm = false
                Settings.PoliceBustedActivated = false
                local seat = getDriveSeat()
                if seat then
                    seat.AssemblyLinearVelocity = Vector3.zero
                    seat.AssemblyAngularVelocity = Vector3.zero
                    seat.Throttle = 0
                    seat.ThrottleFloat = 0
                    seat.SteerFloat = 0
                end
                local car = getPlayerCar()
                if car then
                    local vals = car:FindFirstChild("Values")
                    if vals then
                        local pb = vals:FindFirstChild("PBrake") or vals:FindFirstChild("Handbrake")
                        if pb and pb:IsA("BoolValue") then pb.Value = true end
                    end
                end
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

    TabPolice:AddSection({ Name = "Anti-Police Protection" })

    TabPolice:AddToggle({
        Name = "Anti-Busted 100% (กันตำรวจจับถาวร บล็อกแพ้คดี)",
        Default = Settings.AntiBusted,
        Callback = function(Value) Settings.AntiBusted = Value end
    })

    -- ─── Tab: Farm & Economy ──────────────────────────────────────────
    TabFarm:AddSection({ Name = "Grand Loop Highway Auto Farm (ขับฟาร์ม 96,000 Studs / 26.8 KM)" })

    TabFarm:AddToggle({
        Name = "Auto Drive Farm (เปิดระบบขับฟาร์มเงินอัตโนมัติ)",
        Default = Settings.AutoDriveFarm,
        Callback = function(Value)
            Settings.AutoDriveFarm = Value
            if Value then
                Settings.NoCollisionTraffic = true
                Settings.GhostGodMode = true
                task.spawn(function()
                    local car = getPlayerCar()
                    if not car and Remote_SpawnCar then
                        Remote_SpawnCar:FireServer(Settings.SelectedCar or "Wulfbrecht RZ7")
                        task.wait(1.5)
                        car = getPlayerCar()
                    end
                    local seat = getDriveSeat()
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if seat and hum then
                        if hrp then hrp.CFrame = seat.CFrame + Vector3.new(0, 2, 0) end
                        seat:Sit(hum)
                    end
                end)
            else
                Settings.AutoDriveFarm = false
                Settings.AutoEscapePolice = false
                local seat = getDriveSeat()
                if seat then
                    seat.AssemblyLinearVelocity = Vector3.zero
                    seat.AssemblyAngularVelocity = Vector3.zero
                    seat.Throttle = 0
                    seat.ThrottleFloat = 0
                    seat.SteerFloat = 0
                end
                local car = getPlayerCar()
                if car then
                    local vals = car:FindFirstChild("Values")
                    if vals then
                        local pb = vals:FindFirstChild("PBrake") or vals:FindFirstChild("Handbrake")
                        if pb and pb:IsA("BoolValue") then pb.Value = true end
                    end
                end
            end
        end
    })

    TabFarm:AddSlider({
        Name = "Farm Drive Speed (ความเร็วขับฟาร์ม)",
        Min = 120, Max = 320, Default = Settings.FarmDriveSpeed, Color = Color3.fromRGB(0, 255, 150),
        Increment = 10, ValueName = "MPH",
        Callback = function(Value) Settings.FarmDriveSpeed = Value end
    })

    TabFarm:AddDropdown({
        Name = "Farm Loop Mode (โหมดการวิ่งฟาร์ม)",
        Default = "Infinite Loop (วิ่งวนลูปไฮเวย์รอบโลกต่อเนื่อง)",
        Options = {
            "Infinite Loop (วิ่งวนลูปไฮเวย์รอบโลกต่อเนื่อง)",
            "Sprint 25% (~24,000 studs)",
            "Sprint 50% (~48,000 studs)",
            "Full Loop 100% (~96,000 studs แล้วรีเซ็ต)"
        },
        Callback = function(Value)
            Settings.LoopMode = Value
            if Value:find("25") then
                Settings.FarmPercent = 0.25
            elseif Value:find("50") then
                Settings.FarmPercent = 0.50
            elseif Value:find("100") then
                Settings.FarmPercent = 1.00
            else
                Settings.FarmPercent = 1.00 -- Infinite loop continuously
            end
        end
    })

    TabFarm:AddDropdown({
        Name = "Select Highway Lane (เลือกเลนขับฟาร์ม)",
        Default = "Lane 2 (Center)",
        Options = {"Lane 1 (Left)", "Lane 2 (Center)", "Lane 3 (Right)"},
        Callback = function(Value) Settings.FarmLane = Value end
    })

    TabFarm:AddToggle({
        Name = "Auto Bank / Revive Combo (บันทึกแต้มเงินอัตโนมัติ)",
        Default = Settings.AutoBankCombo,
        Callback = function(Value) Settings.AutoBankCombo = Value end
    })

    TabFarm:AddToggle({
        Name = "Auto Keep Combo (รักษาระดับคอมโบรับแต้มต่อเนื่อง)",
        Default = Settings.AutoKeepCombo,
        Callback = function(Value) Settings.AutoKeepCombo = Value end
    })

    TabFarm:AddToggle({
        Name = "Auto Close Call / Traffic Swerve (ฟาร์มแต้มเฉียดรถ AI รัวๆ)",
        Default = Settings.AutoSwerveCloseCall,
        Callback = function(Value) Settings.AutoSwerveCloseCall = Value end
    })

    TabFarm:AddToggle({
        Name = "Auto Respawn & Mount Car (เสกและขึ้นรถใหม่อัตโนมัติถ้ารถหาย)",
        Default = Settings.AutoRespawnCar,
        Callback = function(Value) Settings.AutoRespawnCar = Value end
    })

    TabFarm:AddToggle({
        Name = "Auto AFK Bonus (กดรับโบนัส AFK อัตโนมัติ)",
        Default = Settings.AutoAFKBonus,
        Callback = function(Value) Settings.AutoAFKBonus = Value end
    })

    TabFarm:AddSection({ Name = "Quick Waypoints & Course Start" })

    TabFarm:AddButton({
        Name = "Warp to Highway Start (วาปไปจุดเริ่มไฮเวย์ใหม่ Z = -957)",
        Callback = function()
            safe(function()
                local car = getPlayerCar()
                local targetPos = Vector3.new(-3498.0, 63.2, -957.0)
                if LocalPlayer.RequestStreamAroundAsync then
                    LocalPlayer:RequestStreamAroundAsync(targetPos, 2)
                    task.wait(0.2)
                end
                if car then
                    car:PivotTo(CFrame.lookAt(targetPos, targetPos + Vector3.new(0, 0, -10)))
                    local seat = getDriveSeat()
                    if seat then
                        seat.AssemblyLinearVelocity = Vector3.zero
                        seat.AssemblyAngularVelocity = Vector3.zero
                    end
                else
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end
                end
            end)
        end
    })

    TabFarm:AddButton({
        Name = "Warp to Desert Sector (วาปไปโซนทะเลทราย X = -30168)",
        Callback = function()
            safe(function()
                local car = getPlayerCar()
                local targetPos = Vector3.new(-30168.0, 63.2, -14626.0)
                if LocalPlayer.RequestStreamAroundAsync then
                    LocalPlayer:RequestStreamAroundAsync(targetPos, 2)
                    task.wait(0.2)
                end
                if car then
                    car:PivotTo(CFrame.lookAt(targetPos, targetPos + Vector3.new(0, 0, 10)))
                else
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) end
                end
            end)
        end
    })

    TabFarm:AddSection({ Name = "Free Gifts & Daily Rewards" })

    TabFarm:AddButton({
        Name = "Claim Daily Login Reward (กดรับรางวัลประจำวัน)",
        Callback = function()
            if Remote_ClaimDaily then
                local ok, res = pcall(function() return Remote_ClaimDaily:InvokeServer() end)
                print("[GhostDriver] Daily Login Result: " .. tostring(res))
            end
        end
    })

    TabFarm:AddButton({
        Name = "Claim Free Car (รับรถแจกฟรี)",
        Callback = function()
            if Remote_ClaimFree then
                local ok, res = pcall(function() return Remote_ClaimFree:InvokeServer() end)
                print("[GhostDriver] Claim Free Car Result: " .. tostring(res))
            end
        end
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

    TabConfig:AddSection({ Name = "🏎️ Adaptive Physics & Curve Steering" })

    TabConfig:AddToggle({
        Name = "Adaptive Cornering (คำนวณโค้งล่วงหน้า & เลี้ยวสมูท)",
        Default = Settings.AdaptiveCornering,
        Callback = function(Value) Settings.AdaptiveCornering = Value end
    })

    TabConfig:AddToggle({
        Name = "Corner Dynamic Slowdown (ชะลอความเร็วเล็กน้อยตอนโค้งหักศอก)",
        Default = Settings.CornerSlowdown,
        Callback = function(Value) Settings.CornerSlowdown = Value end
    })

    TabConfig:AddSlider({
        Name = "Smooth Steer Factor (ความนุ่มนวลของการหักเลี้ยว)",
        Min = 0.10, Max = 0.50, Default = Settings.SmoothSteerFactor, Color = Color3.fromRGB(0, 240, 255),
        Increment = 0.02, ValueName = "factor",
        Callback = function(Value) Settings.SmoothSteerFactor = Value end
    })

    TabConfig:AddSlider({
        Name = "Lookahead Distance Lead (ระยะดึงสายตามองถนน)",
        Min = 20, Max = 60, Default = Settings.LookaheadLead, Color = Color3.fromRGB(255, 180, 0),
        Increment = 2, ValueName = "studs",
        Callback = function(Value) Settings.LookaheadLead = Value end
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
    -- 5. GRAND LOOP HIGHWAY ENGINE (96,000+ STUDS / 26.8 KM OFFICIAL NETWORK)
    -- ═══════════════════════════════════════════════════════════════════
    local RoadData = {
        Loaded = false,
        Lanes = {},
        TotalPoints = 0,
        TotalLength = 0,
        CumDist = {}
    }

    local function loadRoadNetwork()
        if RoadData.Loaded and #RoadData.Lanes > 0 then return true end
        
        local remote = NetFolder and NetFolder:FindFirstChild("RF/PoliceRoadLanes")
        if not remote then
            local pkgs = ReplicatedStorage:FindFirstChild("Packages")
            local r = pkgs and pkgs:FindFirstChild("Remotes")
            local net = r and r:FindFirstChild("Networking")
            remote = net and net:FindFirstChild("RF/PoliceRoadLanes")
        end

        if remote then
            local ok, lanes = pcall(function() return remote:InvokeServer() end)
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
                print(string.format("[GhostDriver] Road Network loaded: %d points, %.1f studs (%.2f KM)", RoadData.TotalPoints, totalDist, totalDist * 0.28 / 1000))
                return true
            end
        end
        return false
    end

    -- Helper: Find nearest road segment, projection, and road orientation vectors
    local function findRoadFrame(currentPos, hintIdx)
        if not RoadData.Loaded then
            if not loadRoadNetwork() then return nil end
        end

        local l2 = RoadData.Lanes[2]
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

        -- Fast Localized Window Search (±6 segments around hintIdx for 90% CPU reduction)
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

        -- Full Scan Fallback (only on initial start, respawn, or large teleport)
        if not usedLocal then
            bestDistSq = 1e12
            for i = 1, total do
                evaluateSegment(i)
            end
        end

        local flatDir = Vector3.new(bestDir.X, 0, bestDir.Z)
        if flatDir.Magnitude > 0.001 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, -1) end
        local roadNormal = Vector3.new(-flatDir.Z, 0, flatDir.X) -- Perpendicular to Right lane
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

    -- Loop 5: Grand Loop 96,000+ Studs Auto Farm & Dynamic Obstacle Evasion
    task.spawn(function()

        local currentWaypointIdx = 1
        local currentLaneOffset = 0 -- 0 = Center, +13.5 = Right, -13.5 = Left
        local lastStreamIdx = -1
        local loopDistanceTraveled = 0
        local lastPos = nil
        local stuckTicks = 0
        local lastCloseCallTick = 0
        local lastRespawnTick = 0
        local lastNitroTick = 0
        local wasDriving = false

        while _G.GhostDriverRunning and _G.GhostDriverActiveToken == myToken do
            if Settings.AutoDriveFarm then
                wasDriving = true
                safe(function()
                    -- 1. Ensure car exists
                    local car = getPlayerCar()
                    if not car then
                        if Remote_SpawnCar then
                            Remote_SpawnCar:FireServer(Settings.SelectedCar or "Wulfbrecht RZ7")
                            task.wait(1.5)
                            car = getPlayerCar()
                        end
                    end

                    if not car then return end

                    local seat = getDriveSeat()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if not seat or not hum then return end

                    -- 2. Ensure player is seated
                    if seat.Occupant ~= hum then
                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0) end
                        seat:Sit(hum)
                        task.wait(0.2)
                    end

                    local currentPos = seat.Position

                    -- Track distance traveled & check stuck state
                    if lastPos then
                        local stepDist = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(lastPos.X, 0, lastPos.Z)).Magnitude
                        if stepDist < 200 then
                            loopDistanceTraveled = loopDistanceTraveled + stepDist
                        end
                        if stepDist < 1.0 then
                            stuckTicks = stuckTicks + 1
                        else
                            stuckTicks = 0
                        end
                    end
                    lastPos = currentPos

                    -- 3. Resolve Current Road Position on Official 96,000 Studs Track
                    local frame = findRoadFrame(currentPos, currentWaypointIdx)
                    if not frame then
                        task.wait(0.5)
                        return
                    end

                    currentWaypointIdx = frame.Index

                    -- Proactive World Streaming Ahead (Prevents any void falling!)
                    if LocalPlayer.RequestStreamAroundAsync and math.abs(frame.Index - lastStreamIdx) >= 4 then
                        lastStreamIdx = frame.Index
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

                    -- Fallback / Off-track & Anti-Void / Anti-Flip Recovery
                    local distY = currentPos.Y - frame.CenterPos.Y
                    local curPivot = car:GetPivot()
                    local isFlipped = curPivot.UpVector.Y < 0.65 or seat.CFrame.UpVector.Y < 0.65
                    local isFalling = distY < -6.0 or distY > 35.0
                    local isOffTrack = frame.DistanceToCenter > 85.0

                    if isFlipped or isFalling or isOffTrack or stuckTicks >= 15 then
                        stuckTicks = 0
                        local safePt = frame.CenterPos + (frame.Normal * currentLaneOffset) + Vector3.new(0, 3.2, 0)
                        if LocalPlayer.RequestStreamAroundAsync then
                            LocalPlayer:RequestStreamAroundAsync(safePt, 2)
                            task.wait(0.04)
                        end
                        local flatDir = Vector3.new(frame.Direction.X, 0, frame.Direction.Z)
                        if flatDir.Magnitude < 0.001 then flatDir = Vector3.new(0, 0, -1) else flatDir = flatDir.Unit end
                        seat.AssemblyLinearVelocity = flatDir * 100
                        seat.AssemblyAngularVelocity = Vector3.zero
                        car:PivotTo(CFrame.lookAt(safePt, safePt + flatDir))
                        task.wait(0.12)
                        return
                    end

                    -- Gentle ground settling (only if floating well above road, never force through surface)
                    if distY > 4.5 then
                        seat.AssemblyLinearVelocity = Vector3.new(seat.AssemblyLinearVelocity.X, -6, seat.AssemblyLinearVelocity.Z)
                    end

                    -- Unlock A-Chassis parking brakes & unanchor parts if vehicle was frozen
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
                    end

                    -- Proactive Car & Character Body Ghosting (Preserves Wheels so car never falls through the road!)
                    if Settings.GhostGodMode or Settings.AutoDriveFarm then
                        for _, p in ipairs(car:GetDescendants()) do
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

                    -- 4. Intelligent Radar & 3-Lane Dynamic Obstacle Evasion Engine
                    local rightDist = 9999
                    local centerDist = 9999
                    local leftDist = 9999
                    local currentLaneObstacleDist = 9999
                    local nearestObsDist = 9999
                    local nearestObsLateral = 0

                    local CAR_HALF_WIDTH = 4.5
                    local SAFETY_MARGIN = 5.5 -- Effective avoidance radius: 10 studs from obstacle center
                    local RADAR_MAX_DIST = 850.0 -- Extended radar for high-speed oncoming traffic

                    -- Vehicle's actual current lateral offset on highway from centerline
                    local carVecFromCenter = currentPos - frame.CenterPos
                    local carCurrentRoadOffset = carVecFromCenter:Dot(frame.Normal)

                    local function checkObstacle(obj)
                        if not obj or obj == car or obj == LocalPlayer.Character then return end
                        local p = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChild("Body") or obj:FindFirstChild("CoreHitbox") or obj:FindFirstChildWhichIsA("BasePart")
                        if p then
                            local toObs = p.Position - currentPos
                            local forwardDist = toObs:Dot(frame.Direction)

                            if forwardDist > -20 and forwardDist < RADAR_MAX_DIST then
                                -- True absolute lateral lane offset relative to highway centerline (Lane 2 = 0.0)
                                local obsVecFromCenter = p.Position - frame.CenterPos
                                local obsLaneOffset = obsVecFromCenter:Dot(frame.Normal)

                                -- Track global nearest obstacle
                                if forwardDist < nearestObsDist then
                                    nearestObsDist = forwardDist
                                    nearestObsLateral = obsLaneOffset
                                end

                                -- Obstacle directly in path of current vehicle position or target lane
                                local lateralDiffToCar = math.abs(obsLaneOffset - carCurrentRoadOffset)
                                local lateralDiffToTarget = math.abs(obsLaneOffset - currentLaneOffset)
                                if (lateralDiffToCar < (CAR_HALF_WIDTH + SAFETY_MARGIN)) or (lateralDiffToTarget < (CAR_HALF_WIDTH + SAFETY_MARGIN)) then
                                    if forwardDist > 0 and forwardDist < currentLaneObstacleDist then
                                        currentLaneObstacleDist = forwardDist
                                    end
                                end

                                -- Proactive collision nullifier on obstacle when in proximity
                                if forwardDist < 250 and (lateralDiffToCar < 20 or lateralDiffToTarget < 20) then
                                    if p.CanCollide then p.CanCollide = false end
                                    for _, part in ipairs(obj:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            if part.CanCollide then part.CanCollide = false end
                                            part.CollisionGroup = "TrafficBox"
                                        end
                                    end
                                end

                                -- Trigger close call points when passing near traffic
                                if Settings.AutoSwerveCloseCall and Remote_TrafficSwerve and forwardDist > 0 and forwardDist < 45 and lateralDiffToCar < 18 then
                                    if tick() - lastCloseCallTick > 0.35 then
                                        lastCloseCallTick = tick()
                                        pcall(function()
                                            local swerveSide = (obsLaneOffset > carCurrentRoadOffset) and "Left" or "Right"
                                            Remote_TrafficSwerve:FireServer(obj, swerveSide)
                                        end)
                                    end
                                end

                                -- Independent 3-Lane Obstruction Checks (Handles multi-lane straddling AI cars)
                                local blockRadius = CAR_HALF_WIDTH + SAFETY_MARGIN -- 10 studs
                                -- Left Lane (-13.5 studs)
                                if math.abs(obsLaneOffset - (-13.5)) < blockRadius then
                                    if forwardDist < leftDist then leftDist = forwardDist end
                                end
                                -- Center Lane (0.0 studs)
                                if math.abs(obsLaneOffset - 0.0) < blockRadius then
                                    if forwardDist < centerDist then centerDist = forwardDist end
                                end
                                -- Right Lane (+13.5 studs)
                                if math.abs(obsLaneOffset - 13.5) < blockRadius then
                                    if forwardDist < rightDist then rightDist = forwardDist end
                                end
                            end
                        end
                    end

                    -- Scan AI Traffic Folders
                    for _, folderName in ipairs({"TrafficFolder", "TrafficBoxes", "more tarffic", "PoliceWalls", "Cars"}) do
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
                            if m:FindFirstChildWhichIsA("VehicleSeat", true) or m.Name:find("_") or m.Name:lower():find("police") then
                                checkObstacle(m)
                            end
                        end
                    end

                    -- Lane Selection Decision: Center Lane is Primary Base Lane
                    local SAFE_DISTANCE = 650 -- Proactive safe distance to react well in advance
                    local baseLaneOffset = 0.0
                    if Settings.FarmLane and (Settings.FarmLane:find("Left") or Settings.FarmLane:find("Lane 1")) then
                        baseLaneOffset = -13.5
                    elseif Settings.FarmLane and (Settings.FarmLane:find("Right") or Settings.FarmLane:find("Lane 3")) then
                        baseLaneOffset = 13.5
                    end

                    local targetLaneOffset = baseLaneOffset
                    local baseDist = (baseLaneOffset == 0.0) and centerDist or ((baseLaneOffset < 0) and leftDist or rightDist)

                    -- 1. If Base Lane is Clear -> Drive Base Lane
                    if baseDist >= SAFE_DISTANCE then
                        targetLaneOffset = baseLaneOffset
                    else
                        -- 2. Base Lane is Blocked -> Evaluate Left, Center, and Right Openings
                        local leftClear = (leftDist >= SAFE_DISTANCE)
                        local centerClear = (centerDist >= SAFE_DISTANCE)
                        local rightClear = (rightDist >= SAFE_DISTANCE)

                        if centerClear and baseLaneOffset ~= 0.0 then
                            targetLaneOffset = 0.0
                        elseif rightClear and leftClear then
                            if currentLaneOffset < -2.0 then
                                targetLaneOffset = -13.5
                            elseif currentLaneOffset > 2.0 then
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
                            -- Heavy Traffic Congestion: pick lane with greatest open room ahead
                            if centerDist >= leftDist and centerDist >= rightDist then
                                targetLaneOffset = 0.0
                            elseif rightDist >= leftDist and rightDist >= centerDist then
                                targetLaneOffset = 13.5
                            else
                                targetLaneOffset = -13.5
                            end
                        end
                    end

                    -- Decisive Lateral Pull: Swift & Crisp Evasion (Scaled for 60 FPS Heartbeat)
                    local offsetDiff = targetLaneOffset - currentLaneOffset
                    local isDodging = (math.abs(offsetDiff) > 0.8) or (currentLaneObstacleDist < 350)
                    if math.abs(offsetDiff) > 0.03 then
                        local pullUrgency = 0.28
                        local maxStep = 2.0
                        if currentLaneObstacleDist < 300 or math.abs(offsetDiff) > 4.0 then
                            pullUrgency = 0.50
                            maxStep = 3.8
                        end
                        local step = math.clamp(offsetDiff * pullUrgency, -maxStep, maxStep)
                        currentLaneOffset = currentLaneOffset + step
                    end

                    -- Instant Stuck / Wedging Recovery
                    local curSpeedMag = seat.AssemblyLinearVelocity.Magnitude
                    if lastPos and (currentPos - lastPos).Magnitude < 1.2 and curSpeedMag < 20 then
                        stuckTicks = stuckTicks + 1
                    else
                        stuckTicks = 0
                    end
                    if stuckTicks >= 6 then
                        stuckTicks = 0
                        local unstuckPos = frame.CenterPos + (frame.Direction * 35) + (frame.Normal * targetLaneOffset) + Vector3.new(0, 3.0, 0)
                        car:PivotTo(CFrame.lookAt(unstuckPos, unstuckPos + frame.Direction))
                        seat.AssemblyLinearVelocity = frame.Direction * 160
                        seat.AssemblyAngularVelocity = Vector3.zero
                        task.wait(0.08)
                        return
                    end

                    -- 5. Route Distance & Reset Check
                    local maxAllowedDist = RoadData.TotalLength * (Settings.FarmPercent or 1.0)
                    if not Settings.LoopMode:find("Infinite") and loopDistanceTraveled >= maxAllowedDist then
                        loopDistanceTraveled = 0
                        -- Bank combo
                        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
                        local comboUI = pgui and pgui:FindFirstChild("InGameHUD") and pgui.InGameHUD:FindFirstChild("ComboUI")
                        if comboUI then
                            local closeBtn = comboUI:FindFirstChild("Close", true)
                            if closeBtn and closeBtn.Visible and firesignal then firesignal(closeBtn.MouseButton1Click) end
                            local reviveBtn = comboUI:FindFirstChild("Revive", true)
                            if reviveBtn and reviveBtn.Visible and firesignal then firesignal(reviveBtn.MouseButton1Click) end
                        end

                        -- Reset to Highway Start (Z = -957)
                        local startPos = Vector3.new(-3498.0, 63.2, -957.0)
                        if LocalPlayer.RequestStreamAroundAsync then
                            LocalPlayer:RequestStreamAroundAsync(startPos, 2)
                            task.wait(0.2)
                        end
                        seat.AssemblyLinearVelocity = Vector3.zero
                        seat.AssemblyAngularVelocity = Vector3.zero
                        car:PivotTo(CFrame.lookAt(startPos, startPos + Vector3.new(0, 0, -10)))
                        currentLaneOffset = 0
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
                    local speedMPH = math.clamp(Settings.FarmDriveSpeed or 170, 80, 240)
                    local forwardSpeed = math.min(speedMPH * 1.467, maxAllowedStuds)

                    -- Anti-Plow Speed Cushioning during urgent lateral swerve
                    if currentLaneObstacleDist < 200 and math.abs(offsetDiff) > 0.8 then
                        forwardSpeed = forwardSpeed * 0.65
                    end

                    -- ─── Predictive Curvature & Adaptive Cornering Engine ───
                    local curveAngleDeg = 0
                    local aheadIdx = ((frame.Index + 2) % RoadData.TotalPoints) + 1
                    local aheadPt = RoadData.Lanes[2][aheadIdx]
                    if aheadPt then
                        local aheadVec = Vector3.new(aheadPt[1] - frame.CenterPos.X, 0, aheadPt[3] - frame.CenterPos.Z).Unit
                        local currentDirFlat = Vector3.new(frame.Direction.X, 0, frame.Direction.Z).Unit
                        local dotVal = math.clamp(currentDirFlat:Dot(aheadVec), -1, 1)
                        curveAngleDeg = math.deg(math.acos(dotVal))
                    end

                    -- Dynamic Corner Slowdown when encountering sharp turns
                    if Settings.CornerSlowdown and curveAngleDeg > 22 then
                        local slowdownFactor = math.clamp(1.0 - ((curveAngleDeg - 22) / 60), 0.55, 0.95)
                        forwardSpeed = forwardSpeed * slowdownFactor
                    end

                    -- Dynamic lookahead lead based on speed & curvature
                    local dynamicLead = Settings.LookaheadLead or 38
                    local baseLookahead = math.clamp(forwardSpeed * 0.18, dynamicLead * 0.7, dynamicLead * 1.4)
                    local lookaheadDist = isDodging and math.clamp(baseLookahead * 0.55, 14, 26) or baseLookahead
                    local aimLateral = currentLaneOffset
                    if isDodging then
                        aimLateral = (currentLaneOffset * 0.35) + (targetLaneOffset * 0.65)
                    end

                    local targetPathPos = frame.CenterPos + (frame.Direction * lookaheadDist) + (frame.Normal * aimLateral)
                    local roadY = frame.CenterPos.Y + 1.8
                    targetPathPos = Vector3.new(targetPathPos.X, roadY, targetPathPos.Z)

                    local moveVec = targetPathPos - currentPos
                    local flatMoveVec = Vector3.new(moveVec.X, 0, moveVec.Z)
                    local moveDir = flatMoveVec.Magnitude > 0.01 and flatMoveVec.Unit or Vector3.new(frame.Direction.X, 0, frame.Direction.Z).Unit

                    -- Apply Velocity directly to VehicleSeat (Smooth Horizontal Propulsion)
                    local curYVel = math.clamp(seat.AssemblyLinearVelocity.Y, -10, 10)
                    seat.AssemblyLinearVelocity = Vector3.new(moveDir.X * forwardSpeed, curYVel, moveDir.Z * forwardSpeed)
                    seat.AssemblyAngularVelocity = Vector3.zero

                    -- Vehicle Heading & Smooth Steering
                    local curPivot = car:GetPivot()
                    local flatLook = Vector3.new(curPivot.LookVector.X, 0, curPivot.LookVector.Z)
                    local flatDir = Vector3.new(frame.Direction.X, 0, frame.Direction.Z)
                    if flatLook.Magnitude > 0.001 then flatLook = flatLook.Unit else flatLook = Vector3.new(0, 0, -1) end
                    if flatDir.Magnitude > 0.001 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, -1) end

                    local targetHeading = Vector3.new(moveDir.X, 0, moveDir.Z)
                    if targetHeading.Magnitude > 0.001 then targetHeading = targetHeading.Unit else targetHeading = flatDir end
                    local headingAlignment = flatLook:Dot(targetHeading)

                    if headingAlignment < 0.65 or curPivot.UpVector.Y < 0.70 or math.abs(currentPos.Y - frame.CenterPos.Y) > 8.0 then
                        -- Re-align instantly onto road surface if vehicle spins out
                        local uprightPos = Vector3.new(currentPos.X, frame.CenterPos.Y + 3.2, currentPos.Z)
                        car:PivotTo(CFrame.lookAt(uprightPos, uprightPos + targetHeading))
                        seat.AssemblyAngularVelocity = Vector3.zero
                        seat.AssemblyLinearVelocity = targetHeading * forwardSpeed
                    else
                        -- Pure horizontal yaw rotation with Adaptive Smooth Factor & Subtle Corner Banking
                        local steerFactor = math.clamp(Settings.SmoothSteerFactor or 0.22, 0.12, 0.45)
                        local rollAngle = 0
                        if Settings.AdaptiveCornering and curveAngleDeg > 8 then
                            local cross = currentDirFlat:Cross(aheadVec)
                            local turnSide = (cross.Y > 0) and 1 or -1
                            rollAngle = math.clamp(math.rad(turnSide * (curveAngleDeg * 0.08)), math.rad(-3), math.rad(3))
                        end

                        local targetRot = CFrame.lookAt(seat.Position, seat.Position + targetHeading) * CFrame.Angles(0, 0, -rollAngle)
                        seat.CFrame = seat.CFrame:Lerp(targetRot, steerFactor)
                    end

                    seat.Throttle = 1
                    seat.ThrottleFloat = 1
                    seat.SteerFloat = 0

                    -- Controlled Nitrous injection (only when enabled, throttled to prevent spam kicks)
                    if Settings.InfiniteNitrous and Remote_Nitrous and (tick() - lastNitroTick > 2.0) then
                        lastNitroTick = tick()
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
                    Telemetry.TotalDistance = math.floor(loopDistanceTraveled)
                    Telemetry.CurrentWaypoint = frame.Index
                    local laneName = "Center"
                    if currentLaneOffset > 5 then laneName = "Right" elseif currentLaneOffset < -5 then laneName = "Left" end
                    Telemetry.StatusText = string.format("Cruising %d MPH | Lane %s", Telemetry.SpeedMPH, laneName)
                end)
                RunService.Heartbeat:Wait()
            else
                if wasDriving then
                    wasDriving = false
                    safe(function()
                        local seat = getDriveSeat()
                        if seat then
                            seat.AssemblyLinearVelocity = Vector3.zero
                            seat.AssemblyAngularVelocity = Vector3.zero
                            seat.Throttle = 0
                            seat.ThrottleFloat = 0
                            seat.SteerFloat = 0
                        end
                        local car = getPlayerCar()
                        if car then
                            local vals = car:FindFirstChild("Values")
                            if vals then
                                local pb = vals:FindFirstChild("PBrake") or vals:FindFirstChild("Handbrake")
                                if pb and pb:IsA("BoolValue") then pb.Value = true end
                            end
                        end
                    end)
                end
                task.wait(0.2)
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
