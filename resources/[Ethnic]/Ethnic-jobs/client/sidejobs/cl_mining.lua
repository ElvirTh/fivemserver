local DoingAnimation, CurrentMining, NowMining = false, nil, false

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local AtMiningSpot = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.MiningSpots) do
                local Distance = #(v['Coords'] - PlayerCoords)
                if Distance < 2.0 then
                    AtMiningSpot, CurrentMining = true, k
                end
            end
            if not AtMiningSpot then
                if CurrentMining ~= nil then
                    CurrentMining = nil
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    exports['Ethnic-ui']:AddEyeEntry("mining-stuff", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 5.0,
        Position = vector4(-594.3, 2091.39, 130.60, 56.32),
        Model = 'cs_old_man2',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'grab_pickaxe',
                Icon = 'fas fa-circle',
                Label = 'Grab Pickaxe!',
                EventType = 'Client',
                EventName = 'Ethnic-jobs/client/mining/grab',
                EventParams = 'pickaxe',
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-items/client/used-pickaxe', function()
    local CurrentMiningSpot = CurrentMining
    if CurrentMiningSpot ~= false and CurrentMiningSpot ~= nil then
        if not NowMining then
            local AlreadyMined = CallbackModule.SendCallback("Ethnic-jobs/server/can-mine-this-spot", CurrentMiningSpot)
            if AlreadyMined ~= nil and AlreadyMined ~= 'No' then
                NowMining = true
                DoMiningAnim(true)
                TriggerServerEvent('Ethnic-jobs/server/mining-set-state', CurrentMiningSpot, 'Busy', true)
                Citizen.SetTimeout(math.random(1500, 10000), function()
                    local Outcome = exports['Ethnic-ui']:StartSkillTest(3, { 10, 15 }, { 3500, 5500 }, false)
                    DoMiningAnim(false)
                    if Outcome then
                        TriggerServerEvent('Ethnic-jobs/server/mining-set-state', CurrentMiningSpot, 'Mined', true)
                        EventsModule.TriggerServer('Ethnic-jobs/server/mining/receive-goods', AlreadyMined)
                    else
                        TriggerEvent('Ethnic-ui/client/notify', "mining-error", "That didn\'t go as planned..", 'error')
                    end
                    TriggerServerEvent('Ethnic-jobs/server/mining-set-state', CurrentMiningSpot, 'Busy', false)
                    NowMining = false
                end)
            else
                TriggerEvent('Ethnic-ui/client/notify', "mining-error", "Something went wrong! (You can\'t mine here now!)", 'error')
            end
        else
            TriggerEvent('Ethnic-ui/client/notify', "mining-error", "Something went wrong! (You are already mining!)", 'error')
        end
    else
        TriggerEvent('Ethnic-ui/client/notify', "mining-error", "Something went wrong! (This is not a spot!)", 'error')
    end
end)

RegisterNetEvent('Ethnic-items/client/used-scanner', function()
-- local testdic = "missexile3"
-- local testanim = "ex03_dingy_search_case_a_michael"
end)

function DoMiningAnim(Bool)
    DoingAnimation = Bool
    if DoingAnimation then
        exports['Ethnic-assets']:AttachProp('Pickaxe')
        FunctionsModule.RequestAnimDict("melee@large_wpn@streamed_core")
        Citizen.CreateThread(function()
            while DoingAnimation do
                Citizen.Wait(4)
                TaskPlayAnim(PlayerPedId(), 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 3.0, -8.0, -1, 8, 0, false, false, false)
                Citizen.Wait(450)
                TriggerEvent('Ethnic-ui/client/play-sound', 'pickaxe', 0.7)
                Citizen.Wait(1650)
            end
            StopAnimTask(PlayerPedId(), "melee@large_wpn@streamed_core", "ground_attack_on_spot", 1.0)
            exports['Ethnic-assets']:RemoveProps('Pickaxe')
        end)
    end
end

RegisterNetEvent('Ethnic-jobs/client/mining/grab', function(ItemName)
    EventsModule.TriggerServer('Ethnic-jobs/server/mining/grab', ItemName)
end)