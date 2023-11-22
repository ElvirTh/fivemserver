local PowerBox, PowerBoxCoords = GetHashKey('prop_elecbox_24b'), vector3(712.33, 166.22, 79.75)
local ExplodeCoords = vector3(711.92, 165.39, 80.74)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-base/client/target-changed', function(Entity, EntityType, EntityCoords)
    local Timeout = false
    if Entity ~= 0 and Entity ~= -1 and EntityType == 3 then
        local TargetModel = GetEntityModel(Entity)
        Citizen.SetTimeout(10000, function() Timeout = true end)
        if TargetModel == PowerBox and not exports['Ethnic-weathersync']:BlackoutActive() and not Timeout then
            while #(PowerBoxCoords - GetEntityCoords(PlayerPedId())) > 6.0 do
                Citizen.Wait(10)
            end
            TriggerEvent('Ethnic-ui/client/notify', "powerplant-error", "Be a real shame if this exploded...", 'error')
        end
    end
end)

RegisterNetEvent('Ethnic-heists/client/try-bomb-power-panel', function()
    if exports['Ethnic-weathersync']:BlackoutActive() then
        TriggerEvent('Ethnic-ui/client/notify', "powerplant-error", "The city power is out..", 'error')
        return
    end
    if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('weapon_stickybomb') then
        TriggerEvent('Ethnic-ui/client/notify', "powerplant-error", "Maybe you should hold bomb in your hands first..", 'error')
        return
    end
    exports['Ethnic-inventory']:SetBusyState(true)
    TaskPlantBomb(PlayerPedId(), PowerBoxCoords.x, PowerBoxCoords.y, PowerBoxCoords.z, 80.75)
    local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'weapon_stickybomb', 1, false, true)
    Citizen.SetTimeout(800, function()
        TriggerEvent('Ethnic-ui/client/notify', "powerplant-error", "Bomb will explode in 20 seconds..", 'error', 7000)
        exports['Ethnic-inventory']:SetBusyState(false)
        TriggerEvent('Ethnic-inventory/client/reset-weapon')
        Citizen.Wait(20000)
        AddExplosion(ExplodeCoords.x, ExplodeCoords.y, ExplodeCoords.z, EXPLOSION_STICKYBOMB, 15.0, true, false, 10.0)
        EventsModule.TriggerServer('Ethnic-weathersync/server/set-blackout')
        EventsModule.TriggerServer('Ethnic-ui/server/send-suspicious', FunctionsModule.GetStreetName())
        if not exports['Ethnic-police']:IsStatusAlreadyActive('explosive') then
            TriggerEvent('Ethnic-police/client/evidence/set-status', 'explosive', 350)
        end
    end)
end)