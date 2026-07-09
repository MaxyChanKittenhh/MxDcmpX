-- init.lua
local BaseURL = "https://raw.githubusercontent.com/YOUR_USERNAME/MxDcmpX/main/"

-- 1. Load the Engine and UI modules directly from your GitHub
local Engine = loadstring(game:HttpGet(BaseURL .. "engine.lua"))()
local UI = loadstring(game:HttpGet(BaseURL .. "ui.lua"))()

-- 2. Initialize the UI and pass the Engine's Save function to it
-- (The UI will handle the configuration toggles and call this when "Start" is clicked)
UI.Init(function(CurrentConfig)
    Engine.Save(CurrentConfig)
end)
