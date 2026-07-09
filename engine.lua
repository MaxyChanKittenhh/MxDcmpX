-- engine.lua
local Engine = {}

function Engine.Save(IncomingConfig)
    local Params = { 
        RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/", 
        SSI = "saveinstance", 
    } 

    -- Master configuration block containing your absolute maxed-out settings
    local Options = {
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
        DecompileIgnore = {
            game:GetService("TextChatService")
        },
        
        SafeMode = true,
        KillAllScripts = true,
        Anonymous = true,
        BoostFPS = true,
        AntiIdle = true,
        ShutdownWhenDone = false,
        
        IgnoreList = {
            game:GetService("CoreGui"),
            game:GetService("CorePackages")
        },
        IgnoreProperties = {},
        NotCreatableFixes = {
            "", "Player", "PlayerScripts", "PlayerGui", "TouchTransmitter"
        },
        
        FilePath = "maxkittentuff",
        AvoidFileOverwrite = true,
        AlternativeWritefile = true,
        SaveCacheInterval = 56320,
        ShowStatus = true,
        ReadMe = true,
        __DEBUG_MODE = false,
        
        Object = game,
        IsModel = false,
        ExtraInstances = {},
        Callback = false,
        CopyToClipboard = false,
        Binary = false
    }

    -- Overwrite options dynamically based on live changes from your UI toggles
    if IncomingConfig and type(IncomingConfig) == "table" then
        for key, value in pairs(IncomingConfig) do
            Options[key] = value
        end
    end

    -- Download and execute the universal saveinstance environment safely
    local success, synsaveinstance = pcall(function()
        return loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
    end)

    if success then
        print("[MXDCMPX] Master Engine initialized successfully. Processing environment extraction...")
        synsaveinstance(Options)
    else
        warn("[MXDCMPX] Engine Error: Critical failure loading UniversalSynSaveInstance backend dependency.")
    end
end

return Engine
