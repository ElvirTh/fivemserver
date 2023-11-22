Jobs.Sanitation = {
    HasBag = false,
    FirstZone = nil,
    SecondZone = nil,
}

local InSanitationZone = false

local SingleDumpsters = {
    [GetHashKey('prop_cs_rub_binbag_01')] = true,
    [GetHashKey('prop_ld_binbag_01')] = true,
    [GetHashKey('prop_ld_rub_binbag_01')] = true,
    [GetHashKey('prop_rub_binbag_sd_01')] = true,
    [GetHashKey('prop_rub_binbag_sd_02')] = true,
    [GetHashKey('prop_cs_street_binbag_01')] = true,
    [GetHashKey('p_binbag_01_s')] = true,
    [GetHashKey('ng_proc_binbag_01a')] = true,
    [GetHashKey('p_rub_binbag_test')] = true,
    [GetHashKey('prop_rub_binbag_01')] = true,
    [GetHashKey('prop_rub_binbag_04')] = true,
    [GetHashKey('prop_rub_binbag_05')] = true,
    [GetHashKey('bkr_prop_fakeid_binbag_01')] = true,
    [GetHashKey('hei_prop_heist_binbag')] = true,
    [GetHashKey('prop_rub_binbag_01b')] = true,
    [GetHashKey('prop_rub_binbag_03')] = true,
    [GetHashKey('prop_rub_binbag_03b')] = true,
    [GetHashKey('prop_rub_binbag_06')] = true,
    [GetHashKey('prop_rub_binbag_08')] = true,
    [GetHashKey('ch_chint10_binbags_smallroom_01')] = true,
    [GetHashKey('prop_cs_bin_01')] = true,
    [GetHashKey('prop_cs_bin_03')] = true,
    [GetHashKey('prop_bin_08a')] = true,
    [GetHashKey('prop_bin_08open')] = true,
}

local Dumpsters = {
    'prop_dumpster_01a',
    'prop_dumpster_02a',
    'prop_dumpster_02b',
    'prop_dumpster_3a',
    'prop_dumpster_4a',
    'prop_dumpster_4b',
    'prop_cs_bin_01',
    'prop_cs_bin_03',
    'prop_bin_08a',
    'prop_bin_08open',
    -- Bags
    'prop_cs_rub_binbag_01',
    'prop_ld_binbag_01',
    'prop_ld_rub_binbag_01',
    'prop_rub_binbag_sd_01',
    'prop_rub_binbag_sd_02',
    'prop_cs_street_binbag_01',
    'p_binbag_01_s',
    'ng_proc_binbag_01a',
    'p_rub_binbag_test',
    'prop_rub_binbag_01',
    'prop_rub_binbag_04',
    'prop_rub_binbag_05',
    'bkr_prop_fakeid_binbag_01',
    'hei_prop_heist_binbag',
    'prop_rub_binbag_01b',
    'prop_rub_binbag_03',
    'prop_rub_binbag_03b',
    'prop_rub_binbag_06',
    'prop_rub_binbag_08',
    'ch_chint10_binbags_smallroom_01',
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    exports['Ethnic-ui']:AddEyeEntry("sanitation_exchange_ped", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 1.5,
        Position = vector4(-355.69, -1556.31, 24.17, 178.6),
        Model = 's_m_y_garbage',
        Options = {
            {
                Name = 'exchange_recyclables',
                Icon = 'fas fa-circle',
                Label = 'Exchange Recyclables',
                EventType = 'Client',
                EventName = 'Ethnic-jobs/client/sanitation/exchange-recyclables',
                EventParams = {},
                Enabled = function(Entity) return true end,
            },
        }
    })

    -- Trash Interactions
    for k, v in pairs(Dumpsters) do
        exports['Ethnic-ui']:AddEyeEntry(GetHashKey(v), {
            Type = 'Model',
            Model = v,
            SpriteDistance = 3.0,
            Options = {
                {
                    Name = 'sanitation_pickup_trash',
                    Icon = 'fas fa-circle',
                    Label = 'Pickup Trash',
                    EventType = 'Client',
                    EventName = 'Ethnic-jobs/client/sanitation/pickup-trash',
                    EventParams = '',
                    Enabled = function(Entity)
                        return (exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 4) or exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 6))
                    end,
                }
            }
        })
    end
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-threads/entered-vehicle', function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if GetEntityModel(Vehicle) ~= GetHashKey("trash") then return end

    if exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 2) then
        TriggerEvent('Ethnic-phone/client/jobcenter/request-task-success', 2, true)
    end
end)

