CommandsModule, PlayerModule, EventsModule = nil, nil, nil

AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Commands',
        'Player',
        'Events'
    }, function(Succeeded)
        if not Succeeded then return end
        CommandsModule = exports['Ethnic-base']:FetchModule('Commands')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')

        CommandsModule.Add("oocm", "Toggle OOC", {}, false, function(source, args)
            TriggerClientEvent('Ethnic-chat/client/toggle-OOC', source)
        end)
    
        CommandsModule.Add("ooc", "Talk in out of character chat", {{Name="Text", Description="Text"}}, false, function(source, args)
            local Player = PlayerModule.GetPlayerBySource(source) 
            local Message = table.concat(args, ' ')
            TriggerClientEvent('Ethnic-chat/client/post-message', -1, "OOC | "..Player.PlayerData.Name, Message, "normal")
        end)

        CommandsModule.Add("looc", "Talk in local out of character chat", {{Name="Text", Description="Text"}}, false, function(source, args)
            local Player = PlayerModule.GetPlayerBySource(source) 
            local Message = table.concat(args, ' ')
            TriggerClientEvent('Ethnic-chat/client/local-ooc', -1, source, GetPlayerName(source), Message)
        end)
    
        CommandsModule.Add("clear", "Clear your chat", {}, false, function(source, args)
            TriggerClientEvent('Ethnic-chat/client/clear-chat', source)
        end)
    
        CommandsModule.Add("clearchatall", "Clear everyone's chat", {}, false, function(source, args)
            TriggerClientEvent('Ethnic-chat/client/clear-chat', -1)
        end, "admin")
        EventsModule.RegisterServer('mercy-chat/server/post-message', function(source, Title, Message, Class)
            TriggerClientEvent('mercy-chat/client/post-message', -1, Title, Message, Class)
        end)
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("Ethnic-chat/server/log-execute", function(Message)
    local src = source
   print(GetPlayerName(src), Message)
end)