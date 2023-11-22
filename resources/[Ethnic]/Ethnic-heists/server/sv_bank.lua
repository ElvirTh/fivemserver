
-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    EventsModule.RegisterServer("Ethnic-heists/server/banks/receive-trolly-goods", function(Source, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Type == 'Fleeca' then
            Player.Functions.AddItem('cash-rolls', math.random(5, 20), false, false, true)
            Player.Functions.AddItem('markedbills', 1, false, {Worth = math.random(8000, 13000)}, true)
        end
    end)

    EventsModule.RegisterServer("Ethnic-heists/server/vault/set-hit-status", function(Source, Type)
        if Config.Panels['Pacific'][Type] ~= nil then
            Config.Panels['Pacific'][Type]['HasBeenHit'] = true
        end
    end)

    CallbackModule.CreateCallback('Ethnic-heists/server/vault/get-hits', function(Source, Cb)
        local Hits = {}
        for PanelId, PanelData in pairs(Config.Panels['Pacific']) do
            Hits[PanelId] = PanelData['HasBeenHit']
        end
        Cb(Hits)
    end)

    CallbackModule.CreateCallback('Ethnic-heists/server/vault/can-hit', function(Source, Cb, Type)
        if Config.Panels['Pacific'][Type] ~= nil then
            Cb(Config.Panels['Pacific'][Type]['HasBeenHit'])
        else
            Cb(false)
        end
    end)
end)

-- [ Events ] --

-- Fleeca

RegisterNetEvent("Ethnic-heists/server/banks/set-panel-state", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['CanUsePanel'] = Bool
    TriggerClientEvent('Ethnic-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

RegisterNetEvent("Ethnic-heists/server/banks/set-hacked-state", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['Hacked'] = Bool
    TriggerClientEvent('Ethnic-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

RegisterNetEvent("Ethnic-heists/server/banks/set-trolly-busy", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['Trolly']['Busy'] = Bool
    TriggerClientEvent('Ethnic-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

-- Vault


-- Thermite

RegisterNetEvent("Ethnic-heists/server/thermite-syncFx", function(Coords, Detcord)
    TriggerClientEvent('Ethnic-heists/client/thermite/sync-fx', -1, Coords, Detcord)
end)