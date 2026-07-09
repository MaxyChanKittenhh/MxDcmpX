-- ==============================================================================
-- MODULE: ui.lua
-- PROJECT: MXDCMPX (Advanced Structural Map Extraction Interface)
-- ARCHITECTURE: Production-Grade Modular User Interface Framework
-- ==============================================================================

local UI = {}

function UI.Init(StartCallback)
    -- --------------------------------------------------------------------------
    -- 1. SYSTEM SERVICES ENGINE INITIALIZATION
    -- --------------------------------------------------------------------------
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer

    -- --------------------------------------------------------------------------
    -- 2. ENVIRONMENT ISOLATION & PURGE OVERRIDE
    -- --------------------------------------------------------------------------
    for _, existingUi in ipairs(CoreGui:GetChildren()) do
        if existingUi.Name == "MXDCMPX_CORE_DISTRIBUTION" then
            existingUi:Destroy()
        end
    end

    -- --------------------------------------------------------------------------
    -- 3. THEME DEFINITION CORE PALETTE MATRIX
    -- --------------------------------------------------------------------------
    local Palette = {
        WindowDepth = Color3.fromRGB(14, 14, 16),
        SidebarDepth = Color3.fromRGB(20, 20, 24),
        HeaderDepth = Color3.fromRGB(18, 18, 22),
        CardBackground = Color3.fromRGB(26, 26, 32),
        InteractiveElement = Color3.fromRGB(32, 32, 40),
        InteractiveHover = Color3.fromRGB(42, 42, 54),
        AccentActive = Color3.fromRGB(44, 115, 242),
        AccentGlow = Color3.fromRGB(72, 140, 255),
        TextPrimary = Color3.fromRGB(245, 245, 248),
        TextSecondary = Color3.fromRGB(142, 142, 155),
        TextMuted = Color3.fromRGB(90, 90, 102),
        StateSuccess = Color3.fromRGB(54, 211, 113),
        StateAlert = Color3.fromRGB(239, 68, 68),
        BorderColor = Color3.fromRGB(36, 36, 44),
        BorderFaint = Color3.fromRGB(28, 28, 34)
    }

    local Typography = {
        FontRegular = Enum.Font.GothamMedium,
        FontBold = Enum.Font.GothamBold,
        FontMono = Enum.Font.Code
    }

    -- --------------------------------------------------------------------------
    -- 4. RUNTIME SYSTEM STATE LOGIC DEFINITIONS
    -- --------------------------------------------------------------------------
    local LiveConfig = {
        mode = "full",
        NilInstances = true,
        IgnoreNotArchivable = false,
        IgnoreDefaultProperties = false,
        TreatUnionsAsParts = true,
        IsolateStarterPlayer = false,
        IsolatePlayers = false,
        IsolateLocalPlayer = false,
        IsolateLocalPlayerCharacter = false,
        SavePlayerCharacters = true,
        RemovePlayerCharacters = false,
        Decompile = true,
        noscripts = false,
        SaveBytecode = true,
        scriptcache = true,
        DecompileJobless = false,
        DecompileTimeout = 20,
        SafeMode = true,
        KillAllScripts = true,
        Anonymous = true,
        BoostFPS = true,
        AntiIdle = true,
        ShutdownWhenDone = false,
        AvoidFileOverwrite = true,
        AlternativeWritefile = true,
        SaveCacheInterval = 56320,
        ShowStatus = true,
        ReadMe = true,
        __DEBUG_MODE = false,
        FilePath = "maxkittentuff"
    }

    local ActiveTabs = {}
    local DisplayPanels = {}
    local DraggingConnections = {}

    -- --------------------------------------------------------------------------
    -- 5. LOW-LEVEL UI OBJECT BUILDERS & UTILITIES
    -- --------------------------------------------------------------------------
    local function InsertCorner(parent, pxRadius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, pxRadius)
        corner.Parent = parent
        return corner
    end

    local function InsertStroke(parent, color, pxThickness, mode)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color
        stroke.Thickness = pxThickness
        stroke.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
        stroke.Parent = parent
        return stroke
    end

    local function MakeDraggableElement(dragHandle, targetWindow)
        local dragging = false
        local dragInput = nil
        local dragStart = nil
        local startPos = nil

        local function UpdatePosition(input)
            local delta = input.Position - dragStart
            local endPosition = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            TweenService:Create(targetWindow, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = endPosition}):Play()
        end

        local conn1 = dragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetWindow.Position

                local connEnd
                connEnd = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        connEnd:Disconnect()
                    end
                end)
            end
        end)

        local conn2 = dragHandle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        local conn3 = UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                UpdatePosition(input)
            end
        end)

        table.insert(DraggingConnections, conn1)
        table.insert(DraggingConnections, conn2)
        table.insert(DraggingConnections, conn3)
    end

    -- --------------------------------------------------------------------------
    -- 6. PRIMARY ROOT CANVAS GENERATION
    -- --------------------------------------------------------------------------
    local RootCanvas = Instance.new("ScreenGui")
    RootCanvas.Name = "MXDCMPX_CORE_DISTRIBUTION"
    RootCanvas.ResetOnSpawn = false
    RootCanvas.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RootCanvas.Parent = CoreGui

    -- --------------------------------------------------------------------------
    -- 7. LOADING ENGINE APPLICATION VIEW SCREEN
    -- --------------------------------------------------------------------------
    local LoadCanvas = Instance.new("Frame")
    LoadCanvas.Name = "LoadCanvas"
    LoadCanvas.Size = UDim2.new(1, 0, 1, 0)
    LoadCanvas.BackgroundColor3 = Palette.WindowDepth
    LoadCanvas.BorderSizePixel = 0
    LoadCanvas.ZIndex = 10000
    LoadCanvas.Parent = RootCanvas

    local LoadLayout = Instance.new("Frame")
    LoadLayout.Name = "LoadLayout"
    LoadLayout.Size = UDim2.new(0, 420, 0, 240)
    LoadLayout.Position = UDim2.new(0.5, -210, 0.5, -120)
    LoadLayout.BackgroundTransparency = 1
    LoadLayout.Parent = LoadCanvas

    local BrandLabel = Instance.new("TextLabel")
    BrandLabel.Name = "BrandLabel"
    BrandLabel.Size = UDim2.new(1, 0, 0, 45)
    BrandLabel.Position = UDim2.new(0, 0, 0, 40)
    BrandLabel.BackgroundTransparency = 1
    BrandLabel.Text = "MXDCMPX"
    BrandLabel.TextColor3 = Palette.TextPrimary
    BrandLabel.Font = Typography.FontBold
    BrandLabel.TextSize = 38
    BrandLabel.TextStrokeTransparency = 0.8
    BrandLabel.Parent = LoadLayout

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "SubtitleLabel"
    SubtitleLabel.Size = UDim2.new(1, 0, 0, 25)
    SubtitleLabel.Position = UDim2.new(0, 0, 0, 90)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = "ENVIRONMENT EXTRACTION FRAMEWORK"
    SubtitleLabel.TextColor3 = Palette.AccentActive
    SubtitleLabel.Font = Typography.FontRegular
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextLetterSpacing = 3
    SubtitleLabel.Parent = LoadLayout

    local StatusConsole = Instance.new("TextLabel")
    StatusConsole.Name = "StatusConsole"
    StatusConsole.Size = UDim2.new(1, 0, 0, 20)
    StatusConsole.Position = UDim2.new(0, 0, 1, -65)
    StatusConsole.BackgroundTransparency = 1
    StatusConsole.Text = "Allocating Secure Virtual Sandbox Environment..."
    StatusConsole.TextColor3 = Palette.TextSecondary
    StatusConsole.Font = Typography.FontRegular
    StatusConsole.TextSize = 13
    StatusConsole.Parent = LoadLayout

    local ProgressRail = Instance.new("Frame")
    ProgressRail.Name = "ProgressRail"
    ProgressRail.Size = UDim2.new(1, 0, 0, 4)
    ProgressRail.Position = UDim2.new(0, 0, 1, -30)
    ProgressRail.BackgroundColor3 = Palette.InteractiveElement
    ProgressRail.BorderSizePixel = 0
    ProgressRail.Parent = LoadLayout
    InsertCorner(ProgressRail, 2)

    local ProgressFill = Instance.new("Frame")
    ProgressFill.Name = "ProgressFill"
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = Palette.AccentActive
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = ProgressRail
    InsertCorner(ProgressFill, 2)

    local RailGlow = Instance.new("Frame")
    RailGlow.Name = "RailGlow"
    RailGlow.Size = UDim2.new(1, 0, 3, 0)
    RailGlow.Position = UDim2.new(0, 0, -1, 0)
    RailGlow.BackgroundColor3 = Palette.AccentGlow
    RailGlow.BackgroundTransparency = 0.85
    RailGlow.BorderSizePixel = 0
    RailGlow.Parent = ProgressFill
    InsertCorner(RailGlow, 4)

    -- --------------------------------------------------------------------------
    -- 8. ANCHORED MINIMIZED INSTANCE FLOATING BUTTON
    -- --------------------------------------------------------------------------
    local TinyAnchor = Instance.new("Frame")
    TinyAnchor.Name = "TinyAnchor"
    TinyAnchor.Size = UDim2.new(0, 60, 0, 60)
    TinyAnchor.Position = UDim2.new(0.05, 0, 0.1, 0)
    TinyAnchor.BackgroundColor3 = Palette.SidebarDepth
    TinyAnchor.Visible = false
    TinyAnchor.ClipsDescendants = false
    TinyAnchor.Parent = RootCanvas
    InsertCorner(TinyAnchor, 30)
    InsertStroke(TinyAnchor, Palette.BorderColor, 2)

    local AnchorInteractive = Instance.new("TextButton")
    AnchorInteractive.Name = "AnchorInteractive"
    AnchorInteractive.Size = UDim2.new(1, 0, 1, 0)
    AnchorInteractive.BackgroundTransparency = 1
    AnchorInteractive.Text = "M"
    AnchorInteractive.TextColor3 = Palette.AccentActive
    AnchorInteractive.Font = Typography.FontBold
    AnchorInteractive.TextSize = 22
    AnchorInteractive.Parent = TinyAnchor

    MakeDraggableElement(TinyAnchor, TinyAnchor)

    -- --------------------------------------------------------------------------
    -- 9. MAIN UTILITY WINDOW STRUCTURE ENVIRONMENT
    -- --------------------------------------------------------------------------
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 880, 0, 540)
    MainFrame.Position = UDim2.new(0.5, -440, 0.5, -270)
    MainFrame.BackgroundColor3 = Palette.WindowDepth
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = RootCanvas
    InsertCorner(MainFrame, 12)
    InsertStroke(MainFrame, Palette.BorderColor, 1)

    -- TOP HEADER BAR CONTAINER
    local TopHeader = Instance.new("Frame")
    TopHeader.Name = "TopHeader"
    TopHeader.Size = UDim2.new(1, 0, 0, 50)
    TopHeader.BackgroundColor3 = Palette.HeaderDepth
    TopHeader.BorderSizePixel = 0
    TopHeader.Parent = MainFrame

    local TopHeaderLine = Instance.new("Frame")
    TopHeaderLine.Name = "TopHeaderLine"
    TopHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    TopHeaderLine.Position = UDim2.new(0, 0, 1, -1)
    TopHeaderLine.BackgroundColor3 = Palette.BorderColor
    TopHeaderLine.BorderSizePixel = 0
    TopHeaderLine.Parent = TopHeader

    local WindowTitle = Instance.new("TextLabel")
    WindowTitle.Name = "WindowTitle"
    WindowTitle.Size = UDim2.new(0, 200, 1, 0)
    WindowTitle.Position = UDim2.new(0, 20, 0, 0)
    WindowTitle.BackgroundTransparency = 1
    WindowTitle.Text = "MXDCMPX"
    WindowTitle.TextColor3 = Palette.TextPrimary
    WindowTitle.Font = Typography.FontBold
    WindowTitle.TextSize = 16
    WindowTitle.TextXAlignment = Enum.TextXAlignment.Left
    WindowTitle.Parent = TopHeader

    local DigitalClock = Instance.new("TextLabel")
    DigitalClock.Name = "DigitalClock"
    DigitalClock.Size = UDim2.new(0, 120, 1, 0)
    DigitalClock.Position = UDim2.new(0.5, -60, 0, 0)
    DigitalClock.BackgroundTransparency = 1
    DigitalClock.Text = "00:00:00 AM"
    DigitalClock.TextColor3 = Palette.TextMuted
    DigitalClock.Font = Typography.FontMono
    DigitalClock.TextSize = 14
    DigitalClock.Parent = TopHeader

    task.spawn(function()
        while task.wait(0.5) do
            local currentHourTime = os.date("%I:%M:%S %p")
            DigitalClock.Text = currentHourTime
        end
    end)

    -- HEADER SYNC OPERATIONS CONTROLS
    local WindowActionsGrid = Instance.new("Frame")
    WindowActionsGrid.Name = "WindowActionsGrid"
    WindowActionsGrid.Size = UDim2.new(0, 90, 1, 0)
    WindowActionsGrid.Position = UDim2.new(1, -105, 0, 0)
    WindowActionsGrid.BackgroundTransparency = 1
    WindowActionsGrid.Parent = TopHeader

    local LayoutActions = Instance.new("UIListLayout")
    LayoutActions.FillDirection = Enum.FillDirection.Horizontal
    LayoutActions.HorizontalAlignment = Enum.HorizontalAlignment.Right
    LayoutActions.VerticalAlignment = Enum.VerticalAlignment.Center
    LayoutActions.Padding = UDim.new(0, 12)
    LayoutActions.Parent = WindowActionsGrid

    local MinimizeAction = Instance.new("TextButton")
    MinimizeAction.Name = "MinimizeAction"
    MinimizeAction.Size = UDim2.new(0, 24, 0, 24)
    MinimizeAction.BackgroundColor3 = Palette.InteractiveElement
    MinimizeAction.Text = "—"
    MinimizeAction.TextColor3 = Palette.TextSecondary
    MinimizeAction.Font = Typography.FontBold
    MinimizeAction.TextSize = 10
    MinimizeAction.AutoButtonColor = false
    MinimizeAction.Parent = WindowActionsGrid
    InsertCorner(MinimizeAction, 12)
    InsertStroke(MinimizeAction, Palette.BorderFaint, 1)

    local CloseAction = Instance.new("TextButton")
    CloseAction.Name = "CloseAction"
    CloseAction.Size = UDim2.new(0, 24, 0, 24)
    CloseAction.BackgroundColor3 = Palette.InteractiveElement
    CloseAction.Text = "✕"
    CloseAction.TextColor3 = Palette.StateAlert
    CloseAction.Font = Typography.FontBold
    CloseAction.TextSize = 10
    CloseAction.AutoButtonColor = false
    CloseAction.Parent = WindowActionsGrid
    InsertCorner(CloseAction, 12)
    InsertStroke(CloseAction, Palette.BorderFaint, 1)

    MakeDraggableElement(TopHeader, MainFrame)

    -- LEFT SIDE NAVIGATION RAIL
    local NavigationRail = Instance.new("Frame")
    NavigationRail.Name = "NavigationRail"
    NavigationRail.Size = UDim2.new(0, 240, 1, -50)
    NavigationRail.Position = UDim2.new(0, 0, 0, 50)
    NavigationRail.BackgroundColor3 = Palette.SidebarDepth
    NavigationRail.BorderSizePixel = 0
    NavigationRail.Parent = MainFrame

    local SeparationRailLine = Instance.new("Frame")
    SeparationRailLine.Name = "SeparationRailLine"
    SeparationRailLine.Size = UDim2.new(0, 1, 1, 0)
    SeparationRailLine.Position = UDim2.new(1, -1, 0, 0)
    SeparationRailLine.BackgroundColor3 = Palette.BorderColor
    SeparationRailLine.BorderSizePixel = 0
    SeparationRailLine.Parent = NavigationRail

    -- SIDEBAR USER IDENTITY CONTAINER WIDGET
    local ProfileComponent = Instance.new("Frame")
    ProfileComponent.Name = "ProfileComponent"
    ProfileComponent.Size = UDim2.new(1, -32, 0, 55)
    ProfileComponent.Position = UDim2.new(0, 16, 0, 20)
    ProfileComponent.BackgroundColor3 = Palette.CardBackground
    ProfileComponent.Parent = NavigationRail
    InsertCorner(ProfileComponent, 8)
    InsertStroke(ProfileComponent, Palette.BorderFaint, 1)

    local OperatorAvatar = Instance.new("ImageLabel")
    OperatorAvatar.Name = "OperatorAvatar"
    OperatorAvatar.Size = UDim2.new(0, 35, 0, 35)
    OperatorAvatar.Position = UDim2.new(0, 10, 0.5, -17)
    OperatorAvatar.BackgroundColor3 = Palette.InteractiveElement
    OperatorAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    OperatorAvatar.Parent = ProfileComponent
    InsertCorner(OperatorAvatar, 18)

    local OperatorName = Instance.new("TextLabel")
    OperatorName.Name = "OperatorName"
    OperatorName.Size = UDim2.new(1, -95, 0, 18)
    OperatorName.Position = UDim2.new(0, 52, 0, 10)
    OperatorName.BackgroundTransparency = 1
    OperatorName.Text = LocalPlayer.Name
    OperatorName.TextColor3 = Palette.TextPrimary
    OperatorName.Font = Typography.FontBold
    OperatorName.TextSize = 13
    OperatorName.TextXAlignment = Enum.TextXAlignment.Left
    OperatorName.ClipsDescendants = true
    OperatorName.Parent = ProfileComponent

    local PrivilegeTag = Instance.new("Frame")
    PrivilegeTag.Name = "PrivilegeTag"
    PrivilegeTag.Size = UDim2.new(0, 52, 0, 16)
    PrivilegeTag.Position = UDim2.new(0, 52, 0, 28)
    PrivilegeTag.BackgroundColor3 = Color3.fromRGB(33, 45, 39)
    PrivilegeTag.Parent = ProfileComponent
    InsertCorner(PrivilegeTag, 4)

    local PrivilegeText = Instance.new("TextLabel")
    PrivilegeText.Name = "PrivilegeText"
    PrivilegeText.Size = UDim2.new(1, 0, 1, 0)
    PrivilegeText.BackgroundTransparency = 1
    PrivilegeText.Text = "OPERATOR"
    PrivilegeText.TextColor3 = Palette.StateSuccess
    PrivilegeText.Font = Typography.FontBold
    PrivilegeText.TextSize = 9
    PrivilegeText.Parent = PrivilegeTag

    local ScrollButtonsTrack = Instance.new("ScrollingFrame")
    ScrollButtonsTrack.Name = "ScrollButtonsTrack"
    ScrollButtonsTrack.Size = UDim2.new(1, -24, 1, -110)
    ScrollButtonsTrack.Position = UDim2.new(0, 12, 0, 95)
    ScrollButtonsTrack.BackgroundTransparency = 1
    ScrollButtonsTrack.BorderSizePixel = 0
    ScrollButtonsTrack.ScrollBarThickness = 0
    ScrollButtonsTrack.Parent = NavigationRail

    local TrackListLayout = Instance.new("UIListLayout")
    TrackListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TrackListLayout.Padding = UDim.new(0, 6)
    TrackListLayout.Parent = ScrollButtonsTrack

    -- CORE WORKSPACE CONTAINER VIEWPORTS
    local ViewsWorkspace = Instance.new("Frame")
    ViewsWorkspace.Name = "ViewsWorkspace"
    ViewsWorkspace.Size = UDim2.new(1, -240, 1, -50)
    ViewsWorkspace.Position = UDim2.new(0, 240, 0, 50)
    ViewsWorkspace.BackgroundTransparency = 1
    ViewsWorkspace.Parent = MainFrame

    -- --------------------------------------------------------------------------
    -- 10. SYSTEM MODULAR TAB RENDERING INTERFACE
    -- --------------------------------------------------------------------------
    local function RouteViewTab(tabTitle, executionIndex)
        local NavigationButton = Instance.new("TextButton")
        NavigationButton.Name = "TabBtn_" .. tabTitle
        NavigationButton.Size = UDim2.new(1, 0, 0, 40)
        NavigationButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NavigationButton.BackgroundTransparency = 1
        NavigationButton.Text = "      " .. tabTitle
        NavigationButton.TextColor3 = Palette.TextSecondary
        NavigationButton.Font = Typography.FontRegular
        NavigationButton.TextSize = 13
        NavigationButton.TextXAlignment = Enum.TextXAlignment.Left
        NavigationButton.LayoutOrder = executionIndex
        NavigationButton.AutoButtonColor = false
        NavigationButton.Parent = ScrollButtonsTrack
        InsertCorner(NavigationButton, 6)

        local SelectionIndicatorDot = Instance.new("Frame")
        SelectionIndicatorDot.Name = "SelectionIndicatorDot"
        SelectionIndicatorDot.Size = UDim2.new(0, 4, 0, 16)
        SelectionIndicatorDot.Position = UDim2.new(0, 12, 0.5, -8)
        SelectionIndicatorDot.BackgroundColor3 = Palette.AccentActive
        SelectionIndicatorDot.BackgroundTransparency = 1
        SelectionIndicatorDot.BorderSizePixel = 0
        SelectionIndicatorDot.Parent = NavigationButton
        InsertCorner(SelectionIndicatorDot, 2)

        local ViewViewportScroll = Instance.new("ScrollingFrame")
        ViewViewportScroll.Name = "ViewViewportScroll_" .. tabTitle
        ViewViewportScroll.Size = UDim2.new(1, -40, 1, -40)
        ViewViewportScroll.Position = UDim2.new(0, 20, 0, 20)
        ViewViewportScroll.BackgroundTransparency = 1
        ViewViewportScroll.BorderSizePixel = 0
        ViewViewportScroll.ScrollBarThickness = 3
        ViewViewportScroll.ScrollBarImageColor3 = Palette.InteractiveElement
        ViewViewportScroll.Visible = false
        ViewViewportScroll.Parent = ViewsWorkspace

        local ViewViewportList = Instance.new("UIListLayout")
        ViewViewportList.SortOrder = Enum.SortOrder.LayoutOrder
        ViewViewportList.Padding = UDim.new(0, 10)
        ViewViewportList.Parent = ViewViewportScroll

        local ViewPadding = Instance.new("UIPadding")
        ViewPadding.PaddingRight = UDim.new(0, 8)
        ViewPadding.Parent = ViewViewportScroll

        ViewViewportList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ViewViewportScroll.CanvasSize = UDim2.new(0, 0, 0, ViewViewportList.AbsoluteContentSize.Y)
        end)

        ActiveTabs[tabTitle] = NavigationButton
        DisplayPanels[tabTitle] = ViewViewportScroll

        NavigationButton.MouseEnter:Connect(function()
            if DisplayPanels[tabTitle].Visible == false then
                TweenService:Create(NavigationButton, TweenInfo.new(0.15), {TextColor3 = Palette.TextPrimary, BackgroundTransparency = 0.95}):Play()
            end
        end)

        NavigationButton.MouseLeave:Connect(function()
            if DisplayPanels[tabTitle].Visible == false then
                TweenService:Create(NavigationButton, TweenInfo.new(0.15), {TextColor3 = Palette.TextSecondary, BackgroundTransparency = 1}):Play()
            end
        end)

        NavigationButton.MouseButton1Click:Connect(function()
            for currentTitle, targetButton in pairs(ActiveTabs) do
                targetButton.TextColor3 = Palette.TextSecondary
                targetButton.BackgroundTransparency = 1
                DisplayPanels[currentTitle].Visible = false
                TweenService:Create(targetButton:FindFirstChild("SelectionIndicatorDot"), TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            end
            NavigationButton.TextColor3 = Palette.TextPrimary
            NavigationButton.BackgroundColor3 = Palette.InteractiveElement
            NavigationButton.BackgroundTransparency = 0.4
            ViewViewportScroll.Visible = true
            TweenService:Create(SelectionIndicatorDot, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        end)

        return ViewViewportScroll
    end

    -- --------------------------------------------------------------------------
    -- 11. GRID PROPERTY RENDER CONTROLS
    -- --------------------------------------------------------------------------
    local function InstantiateBooleanToggle(containerFrame, dataKey, optionHeading, detailDescription)
        local OptionRow = Instance.new("Frame")
        OptionRow.Name = "OptionRow_" .. dataKey
        OptionRow.Size = UDim2.new(1, 0, 0, 55)
        OptionRow.BackgroundColor3 = Palette.CardBackground
        OptionRow.Parent = containerFrame
        InsertCorner(OptionRow, 6)
        InsertStroke(OptionRow, Palette.BorderFaint, 1)

        local HeadingLabel = Instance.new("TextLabel")
        HeadingLabel.Name = "HeadingLabel"
        HeadingLabel.Size = UDim2.new(0.7, 0, 0, 22)
        HeadingLabel.Position = UDim2.new(0, 16, 0, 8)
        HeadingLabel.BackgroundTransparency = 1
        HeadingLabel.Text = optionHeading
        HeadingLabel.TextColor3 = Palette.TextPrimary
        HeadingLabel.Font = Typography.FontRegular
        HeadingLabel.TextSize = 13
        HeadingLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeadingLabel.Parent = OptionRow

        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = UDim2.new(0.7, 0, 0, 18)
        DescriptionLabel.Position = UDim2.new(0, 16, 0, 28)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Text = detailDescription
        DescriptionLabel.TextColor3 = Palette.TextMuted
        DescriptionLabel.Font = Typography.FontRegular
        DescriptionLabel.TextSize = 11
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.Parent = OptionRow

        local HitSwitchButton = Instance.new("TextButton")
        HitSwitchButton.Name = "HitSwitchButton"
        HitSwitchButton.Size = UDim2.new(0, 46, 0, 22)
        HitSwitchButton.Position = UDim2.new(1, -62, 0.5, -11)
        HitSwitchButton.BackgroundColor3 = LiveConfig[dataKey] and Palette.AccentActive or Palette.InteractiveElement
        HitSwitchButton.Text = ""
        HitSwitchButton.AutoButtonColor = false
        HitSwitchButton.Parent = OptionRow
        InsertCorner(HitSwitchButton, 11)
        local SwitchStroke = InsertStroke(HitSwitchButton, Palette.BorderColor, 1)

        local SliderNodeDot = Instance.new("Frame")
        SliderNodeDot.Name = "SliderNodeDot"
        SliderNodeDot.Size = UDim2.new(0, 16, 0, 16)
        SliderNodeDot.Position = LiveConfig[dataKey] and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        SliderNodeDot.BackgroundColor3 = Palette.TextPrimary
        SliderNodeDot.BorderSizePixel = 0
        SliderNodeDot.Parent = HitSwitchButton
        InsertCorner(SliderNodeDot, 8)

        HitSwitchButton.MouseButton1Click:Connect(function()
            LiveConfig[dataKey] = not LiveConfig[dataKey]
            local executionState = LiveConfig[dataKey]

            if executionState then
                TweenService:Create(HitSwitchButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = Palette.AccentActive}):Play()
                TweenService:Create(SliderNodeDot, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
                SwitchStroke.Color = Palette.AccentActive
            else
                TweenService:Create(HitSwitchButton, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = Palette.InteractiveElement}):Play()
                TweenService:Create(SliderNodeDot, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
                SwitchStroke.Color = Palette.BorderColor
            end
        end)
    end

    local function InstantiateTextBoxInput(containerFrame, dataKey, optionHeading, detailDescription)
        local OptionRow = Instance.new("Frame")
        OptionRow.Name = "OptionRow_" .. dataKey
        OptionRow.Size = UDim2.new(1, 0, 0, 55)
        OptionRow.BackgroundColor3 = Palette.CardBackground
        OptionRow.Parent = containerFrame
        InsertCorner(OptionRow, 6)
        InsertStroke(OptionRow, Palette.BorderFaint, 1)

        local HeadingLabel = Instance.new("TextLabel")
        HeadingLabel.Name = "HeadingLabel"
        HeadingLabel.Size = UDim2.new(0.6, 0, 0, 22)
        HeadingLabel.Position = UDim2.new(0, 16, 0, 8)
        HeadingLabel.BackgroundTransparency = 1
        HeadingLabel.Text = optionHeading
        HeadingLabel.TextColor3 = Palette.TextPrimary
        HeadingLabel.Font = Typography.FontRegular
        HeadingLabel.TextSize = 13
        HeadingLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeadingLabel.Parent = OptionRow

        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = UDim2.new(0.6, 0, 0, 18)
        DescriptionLabel.Position = UDim2.new(0, 16, 0, 28)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Text = detailDescription
        DescriptionLabel.TextColor3 = Palette.TextMuted
        DescriptionLabel.Font = Typography.FontRegular
        DescriptionLabel.TextSize = 11
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.Parent = OptionRow

        local ValueCaptureBox = Instance.new("TextBox")
        ValueCaptureBox.Name = "ValueCaptureBox"
        ValueCaptureBox.Size = UDim2.new(0, 160, 0, 26)
        ValueCaptureBox.Position = UDim2.new(1, -176, 0.5, -11)
        ValueCaptureBox.BackgroundColor3 = Palette.InteractiveElement
        ValueCaptureBox.Text = tostring(LiveConfig[dataKey])
        ValueCaptureBox.TextColor3 = Palette.TextPrimary
        ValueCaptureBox.Font = Typography.FontMono
        ValueCaptureBox.TextSize = 12
        ValueCaptureBox.ClearTextOnFocus = false
        ValueCaptureBox.Parent = OptionRow
        InsertCorner(ValueCaptureBox, 4)
        local BoxStroke = InsertStroke(ValueCaptureBox, Palette.BorderColor, 1)

        ValueCaptureBox.Focused:Connect(function()
            TweenService:Create(ValueCaptureBox, TweenInfo.new(0.15), {BackgroundColor3 = Palette.InteractiveHover}):Play()
            BoxStroke.Color = Palette.AccentActive
        end)

        ValueCaptureBox.FocusLost:Connect(function()
            TweenService:Create(ValueCaptureBox, TweenInfo.new(0.15), {BackgroundColor3 = Palette.InteractiveElement}):Play()
            BoxStroke.Color = Palette.BorderColor
            
            local activeRawText = ValueCaptureBox.Text
            if type(LiveConfig[dataKey]) == "number" then
                local transformedNumber = tonumber(activeRawText)
                if transformedNumber then
                    LiveConfig[dataKey] = transformedNumber
                else
                    ValueCaptureBox.Text = tostring(LiveConfig[dataKey])
                end
            else
                LiveConfig[dataKey] = activeRawText
            end
        end)
    end

    local function InstantiateSelectionDropdown(containerFrame, dataKey, optionHeading, detailDescription, alternateArrayOptions)
        local OptionRow = Instance.new("Frame")
        OptionRow.Name = "OptionRow_" .. dataKey
        OptionRow.Size = UDim2.new(1, 0, 0, 55)
        OptionRow.BackgroundColor3 = Palette.CardBackground
        OptionRow.Parent = containerFrame
        InsertCorner(OptionRow, 6)
        InsertStroke(OptionRow, Palette.BorderFaint, 1)

        local HeadingLabel = Instance.new("TextLabel")
        HeadingLabel.Name = "HeadingLabel"
        HeadingLabel.Size = UDim2.new(0.6, 0, 0, 22)
        HeadingLabel.Position = UDim2.new(0, 16, 0, 8)
        HeadingLabel.BackgroundTransparency = 1
        HeadingLabel.Text = optionHeading
        HeadingLabel.TextColor3 = Palette.TextPrimary
        HeadingLabel.Font = Typography.FontRegular
        HeadingLabel.TextSize = 13
        HeadingLabel.TextXAlignment = Enum.TextXAlignment.Left
        HeadingLabel.Parent = OptionRow

        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Size = UDim2.new(0.6, 0, 0, 18)
        DescriptionLabel.Position = UDim2.new(0, 16, 0, 28)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Text = detailDescription
        DescriptionLabel.TextColor3 = Palette.TextMuted
        DescriptionLabel.Font = Typography.FontRegular
        DescriptionLabel.TextSize = 11
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.Parent = OptionRow

        local FrameSelectorButton = Instance.new("TextButton")
        FrameSelectorButton.Name = "FrameSelectorButton"
        FrameSelectorButton.Size = UDim2.new(0, 160, 0, 26)
        FrameSelectorButton.Position = UDim2.new(1, -176, 0.5, -11)
        FrameSelectorButton.BackgroundColor3 = Palette.InteractiveElement
        FrameSelectorButton.Text = tostring(LiveConfig[dataKey]):upper() .. "  ▼"
        FrameSelectorButton.TextColor3 = Palette.TextPrimary
        FrameSelectorButton.Font = Typography.FontRegular
        FrameSelectorButton.TextSize = 11
        FrameSelectorButton.AutoButtonColor = false
        FrameSelectorButton.Parent = OptionRow
        InsertCorner(FrameSelectorButton, 4)
        InsertStroke(FrameSelectorButton, Palette.BorderColor, 1)

        local ContextDropdownList = Instance.new("Frame")
        ContextDropdownList.Name = "ContextDropdownList"
        ContextDropdownList.Size = UDim2.new(1, 0, 0, #alternateArrayOptions * 26)
        ContextDropdownList.Position = UDim2.new(0, 0, 1, 4)
        ContextDropdownList.BackgroundColor3 = Palette.SidebarDepth
        ContextDropdownList.Visible = false
        ContextDropdownList.ZIndex = 500
        ContextDropdownList.Parent = FrameSelectorButton
        InsertCorner(ContextDropdownList, 4)
        InsertStroke(ContextDropdownList, Palette.BorderColor, 1)

        local DropdownUiList = Instance.new("UIListLayout")
        DropdownUiList.SortOrder = Enum.SortOrder.LayoutOrder
        DropdownUiList.Parent = ContextDropdownList

        for loopIdx, valueOptionName in ipairs(alternateArrayOptions) do
            local RowElementItem = Instance.new("TextButton")
            RowElementItem.Name = "RowElementItem_" .. valueOptionName
            RowElementItem.Size = UDim2.new(1, 0, 0, 26)
            RowElementItem.BackgroundColor3 = Palette.SidebarDepth
            RowElementItem.BackgroundTransparency = 1
            RowElementItem.Text = valueOptionName:upper()
            RowElementItem.TextColor3 = Palette.TextSecondary
            RowElementItem.Font = Typography.FontRegular
            RowElementItem.TextSize = 11
            RowElementItem.ZIndex = 501
            RowElementItem.AutoButtonColor = false
            RowElementItem.Parent = ContextDropdownList

            RowElementItem.MouseEnter:Connect(function()
                TweenService:Create(RowElementItem, TweenInfo.new(0.1), {BackgroundTransparency = 0, BackgroundColor3 = Palette.InteractiveElement, TextColor3 = Palette.TextPrimary}):Play()
            end)
            RowElementItem.MouseLeave:Connect(function()
                TweenService:Connect(RowElementItem, TweenInfo.new(0.1), {BackgroundTransparency = 1, TextColor3 = Palette.TextSecondary}):Play()
            end)

            RowElementItem.MouseButton1Click:Connect(function()
                LiveConfig[dataKey] = valueOptionName
                FrameSelectorButton.Text = valueOptionName:upper() .. "  ▼"
                ContextDropdownList.Visible = false
            end)
        end

        FrameSelectorButton.MouseButton1Click:Connect(function()
            ContextDropdownList.Visible = not ContextDropdownList.Visible
        end)
    end

    -- --------------------------------------------------------------------------
    -- 12. RUNTIME GRAPHICAL TARGET INSTANTIATION VIEWS
    -- --------------------------------------------------------------------------
    local Tab_Console = RouteViewTab("Dashboard Panel", 1)
    local Tab_Physical = RouteViewTab("Physical Geometry", 2)
    local Tab_Isolation = RouteViewTab("Tree Isolation", 3)
    local Tab_Scripts = RouteViewTab("Compiler Matrix", 4)
    local Tab_Infrastructure = RouteViewTab("Core Security", 5)

    -- VIEWPORT BUILDER: DASHBOARD PANEL PANEL
    local InfoDisplayBanner = Instance.new("Frame")
    InfoDisplayBanner.Name = "InfoDisplayBanner"
    InfoDisplayBanner.Size = UDim2.new(1, 0, 0, 110)
    InfoDisplayBanner.BackgroundColor3 = Palette.CardBackground
    InfoDisplayBanner.Parent = Tab_Console
    InsertCorner(InfoDisplayBanner, 8)
    InsertStroke(InfoDisplayBanner, Palette.BorderColor, 1)

    local InfoGraphicFrame = Instance.new("Frame")
    InfoGraphicFrame.Name = "InfoGraphicFrame"
    InfoGraphicFrame.Size = UDim2.new(0, 4, 1, -24)
    InfoGraphicFrame.Position = UDim2.new(0, 16, 0, 12)
    InfoGraphicFrame.BackgroundColor3 = Palette.AccentActive
    InfoGraphicFrame.BorderSizePixel = 0
    InfoGraphicFrame.Parent = InfoDisplayBanner
    InsertCorner(InfoGraphicFrame, 2)

    local FrameBannerTitle = Instance.new("TextLabel")
    FrameBannerTitle.Name = "FrameBannerTitle"
    FrameBannerTitle.Size = UDim2.new(1, -45, 0, 25)
    FrameBannerTitle.Position = UDim2.new(0, 32, 0, 12)
    FrameBannerTitle.BackgroundTransparency = 1
    FrameBannerTitle.Text = "READY TO INTIALIZE MAP EXTRACTION PROTOCOL"
    FrameBannerTitle.TextColor3 = Palette.TextPrimary
    FrameBannerTitle.Font = Typography.FontBold
    FrameBannerTitle.TextSize = 14
    FrameBannerTitle.TextXAlignment = Enum.TextXAlignment.Left
    FrameBannerTitle.Parent = InfoDisplayBanner

    local FrameBannerDesc = Instance.new("TextLabel")
    FrameBannerDesc.Name = "FrameBannerDesc"
    FrameBannerDesc.Size = UDim2.new(1, -45, 0, 55)
    FrameBannerDesc.Position = UDim2.new(0, 32, 0, 38)
    FrameBannerDesc.BackgroundTransparency = 1
    FrameBannerDesc.Text = "MXDCMPX provides structural extraction algorithms optimizing targeted scene geometry compilation, instance virtualization pipelines, and client execution threat management parameters safely. Modify operational array matrices via options tree before execution mapping."
    FrameBannerDesc.TextColor3 = Palette.TextSecondary
    FrameBannerDesc.Font = Typography.FontRegular
    FrameBannerDesc.TextSize = 11
    FrameBannerDesc.TextWrapped = true
    FrameBannerDesc.TextXAlignment = Enum.TextXAlignment.Left
    FrameBannerDesc.Parent = InfoDisplayBanner

    -- OPERATOR DYNAMIC REALTIME STATUS LOGGER PANEL
    local EmbeddedConsoleWindow = Instance.new("Frame")
    EmbeddedConsoleWindow.Name = "EmbeddedConsoleWindow"
    EmbeddedConsoleWindow.Size = UDim2.new(1, 0, 0, 215)
    EmbeddedConsoleWindow.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    EmbeddedConsoleWindow.Parent = Tab_Console
    InsertCorner(EmbeddedConsoleWindow, 6)
    InsertStroke(EmbeddedConsoleWindow, Palette.BorderColor, 1)

    local EmbeddedConsoleTitleBar = Instance.new("Frame")
    EmbeddedConsoleTitleBar.Name = "EmbeddedConsoleTitleBar"
    EmbeddedConsoleTitleBar.Size = UDim2.new(1, 0, 0, 30)
    EmbeddedConsoleTitleBar.BackgroundColor3 = Palette.SidebarDepth
    EmbeddedConsoleTitleBar.BorderSizePixel = 0
    EmbeddedConsoleTitleBar.Parent = EmbeddedConsoleWindow
    InsertCorner(EmbeddedConsoleTitleBar, 6)

    local EmbeddedConsoleTitleFix = Instance.new("Frame")
    EmbeddedConsoleTitleFix.Size = UDim2.new(1, 0, 0, 6)
    EmbeddedConsoleTitleFix.Position = UDim2.new(0, 0, 1, -6)
    EmbeddedConsoleTitleFix.BackgroundColor3 = Palette.SidebarDepth
    EmbeddedConsoleTitleFix.BorderSizePixel = 0
    EmbeddedConsoleTitleFix.Parent = EmbeddedConsoleTitleBar

    local EmbeddedConsoleLabel = Instance.new("TextLabel")
    EmbeddedConsoleLabel.Size = UDim2.new(1, -24, 1, 0)
    EmbeddedConsoleLabel.Position = UDim2.new(0, 12, 0, 0)
    EmbeddedConsoleLabel.BackgroundTransparency = 1
    EmbeddedConsoleLabel.Text = "SYSTEM ACTIVITY LOGGER PROCESS"
    EmbeddedConsoleLabel.TextColor3 = Palette.TextSecondary
    EmbeddedConsoleLabel.Font = Typography.FontBold
    EmbeddedConsoleLabel.TextSize = 11
    EmbeddedConsoleLabel.TextXAlignment = Enum.TextXAlignment.Left
    EmbeddedConsoleLabel.Parent = EmbeddedConsoleTitleBar

    local ScrollerConsoleArea = Instance.new("ScrollingFrame")
    ScrollerConsoleArea.Name = "ScrollerConsoleArea"
    ScrollerConsoleArea.Size = UDim2.new(1, -24, 1, -46)
    ScrollerConsoleArea.Position = UDim2.new(0, 12, 0, 36)
    ScrollerConsoleArea.BackgroundTransparency = 1
    ScrollerConsoleArea.BorderSizePixel = 0
    ScrollerConsoleArea.ScrollBarThickness = 2
    ScrollerConsoleArea.ScrollBarImageColor3 = Palette.InteractiveElement
    ScrollerConsoleArea.Parent = EmbeddedConsoleWindow

    local ScrollerConsoleLayout = Instance.new("UIListLayout")
    ScrollerConsoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ScrollerConsoleLayout.Padding = UDim.new(0, 4)
    ScrollerConsoleLayout.Parent = ScrollerConsoleArea

    local function AppendLogConsoleMessage(textMessage, isErrorMessage)
        local StringLogLine = Instance.new("TextLabel")
        StringLogLine.Size = UDim2.new(1, 0, 0, 18)
        StringLogLine.BackgroundTransparency = 1
        StringLogLine.Text = os.date("[%H:%M:%S] ") .. textMessage
        StringLogLine.TextColor3 = isErrorMessage and Palette.StateAlert or Palette.TextSecondary
        StringLogLine.Font = Typography.FontMono
        StringLogLine.TextSize = 11
        StringLogLine.TextXAlignment = Enum.TextXAlignment.Left
        StringLogLine.TextWrapped = true
        StringLogLine.Parent = ScrollerConsoleArea

        ScrollerConsoleArea.CanvasSize = UDim2.new(0, 0, 0, ScrollerConsoleLayout.AbsoluteContentSize.Y)
        ScrollerConsoleArea.CanvasPosition = Vector2.new(0, math.max(0, ScrollerConsoleLayout.AbsoluteContentSize.Y - ScrollerConsoleArea.AbsoluteWindowSize.Y))
    end

    AppendLogConsoleMessage("Framework Initialization Completed successfully.", false)
    AppendLogConsoleMessage("Awaiting operational configuration matrix profile instructions...", false)

    -- MASSIVE OPERATIONAL TRIGGER ACTION ACTION RUNNER BUTTON
    local PrimaryTriggerButton = Instance.new("TextButton")
    PrimaryTriggerButton.Name = "PrimaryTriggerButton"
    PrimaryTriggerButton.Size = UDim2.new(1, 0, 0, 45)
    PrimaryTriggerButton.BackgroundColor3 = Palette.AccentActive
    PrimaryTriggerButton.Text = "EXECUTE DISTRIBUTED CAPTURE MATRIX"
    PrimaryTriggerButton.TextColor3 = Palette.TextPrimary
    PrimaryTriggerButton.Font = Typography.FontBold
    PrimaryTriggerButton.TextSize = 14
    PrimaryTriggerButton.AutoButtonColor = false
    PrimaryTriggerButton.Parent = Tab_Console
    InsertCorner(PrimaryTriggerButton, 6)
    local PrimaryBtnStroke = InsertStroke(PrimaryTriggerButton, Palette.AccentGlow, 1)

    -- VIEWPORT BUILDER: PHYSICAL GEOMETRY CONFIGS
    InstantiateSelectionDropdown(Tab_Physical, "mode", "Extraction Algorithm Mode", "Select full pipeline architecture scope or targeted scripts parsing options optimization.", {"full", "optimized", "scripts"})
    InstantiateBooleanToggle(Tab_Physical, "NilInstances", "Decompress Nil-Indexed Hierarchy Memory Chunks", "Enforce full vector collection validation arrays targeting decoupled memory blocks inside nil parent allocation areas.")
    InstantiateBooleanToggle(Tab_Physical, "TreatUnionsAsParts", "Structural Realignment Extraction Fix (CSG To Parts)", "Forces unstable Constructive Solid Geometry block topologies to regular Part instances safely preventing invisible asset bugs.")
    InstantiateBooleanToggle(Tab_Physical, "IgnoreNotArchivable", "Ignore Archivable Property Constraints Flags", "Overrides instance engine constraints locks parsing unarchivable designated environments layers natively.")
    InstantiateBooleanToggle(Tab_Physical, "IgnoreDefaultProperties", "Strip Context Common Default Value Identifiers", "Saves execution workspace block footprints processing system overhead by ignoring baseline values.")

    -- VIEWPORT BUILDER: TREE ISOLATION CONFIGS
    InstantiateBooleanToggle(Tab_Isolation, "IsolateStarterPlayer", "Isolate StarterPlayer Environment Vectors", "Extracts StarterPlayer properties safely inside dedicated modular branch elements definitions arrays.")
    InstantiateBooleanToggle(Tab_Isolation, "IsolatePlayers", "Segregate Other Replicated Network Client Entities", "Moves external streaming human characters assets groups securely to temporary isolation files mappings layers.")
    InstantiateBooleanToggle(Tab_Isolation, "IsolateLocalPlayer", "Isolate Local Client Engine Context Environment", "Filters out local runtime interface data instances preventing environment cross profile leaks.")
    InstantiateBooleanToggle(Tab_Isolation, "IsolateLocalPlayerCharacter", "Isolate Local Physical Character Construct Rig", "Separates primary user asset nodes components securely during spatial tracking parsing loops sequence.")
    InstantiateBooleanToggle(Tab_Isolation, "SavePlayerCharacters", "Preserve Character Rig Layout Instances Configuration", "Retains functional physical player avatars structures representations inside generated project workspace map data trees.")
    InstantiateBooleanToggle(Tab_Isolation, "RemovePlayerCharacters", "Purge Replicated Avatars Rig Data Structures", "Completely destroys standard runtime player entity nodes trees objects layout representations directly pre-capture mapping.")

    -- VIEWPORT BUILDER: COMPILER MATRIX OPTIONS
    InstantiateBooleanToggle(Tab_Scripts, "Decompile", "Decompile Active Client Environment Scripts Context", "Processes binary bytecode stream architectures translating data layers safely down into clear human readable source text lines.")
    InstantiateBooleanToggle(Tab_Scripts, "noscripts", "Completely Evacuate Script Object Containers Instances", "Blocks script extraction operations completely producing clean data visual scene layout environments trees exclusively.")
    InstantiateBooleanToggle(Tab_Scripts, "SaveBytecode", "Preserve Binary Serialization Stream Objects Fallback", "Retains core protected script bytecode signatures dumps files maps if active decompilation structures return timeout indicators flags.")
    InstantiateBooleanToggle(Tab_Scripts, "scriptcache", "Optimize Redundant Compilation Caching Pools", "Accelerates processing loops indexing matching signatures modules preventing performance leaks.")
    InstantiateBooleanToggle(Tab_Scripts, "DecompileJobless", "Process Static Compiler Thread Jobs Only", "Bypasses engine runtime threads queues relying strictly onto internal precompiled signatures allocations maps natively.")
    InstantiateTextBoxInput(Tab_Scripts, "DecompileTimeout", "Decompiler Thread Processing Timeout Bound Limit", "Maximum elapsed milliseconds limit allowed per individual execution processing task routine before termination triggers.")

    -- VIEWPORT BUILDER: CORE SECURITY ARRAYS
    InstantiateBooleanToggle(Tab_Infrastructure, "SafeMode", "Anti-Heuristic Server-Side Detection Bypass Routine", "Instantly snaps the client application network state connection apart before intensive processing loops execution blocks anti-cheat logs.")
    InstantiateBooleanToggle(Tab_Infrastructure, "KillAllScripts", "Terminate Local Application Thread Executions", "Kills current runtime loops environments directly preventing live asset streaming alterations during system writes maps processing cycles.")
    InstantiateBooleanToggle(Tab_Infrastructure, "Anonymous", "Scrub Identity Signature Footprints Parameters", "Sweeps compiled XML tables data layers fields replacing personal profile keys parameters with generic clean hashes strings values safely.")
    InstantiateBooleanToggle(Tab_Infrastructure, "BoostFPS", "Pause 3D Context Context Engine Render Viewport", "Directs total hardware system clock speeds capability directly into parser processing routines by disabling graphic rendering calculations loops frames.")
    InstantiateBooleanToggle(Tab_Infrastructure, "AntiIdle", "Suppress Core Application Disconnection Timeout System", "Disables native idle constraints flags systems completely blocking the 20 minute execution application kick sequence.")
    InstantiateBooleanToggle(Tab_Infrastructure, "AvoidFileOverwrite", "Prevent Iterative Disk Project Destructive Overwrites", "Automatically tracks existing files configurations index allocations numbers incrementing target names integers safely.")
    InstantiateBooleanToggle(Tab_Infrastructure, "AlternativeWritefile", "Segmented Dynamic Append Multi-Stream Disk Writes", "Writes files streams contents to computer space iteratively in fragment slices preventing internal execution buffer memory crashes.")
    InstantiateTextBoxInput(Tab_Infrastructure, "FilePath", "Target Workspace Directory Designation Name File Path", "Specify custom string file name designation identification tags output variables mapping layout.")
    InstantiateTextBoxInput(Tab_Infrastructure, "SaveCacheInterval", "Memory Thread Cache Output Chunk Buffers Size Bounds", "Sets structural loop limits iterations constraints boundaries before firing memory arrays flushing vectors.")
    InstantiateBooleanToggle(Tab_Infrastructure, "ShowStatus", "Retain Native Core Status Tracking Display Overlays", "Render external overlay metrics logs interface display blocks during operational cycles processing.")
    InstantiateBooleanToggle(Tab_Infrastructure, "ReadMe", "Generate Supplemental Context Structural Information Logs Text", "Compiles comprehensive operational profiles settings tracker manifest documentation logs document along workspace save file.")
    InstantiateBooleanToggle(Tab_Infrastructure, "__DEBUG_MODE", "Enable Internal Verbose Engineering Console Logging Output", "Routes complete systemic trace errors logs signals down onto debugging developer console window screen panels interfaces.")

    -- --------------------------------------------------------------------------
    -- 13. INTERACTIVE MOUSE ROUTINE ANIMATIONS & RESPONSIVENESS HANDLERS
    -- --------------------------------------------------------------------------
    local function EstablishInteractiveFeedback(targetBtn, defaultBg, hoverBg, defaultText, hoverText)
        targetBtn.MouseEnter:Connect(function()
            TweenService:Create(targetBtn, TweenInfo.new(0.12), {BackgroundColor3 = hoverBg}):Play()
            if defaultText and hoverText and targetBtn:IsA("TextButton") then
                TweenService:Create(targetBtn, TweenInfo.new(0.12), {TextColor3 = hoverText}):Play()
            end
        end)
        targetBtn.MouseLeave:Connect(function()
            TweenService:Create(targetBtn, TweenInfo.new(0.12), {BackgroundColor3 = defaultBg}):Play()
            if defaultText and hoverText and targetBtn:IsA("TextButton") then
                TweenService:Create(targetBtn, TweenInfo.new(0.12), {TextColor3 = defaultText}):Play()
            end
        end)
    end

    EstablishInteractiveFeedback(MinimizeAction, Palette.InteractiveElement, Palette.InteractiveHover, Palette.TextSecondary, Palette.TextPrimary)
    EstablishInteractiveFeedback(CloseAction, Palette.InteractiveElement, Palette.StateAlert, Palette.StateAlert, Palette.TextPrimary)
    EstablishInteractiveFeedback(PrimaryTriggerButton, Palette.AccentActive, Color3.fromRGB(54, 130, 255), Palette.TextPrimary, Palette.TextPrimary)

    -- --------------------------------------------------------------------------
    -- 14. WINDOW EXECUTION STATE MANAGEMENT VISUAL LOGIC HANDLERS
    -- --------------------------------------------------------------------------
    MinimizeAction.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 880, 0, 0)}):Play()
        task.wait(0.25)
        MainFrame.Visible = false
        TinyAnchor.Visible = true
        TinyAnchor.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(TinyAnchor, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    end)

    AnchorInteractive.MouseButton1Click:Connect(function()
        TweenService:Create(TinyAnchor, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        TinyAnchor.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 880, 0, 540)}):Play()
    end)

    CloseAction.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 880, 0, 0)}):Play()
        task.wait(0.22)
        for _, connection in ipairs(DraggingConnections) do
            if connection then connection:Disconnect() end
        end
        RootCanvas:Destroy()
    end)

    -- --------------------------------------------------------------------------
    -- 15. PRIMARY INTEGRATED BACKEND ENGINE CALLBACK INTEGRATION HOOK
    -- --------------------------------------------------------------------------
    PrimaryTriggerButton.MouseButton1Click:Connect(function()
        PrimaryTriggerButton.Text = "INITIALIZING CORE DECOMPILER COMPILATION RUN ROUTINE..."
        PrimaryTriggerButton.BackgroundColor3 = Palette.InteractiveElement
        PrimaryTriggerButton.TextColor3 = Palette.TextMuted
        PrimaryBtnStroke.Color = Palette.BorderColor
        
        AppendLogConsoleMessage("Preparing architecture matrix system sequence dump parameters...", false)
        AppendLogConsoleMessage("Current File Destination String Target Token Set: '" .. tostring(LiveConfig.FilePath) .. "'", false)
        AppendLogConsoleMessage("Current Algorithmic Pipeline Operational Context Parameter Mode Set: " .. tostring(LiveConfig.mode):upper(), false)
        AppendLogConsoleMessage("Redirecting execution data array downstream directly to Engine module callback...", false)

        task.wait(0.8)

        local success, coreExecutionErrorSignal = pcall(function()
            StartCallback(LiveConfig)
        end)

        if success then
            AppendLogConsoleMessage("Downstream Engine validation complete. Routine parsing operational layers launched.", false)
            PrimaryTriggerButton.Text = "ROUTINE OPERATIONS PIPELINE SUCCESSFULLY ACTIVE"
            PrimaryTriggerButton.BackgroundColor3 = Palette.StateSuccess
            PrimaryTriggerButton.TextColor3 = Palette.WindowDepth
            PrimaryBtnStroke.Color = Palette.StateSuccess
            task.wait(3.5)
        else
            AppendLogConsoleMessage("CRITICAL ENGINE ERROR: " .. tostring(coreExecutionErrorSignal), true)
            PrimaryTriggerButton.Text = "SYSTEM FAILURE INTERACTION RECOVERY LOGGED"
            PrimaryTriggerButton.BackgroundColor3 = Palette.StateAlert
            PrimaryTriggerButton.TextColor3 = Palette.TextPrimary
            PrimaryBtnStroke.Color = Palette.StateAlert
            task.wait(4)
        end

        PrimaryTriggerButton.Text = "EXECUTE DISTRIBUTED CAPTURE MATRIX"
        PrimaryTriggerButton.BackgroundColor3 = Palette.AccentActive
        PrimaryTriggerButton.TextColor3 = Palette.TextPrimary
        PrimaryBtnStroke.Color = Palette.AccentGlow
    end)

    -- --------------------------------------------------------------------------
    -- 16. CHRONOLOGICAL APPLICATION BOOT INITIALIZATION SYSTEM PIPELINE
    -- --------------------------------------------------------------------------
    local function TriggerChronologicalInterfaceFlow()
        local operationalTimeDuration = 10
        local pollingRefreshCyclesFrequency = 60
        local processingTimeOffsetSequence = operationalTimeDuration / pollingRefreshCyclesFrequency

        local systemStatusMessagesStringsList = {
            "Allocating Secure Virtual Sandbox Environment Pipeline Matrix...",
            "Decrypting Native Memory Environment Allocation Headers Keys...",
            "Hooking Client Instantiation Geometry Replication Vectors Engine...",
            "Overriding Internal Threading Core Anti-Heuristic Detection Signatures...",
            "Allocating Memory Caching Arrays Pools Architecture Framework...",
            "Compiling Graphical Modular Components Rendering Engine Framework...",
            "System Integrity Validations Active. Initializing Suite Application Interface..."
        }

        for cycleIndex = 1, pollingRefreshCyclesFrequency do
            local currentCalculatedPercentageFloat = cycleIndex / pollingRefreshCyclesFrequency
            TweenService:Create(ProgressFill, TweenInfo.new(processingTimeOffsetSequence, Enum.EasingStyle.Linear), {Size = UDim2.new(currentCalculatedPercentageFloat, 0, 1, 0)}):Play()

            local dynamicIndexMessageSelection = math.clamp(math.floor(currentCalculatedPercentageFloat * #systemStatusMessagesStringsList) + 1, 1, #systemStatusMessagesStringsList)
            StatusConsole.Text = systemStatusMessagesStringsList[dynamicIndexMessageSelection]

            task.wait(processingTimeOffsetSequence)
        end

        TweenService:Create(LoadCanvas, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TweenService:Create(BrandLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        TweenService:Create(SubtitleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
        TweenService:Create(StatusConsole, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play()
        TweenService:Create(ProgressRail, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(ProgressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        TweenService:Create(RailGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()

        task.wait(0.45)
        LoadCanvas:Destroy()

        MainFrame.Size = UDim2.new(0, 880, 0, 0)
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 880, 0, 540)}):Play()
        
        -- Activate default initialization layout panel
        ActiveTabs["Dashboard Panel"].TextColor3 = Palette.TextPrimary
        ActiveTabs["Dashboard Panel"].BackgroundColor3 = Palette.InteractiveElement
        ActiveTabs["Dashboard Panel"].BackgroundTransparency = 0.4
        DisplayPanels["Dashboard Panel"].Visible = true
        TweenService:Create(ActiveTabs["Dashboard Panel"]:FindFirstChild("SelectionIndicatorDot"), TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end

    task.spawn(TriggerChronologicalInterfaceFlow)
end

return UI
-- ==============================================================================
-- END OF INTERFACE SOURCE CODE UNIT
-- ==============================================================================
