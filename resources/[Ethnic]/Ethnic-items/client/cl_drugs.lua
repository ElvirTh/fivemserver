
RegisterNetEvent('Ethnic-items/client/used-joint', function()
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Smoking Joint..', 2000, false, false, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'joint', 1, false, true)
                if DidRemove then
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        TriggerEvent('Ethnic-animations/client/play-animation', 'smoke')
                    else
                        TriggerEvent('Ethnic-animations/client/play-animation', 'smokeweed')
                    end
                    if not RemovingStress then
                        RemovingStress = true
                        Citizen.CreateThread(function()
                            for i = 1, math.random(4, 6) do
                                EventsModule.TriggerServer('Ethnic-ui/server/set-stress', 'Remove', math.random(6, 7))
                                local CurrentArmor = GetPedArmour(PlayerPedId())
                                if CurrentArmor + 9 < 100 then
                                    SetPedArmour(PlayerPedId(), CurrentArmor + 9)
                                else
                                    SetPedArmour(PlayerPedId(), 100)
                                end
                                Citizen.Wait(2500)
                            end
                            TriggerEvent('Ethnic-hospital/client/save-vitals')
                            RemovingStress = false
                        end)
                        if not exports['Ethnic-police']:IsStatusAlreadyActive('redeyes') then
                            TriggerEvent('Ethnic-police/client/evidence/set-status', 'redeyes', 250)
                        end
                        if not exports['Ethnic-police']:IsStatusAlreadyActive('weedsmell') then
                            TriggerEvent('Ethnic-police/client/evidence/set-status', 'weedsmell', 250)
                        end
                    end
                end
            end
            exports['Ethnic-inventory']:SetBusyState(false)
        end)
    end)
end)