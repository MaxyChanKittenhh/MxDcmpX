-- ==============================================================================
-- MXDCMPX | Advanced Map Extraction & Decompilation Suite
-- ==============================================================================
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==============================================================================
-- CLEANUP PREVIOUS INSTANCES
-- ==============================================================================
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "MXDCMPX_UI" then
        v:Destroy()
    end
end

-- ==============================================================================
-- THEME & SETTINGS TABLE
-- ==============================================================================
local Theme = {
    MainBackground = Color3.fromRGB(18, 18, 20),
    Sidebar = Color3.fromRGB(24, 24, 27),
    TopBar = Color3.fromRGB(20, 20, 23),
    Accent = Color3.fromRGB(255, 255, 255),
    TextPrimary = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(150, 150, 150),
    ToggleOn = Color3.fromRGB(60, 200, 100),
    ToggleOff = Color3.fromRGB(60, 60, 60),
    Font = Enum.Font.GothamMedium,
    TitleFont = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 12)
}

-- Current USSI Configuration State
local Config = {
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
    ShowStatus = true,
    ReadMe = true,
    __DEBUG_MODE = false
}

-- ==============================================================================
-- CORE GUI CREATION
-- ==============================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MXDCMPX_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- ==============================================================================
-- UTILITY FUNCTIONS
-- ==============================================================================
local function MakeDraggable(topbarObject, object)
    local Dragging = false
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = Position}):Play()
    end

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local function ApplyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or Theme.CornerRadius
    corner.Parent = parent
    return corner
end

local function ApplyStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- ==============================================================================
-- MINIMIZED ICON
-- ==============================================================================
local MinIcon = Instance.new("ImageButton")
MinIcon.Name = "MinIcon"
MinIcon.Size = UDim2.new(0, 50, 0, 50)
MinIcon.Position = UDim2.new(0.05, 0, 0.05, 0)
MinIcon.BackgroundColor3 = Theme.MainBackground
MinIcon.Visible = false
MinIcon.AutoButtonColor = false
MinIcon.Image = "rbxassetid://10886361498" -- Placeholder clean icon
MinIcon.ImageColor3 = Theme.Accent
MinIcon.Parent = ScreenGui
ApplyCorner(MinIcon, UDim.new(1, 0))
ApplyStroke(MinIcon, Color3.fromRGB(50, 50, 55), 2)
MakeDraggable(MinIcon, MinIcon)

-- ==============================================================================
-- MAIN WINDOW
-- ==============================================================================
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 850, 0, 500)
MainWindow.Position = UDim2.new(0.5, -425, 0.5, -250)
MainWindow.BackgroundColor3 = Theme.MainBackground
MainWindow.Visible = false
MainWindow.ClipsDescendants = true
MainWindow.Parent = ScreenGui
ApplyCorner(MainWindow)
ApplyStroke(MainWindow, Color3.fromRGB(40, 40, 45), 1)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundColor3 = Theme.TopBar
TopBar.Parent = MainWindow
ApplyCorner(TopBar)
MakeDraggable(TopBar, MainWindow)

-- Fix corner bleed for TopBar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Theme.TopBar
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MXDCMPX"
Title.TextColor3 = Theme.Accent
Title.Font = Theme.TitleFont
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- CLOCK
local Clock = Instance.new("TextLabel")
Clock.Size = UDim2.new(0, 100, 1, 0)
Clock.Position = UDim2.new(0.5, -50, 0, 0)
Clock.BackgroundTransparency = 1
Clock.TextColor3 = Theme.TextSecondary
Clock.Font = Theme.Font
Clock.TextSize = 14
Clock.Parent = TopBar

task.spawn(function()
    while task.wait(1) do
        local date = os.date("*t")
        Clock.Text = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
    end
end)

-- WINDOW CONTROLS
local Controls = Instance.new("Frame")
Controls.Size = UDim2.new(0, 100, 1, 0)
Controls.Position = UDim2.new(1, -110, 0, 0)
Controls.BackgroundTransparency = 1
Controls.Parent = TopBar

local UIListLayout_Controls = Instance.new("UIListLayout")
UIListLayout_Controls.FillDirection = Enum.FillDirection.Horizontal
UIListLayout_Controls.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIListLayout_Controls.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout_Controls.Padding = UDim.new(0, 10)
UIListLayout_Controls.Parent = Controls

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundColor3 = Theme.TopBar
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Controls
ApplyCorner(CloseBtn, UDim.new(1, 0))

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.TextPrimary
MinBtn.BackgroundColor3 = Theme.TopBar
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = Controls
ApplyCorner(MinBtn, UDim.new(1, 0))

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 850, 0, 0)}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 850, 0, 0)}):Play()
    task.wait(0.3)
    MainWindow.Visible = false
    MinIcon.Visible = true
    MinIcon.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(MinIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)

MinIcon.MouseButton1Click:Connect(function()
    TweenService:Create(MinIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    MinIcon.Visible = false
    MainWindow.Visible = true
    TweenService:Create(MainWindow, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 850, 0, 500)}):Play()
end)