RegisterNetEvent('Ethnic-phone/client/jobcenter/on-job-start', function(Job, Leader)
    if Job ~= 'sanitation' then return end

    Citizen.CreateThread(function()
        local ShowingAnything = false
        local CitizenId = PlayerModule.GetPlayerData().CitizenId
        while exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 1) do
            DrawMarker(20, -352.17, -1545.7, 28.9, 0, 0, 0, 180.0, 0, 0, 0.5, 0.5, 0.5, 138, 43, 226, 150, true, true, false, false, false, false, false)
            
            if Leader == CitizenId then
                if #(GetEntityCoords(PlayerPedId()) - vector3(-352.17, -1545.7, 27.72)) < 1.5 then
                    if not ShowingAnything then
                        ShowingAnything = true
                        exports['Ethnic-ui']:SetInteraction("[E] Ask the foreman for a vehicle")
                    end
    
                    if IsControlJustPressed(0, 38) then
                        if not VehicleModule.CanVehicleSpawnAtCoords(vector3(927.02, -1232.79, 25.58), 1.85) then return exports['Ethnic-ui']:Notify("delivery-error", "Something is in the way..", "error") end
                        exports['Ethnic-ui']:HideInteraction()
                        TriggerEvent('Ethnic-phone/client/jobcenter/request-task-success', 1, true)
                        if FunctionsModule.RequestModel('trash') then
                            local Coords = { X = -335.41, Y = -1564.36, Z = 24.95, Heading = 60.2 }
                            local Plate = 'SAN' .. math.random(11111, 99999)
                            local Vehicle = VehicleModule.SpawnVehicle('trash', Coords, Plate, false)
                            if Vehicle ~= nil then
                                Citizen.SetTimeout(500, function()
                                    VehicleModule.SetVehicleNumberPlate(Vehicle.Vehicle, Plate)
                                    exports['Ethnic-vehicles']:SetVehicleKeys(Plate, true, false)
                                    exports['Ethnic-vehicles']:SetFuelLevel(Vehicle.Vehicle, 100)
                                end)
                            end
                        end
                    end
                elseif ShowingAnything then
                    ShowingAnything = false
                    exports['Ethnic-ui']:HideInteraction()
                end
            end

            Citizen.Wait(4)
        end
    end)
end)

RegisterNetEvent('Ethnic-phone/client/jobcenter/on-task-done', function(Job, FinishedTaskId, NextTaskId, Leader)
    if Job ~= 'sanitation' then return end

    if Leader == PlayerModule.GetPlayerData().CitizenId then
        if FinishedTaskId == 2 or FinishedTaskId == 4 then
            Citizen.SetTimeout(250, function()
                Citizen.CreateThread(function()
                    while exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 3) or exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 4) or exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 5) or exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 6) do
                        local Coords = GetEntityCoords(PlayerPedId())
                        local Zone = GetLabelText(GetNameOfZone(Coords.x, Coords.y, Coords.z))
                        
                        if FinishedTaskId == 2 then
                            if Zone == Config.SanitationZones[Jobs.Sanitation.FirstZone].Label then
                                if exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 3) then
                                    TriggerEvent('Ethnic-phone/client/jobcenter/request-task-success', 3, true)
                                end
                                InSanitationZone = true
                            else
                                InSanitationZone = false
                            end
                        else
                            if Zone == Config.SanitationZones[Jobs.Sanitation.SecondZone].Label then
                                if exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 5) then
                                    TriggerEvent('Ethnic-phone/client/jobcenter/request-task-success', 5, true)
                                end
                                InSanitationZone = true
                            else
                                InSanitationZone = false
                            end
                        end
    
                        Citizen.Wait(100)
                    end
                end)
            end)
        end
    end
end)

RegisterNetEvent('Ethnic-jobs/client/sanitation/exchange-recyclables', function(Data, Entity)
    Citizen.SetTimeout(450, function()
        if exports['Ethnic-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Exchange Recyclables', 'Crafting', 0, 0, Config.RecyclableCrafting)
        end
    end)
end)

