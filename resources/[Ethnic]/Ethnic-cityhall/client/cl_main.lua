PlayerModule, EventsModule, FunctionModule, CallbackModule = nil, nil, nil, nil
IsScanning = false

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(1250, function() 
        InitCityHall()
        InitCityZones()
    end)
end)

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Callback',
        'Functions'
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        FunctionModule = exports['Ethnic-base']:FetchModule('Functions')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-cityhall/client/gavel-hit', function()
    local Position = GetEntityCoords(PlayerPedId())
    EventsModule.TriggerServer('Ethnic-ui/server/play-sound-in-distance', {['Position'] = {[1] = Position.x, [2] = Position.y, [3] = Position.z}, ['Distance'] = 20.0, ['MaxDistance'] = 0.20, ['Name'] = 'gavel-hit', ['Volume'] = 0.4, ['Type'] = 'Spatial'})
end)

-- [ Functions ] --

function InitCityHall()
end

function MetalScanPlayer()
    local Player = exports['Ethnic-base']:FetchModule('Player').GetPlayerData()
    if (Player.Job.Name == 'police' or Player.Job.Name == 'ems' or Player.Job.Name == 'judge' and Player.Job.Duty) or IsScanning then
        return
    end

    IsScanning = true
    TriggerEvent('Ethnic-ui/client/play-sound', 'metal-detector', 0.6)
    TriggerEvent('Ethnic-chat/client/post-message', "Cityhall", 'All your objects have been stored.', 'warning')
    EventsModule.TriggerServer('Ethnic-inventory/server/move-items-to-stash', 'player-'..Player.CitizenId, 'cityhall-'..Player.CitizenId)
end

function LoadCourtScreen(Bool)
    local DuiData = exports['Ethnic-assets']:GenerateNewDui('https://i.imgur.com/5Ust2GQ.jpg', 1920, 1080, 'court-screen')
    if Bool then
        if DuiData == false then
            local SecondDuiData = exports['Ethnic-assets']:GetDuiData('court-screen')
            AddReplaceTexture('np_town_hall_bigscreen', 'projector_screen', SecondDuiData['TxdDictName'], SecondDuiData['TxdName'])
            exports['Ethnic-assets']:ActivateDui('court-screen')
        else
            AddReplaceTexture('np_town_hall_bigscreen', 'projector_screen', DuiData['TxdDictName'], DuiData['TxdName'])
        end
    else
        RemoveReplaceTexture('np_town_hall_bigscreen', 'projector_screen')
        exports['Ethnic-assets']:DeactivateDui('court-screen')
    end
end