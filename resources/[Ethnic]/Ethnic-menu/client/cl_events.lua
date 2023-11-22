local CurrentExpression = nil

-- [ Code ] --

-- [ Events] --

RegisterNetEvent('Ethnic-menu/client/walkstyle-clear', function()
    ResetPedMovementClipset(PlayerPedId(), 0.25)
    TriggerServerEvent('Ethnic-menu/server/set-walkstyle', 'None')
end)

RegisterNetEvent('Ethnic-menu/client/walkstyle', function(WalkStyle)
    RequestAnimSet(WalkStyle)
    while not HasAnimSetLoaded(WalkStyle) do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), WalkStyle, true)
    TriggerServerEvent('Ethnic-menu/server/set-walkstyle', WalkStyle)
end)

RegisterNetEvent("Ethnic-menu/client/expression", function(Expression)
    SetFacialIdleAnimOverride(PlayerPedId(), Expression, 0)
    CurrentExpression = Expression
end)

RegisterNetEvent("Ethnic-menu/client/expression-clear", function()
    CurrentExpression = nil
    ClearFacialIdleAnimOverride(PlayerPedId())
end)

RegisterNetEvent('Ethnic-menu/client/player-wink', function(IsPress)
    if IsPress then
        SetFacialIdleAnimOverride(PlayerPedId(), "pose_aiming_1", 0)
    else
        if CurrentExpression == nil then
            ClearFacialIdleAnimOverride(PlayerPedId())
        else
            SetFacialIdleAnimOverride(PlayerPedId(), CurrentExpression, 0)
        end
    end
end)

RegisterNetEvent('Ethnic-menu/client/send-panic-button', function(Type)
    local StreetLabel = exports['Ethnic-base']:FetchModule('Functions').GetStreetName()
    EventsModule.TriggerServer('Ethnic-ui/server/send-panic-button', StreetLabel, Type)
end)

RegisterNetEvent('Ethnic-menu/client/park-heli', function(Entity)
    local VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
    VehicleModule.DeleteVehicle(Entity)
end)

RegisterNetEvent('Ethnic-menu/client/park-policeveh', function(Entity)
    local VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
    VehicleModule.DeleteVehicle(Entity)
end)