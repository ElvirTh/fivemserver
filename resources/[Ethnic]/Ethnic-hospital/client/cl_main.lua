PlayerModule, EventsModule, FunctionModule, VehicleModule, CallbackModule = nil
local HospitalBedCam = nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'Vehicle',
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        FunctionModule = exports['Ethnic-base']:FetchModule('Functions')
        VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(2250, function()
        InitHospitalZones()
        InitHospital()
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-logout', function()
    TriggerEvent('Ethnic-hospital/client/clear-bleeding')
    TriggerEvent('Ethnic-hospital/client/clear-wounds')
    Config.Dead, Config.Timer = false, 60
    PressingTime, Doingtimer = 5, false
    Config.InHospitalBed = false
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if LocalPlayer.state.LoggedIn then
            Citizen.Wait(3500)
            TriggerEvent('Ethnic-hospital/client/save-vitals')
        else
            Citizen.Wait(450) 
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-hospital/client/kill-player', function()
    SetEntityHealth(PlayerPedId(), 0)
    SetEntityMaxHealth(PlayerPedId(), 200)
end)

RegisterNetEvent("Ethnic-hospital/client/save-vitals", function()
    local Armor = GetPedArmour(PlayerPedId())
    local Health = GetEntityHealth(PlayerPedId())
    TriggerServerEvent('Ethnic-hospital/server/save-vitals', Armor, Health)
end)

RegisterNetEvent('Ethnic-hospital/client/set-hospital-bed-busy', function(BedId, Bool)
    Config.HospitalBeds[BedId]['Busy'] = Bool
end)

RegisterNetEvent('Ethnic-hospital/client/open-ems-store', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Ems Cabin', 'Store', 0, 0, Config.EmsStore, 'EmsStore')
    end
end)

RegisterNetEvent('Ethnic-hospital/client/try-send-to-bed', function(IsRespawn)
    if not IsRespawn then
        exports['Ethnic-ui']:ProgressBar('Showing Credentials..', 5000, {['AnimName'] = 'base', ['AnimDict'] = 'missheistdockssetup1clipboard@base', ['AnimFlag'] = 49}, 'Clipboard', true, true, function(DidComplete)
            if DidComplete then
                local FreeBed = GetAvailableHospitalBed()
                if FreeBed ~= false then
                    TriggerEvent('Ethnic-hospital/client/send-to-bed', FreeBed)
                else
                    TriggerEvent('Ethnic-ui/client/notify', "hospital-beds", 'Their are no free beds..', 'error', 4500)
                end
            end
        end)
    else
        local FreeBed = GetAvailableHospitalBed()
        if FreeBed ~= false then
            PressingTime, Doingtimer = 5, false
            TriggerEvent('Ethnic-hospital/client/send-to-bed', FreeBed)
            TriggerServerEvent('Ethnic-hospital/server/clear-inventory')
            TriggerEvent('Ethnic-ui/client/notify', "hospital-items", 'You lost all your items..', 'error', 4500)
        else
            TriggerEvent('Ethnic-ui/client/notify', "hospital-beds", 'Their are no free beds at the moment please wait..', 'error', 4500)
        end
    end
end)

RegisterNetEvent('Ethnic-hospital/client/send-to-bed', function(BedId)
    Citizen.SetTimeout(50, function()
        TriggerEvent('Ethnic-assets/client/attach-items')
        EnterHospitalBed(BedId)
        TriggerServerEvent('Ethnic-hospital/server/set-hospital-bed-busy', BedId, true)
        Citizen.Wait(25000)
        LeaveHospitalBed(BedId)
        EventsModule.TriggerServer('Ethnic-hospital/server/reset-vitals')
        TriggerEvent('Ethnic-hospital/client/revive', false)
        TriggerServerEvent('Ethnic-hospital/server/set-hospital-bed-busy', BedId, false)
    end)
end)

-- [ Functions ] --

function EnterHospitalBed(BedId)
    Citizen.CreateThread(function()
        Config.InHospitalBed = true
        local BedData = Config.HospitalBeds[BedId]
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Citizen.Wait(100)
        end
        SetEntityCoords(PlayerPedId(), BedData['Coords'].x, BedData['Coords'].y, BedData['Coords'].z - 0.40)
        SetEntityHeading(PlayerPedId(), BedData['Coords'].w)
        Citizen.Wait(500)
        FunctionModule.RequestAnimDict("misslamar1dead_body")
        TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        FreezeEntityPosition(PlayerPedId(), true)
        CreateHospitalBedCamera()
        DoScreenFadeIn(1000)
    end)
end

function LeaveHospitalBed(BedId)
    Citizen.CreateThread(function()
        local BedData = Config.HospitalBeds[BedId]
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), BedData['Coords'].x, BedData['Coords'].y, BedData['Coords'].z - 0.40)
        SetEntityHeading(PlayerPedId(), BedData['Coords'].w + 90)
        FunctionModule.RequestAnimDict("switch@franklin@bed")
        TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
        Citizen.Wait(4000)
        ClearPedTasks(PlayerPedId())
        DestroyCam(HospitalBedCam, true)
        RenderScriptCams(false, false, 1, true, true)
        HospitalBedCam, Config.InHospitalBed = nil, false
        -- Set bed state to normale
    end)
end

function CreateHospitalBedCamera()
    HospitalBedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(HospitalBedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(HospitalBedCam, PlayerPedId(), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(HospitalBedCam, 100.0)
    SetCamRot(HospitalBedCam, -45.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
end

function GetAvailableHospitalBed()
    for k, v in pairs(Config.HospitalBeds) do
        if not v['Busy'] then
            return k
        end
    end
    return false
end

function DrawScreenText(ScreenX, ScreenY, Center, Text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.57, 0.57)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(Center)
    SetTextEntry("STRING")
    AddTextComponentString(Text)
    DrawText(ScreenX, ScreenY)
end

function InitHospital()
    local Player = PlayerModule.GetPlayerData()
    Citizen.SetTimeout(3500, function()
        if Player.MetaData['Dead'] then
            Config.Dead, Config.Timer, Doingtimer, PressingTime = true, 60, false, 5
            EventsModule.TriggerServer('Ethnic-hospital/server/set-dead-state', true)
            TriggerEvent('Ethnic-hospital/client/do-dead-on-player', true)
        else
            SetEntityMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), Player.MetaData['Health'])
            SetPedArmour(PlayerPedId(), Player.MetaData['Armor'])
        end
    end)
end