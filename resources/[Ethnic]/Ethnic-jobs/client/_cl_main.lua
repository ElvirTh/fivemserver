EntityModule, LoggerModule, EventsModule, CallbackModule, BlipModule, PedsModule, FunctionsModule, VehicleModule = nil, nil, nil, nil, nil, nil, nil, nil
Jobs.Delivery = {
    Location = nil,
    HasPackage = false,
}
local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Events',
        'Entity',
        'Logger',
        'Callback',
        'Functions',
        'BlipManager',
        'Player',
        'Vehicle',
        'Peds',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        BlipModule = exports['Ethnic-base']:FetchModule('BlipManager')
        EntityModule = exports['Ethnic-base']:FetchModule("Entity")
        VehicleModule = exports['Ethnic-base']:FetchModule("Vehicle")
        LoggerModule = exports['Ethnic-base']:FetchModule('Logger')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        PedsModule = exports['Ethnic-base']:FetchModule('Peds')
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
    SetupPeds()
end)

-- [ Code ] --

-- [ Events ] --

local CanSell = true
RegisterNetEvent('Ethnic-jobs/client/hand-receipts', function()
    if not CanSell then return end

    EventsModule.TriggerServer('Ethnic-jobs/server/sell-receipts') 
    CanSell = false
    Citizen.SetTimeout(1000, function()
        CanSell = true
    end)
end)

-- [ Functions ] --

function SetupPeds()
    while not _Ready do
        Citizen.Wait(150)
    end
    exports['Ethnic-ui']:AddEyeEntry("payment_ped", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 5.0,
        Position = vector4(241.3, 225.13, 105.25, 159.08),
        Model = 'a_m_y_hasjew_01',
        Anim = {
            Dict = "missheistdockssetup1clipboard@base",
            Name = "base"
        },
        Props = {
            {
                Prop = 'prop_notepad_01',
                Bone = 18905,
                Placement = {0.1, 0.02, 0.05, 10.0, 0.0, 0.0},
            },
            {
                Prop = 'prop_pencil_01',
                Bone = 58866,
                Placement = {0.11, -0.02, 0.001, -120.0, 0.0, 0.0},
            },
        },
        Options = {
            {
                Name = 'payment_interaction',
                Icon = 'fas fa-circle',
                Label = 'Receive Paycheck',
                EventType = 'Server',
                EventName = 'Ethnic-jobs/server/receive-paycheck',
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'payment_ticket',
                Icon = 'fas fa-circle',
                Label = 'Hand In Receipts',
                EventType = 'Client',
                EventName = 'Ethnic-jobs/client/hand-receipts',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['Ethnic-business']:IsPlayerInBusiness('Burger Shot') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    local JobsTable = CallbackModule.SendCallback("Ethnic-phone/server/jobcenter/get-jobs")
    for k, Job in pairs(JobsTable) do
        exports['Ethnic-ui']:AddEyeEntry("job_ped_" .. Job['Name'] .. "_" .. k, {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 10.0,
            Position = vector4(Job['Location'].x, Job['Location'].y, Job['Location'].z, Job['Location'].w),
            Model = Job['PedModel'],
            Scenario = Job['Scenario'],
            Anim = Job['Anim'],
            Props = Job['Props'],
            Options = {
                {
                    Name = 'sign_in',
                    Icon = 'fas fa-circle',
                    Label = 'Check In',
                    EventType = 'Server',
                    EventName = 'Ethnic-phone/server/jobcenter/check-in',
                    EventParams = Job['Name'],
                    Enabled = function(Entity)
                        if Job['RequiresVPN'] and not exports['Ethnic-inventory']:HasEnoughOfItem('vpn', 1) then
                            return false
                        end

                        return exports['Ethnic-phone']:GetCurrentJob() == false
                    end,
                },
                {
                    Name = 'sign_off',
                    Icon = 'fas fa-circle',
                    Label = 'Check Out',
                    EventType = 'Server',
                    EventName = 'Ethnic-phone/server/jobcenter/check-out',
                    EventParams = {},
                    Enabled = function(Entity)
                        if Job['RequiresVPN'] and not exports['Ethnic-inventory']:HasEnoughOfItem('vpn', 1) then
                            return false
                        end

                        return exports['Ethnic-phone']:GetCurrentJob() ~= false
                    end,
                },
                {
                    Name = 'get_paycheck',
                    Icon = 'fas fa-hand-holding-usd',
                    Label = 'Get Paycheck',
                    EventType = 'Server',
                    EventName = 'Ethnic-phone/server/jobcenter/request-paycheck',
                    EventParams = {},
                    Enabled = function(Entity)
                        return exports['Ethnic-phone']:GetPaycheckAmount() > 0
                    end,
                },
            }
        })
    end
end

exports("GetJobTasks", function(Job, GroupLeader)
    local Tasks = FunctionsModule.DeepCopyTable(Config.Tasks[Job])
    local Promise = promise:new()
    if Job == 'sanitation' then
        if GroupLeader == PlayerModule.GetPlayerData().CitizenId then EventsModule.TriggerServer("Ethnic-jobs/server/set-job-locs", Job, GroupLeader) end
        Citizen.SetTimeout(300, function()
            local Zones = CallbackModule.SendCallback("Ethnic-jobs/server/get-job-locs", Job, GroupLeader)
            Jobs.Sanitation.FirstZone, Jobs.Sanitation.SecondZone = Zones[1], Zones[2]
            Tasks.Tasks[3].Text = (Tasks.Tasks[3].Text):format(Config.SanitationZones[Zones[1]].Label)
            Tasks.Tasks[5].Text = (Tasks.Tasks[5].Text):format(Config.SanitationZones[Zones[2]].Label)
            Promise:resolve(Tasks)
        end)
    elseif Job == 'delivery' then
        if GroupLeader == PlayerModule.GetPlayerData().CitizenId then EventsModule.TriggerServer("Ethnic-jobs/server/set-job-locs", Job, GroupLeader) end
        Citizen.SetTimeout(300, function()
            local Location = CallbackModule.SendCallback("Ethnic-jobs/server/get-job-locs", Job, GroupLeader)
            Jobs.Delivery.Location = Config.DeliveryStores[Location]
            Promise:resolve(Tasks)
        end)
    else
        Promise:resolve(Tasks)
    end

    return Citizen.Await(Promise)
end)