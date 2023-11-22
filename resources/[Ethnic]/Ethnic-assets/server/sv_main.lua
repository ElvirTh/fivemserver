CallbackModule, CommandsModule = nil, nil
local BlockedModels = {}

-- [ Code ] --

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        CommandsModule = exports['Ethnic-base']:FetchModule('Commands')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Commands ] --

    CommandsModule.Add({"me"}, "Character Expression", {{Name="message", Help="Message"}}, false, function(source, args)
        local Text = table.concat(args, ' ')
        TriggerClientEvent('Ethnic-misc/client/me', -1, source, Text)
    end)

    CommandsModule.Add("duty", "Duty Menu", {}, false, function(source, args)
        TriggerClientEvent('Ethnic-base/client/duty-menu', source)
    end, "admin")
    
    CallbackModule.CreateCallback('Ethnic-assets/server/get-dui-data', function(Source, Cb)
        Cb(Config.SavedDuiData)
    end)
end)

-- [ Threads ] --

-- Anti Peds / Vehs / Props
Citizen.CreateThread(function()
    BlockedModels = {}
    for _, Entities in pairs(Config.BlacklistedEntitys) do
        table.insert(BlockedModels, Entities)
    end
end)

AddEventHandler("entityCreating", function(Entity)
    for Hash, _ in pairs(BlockedModels) do
        if Hash and GetEntityModel(Entity) == Hash then
            CancelEvent()
            break
        end
    end
end)

-- [ Events ] --

RegisterNetEvent("Ethnic-assets/server/tackle-player", function(PlayerId)
    TriggerClientEvent("Ethnic-assets/client/get-tackled", PlayerId)
end)

RegisterNetEvent("Ethnic-assets/server/set-dui-url", function(DuiId, URL)
    TriggerClientEvent('Ethnic-assets/client/set-dui-url', -1, DuiId, URL)
end)

RegisterNetEvent('Ethnic-assets/server/set-dui-data', function(DuiId, DuiData)
    Config.SavedDuiData[DuiId] = DuiData
    TriggerClientEvent('Ethnic-assets/client/set-dui-data', -1, DuiId, Config.SavedDuiData[DuiId])
end)

RegisterNetEvent("Ethnic-assets/server/toggle-effect", function(TargetId, Effect, Bool)
    TriggerClientEvent("Ethnic-assets/client/toggle-effect", -1, TargetId, Effect, nil, Bool)
end)