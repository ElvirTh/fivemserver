local MessagesCount, CanStealShoes = 0, true
EventsModule, CallbackModule, FunctionsModule, PlayerModule, EntityModule, VehicleModule = nil, nil, nil, nil, nil, nil
CurrentCops = 0

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        local GoPros = CallbackModule.SendCallback("Ethnic-misc/server/gopros/get-all")
        Config.GoPros = GoPros
        InitGoPros()
        InitMiscZones()
        InitTea()
    end)
end)

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Callback',
        'Functions',
        'Entity',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        EntityModule = exports['Ethnic-base']:FetchModule('Entity')
        VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("Ethnic-police/set-cop-count", function(Amount)
    CurrentCops = Amount
end)

RegisterNetEvent('Ethnic-misc/client/steal-target-shoes', function(Data)
    if CanStealShoes then
        CanStealShoes = false
        FunctionsModule.RequestAnimDict("random@domestic")
        TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
        Citizen.Wait(1400)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('Ethnic-clothing/server/steal-shoes', Data.ServerId, Data.ToShoes)
        Citizen.SetTimeout(2000, function()
            CanStealShoes = true
        end)
    else
        exports['Ethnic-ui']:Notify("misc-error", "I don\'t think so..", 'error')
    end
end)

RegisterNetEvent('Ethnic-misc/client/open-scav-box', function(BoxId)
    if BoxId == nil then return end
    Citizen.SetTimeout(450, function()
        if exports['Ethnic-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', BoxId, 'Stash', 25, 500, 'scavbox')
        end
    end)
end)

RegisterNetEvent('Ethnic-misc/client/do-yoga', function(Nothing, Entity)
    local EntityCoords, EntityHeading = GetEntityCoords(Entity), GetEntityHeading(Entity)
    TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_YOGA", EntityCoords.x, EntityCoords.y, EntityCoords.z, (EntityHeading + 90.0), 20000, false, true)
    exports['Ethnic-ui']:ProgressBar('Breathe In..', 20000, false, false, true, false, function(DidComplete)
        if DidComplete then
            EventsModule.TriggerServer('Ethnic-ui/server/set-stress', 'Remove', math.random(15, 20))
        end
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('Ethnic-misc/client/used-dice', function()
    Citizen.SetTimeout(450, function()
        local Data = {{Name = 'Amount', Label = 'Dices Amount (1-20)', Icon = 'fas fa-dice'}, {Name = 'Sides', Label = 'Dice Sides (1-6)', Icon = 'fas fa-dice'}}
        local DiceInput = exports['Ethnic-ui']:CreateInput(Data)
        if DiceInput['Amount'] and tonumber(DiceInput['Amount']) <= 20 and DiceInput['Sides'] and tonumber(DiceInput['Sides']) <= 6 then
            local DiceResult = {}
            for i = 1, DiceInput['Amount'] do
                table.insert(DiceResult, math.random(1, DiceInput['Sides']))
            end
            TriggerEvent('Ethnic-assets/client/dice-animation')
            local RollText = CreateRollText(DiceResult, DiceInput['Sides'])
            Citizen.SetTimeout(1900, function()
                EventsModule.TriggerServer('Ethnic-ui/server/play-sound-in-distance', {['Distance'] = 2.0, ['Type'] = 'Distance', ['Name'] = 'dice', ['Volume'] = 0.3})
                EventsModule.TriggerServer('Ethnic-misc/server/send-me', RollText)
            end)
        else
            exports['Ethnic-ui']:Notify("misc-error", "An error occured!", 'error')
        end
    end)
end)

-- [ Functions ] --

function CreateRollText(Table, Sides)
    local Total, String = 0, "~g~Dice Roll~s~: "
    for k, v in pairs(Table) do
        Total = Total + v
        if k == 1 then
            String = String .. v .. "/" .. Sides
        else
            String = String .. " | " .. v .. "/" .. Sides
        end
    end
    String = String .. " | (Total: ~g~"..Total.."~s~)"
    return String
end
