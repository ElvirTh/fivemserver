EventsModule, CallbackModule, FunctionsModule, PlayerModule = nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Callback',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
    end)
end)

-- [ Code ] --

RegisterNetEvent('Ethnic-ui/client/ui-reset', function()
    exports['Ethnic-ui']:SendUIMessage("Mdw", "CloseMdw")
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-mdw/client/open-MDW', function(Data)
    local IsPublic = false
    if Data == nil or Data.Type == nil then IsPublic = true end
    exports['Ethnic-assets']:AttachProp('Laplet')
    FunctionsModule.RequestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.SetTimeout(50, function()
        exports['Ethnic-ui']:SetNuiFocus(true, true)
        exports['Ethnic-ui']:SendUIMessage('Mdw', 'OpenMobileData', {
            ['CitizenId'] = PlayerModule.GetPlayerData().CitizenId,
            ['IsPublic'] = IsPublic
        })
    end)
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('MDW/Close', function(Data, Cb)
    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    exports['Ethnic-ui']:SetNuiFocus(false, false)
    exports['Ethnic-assets']:RemoveProps('Laplet')
    Cb('Ok')
end)

RegisterNUICallback('MDW/Main/GetUser', function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-mdw/server/get-user", Data.CitizenId)
    Cb(Result)
end)

-- Dashboard
RegisterNUICallback('MDW/Dashboard/CreateAnnouncement', function(Data, Cb)
    EventsModule.TriggerServer('Ethnic-mdw/server/dashboard-create-announcement', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Announcements/GetAnnouncements', function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-mdw/server/dashboard/get-announcements")
    Cb(Result)
end)