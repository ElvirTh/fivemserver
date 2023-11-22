-- [ Events ] --

RegisterNetEvent('Ethnic-casino/client/hotel-availability', function()
    local Result = CallbackModule.SendCallback("Ethnic-casino/server/check-room-ownership")
    local MenuData = {}
    if Result.HasRoom then
        MenuData = {
            {
                                
                ['Title'] = 'Rented Room: ' .. Result.RoomInfo.RoomId,
                ['Desc'] = 'You are currently renting this room.',
                ['Data'] = { ['Event'] = '', ['Type'] = 'Server' }
            },
            {
                                
                ['Title'] = 'Change storage password',
                ['Desc'] = 'Make sure no one is watching from behind.',
                ['Data'] = { ['Event'] = 'Ethnic-casino/client/rooms/change-password', ['Type'] = 'Client' }
            },
            {
                ['Title'] = 'Check Out',
                ['Desc'] = 'How was your stay?',
                ['Data'] = { ['Event'] = 'Ethnic-casino/server/rooms/rent-stop', ['Type'] = 'Server' }

            }
        }
    else
        MenuData = {
            {
                ['Title'] = 'Check in ($'..Config.Casino['Rent']..'/day)',
                ['Desc'] = 'Comes with bed & storage.',
                ['Data'] = { ['Event'] = 'Ethnic-casino/client/hotel/roomSetup', ['Type'] = 'Client' }
            }
        }
    end
    exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuData })
end)

RegisterNetEvent('Ethnic-casino/client/hotel/roomSetup', function()
    Citizen.SetTimeout(550, function()
        local hotelInfo = exports['Ethnic-ui']:CreateInput({
            {
                Name = 'hotelPass', 
                Label = 'Storage Password', 
                Icon = 'fas fa-lock',
                Type = 'Password'

            },
        })
        if hotelInfo['hotelPass'] then
            TriggerServerEvent('Ethnic-casino/server/rooms/rent-start', hotelInfo['hotelPass'])
        end
    end)
end)

RegisterNetEvent('Ethnic-casino/client/hotel/storageAuth', function(roomNumber)
    Citizen.SetTimeout(550, function()
        local storageAuth = exports['Ethnic-ui']:CreateInput({
            {
                Name = 'password', 
                Label = 'Storage Password', 
                Icon = 'fas fa-lock',
                Type = 'Password'

            },
        })
        if storageAuth['password'] then
            print(storageAuth['password'], roomNumber)
        end
    end)
end)

RegisterNetEvent('Ethnic-casino/client/hotel/open-storage', function(PolyInfo) 
    EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Room'..PolyInfo, 'Stash', 30, 700.0)
end)

RegisterNetEvent('Ethnic-casino/client/rooms/change-password', function()
    Citizen.SetTimeout(550, function()
        local storageAuth = exports['Ethnic-ui']:CreateInput({
            {
                Name = 'password', 
                Label = 'Storage Password', 
                Icon = 'fas fa-lock',
                Type = 'Password'
            },
        })
        if storageAuth['password'] then
            TriggerServerEvent('Ethnic-casino/server/rooms/change-password', storageAuth['password'])
        end
    end)
end)