RegisterNetEvent('Ethnic-jobs/client/sanitation/throw-in-trash', function(Data, Entity)
    if exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 4) == false and exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 6) == false then return end
    if Jobs.Sanitation.HasBag == false then exports['Ethnic-ui']:Notify("sanitation-error", "Where da trash bag?", "error") return end
    
    Jobs.Sanitation.HasBag = false
    TaskTurnPedToFaceEntity(PlayerPedId(), Entity, -1)
    FunctionsModule.RequestAnimDict('missfbi4prepp1')
    TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(PlayerPedId(), true)
    CanTakeBag = false

    SetTimeout(1250, function()
        exports['Ethnic-assets']:RemoveProps('TrashBag')
        TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(PlayerPedId(), false)

        if math.random(1, 100) <= 50 then
            EventsModule.TriggerServer('Ethnic-inventory/server/add-item', "recyclablematerial", math.random(4, 8), false, nil, true, false)
        end

        ClearPedTasks(PlayerPedId())
        if exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 4) then
            TriggerEvent('Ethnic-phone/client/jobcenter/request-task-update', 4, 1)
        elseif exports['Ethnic-phone']:IsJobCenterTaskActive('sanitation', 6) then
            TriggerEvent('Ethnic-phone/client/jobcenter/request-task-update', 6, 1)
        end
    end)
end)

RegisterNetEvent('Ethnic-jobs/client/sanitation/return-veh', function(Data, Entity)
    VehicleModule.DeleteVehicle(Entity)
    TriggerEvent('Ethnic-phone/client/jobcenter/request-task-success', 7, true)
end)

RegisterNetEvent('Ethnic-jobs/client/sanitation/pickup-trash', function(Data, Entity)
    if Jobs.Sanitation.HasBag then exports['Ethnic-ui']:Notify("sanitation-error", "You already have a trash bag..", "error") return end
    
    local IsEmpty = CallbackModule.SendCallback("Ethnic-jobs/server/sanitation/is-dumpster-empty", ObjToNet(Entity))
    if IsEmpty then
        if SingleDumpsters[GetEntityModel(Entity)] then
            exports['Ethnic-ui']:Notify("sanitation-error", "This bag isn't really here..", "error")
        else
            exports['Ethnic-ui']:Notify("sanitation-error", "This dumpster looks empty..", "error")
        end
        goto Skip
    end

    exports['Ethnic-assets']:AttachProp("TrashBag")
    FunctionsModule.RequestAnimDict("missfbi4prepp1")
    Jobs.Sanitation.HasBag = true
    
    Citizen.CreateThread(function()
        while Jobs.Sanitation.HasBag do
            if not IsEntityPlayingAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            
            Citizen.Wait(500)
        end
    end)

    if SingleDumpsters[GetEntityModel(Entity)] then
        EntityModule.DeleteEntity(Entity)
        TriggerServerEvent('Ethnic-jobs/server/sanitation/delete-bin-bag', ObjToNet(Entity))
    end

    ::Skip::
end)

RegisterNetEvent('Ethnic-phone/client/jobcenter/job-tasks-done', function(Job, Leader)
    if Job ~= 'sanitation' then return end
    if Jobs.Sanitation.HasBag then
        if IsEntityPlayingAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
            StopAnimTask(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 1.0)
        end
        
        exports['Ethnic-assets']:RemoveProps('TrashBag')
        Jobs.Sanitation.HasBag = false
    end

    if Jobs.Sanitation.FirstZone ~= nil then EventsModule.TriggerServer("Ethnic-jobs/server/sanitation/set-busy", Jobs.Sanitation.FirstZone) end
    if Jobs.Sanitation.SecondZone ~= nil then EventsModule.TriggerServer("Ethnic-jobs/server/sanitation/set-busy", Jobs.Sanitation.SecondZone) end

    InSanitationZone = false
    
    Jobs.Sanitation.FirstZone = nil
    Jobs.Sanitation.SecondZone = nil
end)

RegisterNetEvent('Ethnic-phone/client/jobcenter/on-crash', function(Job)
    if Job ~= 'sanitation' then return end
    if Jobs.Sanitation.HasBag then
        if IsEntityPlayingAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
            StopAnimTask(PlayerPedId(), 'missfbi4prepp1', '_bag_walk_garbage_man', 1.0)
        end
        
        exports['Ethnic-assets']:RemoveProps('TrashBag')
        Jobs.Sanitation.HasBag = false
    end

    if Jobs.Sanitation.FirstZone ~= nil then EventsModule.TriggerServer("Ethnic-jobs/server/sanitation/set-busy", Jobs.Sanitation.FirstZone) end
    if Jobs.Sanitation.SecondZone ~= nil then EventsModule.TriggerServer("Ethnic-jobs/server/sanitation/set-busy", Jobs.Sanitation.SecondZone) end

    InSanitationZone = false
    
    Jobs.Sanitation.FirstZone = nil
    Jobs.Sanitation.SecondZone = nil
end)

-- [ Functions ] --

function IsInJobZone()
    return InSanitationZone
end
exports('IsInJobZone', IsInJobZone)