Debt = {}

function Debt.Render()
    local Data = CallbackModule.SendCallback("Ethnic-phone/server/debts/get")
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderDebtApp", {
        Items = Data,
    })
end

RegisterNUICallback("Debt/GetDebt", function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/debts/get")
    Cb(Result)
end)

RegisterNUICallback("Debt/PayDebt", function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/debts/pay", Data)
    Cb(Result)
end)