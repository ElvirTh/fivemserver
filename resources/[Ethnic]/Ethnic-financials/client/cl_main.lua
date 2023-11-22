CallbackModule, FunctionsModule, PlayerModule, EventsModule, KeybindsModule = nil, nil, nil, nil, nil

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        InitFinancials()
        InitZones()
    end)
end)

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Functions',
        'Player',
        'Events',
        'Keybinds',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        KeybindsModule = exports['Ethnic-base']:FetchModule('Keybinds')
    end)
end)

-- [ Code ] --

-- [ Events ] --

local SendedAlert = false
RegisterNetEvent('Ethnic-financials/client/open-banking', function(IsBank, Entity)
    Citizen.SetTimeout(450, function()
        local AnimDict, Animation, Title = 'amb@prop_human_atm@male@idle_a', 'idle_b', 'Inserting card..'
        if IsBank then
            AnimDict, Animation, Title = 'mp_common', 'givetake1_a', 'Showing bank documentation..'
        else
            TaskTurnPedToFaceEntity(PlayerPedId(), Entity, -1)
        end
        exports['Ethnic-ui']:ProgressBar(Title, 2000, {['AnimName'] = Animation, ['AnimDict'] = AnimDict, ['AnimFlag'] = 49}, nil, true, true, function(DidComplete)
            if DidComplete then
                local BankData = CallbackModule.SendCallback('Ethnic-financials/server/get-accounts')
                for AccountId, AccountData in pairs(BankData) do
                    if AccountData['Monitoring'] == 1 and not SendedAlert then
                        SendedAlert = true
                        local PlayerCoords = GetEntityCoords(PlayerPedId())
                        for k, v in pairs(Config.BankLocations) do
                            if #(PlayerCoords - v['Coords']) < 10.0 then
                                local StreetLabel = FunctionsModule.GetStreetName()
                                EventsModule.TriggerServer('Ethnic-ui/server/send-bank-monitor', StreetLabel)
                            end
                        end
                        EventsModule.TriggerServer('Ethnic-financials/server/monitor-account', AccountData)
                        SetTimeout(2000, function()
                            SendedAlert = false
                        end)
                    end
                end
                exports['Ethnic-ui']:SetNuiFocus(true, true)
                exports['Ethnic-ui']:SendUIMessage('Financials', 'OpenBank', {
                    ['IsBank'] = IsBank,
                    ['BankData'] = BankData
                })
            end
        end)
    end)
end)

-- [ Functions ] --

function InitFinancials()

end

function GetCurrentBankBalance(AccountId)
    local Balance = CallbackModule.SendCallback('Ethnic-financials/server/get-current-balance', AccountId)
    return Balance
end

RegisterNUICallback('Financials/ErrorSound', function(Data, Cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    Cb('Ok')
end)

RegisterNUICallback('Financials/Close', function(Data, Cb)
    exports['Ethnic-ui']:SetNuiFocus(false, false)
    local AnimDict, Animation, Title = 'amb@prop_human_atm@male@exit', 'exit', 'Retrieving Card..'
    if Data.IsAtBank then
        AnimDict, Animation, Title = 'mp_common', 'givetake1_a', 'Collecting documentation..'
    end
    exports['Ethnic-ui']:ProgressBar(Title, 1000, {['AnimName'] = Animation, ['AnimDict'] = AnimDict, ['AnimFlag'] = 49}, nil, false, true)
    Cb('Ok')
end)

RegisterNUICallback('Financials/Withdraw', function(Data, Cb)
    local IsDone = CallbackModule.SendCallback('Ethnic-financials/server/withdraw-money', Data)
    Cb(IsDone)
end)

RegisterNUICallback('Financials/Deposit', function(Data, Cb)
    local IsDone = CallbackModule.SendCallback('Ethnic-financials/server/deposit-money', Data)
    Cb(IsDone)
end)

RegisterNUICallback('Financials/Transfer', function(Data, Cb)
    local IsDone = CallbackModule.SendCallback('Ethnic-financials/server/transfer-money', Data)
    Cb(IsDone)
end)

RegisterNUICallback('Financials/GetAccounts', function(Data, Cb)
    local BankData = CallbackModule.SendCallback('Ethnic-financials/server/get-accounts')
    Cb(BankData)
end)

RegisterNUICallback('Financials/GetCash', function(Data, Cb)
    Cb(PlayerModule.GetPlayerData().Money['Cash'])
end)

exports("GetCurrentBankBalance", GetCurrentBankBalance)