-- ==============================================================================
-- SIDEBAR & TABS
-- ==============================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 220, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainWindow

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

local SidebarList = Instance.new("UIListLayout")
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Padding = UDim.new(0, 8)
SidebarList.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -220, 1, -45)
ContentArea.Position = UDim2.new(0, 220, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainWindow

local Tabs = {}
local TabFrames = {}

local function CreateTab(name, layoutOrder)
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.BackgroundColor3 = Theme.Sidebar
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Theme.TextSecondary
    TabBtn.Font = Theme.Font
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.LayoutOrder = layoutOrder
    TabBtn.Parent = Sidebar
    ApplyCorner(TabBtn, UDim.new(0, 8))
    
    -- Tab Frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Size = UDim2.new(1, -30, 1, -30)
    TabFrame.Position = UDim2.new(0, 15, 0, 15)
    TabFrame.BackgroundTransparency = 1
    TabFrame.ScrollBarThickness = 4
    TabFrame.ScrollBarImageColor3 = Theme.TextSecondary
    TabFrame.Visible = false
    TabFrame.Parent = ContentArea
    
    local FrameList = Instance.new("UIListLayout")
    FrameList.SortOrder = Enum.SortOrder.LayoutOrder
    FrameList.Padding = UDim.new(0, 10)
    FrameList.Parent = TabFrame
    
    local FramePadding = Instance.new("UIPadding")
    FramePadding.PaddingRight = UDim.new(0, 10)
    FramePadding.Parent = TabFrame

    Tabs[name] = TabBtn
    TabFrames[name] = TabFrame

    TabBtn.MouseButton1Click:Connect(function()
        for tName, btn in pairs(Tabs) do
            btn.TextColor3 = Theme.TextSecondary
            btn.BackgroundColor3 = Theme.Sidebar
            TabFrames[tName].Visible = false
        end
        TabBtn.TextColor3 = Theme.Accent
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        TabFrame.Visible = true
    end)

    return TabFrame
end

-- ==============================================================================
-- UI COMPONENTS (TOGGLES)
-- ==============================================================================
local function CreateToggle(parent, settingName, labelText)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    Container.Parent = parent
    ApplyCorner(Container, UDim.new(0, 6))

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.TextColor3 = Theme.TextPrimary
    Label.Font = Theme.Font
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -65, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Config[settingName] and Theme.ToggleOn or Theme.ToggleOff
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Container
    ApplyCorner(ToggleBtn, UDim.new(1, 0))

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.Position = Config[settingName] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Parent = ToggleBtn
    ApplyCorner(Indicator, UDim.new(1, 0))

    ToggleBtn.MouseButton1Click:Connect(function()
        Config[settingName] = not Config[settingName]
        local state = Config[settingName]
        
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
    end)
end

-- ==============================================================================
-- POPULATING TABS
-- ==============================================================================
local Frame_Dashboard = CreateTab("Dashboard", 1)
local Frame_Core = CreateTab("Core Map Options", 2)
local Frame_Scripts = CreateTab("Script Decompilation", 3)
local Frame_Safety = CreateTab("Safety & System", 4)

-- DASHBOARD TAB
local WelcomeCard = Instance.new("Frame")
WelcomeCard.Size = UDim2.new(1, 0, 0, 100)
WelcomeCard.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
WelcomeCard.Parent = Frame_Dashboard
ApplyCorner(WelcomeCard)

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -30, 1, 0)
WelcomeText.Position = UDim2.new(0, 15, 0, 0)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome to MXDCMPX.\nConfigure your instance extraction settings using the sidebar, then execute the protocol below."
WelcomeText.TextColor3 = Theme.TextPrimary
WelcomeText.Font = Theme.Font
WelcomeText.TextSize = 14
WelcomeText.TextWrapped = true
WelcomeText.TextXAlignment = Enum.TextXAlignment.Left
WelcomeText.Parent = WelcomeCard

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, 0, 0, 50)
StartBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
StartBtn.Text = "EXECUTE DECOMPILATION"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 16
StartBtn.Parent = Frame_Dashboard
ApplyCorner(StartBtn)
ApplyStroke(StartBtn, Color3.fromRGB(80, 140, 255), 2)

-- CORE OPTIONS TAB
CreateToggle(Frame_Core, "NilInstances", "Capture Nil Instances (StreamingEnabled)")
CreateToggle(Frame_Core, "TreatUnionsAsParts", "Treat Unions As Parts (Fix Invisible Walls)")
CreateToggle(Frame_Core, "IgnoreNotArchivable", "Ignore Archivable Property Constraints")
CreateToggle(Frame_Core, "IgnoreDefaultProperties", "Ignore Default Properties (Optimizes Size)")
CreateToggle(Frame_Core, "IsolatePlayers", "Isolate Other Players into Folder")
CreateToggle(Frame_Core, "SavePlayerCharacters", "Save Player Character Models")

