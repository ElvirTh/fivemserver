-- [ Events ] --

RegisterNetEvent("Ethnic-vehicles/server/set-vehicle-purge", function(VehNet, Bool)
    TriggerClientEvent('Ethnic-vehicles/client/set-vehicle-purge', -1, VehNet, Bool)
end)

RegisterNetEvent("Ethnic-vehicles/server/set-vehicle-flames", function(VehNet, Bool)
    TriggerClientEvent('Ethnic-vehicles/client/set-vehicle-flames', -1, VehNet, Bool)
end)