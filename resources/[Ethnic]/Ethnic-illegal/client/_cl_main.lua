EntityModule, LoggerModule, EventsModule, CallbackModule, FunctionsModule, PlayerModule = nil

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Entity',
        'Logger',
        'Callback',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EntityModule = exports['Ethnic-base']:FetchModule("Entity")
        LoggerModule = exports['Ethnic-base']:FetchModule('Logger')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(1250, function()
        InitZones() InitPlants()
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-logout', function()
    RemoveAllPlants()
end)

-- [ Code ] --

-- [ Events ] --

local CanSell = true
RegisterNetEvent('Ethnic-illegal/client/sell-something', function()
    if not CanSell then return end
    EventsModule.TriggerServer('Ethnic-illegal/server/sell-something') 
    CanSell = false
    Citizen.SetTimeout(10000, function()
        CanSell = true
    end)
end)