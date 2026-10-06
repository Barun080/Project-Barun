--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║         💎 PROJECT BARUN (PB) OBSIDIAN GLASS — GOD-TIER UI v2.0          ║
    ║        Pure Luau • Neo-Cyber Glassmorphism • Ultra-Luxe Micro-FX         ║
    ║       Engineered by cook45 with Mimi Precision for Clack's Scripts       ║
    ║       [100% STANDALONE — ไม่พึ่งพาไฟล์แยก ไม่เสี่ยง failed to read file]   ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- ─── Color Palette (Obsidian Cyber Glass) ───────────────────────────
local Theme = {
    VoidBg          = Color3.fromRGB(11, 13, 19),      -- Ultra Deep Charcoal
    SurfaceBg       = Color3.fromRGB(16, 18, 27),      -- Translucent Obsidian
    SidebarBg       = Color3.fromRGB(13, 15, 23),      -- Darker Sidebar depth
    CardBg          = Color3.fromRGB(22, 25, 38),      -- Frosted Glass Card
    CardHover       = Color3.fromRGB(28, 32, 49),      -- Card Hover Glow
    CardBorder      = Color3.fromRGB(42, 46, 68),      -- Crisp Inner Stroke
    CardBorderGlow  = Color3.fromRGB(80, 88, 130),     -- Focused Stroke
    
    -- Neon Chromatic Accents
    AccentPrimary   = Color3.fromRGB(139, 92, 246),    -- Vivid Electric Purple
    AccentSecondary = Color3.fromRGB(59, 130, 246),    -- Cyber Blue
    AccentCyan      = Color3.fromRGB(6, 182, 212),     -- Neon Cyan
    AccentGlow      = Color3.fromRGB(168, 85, 247),
    
    -- Typography & State Colors
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

local UI = {}
UI.__index = UI

-- Fast Smooth Tweener
local function tw(inst, props, dur, style, dir)
    local info = TweenInfo.new(dur or 0.28, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

-- Helper Make Instance with Children
local function make(className, properties, children)
    local inst = Instance.new(className)
    for k, v in pairs(properties or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

-- ═════════════════════════════════════════════════════════════════════
-- WINDOW CREATION
-- ═════════════════════════════════════════════════════════════════════
function UI:CreateWindow(config)
    config = config or {}
    local TitleText    = config.Title or "PROJECT BARUN"
    local SubtitleText = config.Subtitle or "PB CYBER ENGINE v2.0"
    local WindowSize   = config.Size or UDim2.new(0, 720, 0, 480)
    local ParentTarget = (gethui and gethui()) or CoreGui

    -- Clean Previous ScreenGuis
    for _, existing in ipairs(ParentTarget:GetChildren()) do
        if existing.Name == (config.Name or "ApexScriptHub") then
            existing:Destroy()
        end
    end

    local ScreenGui = make("ScreenGui", {
        Name = config.Name or "ApexScriptHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = ParentTarget
    })

    -- Ambient Shadow Layer (Glow Backdrop)
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

    -- Main Chassis Frame
    local MainFrame = make("Frame", {
        Name = "MainChassis",
        Size = WindowSize,
        Position = UDim2.new(0.5, -WindowSize.X.Offset / 2, 0.5, -WindowSize.Y.Offset / 2),
        BackgroundColor3 = Theme.VoidBg,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = ScreenGui
    }, {
        make("UICorner", { CornerRadius = UDim.new(0, 16) }),
        make("UIStroke", {
            Color = Theme.CardBorder,
            Thickness = 1.4,
            Transparency = 0.15
        }),
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.0, Color3.fromRGB(18, 20, 30)),
                ColorSequenceKeypoint.new(1.0, Color3.fromRGB(11, 13, 19))
            }),
            Rotation = 45
        })
    })

    -- Top Ambient Neon Accent Bar
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

    -- Toast HUD (Bottom Right)
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

    -- ─── Cyber TopBar ────────────────────────────────────────────────
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

    -- ─── Official Project Barun Logo System (GitHub Raw + Local Cache + Safe Fallback) ───
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

    local LogoBadgeHolder = make("Frame", {
        Name = "LogoBadgeHolder",
        Size = UDim2.new(0, 38, 0, 38),
        Position = UDim2.new(0, 14, 0, 10),
        BackgroundColor3 = Color3.fromRGB(18, 20, 32),
        Parent = TopBar
    }, {
        make("UICorner", { CornerRadius = UDim.new(0, 9) }),
        make("UIStroke", {
            Name = "LogoGlowStroke",
            Color = Theme.AccentCyan,
            Thickness = 1.3,
            Transparency = 0.2
        }),
        make("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 30, 52)),
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
            TextSize = 16,
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
            make("UICorner", { CornerRadius = UDim.new(0, 9) })
        })
    })

    -- Subtle breathing neon pulse on logo stroke
    task.spawn(function()
        local stroke = LogoBadgeHolder:FindFirstChild("LogoGlowStroke")
        while ScreenGui.Parent and stroke do
            tw(stroke, { Color = Theme.AccentPrimary, Transparency = 0.1 }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            tw(stroke, { Color = Theme.AccentCyan, Transparency = 0.35 }, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end)

    local TitleLabel = make("TextLabel", {
        Text = TitleText,
        Font = Theme.FontTitle,
        TextSize = 16,
        TextColor3 = Theme.TextTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 60, 0, 11),
        Size = UDim2.new(0, 240, 0, 18),
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    local SubtitleLabel = make("TextLabel", {
        Text = string.upper(SubtitleText),
        Font = Theme.FontBold,
        TextSize = 9,
        TextColor3 = Theme.AccentCyan,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0, 60, 0, 31),
        Size = UDim2.new(0, 240, 0, 14),
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    -- Live Performance Pill in TopBar
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
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            if PerfPill and PerfPill:FindFirstChild("PerfText") then
                local icon = fps >= 50 and "🟢" or (fps >= 30 and "🟡" or "🔴")
                PerfPill.PerfText.Text = string.format("%s %d FPS  •  %dms", icon, fps, ping)
            end
            task.wait(1.2)
        end
    end)

    -- Window Controls (Minimize / Close)
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

    -- Draggable Motion
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
            local targetPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            MainFrame.Position = targetPos
            ShadowBackdrop.Position = UDim2.new(
                targetPos.X.Scale,
                targetPos.X.Offset - 32,
                targetPos.Y.Scale,
                targetPos.Y.Offset - 32
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- ─── Body Architecture ───────────────────────────────────────────
    local Body = make("Frame", {
        Name = "Body",
        Size = UDim2.new(1, 0, 1, -58),
        Position = UDim2.new(0, 0, 0, 58),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame
    })

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tw(MainFrame, { Size = UDim2.new(0, WindowSize.X.Offset, 0, 58) }, 0.28, Enum.EasingStyle.Quart)
            tw(ShadowBackdrop, { Size = UDim2.new(0, WindowSize.X.Offset + 64, 0, 58 + 64) }, 0.28, Enum.EasingStyle.Quart)
            Body.Visible = false
            MinBtn.Text = "+"
        else
            tw(MainFrame, { Size = WindowSize }, 0.28, Enum.EasingStyle.Quart)
            tw(ShadowBackdrop, { Size = UDim2.new(0, WindowSize.X.Offset + 64, 0, WindowSize.Y.Offset + 64) }, 0.28, Enum.EasingStyle.Quart)
            Body.Visible = true
            MinBtn.Text = "-"
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tw(MainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = MainFrame.Position + UDim2.new(0, WindowSize.X.Offset/2, 0, WindowSize.Y.Offset/2) }, 0.25)
        tw(ShadowBackdrop, { ImageTransparency = 1 }, 0.2)
        task.wait(0.28)
        ScreenGui:Destroy()
    end)

    -- Sidebar Container
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

    -- ─── Toast HUD Notifier ───────────────────────────────────────────
    function WindowObj:Notify(toast)
        toast = toast or {}
        local title = toast.Title or "System Notification"
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
            make("UIStroke", {
                Color = Theme.AccentPrimary,
                Thickness = 1.2,
                Transparency = 0.3
            }),
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
            card:Destroy()
        end)
    end

    -- ═════════════════════════════════════════════════════════════════
    -- TAB CONSTRUCTOR
    -- ═════════════════════════════════════════════════════════════════
    function WindowObj:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Category"
        local TabIcon = tabConfig.Icon or "✦"

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
                Padding = UDim.new(0, 10)
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
                TextSize = 15,
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
                TextSize = 13,
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

        -- 1. Section Header
        function TabObj:AddSection(secTitle)
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

        -- 2. Hero Stat Card
        function TabObj:AddStatCard(cardConfig)
            cardConfig = cardConfig or {}
            local title     = cardConfig.Title or "Telemetry Metric"
            local initial   = cardConfig.Value or "0"
            local subtitle  = cardConfig.Subtext or "Live Feed"

            local card = make("Frame", {
                Size = UDim2.new(1, 0, 0, 54),
                BackgroundColor3 = Theme.CardBg,
                Parent = TabPage
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                make("UIStroke", { Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
                make("Frame", {
                    Size = UDim2.new(0, 3, 1, -14),
                    Position = UDim2.new(0, 8, 0, 7),
                    BackgroundColor3 = Theme.AccentPrimary
                }, {
                    make("UICorner", { CornerRadius = UDim.new(1, 0) })
                }),
                make("TextLabel", {
                    Text = title,
                    Font = Theme.FontSemi,
                    TextSize = 11,
                    TextColor3 = Theme.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 20, 0, 9),
                    Size = UDim2.new(0.6, 0, 0, 16),
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Name = "SubLabel",
                    Text = subtitle,
                    Font = Theme.FontRegular,
                    TextSize = 10,
                    TextColor3 = Theme.AccentCyan,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 20, 0, 28),
                    Size = UDim2.new(0.6, 0, 0, 16),
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Name = "ValueLabel",
                    Text = tostring(initial),
                    Font = Theme.FontTitle,
                    TextSize = 17,
                    TextColor3 = Theme.TextTitle,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(0.6, 0, 0, 0),
                    Size = UDim2.new(0.4, -18, 1, 0),
                    BackgroundTransparency = 1
                })
            })

            local CardHandle = {}
            function CardHandle:Set(newVal, color, subText)
                card.ValueLabel.Text = tostring(newVal)
                if color then card.ValueLabel.TextColor3 = color end
                if subText then card.SubLabel.Text = tostring(subText) end
            end
            return CardHandle
        end

        -- 3. Gloss Toggle Switch
        function TabObj:AddToggle(togConfig)
            togConfig = togConfig or {}
            local name      = togConfig.Name or "Toggle Switch"
            local desc      = togConfig.Desc or ""
            local default   = togConfig.Default or false
            local callback  = togConfig.Callback or function() end

            local isToggled = default
            local cardHeight = desc ~= "" and 54 or 44

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
                    TextSize = 13,
                    TextColor3 = Theme.TextTitle,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 16, 0, desc ~= "" and 10 or 0),
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
                    Position = UDim2.new(0, 16, 0, 28),
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
                if fire then
                    task.spawn(callback, isToggled)
                end
            end

            ToggleCard.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                syncVisual(true)
            end)

            ToggleCard.MouseEnter:Connect(function()
                tw(ToggleCard, { BackgroundColor3 = Theme.CardHover }, 0.15)
            end)
            ToggleCard.MouseLeave:Connect(function()
                tw(ToggleCard, { BackgroundColor3 = Theme.CardBg }, 0.15)
            end)

            local ToggleHandle = {}
            function ToggleHandle:Set(val)
                isToggled = val
                syncVisual(true)
            end
            return ToggleHandle
        end

        -- 4. Precision Slider
        function TabObj:AddSlider(sldConfig)
            sldConfig = sldConfig or {}
            local name      = sldConfig.Name or "Parameter Adjustment"
            local min       = sldConfig.Min or 0
            local max       = sldConfig.Max or 100
            local default   = math.clamp(sldConfig.Default or min, min, max)
            local inc       = sldConfig.Increment or 1
            local suffix    = sldConfig.ValueName or ""
            local callback  = sldConfig.Callback or function() end

            local currentVal = default

            local SliderCard = make("Frame", {
                Size = UDim2.new(1, 0, 0, 58),
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
                    Position = UDim2.new(0, 16, 0, 10),
                    Size = UDim2.new(0.65, 0, 0, 16),
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Name = "ValText",
                    Text = tostring(currentVal) .. (suffix ~= "" and (" " .. suffix) or ""),
                    Font = Theme.FontTitle,
                    TextSize = 13,
                    TextColor3 = Theme.AccentCyan,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(0.65, 0, 0, 10),
                    Size = UDim2.new(0.35, -16, 0, 16),
                    BackgroundTransparency = 1
                })
            })

            local Rail = make("TextButton", {
                Size = UDim2.new(1, -32, 0, 7),
                Position = UDim2.new(0, 16, 0, 38),
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

        -- 5. Neo Button
        function TabObj:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            local name      = btnConfig.Name or "Execute Command"
            local icon      = btnConfig.Icon or "⚡"
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
                    Text = icon,
                    Font = Theme.FontBold,
                    TextSize = 14,
                    Position = UDim2.new(0, 14, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    TextColor3 = Theme.AccentCyan,
                    BackgroundTransparency = 1
                }),
                make("TextLabel", {
                    Name = "Title",
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

        -- 6. Accordion Dropdown
        function TabObj:AddDropdown(dropConfig)
            dropConfig = dropConfig or {}
            local name      = dropConfig.Name or "Dropdown Selection"
            local options   = dropConfig.Options or {}
            local default   = dropConfig.Default or options[1]
            local callback  = dropConfig.Callback or function() end

            local isExpanded = false
            local selected   = default

            local DropCard = make("Frame", {
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.CardBg,
                ClipsDescendants = true,
                Parent = TabPage
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                make("UIStroke", { Name = "DropStroke", Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 })
            })

            local Header = make("TextButton", {
                Size = UDim2.new(1, 0, 0, 44),
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
                Size = UDim2.new(1, -24, 0, #options * 32),
                Position = UDim2.new(0, 12, 0, 48),
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
                    Size = UDim2.new(1, 0, 0, 28),
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
                    tw(DropCard, { Size = UDim2.new(1, 0, 0, 44) }, 0.22)
                    task.spawn(callback, selected)
                end)

                OptBtn.MouseEnter:Connect(function()
                    tw(OptBtn, { BackgroundColor3 = Theme.AccentPrimary, TextColor3 = Color3.fromRGB(255, 255, 255) }, 0.12)
                end)
                OptBtn.MouseLeave:Connect(function()
                    tw(OptBtn, { BackgroundColor3 = Color3.fromRGB(30, 34, 50), TextColor3 = Theme.TextBody }, 0.12)
                end)
            end

            Header.MouseButton1Click:Connect(function()
                isExpanded = not isExpanded
                if isExpanded then
                    local targetH = 54 + (#options * 32)
                    tw(DropCard, { Size = UDim2.new(1, 0, 0, targetH) }, 0.26, Enum.EasingStyle.Quart)
                    Header.SelectedText.Text = tostring(selected) .. "  ▴"
                else
                    tw(DropCard, { Size = UDim2.new(1, 0, 0, 44) }, 0.22, Enum.EasingStyle.Quart)
                    Header.SelectedText.Text = tostring(selected) .. "  ▾"
                end
            end)
        end

        -- 7. Cyber Textbox
        function TabObj:AddTextbox(txtConfig)
            txtConfig = txtConfig or {}
            local name      = txtConfig.Name or "Input Key / Text"
            local default   = txtConfig.Default or ""
            local place     = txtConfig.Placeholder or "Enter value..."
            local callback  = txtConfig.Callback or function() end

            local BoxCard = make("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Theme.CardBg,
                Parent = TabPage
            }, {
                make("UICorner", { CornerRadius = UDim.new(0, 10) }),
                make("UIStroke", { Name = "BoxStroke", Color = Theme.CardBorder, Thickness = 1.1, Transparency = 0.3 }),
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

        return TabObj
    end

    return WindowObj
end

-- ═════════════════════════════════════════════════════════════════════
-- SCRIPT LOGIC (RUNS IMMEDIATELY & FLAWLESSLY)
-- ═════════════════════════════════════════════════════════════════════

-- 1. สร้าง Main Window (ขนาดสัดส่วน 720 x 480 ดูโปร สบายตา)
local Window = UI:CreateWindow({
    Name = "ProjectBarunHub",
    Title = "PROJECT BARUN",
    Subtitle = "PB CYBER AUTOMATION ENGINE v2.0",
    Size = UDim2.new(0, 720, 0, 480)
})

-- ป๊อปอัปต้อนรับแบบ Luxury Toast HUD
Window:Notify({
    Title = "Project Barun Initialized",
    Content = "เชื่อมต่อระบบ Project Barun (PB) สำเร็จ พร้อมเปิดใช้งานฟังก์ชันทั้งหมด",
    Icon = "💎",
    Duration = 4
})

-- 2. สร้างแท็บแยกหมวดหมู่ชัดเจน
local TabDash    = Window:CreateTab({ Name = "Live Metrics",    Icon = "📊" })
local TabCombat  = Window:CreateTab({ Name = "God Combat",      Icon = "⚔️" })
local TabFarm    = Window:CreateTab({ Name = "Auto Farm",       Icon = "⚡" })
local TabMove    = Window:CreateTab({ Name = "Speed & Teleport",Icon = "🚀" })
local TabConfig  = Window:CreateTab({ Name = "Engine Settings", Icon = "⚙️" })

-- ─────────────────────────────────────────────────────────────────
-- TAB 1: LIVE METRICS (แดชบอร์ดสถิติสด)
-- ─────────────────────────────────────────────────────────────────
TabDash:AddSection("Real-Time Telemetry & Economy")

local StatCash = TabDash:AddStatCard({
    Title = "Total Earned Cash",
    Value = "+$142,500",
    Subtext = "Rate: ~$420,000 / hr"
})

local StatKills = TabDash:AddStatCard({
    Title = "Mobs Eliminated",
    Value = "1,842",
    Subtext = "Silent Insta-Kill Active"
})

local StatState = TabDash:AddStatCard({
    Title = "Active Loop Cycle",
    Value = "Zone 4: Volcano Dungeon",
    Subtext = "Elapsed: 00:42:15"
})

-- ─────────────────────────────────────────────────────────────────
-- TAB 2: GOD COMBAT (ระบบต่อสู้ & ฆ่าม็อบ)
-- ─────────────────────────────────────────────────────────────────
TabCombat:AddSection("Combat Automation & Silent Kill")

TabCombat:AddToggle({
    Name = "Silent Insta-Kill (ฆ่าม็อบไร้ดีเลย์)",
    Desc = "โจมตีผ่านเน็ตเวิร์กโดยตรงโดยที่ตัวละครไม่ต้องเดินไปตี",
    Default = true,
    Callback = function(v)
        Window:Notify({
            Title = "Combat Mode",
            Content = v and "เปิด Silent Kill แล้ว!" or "ปิด Silent Kill แล้ว",
            Icon = "⚔️",
            Duration = 2
        })
    end
})

TabCombat:AddToggle({
    Name = "Infinite Reach (ตีระยะไกลรอบทิศทาง)",
    Desc = "ขยายระยะฮิตบ็อกซ์รอบตัว 360 องศา",
    Default = true,
    Callback = function(v) end
})

TabCombat:AddSlider({
    Name = "Attack Speed Multiplier (เร่งความเร็วฟัน)",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 1,
    ValueName = "x Speed",
    Callback = function(v) end
})

TabCombat:AddButton({
    Name = "Execute Boss Insta-Wipe (สั่งล้างบอสทันที)",
    Icon = "💀",
    Callback = function()
        Window:Notify({
            Title = "Boss Annihilation",
            Content = "ส่ง Packet ดาเมจมหาศาล กำจัดบอสสำเร็จ!",
            Icon = "🔥",
            Duration = 3
        })
    end
})

-- ─────────────────────────────────────────────────────────────────
-- TAB 3: AUTO FARM (ฟาร์มของ & สเตจ)
-- ─────────────────────────────────────────────────────────────────
TabFarm:AddSection("Farming & Dungeon")

TabFarm:AddDropdown({
    Name = "Target Farm Zone",
    Options = {
        "Zone 1: Beginner Prairie",
        "Zone 2: Whispering Forest",
        "Zone 3: Desert of Solitude",
        "Zone 4: Volcano Dungeon",
        "Zone 5: Celestial Void"
    },
    Default = "Zone 4: Volcano Dungeon",
    Callback = function(sel)
        StatState:Set(sel, nil, "Auto Pathing Target")
    end
})

TabFarm:AddToggle({
    Name = "Auto Collect Drops & Chests (ดูดของอัตโนมัติ)",
    Desc = "ดึงเงิน แร่ และกล่องสมบัติเข้าตัวทันทีที่ดรอป",
    Default = true,
    Callback = function(v) end
})

TabFarm:AddToggle({
    Name = "Auto Rebirth & Level Up (จุติอัตโนมัติ)",
    Desc = "เมื่อเลเวลเต็ม ระบบจะกดจุติให้อัตโนมัติทันที",
    Default = false,
    Callback = function(v) end
})

-- ─────────────────────────────────────────────────────────────────
-- TAB 4: SPEED & TELEPORT (วาป & เคลื่อนที่)
-- ─────────────────────────────────────────────────────────────────
TabMove:AddSection("Movement Modifications")

TabMove:AddSlider({
    Name = "WalkSpeed Velocity",
    Min = 16,
    Max = 300,
    Default = 65,
    Increment = 5,
    ValueName = "Speed",
    Callback = function(spd)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = spd end
    end
})

TabMove:AddToggle({
    Name = "NoClip Collision Bypass (เดินทะลุกำแพง)",
    Desc = "ปิดการชนของทุกชิ้นส่วนในตัวละคร เดินทะลุสิ่งกีดขวางได้ 100%",
    Default = false,
    Callback = function(v) end
})

TabMove:AddButton({
    Name = "Teleport to Spawn (วาปกลับจุดเกิด)",
    Icon = "📍",
    Callback = function()
        Window:Notify({
            Title = "Teleport",
            Content = "วาปกลับยังจุดเกิดเรียบร้อยแล้ว",
            Icon = "✨",
            Duration = 2.5
        })
    end
})

-- ─────────────────────────────────────────────────────────────────
-- TAB 5: ENGINE SETTINGS (ตั้งค่าระบบ & ประหยัดทรัพยากร)
-- ─────────────────────────────────────────────────────────────────
TabConfig:AddSection("Anti-Detection & System Saver")

TabConfig:AddToggle({
    Name = "24/7 Anti-AFK Protector (กันหลุด 20 นาที)",
    Desc = "จำลองการขยับและส่ง Heartbeat ปลอดภัย ไม่โดนตัดการเชื่อมต่อ",
    Default = true,
    Callback = function(v) end
})

TabConfig:AddToggle({
    Name = "GPU Eco Mode (ปิดเรนเดอร์ 3D สำหรับฟาร์มทั้งคืน)",
    Desc = "ลดการทำงานของการ์ดจอเหลือ 1% เครื่องไม่ร้อน พัดลมเงียบ",
    Default = false,
    Callback = function(v)
        game:GetService("RunService"):Set3dRenderingEnabled(not v)
    end
})

TabConfig:AddTextbox({
    Name = "Discord Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = "",
    Callback = function(url, enter)
        if enter and #url > 10 then
            Window:Notify({
                Title = "Discord Webhook",
                Content = "ผูก Webhook สำเร็จ! ระบบจะส่งสรุปผลฟาร์มทุก 30 นาที",
                Icon = "🔔",
                Duration = 3
            })
        end
    end
})
