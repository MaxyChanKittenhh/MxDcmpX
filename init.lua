-- We changed 'MxDcmp-Project' to 'MxDcmpX' right here:
local BaseURL = "https://raw.githubusercontent.com/MaxyChanKittenhh/MxDcmpX/main/"
local CacheBust = "?t=" .. tostring(os.time())

-- Fetching modules with forced cache-bypass
local Engine = loadstring(game:HttpGet(BaseURL .. "engine.lua" .. CacheBust))()
local UI = loadstring(game:HttpGet(BaseURL .. "ui.lua" .. CacheBust))()

-- Initialize framework linkage
UI.Init(function(CurrentConfig)
    Engine.Save(CurrentConfig)
end)
