--[[
    App: Crypto
]]

Crypto = {}

function Crypto.Render()
    local Cryptos = CallbackModule.SendCallback("Ethnic-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })
end

RegisterNUICallback("Crypto/Purchase", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-phone/server/purchase-crypto", Data['Data'])
    local Cryptos = CallbackModule.SendCallback("Ethnic-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })

    Cb(Success)
end)

RegisterNUICallback("Crypto/Exchange", function(Data, Cb)
    local Success = CallbackModule.SendCallback("Ethnic-phone/server/exchange-crypto", Data['Data'])
    local Cryptos = CallbackModule.SendCallback("Ethnic-base/server/get-crypto-data", 'all')
    local PlayerData = PlayerModule.GetPlayerData()
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderCryptoApp", {
        Cryptos = Cryptos,
        MyCryptos = PlayerData.Money.Crypto,
    })

    Cb(Success)
end)