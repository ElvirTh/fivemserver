

RegisterNetEvent('Ethnic-hospital/client/heal-player', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if not exports['Ethnic-inventory']:HasEnoughOfItem('ifak', 1) then 
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no ifaks!)", 'error')
        return 
    end
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('Ethnic-assets/client/heal-animation', true)
        exports['Ethnic-ui']:ProgressBar('Healing..', 3000, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('Ethnic-hospital/server/heal-player', ClosestPlayer['ClosestServer'])
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'ifak', 1, false, true)
            end
            TriggerEvent('Ethnic-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent('Ethnic-hospital/client/revive-player', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if not exports['Ethnic-inventory']:HasEnoughOfItem('ifak', 1) then 
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no ifaks!)", 'error')
        return 
    end
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('Ethnic-assets/client/heal-animation', true)
        exports['Ethnic-ui']:ProgressBar('Reviving..', 4500, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('Ethnic-hospital/server/revive-player', ClosestPlayer['ClosestServer'])
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'ifak', 1, false, true)
            end
            TriggerEvent('Ethnic-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent('Ethnic-hospital/client/take-blood', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('Ethnic-assets/client/heal-animation', true)
        exports['Ethnic-ui']:ProgressBar('Taking Blood..', 4500, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('Ethnic-hospital/server/take-blood', ClosestPlayer['ClosestServer'])
            end
            TriggerEvent('Ethnic-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent("Ethnic-hospital/client/scan-blood", function()
    local Samples = CallbackModule.SendCallback('Ethnic-hospital/server/get-samples', 'blood-sample')
    if not Samples then 
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no blood samples!)", 'error')
        return 
    end

    local SampleItems = {
        {
            ['Title'] = 'Scan Blood Sample',
            ['Desc'] = 'Choose a blood sample to scan',
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        }
    }

    for SampleId, SampleData in pairs(Samples) do
        SampleItems[#SampleItems + 1] = {
            ['Title'] = 'Sample #'..SampleData.Info.Blood,
            ['Desc'] = 'Click to start blood scan',
            ['Data'] = {['Event'] = 'Ethnic-hospital/client/start-blood-scan', ['Type'] = 'Client', ['BloodData'] = SampleData.Info},
        }
    end
    if #SampleItems > 0 then 
        exports['Ethnic-ui']:OpenContext({
            ['MainMenuItems'] = SampleItems,
        })
    else
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no blood samples!)", 'error')
    end
end)

RegisterNetEvent("Ethnic-hospital/client/start-blood-scan", function(Data)
    exports['Ethnic-ui']:ProgressBar('Scanning blood..', 14000, false, false, false, true, function(DidComplete)
        if DidComplete then
            EventsModule.TriggerServer('Ethnic-hospital/server/receive-result', Data['BloodData'])
        end
    end)
end)

RegisterNetEvent('Ethnic-hospital/client/stomach-pump', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('Ethnic-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        -- Pump pump pump pump
        TriggerEvent('Ethnic-assets/client/heal-animation', true)
        exports['Ethnic-ui']:ProgressBar('Pumping out stomach..', 12000, false, false, false, true, function(DidComplete)
            if DidComplete then
    
            end
            TriggerEvent('Ethnic-assets/client/heal-animation', false)
        end)
    end
end)