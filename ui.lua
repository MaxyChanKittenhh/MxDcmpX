-- ==============================================================================
-- MXDCMPX ADVANCED USER INTERFACE COMPONENT
-- ==============================================================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local UI = {}

function UI.Init(OnConfigurationSaved)
    -- Prevent UI Layer Stacking
    if CoreGui:FindFirstChild("MXD_Framework_Canvas") then
        CoreGui.MXD_Framework_Canvas:Destroy()
    end
    if CoreGui:FindFirstChild("MXD_Loading_Canvas") then
        CoreGui.MXD_Loading_Canvas:Destroy()
    end

    -- ==========================================================================
    -- PHASE 1: PRE-LOAD SEQUENCE
    -- ==========================================================================
    local LoadingCanvas = Instance.new("ScreenGui")
    LoadingCanvas.Name = "MXD_Loading_Canvas"
    LoadingCanvas.DisplayOrder = 999
    LoadingCanvas.ResetOnSpawn = false
    LoadingCanvas.Parent = CoreGui

    local LoadingBackground = Instance.new("Frame")
    LoadingBackground.Name = "LoadingBackground"
    LoadingBackground.Size = UDim2.new(1, 0, 1, 0)
    LoadingBackground.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    LoadingBackground.BorderSizePixel = 0
    LoadingBackground.Parent = LoadingCanvas

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Name = "LoadingText"
    LoadingText.Size = UDim2.new(0, 400, 0, 50)
    LoadingText.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingText.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Text = "MXDCMPX"
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.Font = Enum.Font.BuilderSansExtraBold
    LoadingText.TextSize = 28
    LoadingText.TextLetterSpacing = 3
    LoadingText.TextTransparency = 1
    LoadingText.Parent = LoadingBackground

    -- Smoothly reveal loading display
    TweenService:Create(LoadingText, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(1.2)

    -- ==========================================================================
    -- PHASE 2: MAIN USER INTERFACE CORE
    -- ==========================================================================
    local MainCanvas = Instance.new("ScreenGui")
    MainCanvas.Name = "MXD_Framework_Canvas"
    MainCanvas.DisplayOrder = 100
    MainCanvas.ResetOnSpawn = false
    MainCanvas.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainCanvas.Parent = CoreGui

    -- Main Panel Container (Fixed Compact Proportions)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 680, 0, 420)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = MainCanvas

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(28, 28, 32)
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    MainStroke.Parent = MainFrame

    -- ==========================================================================
    -- PHASE 3: COMPONENT ARCHITECTURE - TOP BAR
    -- ==========================================================================
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarLine = Instance.new("Frame")
    TopBarLine.Name = "Line"
    TopBarLine.Size = UDim2.new(1, 0, 0, 1)
    TopBarLine.Position = UDim2.new(0, 0, 1, -1)
    TopBarLine.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    TopBarLine.BorderSizePixel = 0
    TopBarLine.Parent = TopBar

    -- Identity Container
    local ProfileLayout = Instance.new("UIListLayout")
    ProfileLayout.FillDirection = Enum.FillDirection.Horizontal
    ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ProfileLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ProfileLayout.Padding = UDim.new(0, 8)

    local ProfileContainer = Instance.new("Frame")
    ProfileContainer.Name = "ProfileContainer"
    ProfileContainer.Size = UDim2.new(0, 200, 1, 0)
    ProfileContainer.Position = UDim2.new(0, 16, 0, 0)
    ProfileContainer.BackgroundTransparency = 1
    ProfileContainer.Parent = TopBar
    ProfileLayout.Parent = ProfileContainer

    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Name = "UsernameLabel"
    UsernameLabel.Size = UDim2.new(0, 0, 1, 0)
    UsernameLabel.AutomaticSize = Enum.AutomaticSize.X
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Text = Players.LocalPlayer.Name
    UsernameLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
    UsernameLabel.Font = Enum.Font.GothamMedium
    UsernameLabel.TextSize = 13
    UsernameLabel.Parent = ProfileContainer

    local TagBadge = Instance.new("Frame")
    TagBadge.Name = "TagBadge"
    TagBadge.Size = UDim2.new(0, 50, 0, 18)
    TagBadge.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    TagBadge.Parent = ProfileContainer

    local TagCorner = Instance.new("UICorner")
    TagCorner.CornerRadius = UDim.new(0, 4)
    TagCorner.Parent = TagBadge

    local TagStroke = Instance.new("UIStroke")
    TagStroke.Color = Color3.fromRGB(40, 40, 45)
    TagStroke.Thickness = 1
    TagStroke.Parent = TagBadge

    local TagLabel = Instance.new("TextLabel")
    TagLabel.Name = "TagLabel"
    TagLabel.Size = UDim2.new(1, 0, 1, 0)
    TagLabel.BackgroundTransparency = 1
    TagLabel.Text = "Owner"
    TagLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
    TagLabel.Font = Enum.Font.GothamMedium
    TagLabel.TextSize = 10
    TagLabel.Parent = TagBadge

    -- Navigation Segment Core Buttons
    local NavIconContainer = Instance.new("Frame")
    NavIconContainer.Name = "NavIconContainer"
    NavIconContainer.Size = UDim2.new(0, 160, 1, 0)
    NavIconContainer.Position = UDim2.new(0.3, 0, 0, 0)
    NavIconContainer.BackgroundTransparency = 1
    NavIconContainer.Parent = TopBar

    local NavListLayout = Instance.new("UIListLayout")
    NavListLayout.FillDirection = Enum.FillDirection.Horizontal
    NavListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    NavListLayout.Padding = UDim.new(0, 14)
    NavListLayout.Parent = NavIconContainer

    local IconsList = {"Grid", "Users", "Megaphone", "Terminal", "Home"}
    for Index, IconName in ipairs(IconsList) do
        local IconBtn = Instance.new("ImageButton")
        IconBtn.Name = IconName .. "Icon"
        IconBtn.Size = UDim2.new(0, 16, 0, 16)
        IconBtn.BackgroundTransparency = 1
        IconBtn.Image = "rbxassetid://10734950309" -- Modular fallback high-res utility asset asset map
        IconBtn.ImageColor3 = (IconName == "Home") and Color3.fromRGB(240, 240, 245) or Color3.fromRGB(110, 110, 115)
        IconBtn.Parent = NavIconContainer
    end

    -- Clock Engine Frame
    local ClockFrame = Instance.new("Frame")
    ClockFrame.Name = "ClockFrame"
    ClockFrame.Size = UDim2.new(0, 65, 0, 22)
    ClockFrame.Position = UDim2.new(1, -145, 0.5, 0)
    ClockFrame.AnchorPoint = Vector2.new(0, 0.5)
    ClockFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    ClockFrame.Parent = TopBar

    local ClockCorner = Instance.new("UICorner")
    ClockCorner.CornerRadius = UDim.new(0, 11)
    ClockCorner.Parent = ClockFrame

    local ClockLabel = Instance.new("TextLabel")
    ClockLabel.Name = "ClockLabel"
    ClockLabel.Size = UDim2.new(1, 0, 1, 0)
    ClockLabel.BackgroundTransparency = 1
    ClockLabel.Text = os.date("%H:%M")
    ClockLabel.TextColor3 = Color3.fromRGB(160, 160, 165)
    ClockLabel.Font = Enum.Font.Code
    ClockLabel.TextSize = 11
    ClockLabel.Parent = ClockFrame

    -- Standardized Utility Control Panel System (Window Management)
    local WindowControls = Instance.new("Frame")
    WindowControls.Name = "WindowControls"
    WindowControls.Size = UDim2.new(0, 70, 1, 0)
    WindowControls.Position = UDim2.new(1, -80, 0, 0)
    WindowControls.BackgroundTransparency = 1
    WindowControls.Parent = TopBar

    local WindowLayout = Instance.new("UIListLayout")
    WindowLayout.FillDirection = Enum.FillDirection.Horizontal
    WindowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    WindowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    WindowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    WindowLayout.Padding = UDim.new(0, 10)
    WindowLayout.Parent = WindowControls

    local ControlClose = Instance.new("ImageButton")
    ControlClose.Name = "Close"
    ControlClose.Size = UDim2.new(0, 14, 0, 14)
    ControlClose.BackgroundTransparency = 1
    ControlClose.Image = "rbxassetid://10747373117"
    ControlClose.ImageColor3 = Color3.fromRGB(140, 140, 145)
    ControlClose.LayoutOrder = 3
    ControlClose.Parent = WindowControls

    local ControlMax = Instance.new("ImageButton")
    ControlMax.Name = "Maximize"
    ControlMax.Size = UDim2.new(0, 13, 0, 13)
    ControlMax.BackgroundTransparency = 1
    ControlMax.Image = "rbxassetid://10747375253"
    ControlMax.ImageColor3 = Color3.fromRGB(90, 90, 95)
    ControlMax.LayoutOrder = 2
    ControlMax.Parent = WindowControls

    local ControlDots = Instance.new("ImageButton")
    ControlDots.Name = "Options"
    ControlDots.Size = UDim2.new(0, 14, 0, 14)
    ControlDots.BackgroundTransparency = 1
    ControlDots.Image = "rbxassetid://10747383819"
    ControlDots.ImageColor3 = Color3.fromRGB(110, 110, 115)
    ControlDots.LayoutOrder = 1
    ControlDots.Parent = WindowControls

    -- ==========================================================================
    -- PHASE 4: COMPONENT ARCHITECTURE - SIDEBAR NAVIGATION PANEL
    -- ==========================================================================
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Size = UDim2.new(0, 160, 1, -45)
    SideBar.Position = UDim2.new(0, 0, 0, 45)
    SideBar.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    SideBar.BorderSizePixel = 0
    SideBar.Parent = MainFrame

    local SideBarLine = Instance.new("Frame")
    SideBarLine.Name = "Line"
    SideBarLine.Size = UDim2.new(0, 1, 1, 0)
    SideBarLine.Position = UDim2.new(1, -1, 0, 0)
    SideBarLine.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    SideBarLine.BorderSizePixel = 0
    SideBarLine.Parent = SideBar

    local TabButtonsContainer = Instance.new("Frame")
    TabButtonsContainer.Name = "TabButtonsContainer"
    TabButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.Parent = SideBar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.FillDirection = Enum.FillDirection.Vertical
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabButtonsContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 12)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabButtonsContainer

    -- ==========================================================================
    -- PHASE 5: COMPONENT ARCHITECTURE - PAGE MOUNTING INTERACTION PIPELINE
    -- ==========================================================================
    local ContentDisplay = Instance.new("Frame")
    ContentDisplay.Name = "ContentDisplay"
    ContentDisplay.Size = UDim2.new(1, -160, 1, -45)
    ContentDisplay.Position = UDim2.new(0, 160, 0, 45)
    ContentDisplay.BackgroundTransparency = 1
    ContentDisplay.Parent = MainFrame

    local DisplayPadding = Instance.new("UIPadding")
    DisplayPadding.PaddingTop = UDim.new(0, 16)
    DisplayPadding.PaddingLeft = UDim.new(0, 16)
    DisplayPadding.PaddingRight = UDim.new(0, 16)
    DisplayPadding.PaddingBottom = UDim.new(0, 16)
    DisplayPadding.Parent = ContentDisplay

    local StructuralPages = {}
    local ActiveTabTracker = nil

    local function GenerateStructuralPage(PageName)
        local PageFrame = Instance.new("Frame")
        PageFrame.Name = PageName .. "_Page"
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.BackgroundTransparency = 1
        PageFrame.Visible = false
        PageFrame.Parent = ContentDisplay
        StructuralPages[PageName] = PageFrame
        return PageFrame
    end

    -- Constructing Target Context Canvas Elements
    local HomePage = GenerateStructuralPage("Home")
    local AnnouncementsPage = GenerateStructuralPage("Announcements")
    local PlayersPage = GenerateStructuralPage("Players")
    local CommandsPage = GenerateStructuralPage("Commands")

    -- Clean Modern Elements for Home Content Initialization
    local WelcomeTitle = Instance.new("TextLabel")
    WelcomeTitle.Name = "WelcomeTitle"
    WelcomeTitle.Size = UDim2.new(1, 0, 0, 24)
    WelcomeTitle.BackgroundTransparency = 1
    WelcomeTitle.Text = "System Control Framework Active"
    WelcomeTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    WelcomeTitle.Font = Enum.Font.GothamMedium
    WelcomeTitle.TextSize = 16
    WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeTitle.Parent = HomePage

    -- Content Elements for Players Context Frame Setup
    local ServerSearchBox = Instance.new("TextBox")
    ServerSearchBox.Name = "ServerSearchBox"
    ServerSearchBox.Size = UDim2.new(0, 240, 0, 32)
    ServerSearchBox.Position = UDim2.new(0, 0, 1, -32)
    ServerSearchBox.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    ServerSearchBox.Text = ""
    ServerSearchBox.PlaceholderText = "Search in Server..."
    ServerSearchBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 85)
    ServerSearchBox.TextColor3 = Color3.fromRGB(220, 220, 225)
    ServerSearchBox.Font = Enum.Font.BuilderSans
    ServerSearchBox.TextSize = 12
    ServerSearchBox.Parent = PlayersPage

    local SearchBoxCorner = Instance.new("UICorner")
    SearchBoxCorner.CornerRadius = UDim.new(0, 6)
    SearchBoxCorner.Parent = ServerSearchBox

    local SearchBoxStroke = Instance.new("UIStroke")
    SearchBoxStroke.Color = Color3.fromRGB(32, 32, 38)
    SearchBoxStroke.Thickness = 1
    SearchBoxStroke.Parent = ServerSearchBox

    -- Core Execution Frame Pipeline
    local function TransitionPageContext(TargetName)
        for PageName, Frame in pairs(StructuralPages) do
            if PageName == TargetName then
                Frame.Visible = true
            else
                Frame.Visible = false
            end
        end
    end

    -- Generation Functional Logic For Sidebar Links Interface Elements
    local function ConstructTabItem(Name, Order)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Name = Name .. "_Tab"
        ButtonFrame.Size = UDim2.new(1, 0, 0, 34)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        ButtonFrame.BackgroundTransparency = 1
        ButtonFrame.LayoutOrder = Order
        ButtonFrame.Parent = TabButtonsContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = ButtonFrame

        local TargetClickButton = Instance.new("TextButton")
        TargetClickButton.Name = "Trigger"
        TargetClickButton.Size = UDim2.new(1, 0, 1, 0)
        TargetClickButton.BackgroundTransparency = 1
        TargetClickButton.Text = ""
        TargetClickButton.Parent = ButtonFrame

        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Name = "Label"
        ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
        ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
        ButtonLabel.BackgroundTransparency = 1
        -- Clean, legible font replacement to prevent old cursive style layout issues
        ButtonLabel.Text = Name
        ButtonLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
        ButtonLabel.Font = Enum.Font.BuilderSansMedium
        ButtonLabel.TextSize = 13
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        ButtonLabel.Parent = ButtonFrame

        -- Functional Verification Routine Linkage Setup
        local function SetSelectStatus(Selected)
            if Selected then
                ButtonFrame.BackgroundTransparency = 0
                ButtonFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonLabel.Font = Enum.Font.BuilderSansBold
            else
                ButtonFrame.BackgroundTransparency = 1
                ButtonLabel.TextColor3 = Color3.fromRGB(130, 130, 135)
                ButtonLabel.Font = Enum.Font.BuilderSansMedium
            end
        end

        TargetClickButton.MouseEnter:Connect(function()
            if ActiveTabTracker ~= Name then
                TweenService:Create(ButtonLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(200, 200, 205)}):Play()
            end
        end)

        TargetClickButton.MouseLeave:Connect(function()
            if ActiveTabTracker ~= Name then
                TweenService:Create(ButtonLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(130, 130, 135)}):Play()
            end
        end)

        TargetClickButton.MouseButton1Click:Connect(function()
            if ActiveTabTracker == Name then return end
            
            -- Cycle configuration nodes state context values
            for _, Element in ipairs(TabButtonsContainer:GetChildren()) do
                if Element:IsA("Frame") then
                    if Element.Name == Name .. "_Tab" then
                        Element.BackgroundTransparency = 0
                        Element.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
                        Element.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        Element.Label.Font = Enum.Font.BuilderSansBold
                    else
                        Element.BackgroundTransparency = 1
                        Element.Label.TextColor3 = Color3.fromRGB(130, 130, 135)
                        Element.Label.Font = Enum.Font.BuilderSansMedium
                    end
                end
            end
            
            ActiveTabTracker = Name
            TransitionPageContext(Name)
        end)

        return ButtonFrame
    end

    -- Mount Menu Tabs List Configuration Items 
    local HomeTab = ConstructTabItem("Home", 1)
    local AnnouncementsTab = ConstructTabItem("Announcements", 2)
    local PlayersTab = ConstructTabItem("Players", 3)
    local CommandsTab = ConstructTabItem("Commands", 4)

    -- Force default landing selection setup configuration rules profile layout system
    ActiveTabTracker = "Home"
    TransitionPageContext("Home")
    HomeTab.BackgroundTransparency = 0
    HomeTab.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    HomeTab.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    HomeTab.Label.Font = Enum.Font.BuilderSansBold

    -- ==========================================================================
    -- PHASE 6: COMPONENT ARCHITECTURE - MODAL POPUP DIALOG WINDOW SYSTEM
    -- ==========================================================================
    local ModalOverlay = Instance.new("Frame")
    ModalOverlay.Name = "ModalOverlay"
    ModalOverlay.Size = UDim2.new(1, 0, 1, 0)
    ModalOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    ModalOverlay.BackgroundTransparency = 1
    ModalOverlay.Visible = false
    ModalOverlay.ZIndex = 10
    ModalOverlay.Parent = MainFrame

    local ModalPopup = Instance.new("Frame")
    ModalPopup.Name = "ModalPopup"
    ModalPopup.Size = UDim2.new(0, 260, 0, 320)
    ModalPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
    ModalPopup.AnchorPoint = Vector2.new(0.5, 0.5)
    ModalPopup.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    ModalPopup.BorderSizePixel = 0
    ModalPopup.Parent = ModalOverlay

    local ModalCorner = Instance.new("UICorner")
    ModalCorner.CornerRadius = UDim.new(0, 8)
    ModalCorner.Parent = ModalPopup

    local ModalStroke = Instance.new("UIStroke")
    ModalStroke.Color = Color3.fromRGB(36, 36, 42)
    ModalStroke.Thickness = 1
    ModalStroke.Parent = ModalPopup

    local ModalClose = Instance.new("ImageButton")
    ModalClose.Name = "ModalClose"
    ModalClose.Size = UDim2.new(0, 14, 0, 14)
    ModalClose.Position = UDim2.new(1, -24, 0, 12)
    ModalClose.BackgroundTransparency = 1
    ModalClose.Image = "rbxassetid://10747373117"
    ModalClose.ImageColor3 = Color3.fromRGB(140, 140, 145)
    ModalClose.Parent = ModalPopup

    -- Operational verification action system mapping functions hooks
    local function ToggleModalState(VisibleState)
        if VisibleState then
            ModalOverlay.Visible = true
            TweenService:Create(ModalOverlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.4}):Play()
        else
            TweenService:Create(ModalOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
            task.delay(0.2, function()
                ModalOverlay.Visible = false
            end)
        end
    end

    ModalClose.MouseButton1Click:Connect(function()
        ToggleModalState(false)
    end)

    -- Bind Option Menu Dots Icon Button Trigger to open Modal Menu View
    ControlDots.MouseButton1Click:Connect(function()
        ToggleModalState(not ModalOverlay.Visible)
    end)

    -- ==========================================================================
    -- PHASE 7: DRAG ENGINE & BACKGROUND UTILITY THREADS LOGIC LAYER
    -- ==========================================================================
    local DraggingEnabled = false
    local DragInputSource = nil
    local DragStartPosition = nil
    local FrameStartPosition = nil

    TopBar.InputBegan:Connect(function(InputObj)
        if InputObj.UserInputType == Enum.UserInputType.MouseButton1 or InputObj.UserInputType == Enum.UserInputType.Touch then
            DraggingEnabled = true
            DragStartPosition = InputObj.Position
            FrameStartPosition = MainFrame.Position

            InputObj.Changed:Connect(function()
                if InputObj.UserInputState == Enum.UserInputState.End then
                    DraggingEnabled = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(InputObj)
        if InputObj.UserInputType == Enum.UserInputType.MouseMovement or InputObj.UserInputType == Enum.UserInputType.Touch then
            DragInputSource = InputObj
        end
    end)

    UserInputService.InputChanged:Connect(function(InputObj)
        if InputObj == DragInputSource and DraggingEnabled then
            local DeltaOffset = InputObj.Position - DragStartPosition
            local TargetPosition = UDim2.new(
                FrameStartPosition.X.Scale,
                FrameStartPosition.X.Offset + DeltaOffset.X,
                FrameStartPosition.Y.Scale,
                FrameStartPosition.Y.Offset + DeltaOffset.Y
            )
            TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = TargetPosition}):Play()
        end
    end)

    -- System Clock Run Loop Thread Logic
    task.spawn(function()
        while task.wait(1) do
            if not MainCanvas.Parent then break end
            ClockLabel.Text = os.date("%H:%M")
        end
    end)

    -- Framework Destructor Execution Window Mapping Hook Action Control
    ControlClose.MouseButton1Click:Connect(function()
        MainCanvas:Destroy()
    end)

    -- ==========================================================================
    -- PHASE 8: HANDSHAKE LIFECYCLE DEPLOYMENT SWITCH TERMINATION
    -- ==========================================================================
    -- Destroy loading elements safely to prevent stuck UI errors
    TweenService:Create(LoadingBackground, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    
    task.delay(0.4, function()
        LoadingCanvas:Destroy()
    end)

    -- Callback to engine verification pipeline components connection module layout
    if OnConfigurationSaved then
        OnConfigurationSaved({ InterfaceTheme = "DarkCarbon", CompiledBuild = 2026 })
    end
end

return UI
