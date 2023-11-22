-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-illegal/client/open-dry-rack', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
        Citizen.SetTimeout(450, function()
            local IsBusy = CallbackModule.SendCallback('Ethnic-illegal/server/is-dryer-busy')
            if not IsBusy then    
                EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'dry-rack', 'Temp', 5, 1000)
            else
                TriggerEvent('Ethnic-ui/client/notify', "dryer-error", "The dryer is busy..", 'error')
            end
        end)
    end
end)

RegisterNetEvent('Ethnic-items/client/used-scales', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
        Citizen.SetTimeout(450, function()
            EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Scales Crafting', 'Crafting', 0, 0, Config.ScalesCrafting)
        end)
    end
end)