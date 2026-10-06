local HttpService = game:GetService("HttpService")
-- ╔══════════════════════════════════════════════════════════════════╗
-- ║   💎 PROJECT BARUN — LOOT TO FORGE GOD FARM HUB v3 MASTER        ║
-- ║   Reverse-Engineered & Enhanced with Project Barun (PB) Engine   ║
-- ║   Developed by cook45 for clack with Mimi Engine                ║
-- ╚══════════════════════════════════════════════════════════════════╝

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
    local TitleText    = config.Name or config.Title or "PROJECT BARUN | Loot To Forge"
    local SubtitleText = config.Subtitle or "PB FORGE ENGINE • v3.0"
    local WindowSize   = config.Size or UDim2.new(0, 720, 0, 480)
    local ParentTarget = (gethui and gethui()) or CoreGui

    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == "ProjectBarunForge" or existing.Name == "Orion" then
            pcall(function() existing:Destroy() end)
        end
    end

    local ScreenGui = make("ScreenGui", {
        Name = "ProjectBarunForge",
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

    local LogoBeacon = make("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 20, 0, 24),
        BackgroundColor3 = Theme.AccentCyan,
        Parent = TopBar
    }, {
        make("UICorner", { CornerRadius = UDim.new(1, 0) }),
        make("UIStroke", { Color = Theme.AccentPrimary, Thickness = 2, Transparency = 0.3 })
    })

    task.spawn(function()
        while ScreenGui.Parent do
            tw(LogoBeacon, { BackgroundColor3 = Theme.AccentPrimary }, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
            tw(LogoBeacon, { BackgroundColor3 = Theme.AccentCyan }, 1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.2)
        end
    end)

    make("TextLabel", {
        Text = TitleText,
        Font = Theme.FontTitle,
        TextSize = 16,
        TextColor3 = Theme.TextTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 38, 0, 12),
        Size = UDim2.new(0, 280, 0, 18),
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    make("TextLabel", {
        Text = string.upper(SubtitleText),
        Font = Theme.FontBold,
        TextSize = 9,
        TextColor3 = Theme.AccentCyan,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 38, 0, 32),
        Size = UDim2.new(0, 280, 0, 14),
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
        Size = UDim2.new(0, 48, 0, 48),
        Position = UDim2.new(0, 24, 0, 120),
        BackgroundColor3 = Color3.fromRGB(15, 17, 26),
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 100,
        Parent = ScreenGui
    }, {
        make("UICorner", { CornerRadius = UDim.new(1, 0) }),
        make("UIStroke", { Color = Theme.AccentCyan, Thickness = 2, Transparency = 0.2 }),
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(24, 28, 42)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(11, 13, 19))
            }),
            Rotation = 45
        }),
        make("TextLabel", {
            Text = "PB",
            Font = Theme.FontTitle,
            TextSize = 16,
            TextColor3 = Theme.AccentCyan,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 101
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
            tw(FloatingBadge, { Size = UDim2.new(0, 48, 0, 48) }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
        if TabIcon:find("rbxassetid") then TabIcon = "⚡" end

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
                tw(t.Button.GlowIndicator, { Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0) }, 0.2)
            end
            TabPage.Visible = true
            tw(TabBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.CardBg }, 0.25)
            TabBtn.Label.TextColor3 = Theme.TextTitle
            TabBtn.Icon.TextColor3 = Theme.AccentCyan
            tw(TabBtn.GlowIndicator, { Size = UDim2.new(0, 3, 0, 22), Position = UDim2.new(0, 0, 0.5, -11) }, 0.25)
            WindowObj.CurrentTab = TabObj
        end

        TabBtn.MouseButton1Click:Connect(activateTab)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                tw(TabBtn, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.CardHover }, 0.15)
                TabBtn.Label.TextColor3 = Theme.TextBody
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                tw(TabBtn, { BackgroundTransparency = 1 }, 0.15)
                TabBtn.Label.TextColor3 = Theme.TextDim
            end
        end)

        if #WindowObj.Tabs == 0 then
            activateTab()
        end
        table.insert(WindowObj.Tabs, TabObj)

        function TabObj:AddSection(secTitle)
            if type(secTitle) == "table" and secTitle.Name then
                secTitle = secTitle.Name
            end
            local SecFrame = make("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabPage
            }, {
                make("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, -1),
                    BackgroundColor3 = Theme.CardBorder,
                    BackgroundTransparency = 0.6
                }),
                make("TextLabel", {
                    Text = string.upper(tostring(secTitle)),
                    Font = Theme.FontTitle,
                    TextSize = 11,
                    TextColor3 = Theme.AccentPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 1, -2),
                    BackgroundTransparency = 1
                })
            })
            return SecFrame
        end

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

        function TabObj:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local name      = btnConfig.Name or "Button"
            local callback  = btnConfig.Callback or function() end

            local Btn = make("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.CardBg,
                AutoButtonColor = false,
                Text = "",
                Parent = TabPage
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                make("UIStroke", { Name = "BtnStroke", Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                make("TextLabel", {
                    Text = "⚡",
                    Font = Theme.FontBold,
                    TextSize = 13,
                    Position = UDim2.new(0, 16, 0.5, -10),
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
                    Position = UDim2.new(0, 42, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1
                })
            })

            Btn.MouseButton1Click:Connect(function()
                tw(Btn, { BackgroundColor3 = Theme.CardHover }, 0.1)
                task.wait(0.08)
                tw(Btn, { BackgroundColor3 = Theme.CardBg }, 0.18)
                task.spawn(callback)
            end)
        end

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

-- ─── Settings / Configuration ─────────────────────────────────────
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
    ForgeType            = "All", -- "Weapon" | "Armor" | "Hat" | "All" (หมุนเวียน 3 ชิ้น)
    MinOreToForge        = 4,     -- เกมนี้ต้องการขั้นต่ำ 4 แร่
    ForgeDelay           = 0.6,
    OreQualityMode       = "Best", -- "Best" (แร่เกรดสูงก่อน) | "Low" (แร่เกรดต่ำก่อน)
    AutoEquipBestAfter   = false,

    -- Auto Equip Best Gear
    AutoEquipBest        = false,

    -- Enhance & Safe Sell
    AutoEnhance          = false,
    UseProtect           = false,
    AutoSellTrashGear    = false, -- ขายเฉพาะขยะอาวุธ/เกราะ/หมวก ไม่แตะต้องแร่เด็ดขาด

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

-- ─── Services & Remotes ───────────────────────────────────────────
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer       = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Remote            = ReplicatedStorage:WaitForChild("Remote", 10)
local function R(folder, name)
    local f = Remote and Remote:FindFirstChild(folder)
    return f and f:FindFirstChild(name)
end

-- Remotes setup
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

-- Bindables for Instant Silent Kill
local Bindable_EnemyHit   = Remote and Remote:FindFirstChild("Attack") and Remote.Attack:FindFirstChild("EnemyHitBE")

-- Internal Controllers & Modules
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
-- 1. GAMEPASS BYPASS INJECTOR (SkipForge, VIP, MoreOre, UltraLuck)
-- ═══════════════════════════════════════════════════════════════════
local GamePassMap = {
    [1962630901] = "VIP",           -- VIP (x2 Coins, x2 EXP)
    [1963566878] = "SuperLuck",     -- Super Luck (x200% Luck)
    [1965960643] = "CommonLuck",    -- Common Luck (x150% Luck)
    [1963764856] = "MoreOre",       -- More Ore (x200% Ore Drop)
    [1982474360] = "UltraLuck",     -- Ultra Luck (x500% Luck)
    [1962564854] = "SkipForge",     -- Skip Forge (หลอมทันทีไม่ต้องรอ)
}

local function applyGamePassBypass()
    -- Inject flags into Pem store
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

    -- Hook __namecall to fake ownership
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
-- 2. BACKPACK SANITIZER (Prevents in-game ForgeGUI Line 508 Crash)
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
                    -- Fix enhancement stones miscategorized as Type="Ore"
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
-- 3. SMART FORGE ENGINE (Extracted from 2SKI Architecture)
-- ═══════════════════════════════════════════════════════════════════
local forgeCycleIndex = 1

local function executeForgeNow(forgeType, minOres)
    if not ForgeRF then return false, "No Forge Remote" end
    local have = getBackpackData()
    forgeType = forgeType or Settings.ForgeType or "All"
    minOres = minOres or Settings.MinOreToForge or 4

    -- 1. Gather all real string-ID ores
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

    -- 2. Sort ores based on user preference
    if Settings.OreQualityMode == "Best" then
        table.sort(oreEntries, function(a, b) return a.power > b.power end)
    else
        table.sort(oreEntries, function(a, b) return a.power < b.power end)
    end

    -- 3. Determine actual slot and serverConfigType
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
        targetOreCount = math.clamp(totalOres, 4, 13) -- 13 ores = 100% Greatsword
    elseif actualSlot == "Hat" then
        serverConfigType = "Armor" -- Game server categorizes Hat under "Armor"
        targetOreCount = (totalOres >= 16) and 16 or 4
    elseif actualSlot == "Armor" then
        serverConfigType = "Armor"
        if totalOres >= 23 then
            targetOreCount = 23 -- 100% Heavy Armor
        elseif totalOres >= 11 then
            targetOreCount = 11 -- 80% Light Armor
        else
            targetOreCount = math.clamp(totalOres, 4, 11)
        end
    end

    -- 4. Slice required ores into dictionary
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

    -- 5. Invoke Forge with exact parameters
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
-- 4. AUTO EQUIP BEST GEAR
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
-- 5. TRAIN MULTIPLIER ZONES CONFIG
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
-- 6. ORION UI WINDOW SETUP
-- ═══════════════════════════════════════════════════════════════════
local Window = OrionLib:MakeWindow({
    Name = "PROJECT BARUN | Loot To Forge",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "ProjectBarunForge"
})

local TabFarming = Window:MakeTab({ Name = "Farming & Stage", Icon = "rbxassetid://4483345998" })
local TabForge   = Window:MakeTab({ Name = "Forge & Gear",    Icon = "rbxassetid://4483345998" })
local TabCombat  = Window:MakeTab({ Name = "Combat & Train",  Icon = "rbxassetid://4483345998" })
local TabMisc    = Window:MakeTab({ Name = "Misc & Upgrades", Icon = "rbxassetid://4483345998" })
local TabConfig  = Window:MakeTab({ Name = "Settings & Save",  Icon = "rbxassetid://4483345998" })

-- ─── Tab: Farming & Stage ─────────────────────────────────────────
TabFarming:AddSection({ Name = "Stage Automation" })

TabFarming:AddToggle({
    Name = "Auto Stage & Claim Ore",
    Default = Settings.AutoStageOre,
    Callback = function(Value) Settings.AutoStageOre = Value end
})

TabFarming:AddToggle({
    Name = "Auto Max Stage (ลุยด่านสูงสุดอัตโนมัติ)",
    Default = Settings.AutoMaxStage,
    Callback = function(Value) Settings.AutoMaxStage = Value end
})

TabFarming:AddTextbox({
    Name = "Specific Stage Name",
    Default = Settings.StageName,
    TextDisappear = false,
    Callback = function(Value) Settings.StageName = Value end
})

TabFarming:AddToggle({
    Name = "Silent Insta-Kill Mobs (สังหารม็อบในสเตจทันที)",
    Default = Settings.SilentKillMobs,
    Callback = function(Value) Settings.SilentKillMobs = Value end
})

TabFarming:AddSlider({
    Name = "Stage Delay",
    Min = 0.15, Max = 2.0, Default = Settings.StageDelay, Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.05, ValueName = "sec",
    Callback = function(Value) Settings.StageDelay = Value end
})

-- ─── Tab: Forge & Gear ───────────────────────────────────────────
TabForge:AddSection({ Name = "PROJECT BARUN Smart Forge Engine" })

TabForge:AddToggle({
    Name = "Auto Forge (หลอมอัตโนมัติ)",
    Default = Settings.AutoForge,
    Callback = function(Value) Settings.AutoForge = Value end
})

TabForge:AddDropdown({
    Name = "Forge Mode",
    Default = "All",
    Options = {"All", "Weapon", "Armor", "Hat"},
    Callback = function(Value) Settings.ForgeType = Value end
})

TabForge:AddDropdown({
    Name = "Ore Quality Priority",
    Default = "Best",
    Options = {"Best", "Low"},
    Callback = function(Value) Settings.OreQualityMode = Value end
})

TabForge:AddSlider({
    Name = "Min Ores To Forge (เกมนี้ต้องการขั้นต่ำ 4)",
    Min = 4, Max = 23, Default = Settings.MinOreToForge, Color = Color3.fromRGB(255, 255, 255),
    Increment = 1, ValueName = "ores",
    Callback = function(Value) Settings.MinOreToForge = Value end
})

TabForge:AddSlider({
    Name = "Forge Loop Delay",
    Min = 0.2, Max = 2.0, Default = Settings.ForgeDelay, Color = Color3.fromRGB(255, 255, 255),
    Increment = 0.1, ValueName = "sec",
    Callback = function(Value) Settings.ForgeDelay = Value end
})

TabForge:AddSection({ Name = "Gear Management" })

TabForge:AddButton({
    Name = "Equip Best Gear Now (สวมใส่อุปกรณ์ที่ดีที่สุดทันที)",
    Callback = function() equipBestGearNow("All") end
})

TabForge:AddToggle({
    Name = "Auto Equip Best After Forge",
    Default = Settings.AutoEquipBestAfter,
    Callback = function(Value) Settings.AutoEquipBestAfter = Value end
})

TabForge:AddToggle({
    Name = "Auto Enhance Equipped Weapon",
    Default = Settings.AutoEnhance,
    Callback = function(Value) Settings.AutoEnhance = Value end
})

TabForge:AddToggle({
    Name = "Use Protection Item (หินกันแตก)",
    Default = Settings.UseProtect,
    Callback = function(Value) Settings.UseProtect = Value end
})

TabForge:AddToggle({
    Name = "Auto Sell Trash Gear (ขายขยะอุปกรณ์ - ไม่แตะต้องแร่)",
    Default = Settings.AutoSellTrashGear,
    Callback = function(Value) Settings.AutoSellTrashGear = Value end
})

-- ─── Tab: Combat & Train ──────────────────────────────────────────
TabCombat:AddSection({ Name = "Training Automation" })

TabCombat:AddToggle({
    Name = "Auto Train (ฟันดาบเก็บพลัง)",
    Default = Settings.AutoTrain,
    Callback = function(Value) Settings.AutoTrain = Value end
})

TabCombat:AddToggle({
    Name = "Auto Best Multiplier Zone (ยืนแท่นคูณสูงสุดที่ปลดล็อค)",
    Default = Settings.AutoTrainBestZone,
    Callback = function(Value) Settings.AutoTrainBestZone = Value end
})

TabCombat:AddSlider({
    Name = "Manual Train Zone (1-8)",
    Min = 1, Max = 8, Default = Settings.TrainAreaIndex, Color = Color3.fromRGB(255, 255, 255),
    Increment = 1, ValueName = "Zone",
    Callback = function(Value) Settings.TrainAreaIndex = Value end
})

TabCombat:AddSection({ Name = "Boss & World Combat" })

TabCombat:AddToggle({
    Name = "Auto Attack Nearby Enemies",
    Default = Settings.AutoAttack,
    Callback = function(Value) Settings.AutoAttack = Value end
})

TabCombat:AddToggle({
    Name = "Auto SuperLoot Hunter",
    Default = Settings.AutoSuperLoot,
    Callback = function(Value) Settings.AutoSuperLoot = Value end
})

-- ─── Tab: Misc & Upgrades ─────────────────────────────────────────
TabMisc:AddSection({ Name = "Automation & Economy" })

TabMisc:AddToggle({
    Name = "Auto Claim All Rewards (Online, Update, Offline, Ticket)",
    Default = Settings.AutoClaimRewards,
    Callback = function(Value) Settings.AutoClaimRewards = Value end
})

TabMisc:AddToggle({
    Name = "Auto Upgrades (Train / OrePack / Luck)",
    Default = Settings.AutoUpgrade,
    Callback = function(Value) Settings.AutoUpgrade = Value end
})

TabMisc:AddToggle({
    Name = "Auto Rebirth (ขายขยะก่อนจุติอัตโนมัติ)",
    Default = Settings.AutoRebirth,
    Callback = function(Value) Settings.AutoRebirth = Value end
})

TabMisc:AddToggle({
    Name = "Auto Class Luck Roll",
    Default = Settings.AutoLuckRoll,
    Callback = function(Value) Settings.AutoLuckRoll = Value end
})

-- ═══════════════════════════════════════════════════════════════════

-- ═════════════════════════════════════════════════════════════════════
-- TAB: SETTINGS & CONFIGURATION PROFILES (SAVE & LOAD)
-- ═════════════════════════════════════════════════════════════════════
local CONFIG_FILE = "PB_LootToForge_Config.json"

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

TabConfig:AddSection({ Name = "💾 Configuration Profiles" })

local currentProfile = "default"

TabConfig:AddTextbox({
    Name = "Profile Name (ชื่อคอนฟิก)",
    Default = "default",
    TextDisappear = false,
    Callback = function(val)
        currentProfile = (val and val:gsub("%s+", "") ~= "") and val:gsub("%s+", "") or "default"
    end
})

TabConfig:AddButton({
    Name = "💾 Save Config (บันทึกคอนฟิก)",
    Callback = function()
        local ok, path = ConfigManager.Save(currentProfile)
        if ok then
            OrionLib:MakeNotification({
                Name = "Config Saved",
                Content = "บันทึกการตั้งค่าลงไฟล์ " .. currentProfile .. " สำเร็จ!",
                Time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "Save Failed",
                Content = tostring(path),
                Time = 4
            })
        end
    end
})

TabConfig:AddButton({
    Name = "📂 Load Config (โหลดคอนฟิก)",
    Callback = function()
        local ok, path = ConfigManager.Load(currentProfile)
        if ok then
            OrionLib:MakeNotification({
                Name = "Config Loaded",
                Content = "โหลดการตั้งค่าจากไฟล์ " .. currentProfile .. " เรียบร้อย!",
                Time = 4
            })
        else
            OrionLib:MakeNotification({
                Name = "Load Failed",
                Content = tostring(path),
                Time = 4
            })
        end
    end
})

-- 7. EXECUTION THREADS
-- ═══════════════════════════════════════════════════════════════════

-- Thread 1: Auto Train & Best Multiplier Zone
task.spawn(function()
    while true do
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
    while true do
        if Settings.AutoStageOre and StageRF_Finish then
            safe(function()
                -- 1. Determine Stage
                local stageId = Settings.StageName
                if Settings.AutoMaxStage then
                    pcall(function()
                        local ProfileData = require(ReplicatedStorage.ProfileData)
                        local pd = ProfileData and ProfileData.GetTotalData()
                        local pass = pd and pd.Stats and pd.Stats.StagePass or 0
                        stageId = "Stage_" .. tostring(math.clamp(pass + 1, 1, 27))
                    end)
                end

                -- 2. Clear Stage on Server & Claim Loot
                local ok, loot = pcall(function() return StageRF_Finish:InvokeServer(stageId) end)
                if ok and type(loot) == "table" then
                    for oreKey in pairs(loot) do
                        if StageRF_GetOre then StageRF_GetOre:InvokeServer(oreKey) end
                    end
                    if StageRE_Claim then StageRE_Claim:FireServer() end
                end

                -- 3. Silent Insta-Kill Mobs in EnemyFolder
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
    while true do
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
    while true do
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
    while true do
        if Settings.AutoSellTrashGear and BackpackRE_SellItem then
            safe(function()
                local have = getBackpackData()
                for uuid, item in pairs(have) do
                    -- Sell only Weapons, Armors, Hats below top tier; NEVER sell ores or stones
                    if item.Type == "Weapon" or item.Type == "Armor" or item.Type == "Hat" then
                        local isEquipped = false
                        pcall(function()
                            if BackpackData and BackpackData.IsEquipedUUID then
                                isEquipped = BackpackData.IsEquipedUUID(uuid)
                            end
                        end)
                        if not isEquipped then
                            local score = calculateGearScore(item)
                            -- If gear score is low, sell it
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
    while true do
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
    while true do
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
    while true do
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
    while true do
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

OrionLib:Init()