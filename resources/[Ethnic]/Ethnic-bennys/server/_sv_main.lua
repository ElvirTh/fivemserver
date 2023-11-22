CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Functions',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        DatabaseModule = exports['Ethnic-base']:FetchModule('Database')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        CommandsModule = exports['Ethnic-base']:FetchModule('Commands')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(500) 
    end 

    -- [ Callbacks ] --

    local MechanicBusinesses = {
        'Bennys Motorworks',
        'Hayes Repairs',
        'Harmony Repairs',
    }

    CallbackModule.CreateCallback('Ethnic-bennys/server/is-mechanic-online', function(Source, Cb)
        local EmployeeCount = 0
        for _, Name in pairs(MechanicBusinesses) do
            local Amount = exports['Ethnic-business']:GetOnlineBusinessEmployees(Name)
            if not Amount then goto Skip end
            if #Amount > 0 then
                EmployeeCount = EmployeeCount + 1
            end
            ::Skip::
        end
        print('Ready', EmployeeCount > 0)
        if EmployeeCount > 0 then
            Cb(true)
        else
            Cb(false)
        end
    end)

end)