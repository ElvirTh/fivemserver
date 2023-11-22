-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-heists/client/try-panel-hack', function(Data, Entity)
    Citizen.SetTimeout(450, function()
        if Data.Laptop == 'Green' then
            local Type = GetCurrentRobberyType()
            local BankData = Config.Panels[Type][Data.Panel] ~= nil and Config.Panels[Type][Data.Panel] or false
            if BankData ~= false and not BankData.Hacked and BankData.CanUsePanel then
                local StreetLabel = FunctionsModule.GetStreetName()
                EventsModule.TriggerServer('Ethnic-ui/server/send-bank-rob', StreetLabel)
                TriggerServerEvent('Ethnic-heists/server/banks/set-panel-state', 'Fleeca', Data.Panel, false)
                EventsModule.TriggerServer('Ethnic-inventory/server/degen-item', exports['Ethnic-inventory']:GetSlotForItem('heist-laptop-green'), 33.0)
                exports['Ethnic-ui']:MemoryMinigame(function(Outcome)
                    if Outcome then
                        TriggerEvent('Ethnic-ui/client/notify', "bankrob-success", "Be patient bitch", 'success')
                        local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'heist-laptop-green', 1, false, true)
                        Citizen.CreateThread(function()
                            Citizen.SetTimeout((1000 * 60) * 1.75, function()
                                SpawnTrolley(BankData.Trolly.Coords, 'Money')
                                TriggerServerEvent('Ethnic-heists/server/banks/set-hacked-state', 'Fleeca', Data.Panel, true)
                            end)
                        end)
                    else
                        TriggerServerEvent('Ethnic-heists/server/banks/set-panel-state', 'Fleeca', Data.Panel, true)
                        TriggerEvent('Ethnic-ui/client/notify', "bankrob-error", "Something went wrong! (You\'re a noob)", 'error')
                    end
                end)
            end
        end
    end)
end)