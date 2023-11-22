--[[
    App: Dark
]]

Dark = {}

function Dark.Render()
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/dark/get-items")
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderDarkApp", {
        Items = Result or {},
    })
end

RegisterNUICallback('Dark/PurchaseItem', function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/dark/purchase", Data)
    Cb(Result)
end)

RegisterNetEvent('Ethnic-phone/client/dark/start-drop-off', function(Id)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/dark/get-drop-off-location", Id)
    if not Result then return end
    local NearCoords = false
    SetNewWaypoint(Result.Coords)
    local Blip = BlipModule.CreateBlip('dark-pickup', Result.Coords, 'Item Pickup', 586, 47, false, 1.0)
    while NearCoords == false do
        if #(GetEntityCoords(PlayerPedId()) - Result.Coords) < 1.0 then
            NearCoords = true
            EventsModule.TriggerServer('Ethnic-phone/server/dark/receive-drop-off', Id)
            BlipModule.RemoveBlip('dark-pickup')
        end
        Citizen.Wait(250)
    end
end)