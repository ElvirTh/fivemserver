--[[
    App: Employment
]]

Employment = {}

function Employment.Render()
    local Data = CallbackModule.SendCallback("Ethnic-phone/server/get-businesses-by-citizenid")
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderEmployedBusinesses", {
        CitizenId = PlayerModule.GetPlayerData().CitizenId,
        Businesses = Data,
    })
end

RegisterNUICallback("Employment/GetSpecificBusiness", function(Data, Cb)
    local Retval = CallbackModule.SendCallback("Ethnic-phone/server/get-specific-business", Data['Name'])
    Cb(Retval)
end)

RegisterNUICallback("Employment/CreateRank", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/create-rank", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/EditRank", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/edit-rank", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/RemoveRank", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/remove-rank", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/AddEmployee", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/add-employee", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/SetEmployeeRank", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/set-employee-rank", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/RemoveEmployee", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-business/server/remove-employee", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/ChargeCustomer", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-phone/server/employment/request-customer-charge", Data)
    Cb(Success)
end)

RegisterNUICallback("Employment/PayExternal", function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/employment/pay-external", Data)
    Cb(Result)
end)

RegisterNetEvent('Ethnic-phone/client/employment/pay-charge-customer', function(Data)
    TriggerServerEvent('Ethnic-phone/server/employment/pay-charge-customer', Data)
end)