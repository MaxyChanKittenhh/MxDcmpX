-- engine.lua
local Engine = {}

function Engine.Save(Config)
    local Params = { 
        RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/", 
        SSI = "saveinstance", 
    } 
    
    -- Safely attempt to load the USSI script
    local success, synsaveinstance = pcall(function()
        return loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
    end)

    if success then
        print("[MXDCMPX] Engine loaded successfully. Starting extraction...")
        synsaveinstance(Config)
    else
        warn("[MXDCMPX] Engine Error: Failed to load UniversalSynSaveInstance.")
    end
end

return Engine
