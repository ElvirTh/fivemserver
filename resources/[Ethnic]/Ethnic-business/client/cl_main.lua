FunctionsModule, CallbackModule, EventsModule, PlayerModule, VehicleModule = nil
ClockedData = {Business = 'None', Clocked = false}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Functions',
        'Events',
        'Player',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(3000, function()
        InitZones()
        InitFoodzones()
        InitHayes()
    end)
end)


-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-business/client/open-stash', function(Data, Entity)
    if Data.Stash == nil or Data.Business == nil then return end
    if not HasPlayerBusinessPermission(Data.Business, 'stash_access') then return end
    Citizen.SetTimeout(350, function()
        if exports['Ethnic-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', Data.Stash, 'Stash', 40, 700.0)
        end
    end)
end)

-- [ Functions ] --

function IsPlayerInBusiness(Name)
    local Promise = promise:new()
    local Player = PlayerModule.GetPlayerData()
    local BusinessData = CallbackModule.SendCallback('Ethnic-business/server/get-specific-business', Name)
    if BusinessData ~= false then
        if BusinessData.Owner == Player.CitizenId then
            Promise:resolve(true)
        end
        for Employee, Employees in pairs(BusinessData.Employees) do
            if Employees.CitizenId == Player.CitizenId then
                Promise:resolve(true)
            end
        end
        Promise:resolve(false)
    else
        Promise:resolve(false)
    end
    return Citizen.Await(Promise)
end
exports("IsPlayerInBusiness", IsPlayerInBusiness)

function HasPlayerBusinessPermission(Name, Permission)
    local Promise = promise:new()
    local Player = PlayerModule.GetPlayerData()
    local BusinessData = CallbackModule.SendCallback('Ethnic-business/server/get-specific-business', Name)
    if BusinessData ~= false then
        if BusinessData.Owner == Player.CitizenId then
            Promise:resolve(true)
        end
        for Employee, Employees in pairs(BusinessData.Employees) do
            if Employees.CitizenId == Player.CitizenId and BusinessData.Ranks[Employees.Rank] ~= nil and BusinessData.Ranks[Employees.Rank].Permissions[Permission] ~= nil and BusinessData.Ranks[Employees.Rank].Permissions[Permission] then
                Promise:resolve(true)
            end
        end
        Promise:resolve(false)
    else
        Promise:resolve(false)
    end
    return Citizen.Await(Promise)
end
exports("HasPlayerBusinessPermission", HasPlayerBusinessPermission)

-- [ Functions ] --

function GetClockedData()
    return ClockedData
end
exports('GetClockedData', GetClockedData)