-- [ Events] --

RegisterNetEvent("Ethnic-vehicles/server/mute-sirens", function(NetId)
    TriggerClientEvent('Ethnic-vehicles/client/mute-sirens', -1, NetId)
end)