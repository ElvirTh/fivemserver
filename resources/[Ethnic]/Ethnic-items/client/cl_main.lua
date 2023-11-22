local SupportedModels, SupportedGogglesModels = {[GetHashKey('mp_f_freemode_01')] = 4, [GetHashKey('mp_m_freemode_01')] = 7}, {[GetHashKey('mp_f_freemode_01')] = 115, [GetHashKey('mp_m_freemode_01')] = 116}
FunctionsModule, VehicleModule, CallbackModule, EventsModule = nil, nil, nil, nil
local UsingMegaPhone, FastfoodCombo, DoingFastfoodTimeout = false, 0, false
local HairTied, NightVisonActive, HairSyles, GogglesStyles = false, false, nil, nil
local CurrentBuffItems = {}
DoingBinoculars, DoingPDCamera, RemovingStress = false, false, false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Functions',
        'Events',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-logout', function()
    RemovingStress = false
    DoingBinoculars = false
    DoingPDCamera = false
    DoingFastfoodTimeout = false
    HairTied, HairSyles = false, nil
    NightVisonActive, GogglesStyles = false, nil
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            for k, v in pairs(CurrentBuffItems) do
                if CurrentBuffItems[k] - 1 > 0 then
                    CurrentBuffItems[k] = CurrentBuffItems[k] - 1
                else
                    CurrentBuffItems[k] = nil
                    TriggerClientEvent('Ethnic-items/client/do-food-buff', k, false)
                end
            end
            Citizen.Wait((1000 * 60) * 1)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and UsingMegaPhone then
            if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_mobile_film_shocking@female@base", "base", 3) then
                FunctionsModule.RequestAnimDict("amb@world_human_mobile_film_shocking@female@base")
                TaskPlayAnim(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0, 1.0, GetAnimDuration('amb@world_human_mobile_film_shocking@female@base', 'base'), 49, 0, 0, 0, 0)
            end
            Citizen.Wait(1000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-items/client/used-food', function(ItemData, PropName)
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Eating..', 5000, {['AnimName'] = 'mp_player_int_eat_burger', ['AnimDict'] = 'mp_player_inteat@burger', ['AnimFlag'] = 49}, PropName, false, true, function(DidComplete)
            exports['Ethnic-inventory']:SetBusyState(false)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', ItemData.ItemName, 1, false, true)
                if DidRemove then
                    EventsModule.TriggerServer('Ethnic-items/server/add-food', math.random(25, 30))
                    if Config.SpecialFood[ItemData.ItemName] ~= nil and Config.SpecialFood[ItemData.ItemName] then
                        DoSpecial(ItemData.ItemName)
                    end
                    if Config.BuffItems[ItemData.ItemName] ~= nil and Config.BuffItems[ItemData.ItemName] then
                        DoItemBuff(ItemData.ItemName)
                    end
                    if Config.FastFood[ItemData.ItemName] ~= nil and Config.FastFood[ItemData.ItemName] then
                        DoFastFoodShit()
                    end
                end
            end
        end)
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-water', function(ItemData, PropName)
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Drinking..', 5000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_drinking@coffee@male@idle_a', ['AnimFlag'] = 49}, PropName, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', ItemData.ItemName, 1, false, true)
                if DidRemove then
                    EventsModule.TriggerServer('Ethnic-items/server/add-water', math.random(25, 30))
                    if Config.SpecialWater[ItemData.ItemName] ~= nil and Config.SpecialWater[ItemData.ItemName] then
                        DoSpecial(ItemData.ItemName)
                    end
                    if Config.BuffItems[ItemData.ItemName] ~= nil and Config.BuffItems[ItemData.ItemName] then
                        DoItemBuff(ItemData.ItemName)
                    end
                end
            end
            exports['Ethnic-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-bandage', function(IsIfak)
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar(IsIfak and 'Applying Ifak..' or 'Healing..', 3000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_clipboard@male@idle_a', ['AnimFlag'] = 49}, nil, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', IsIfak and 'ifak' or 'bandage', 1, false, true)
                if DidRemove then
                    Citizen.SetTimeout(1500, function()
                        for i = 1, 6 do
                            Citizen.Wait(3500)
                            local CurrentHealth = GetEntityHealth(PlayerPedId())
                            local NewHealth = CurrentHealth + 4 > 200 and 200 or CurrentHealth + 4
                            SetEntityHealth(PlayerPedId(), NewHealth)

                        end
                        if IsIfak then
                            TriggerEvent('Ethnic-hospital/client/clear-wounds')
                            if exports['Ethnic-hospital']:IsPlayerBleeding() then
                                TriggerEvent('Ethnic-hospital/client/clear-bleeding')
                            end
                        else
                            TriggerEvent('Ethnic-hospital/client/decrease-wounds')
                            if exports['Ethnic-hospital']:IsPlayerBleeding() then
                                TriggerEvent('Ethnic-hospital/client/clear-bleeding')
                            end
                        end
                    end)
                end
            end
            exports['Ethnic-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-chest-armor', function(ItemName)
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Armor..', 5000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_clipboard@male@idle_a', ['AnimFlag'] = 49}, nil, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', ItemName, 1, false, true)
                if DidRemove then
                    local CurrentArmor = GetPedArmour(PlayerPedId())
                    local NewArmor = CurrentArmor + 75 > 100 and 100 or CurrentArmor + 75
                    SetPedArmour(PlayerPedId(), NewArmor)
                end
                TriggerEvent('Ethnic-hospital/client/save-vitals')
            end
            exports['Ethnic-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-megaphone', function()
    Citizen.SetTimeout(1000, function()
        if not UsingMegaPhone then
            UsingMegaPhone = true
            exports['Ethnic-assets']:AttachProp('Megaphone')
            FunctionsModule.RequestAnimDict("amb@world_human_mobile_film_shocking@female@base")
            TaskPlayAnim(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0, 1.0, GetAnimDuration('amb@world_human_mobile_film_shocking@female@base', 'base'), 49, 0, 0, 0, 0)
            TriggerServerEvent("Ethnic-voice/server/transmission-state", 'Megaphone', true)
            TriggerEvent('Ethnic-voice/client/proximity-override', "Megaphone", 3, 15.0, 2)
        else
            UsingMegaPhone = false
            exports['Ethnic-assets']:RemoveProps('Megaphone')
            StopAnimTask(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0)
            TriggerServerEvent("Ethnic-voice/server/transmission-state", 'Megaphone', false)
            TriggerEvent('Ethnic-voice/client/proximity-override', "Megaphone", 3, -1, -1)
        end
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-lawnchair', function()
    Citizen.SetTimeout(450, function()
        if IsEntityPlayingAnim(PlayerPedId(), "timetable@ron@ig_3_couch", "base", 3) then
            TriggerEvent('Ethnic-animations/client/clear-animation')
        else
            TriggerEvent('Ethnic-animations/client/play-animation', 'lawnchair')
            exports['Ethnic-assets']:AttachProp('Lawnchair')
        end
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-wheelchair', function()
    Citizen.SetTimeout(450, function()
        if not IsPedInAnyVehicle(PlayerPedId()) then
            exports['Ethnic-inventory']:SetBusyState(true)
            exports['Ethnic-ui']:ProgressBar('Wheelchair..', 1000, {}, nil, false, true, function(DidComplete)
                if DidComplete then
                    exports['Ethnic-inventory']:SetBusyState(false)
                    local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'wheelchair', 1, false, true)
                    if DidRemove then
                        local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
                        local VehicleCoords = { ['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['Heading'] = GetEntityHeading(PlayerPedId()) }
                        local Vehicle = VehicleModule.SpawnVehicle('wheelchair', VehicleCoords, nil, false)
                        if Vehicle ~= nil then
                            Citizen.SetTimeout(500, function()
                                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                                exports['Ethnic-vehicles']:SetVehicleKeys(Plate, true, false)
                                exports['Ethnic-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                            end)
                        end
                    end
                else
                    exports['Ethnic-inventory']:SetBusyState(false)
                end
            end)
        else
            exports['Ethnic-ui']:Notify("item-error", "Failed attempt..", 'error')
        end
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-present', function()
    Citizen.SetTimeout(450, function()
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Unwrapping..', 5000, false, false, false, true, function(DidComplete)
            exports['Ethnic-inventory']:SetBusyState(false)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'present', 1, false, true)
                if DidRemove then
                    EventsModule.TriggerServer('Ethnic-items/server/receive-present-items')
                end
            end
        end)
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-toolbox', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if EntityType == 2 then
            VehicleModule.SetVehicleDoorOpen(Entity, 4)
            local Outcome = exports['Ethnic-ui']:StartSkillTest(1, { 1, 5 }, { 12000, 18000 }, false)
            if Outcome then
                local CurrentEngineHealth = GetVehicleEngineHealth(Entity)
                local NewEngineHealth = CurrentEngineHealth + 250.0 < 1000.0 and CurrentEngineHealth + 250.0 or 1000.0
                SetVehicleEngineHealth(Entity, NewEngineHealth)
            else
                TriggerEvent('Ethnic-ui/client/notify', "item-error", "Failed attempt..", 'error')
            end
            SetVehicleDoorShut(Entity, 4, false)
        else
            TriggerEvent('Ethnic-ui/client/notify', "item-error", "No vehicle found..", 'error')
        end
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-tirekit', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if EntityType == 2 then
            local Outcome = exports['Ethnic-ui']:StartSkillTest(1, { 1, 5 }, { 12000, 18000 }, false)
            if Outcome then
                for i = 0, 7, 1 do
                    if i == 6 then
                        VehicleModule.SetTyreHealth(Entity, 45, 1000.0) -- 6 wheels car
                        VehicleModule.SetVehicleTyreFixed(Entity, 45) -- 6 wheels car
                    elseif i == 7 then
                        VehicleModule.SetTyreHealth(Entity, 47, 1000.0) -- 6 wheels car
                        VehicleModule.SetVehicleTyreFixed(Entity, 47) -- 6 wheels car
                    else
                        VehicleModule.SetTyreHealth(Entity, i, 1000.0)
                        VehicleModule.SetVehicleTyreFixed(Entity, i)
                    end
                end
            else
                TriggerEvent('Ethnic-ui/client/notify', "item-error", "Failed attempt..", 'error')
            end
        else
            TriggerEvent('Ethnic-ui/client/notify', "item-error", "No vehicle found..", 'error')
        end
    end)
end)

RegisterNetEvent('Ethnic-items/client/used-carpolish', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if Entity == 0 or Entity == -1 or EntityType ~= 2 then 
            TriggerEvent('Ethnic-ui/client/notify', "item-error", "No vehicle found..", 'error') 
            return 
        end
        exports['Ethnic-inventory']:SetBusyState(true)
        TriggerEvent('Ethnic-animations/client/play-animation', 'cleaning')
        exports['Ethnic-ui']:ProgressBar('Cleaning Vehicle..', 6500, false, false, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('Ethnic-base/server/remove-item', 'car-polish', 1, false, true)
                if DidRemove then
                    VehicleModule.SetVehicleDirtLevel(Entity, 0.0)
                end
            end
            TriggerEvent('Ethnic-animations/client/clear-animation')
            exports['Ethnic-inventory']:SetBusyState(false)
        end)
    end)
end)


RegisterNetEvent("Ethnic-items/client/use-hairtie", function()
    local HairValue = SupportedModels[GetEntityModel(PlayerPedId())]
    if HairValue == nil then return end
    Citizen.SetTimeout(750, function()
        TriggerEvent('Ethnic-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(1700, function()
            if not HairTied then
                local HairDraw, HairTexture, HairPallete = GetPedDrawableVariation(PlayerPedId(), 2), GetPedTextureVariation(PlayerPedId(), 2), GetPedPaletteVariation(PlayerPedId(), 2)
                SetPedComponentVariation(PlayerPedId(), 2, HairValue, HairTexture, HairPallete)
                HairTied, HairSyles = true, {HairDraw, HairTexture, HairPallete}
            else
                SetPedComponentVariation(PlayerPedId(), 2, HairSyles[1], HairSyles[2], HairSyles[3])
                HairTied, HairSyles = false, nil
            end
        end)
    end)
end)

local UsingHairspray = false
RegisterNetEvent("Ethnic-items/client/use-hairspray", function()
    if UsingHairspray then return end
    UsingHairspray = true
    Citizen.SetTimeout(750, function()
        exports['Ethnic-assets']:AttachProp('Spray')
        TriggerEvent('Ethnic-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(800, function()
            TriggerEvent('Ethnic-ui/client/play-sound', 'spray', 0.55)
            Citizen.Wait(900)
            exports['Ethnic-assets']:RemoveProps('Spray')
            TriggerEvent('Ethnic-clothing/client/set-hair-color', math.random(1, 56))
            UsingHairspray = false
        end)
    end)
end)

RegisterNetEvent("Ethnic-items/client/use-nightvison", function()
    local GogglesValue = SupportedGogglesModels[GetEntityModel(PlayerPedId())]
    if GogglesValue == nil then return end
    Citizen.SetTimeout(750, function()
        TriggerEvent('Ethnic-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(1000, function()
            NightVisonActive = not NightVisonActive
            SetNightvision(NightVisonActive)
            if NightVisonActive then
                GogglesStyles = {Prop = GetPedPropIndex(PlayerPedId(), 0), Texture = GetPedPropTextureIndex(PlayerPedId(), 0)}
                SetPedPropIndex(PlayerPedId(), 0, GogglesValue, 0, true)
            else
                ClearPedProp(PlayerPedId(), 0)
                SetPedPropIndex(PlayerPedId(), 0, GogglesStyles.Prop, GogglesStyles.Texture, true)
                GogglesStyles = nil
            end
        end)
    end)
end)

-- [ Functions ] --

function DoSpecial(ItemName)
    Citizen.CreateThread(function()
        if ItemName == 'heartstopper' or ItemName == 'moneyshot' then
            EventsModule.TriggerServer('Ethnic-items/server/add-food', math.random(5, 16))
            if not exports['Ethnic-police']:IsStatusAlreadyActive('wellfed') then
                TriggerEvent('Ethnic-police/client/evidence/set-status', 'wellfed', 210)
            end
        elseif ItemName == 'milkshake' or ItemName == 'slushy' then
            EventsModule.TriggerServer('Ethnic-ui/server/set-stress', 'Remove', math.random(10, 20))
        end
    end)
end

function DoItemBuff(ItemName)
    if CurrentBuffItems[ItemName] ~= nil then
        CurrentBuffItems[ItemName] = 30
        TriggerEvent('Ethnic-items/client/do-food-buff', ItemName, true)
    else
        -- Print Buff is already active
    end
end

function DoFastFoodShit()
    local Puking = exports['Ethnic-assets']:IsPuking()
    if not Puking then
        FastfoodCombo = FastfoodCombo + 1
        if FastfoodCombo >= 3 and not Puking then

            TriggerServerEvent('Ethnic-assets/server/toggle-effect', GetPlayerServerId(PlayerId()), 'Puke', 5000, true)
        end
        if FastfoodCombo > 0 and not DoingFastfoodTimeout then
            DoingFastfoodTimeout = true
            Citizen.SetTimeout(20000, function()
                FastfoodCombo, DoingFastfoodTimeout = 0, false
            end)
        end
    end
end
