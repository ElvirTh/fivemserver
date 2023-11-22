-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("Ethnic-grapple/server/do-rope", function(RopeId, Coords, Type)
    local src = source
    TriggerClientEvent('Ethnic-grapple/client/do-rope', -1, src, Type, RopeId, src, Coords)
end)