-- SCRIPT OPTIONS TAB
CreateToggle(Frame_Scripts, "Decompile", "Enable Script Decompilation")
CreateToggle(Frame_Scripts, "noscripts", "Disable ALL Script Saving")
CreateToggle(Frame_Scripts, "SaveBytecode", "Save Raw Bytecode as Backup")
CreateToggle(Frame_Scripts, "scriptcache", "Cache Duplicate Scripts (Performance)")
CreateToggle(Frame_Scripts, "DecompileJobless", "Decompile Jobless (Pre-Compiled Only)")

-- SAFETY & SYSTEM TAB
CreateToggle(Frame_Safety, "SafeMode", "SafeMode (Auto-Kick to Prevent Bans)")
CreateToggle(Frame_Safety, "BoostFPS", "Boost FPS (Pauses 3D Rendering)")
CreateToggle(Frame_Safety, "Anonymous", "Anonymous Mode (Scrub User Info)")
CreateToggle(Frame_Safety, "KillAllScripts", "Kill Client Scripts Before Extracting")
CreateToggle(Frame_Safety, "AntiIdle", "Bypass 20-Minute AFK Kick")
CreateToggle(Frame_Safety, "AvoidFileOverwrite", "Avoid Overwriting Existing Save Files")
CreateToggle(Frame_Safety, "AlternativeWritefile", "Alternative Write (Prevents Crashes)")
CreateToggle(Frame_Safety, "ShutdownWhenDone", "Shutdown Roblox Client When Finished")

-- Set default active tab
Tabs["Dashboard"].TextColor3 = Theme.Accent
Tabs["Dashboard"].BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TabFrames["Dashboard"].Visible = true

-- ==============================================================================
-- ENGINE EXECUTION LOGIC
-- ==============================================================================
StartBtn.MouseButton1Click:Connect(function()
    StartBtn.Text = "INITIALIZING..."
    StartBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    
    local Params = { 
        RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/", 
        SSI = "saveinstance", 
    } 
    
    local success, synsaveinstance = pcall(function()
        return loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
    end)
    
    if success then
        StartBtn.Text = "RUNNING PROTOCOL..."
        synsaveinstance(Config)
        task.wait(2)
        StartBtn.Text = "EXECUTE DECOMPILATION"
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
    else
        StartBtn.Text = "ERROR LOADING USSI MODULE"
        StartBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(3)
        StartBtn.Text = "EXECUTE DECOMPILATION"
        StartBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
    end
end)

-- ==============================================================================
-- LOADING SCREEN (10 SECONDS)
-- ==============================================================================
local LoadScreen = Instance.new("Frame")
LoadScreen.Size = UDim2.new(1, 0, 1, 0)
LoadScreen.BackgroundColor3 = Theme.MainBackground
LoadScreen.ZIndex = 100
LoadScreen.Parent = ScreenGui

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(0, 300, 0, 50)
LoadTitle.Position = UDim2.new(0.5, -150, 0.5, -60)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "MXDCMPX"
LoadTitle.TextColor3 = Theme.Accent
LoadTitle.Font = Theme.TitleFont
LoadTitle.TextSize = 40
LoadTitle.ZIndex = 101
LoadTitle.Parent = LoadScreen

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 300, 0, 20)
SubTitle.Position = UDim2.new(0.5, -150, 0.5, -10)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Initializing Engine..."
SubTitle.TextColor3 = Theme.TextSecondary
SubTitle.Font = Theme.Font
SubTitle.TextSize = 14
SubTitle.ZIndex = 101
SubTitle.Parent = LoadScreen

local BarBG = Instance.new("Frame")
BarBG.Size = UDim2.new(0, 400, 0, 6)
BarBG.Position = UDim2.new(0.5, -200, 0.5, 30)
BarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
BarBG.ZIndex = 101
BarBG.Parent = LoadScreen
ApplyCorner(BarBG, UDim.new(1, 0))

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(40, 100, 255)
BarFill.ZIndex = 102
BarFill.Parent = BarBG
ApplyCorner(BarFill, UDim.new(1, 0))

-- Pulse Animation for Title
local pulseTween = TweenService:Create(LoadTitle, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {TextTransparency = 0.5})
pulseTween:Play()

-- 10 Second Fill Animation
local fillTween = TweenService:Create(BarFill, TweenInfo.new(10, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
fillTween:Play()

-- Status Text Updates during 10 seconds
task.spawn(function()
    task.wait(2)
    SubTitle.Text = "Bypassing Security Protocols..."
    task.wait(3)
    SubTitle.Text = "Loading UI Framework..."
    task.wait(2.5)
    SubTitle.Text = "Fetching USSI Assets..."
    task.wait(2.5)
    SubTitle.Text = "Ready."
end)

-- Finish Loading
fillTween.Completed:Connect(function()
    pulseTween:Cancel()
    local fadeOut = TweenService:Create(LoadScreen, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    TweenService:Create(LoadTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(SubTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(BarBG, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    fadeOut:Play()
    fadeOut.Completed:Connect(function()
        LoadScreen:Destroy()
        
        -- Reveal Main Window
        MainWindow.Size = UDim2.new(0, 850, 0, 0)
        MainWindow.Visible = true
        TweenService:Create(MainWindow, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 850, 0, 500)}):Play()
    end)
end)
