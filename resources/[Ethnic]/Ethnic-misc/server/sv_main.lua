CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
Carrying, Carried = {}, {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        DatabaseModule = exports['Ethnic-base']:FetchModule('Database')
        CommandsModule = exports['Ethnic-base']:FetchModule('Commands')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    CommandsModule.Add({"carry"}, "Carry the closest person", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Text = args[1]
        TriggerClientEvent('Ethnic-misc/client/try-carry', source)
    end)

    CallbackModule.CreateCallback('Ethnic-misc/server/gopros/does-exist', function(Source, Cb, CamId)
        for k, v in pairs(Config.GoPros) do
            if tonumber(v.Id) == tonumber(CamId) then
                Cb(v)
                return
            end
        end
        Cb(false)
    end)

    CallbackModule.CreateCallback('Ethnic-misc/server/gopros/get-all', function(Source, Cb)
        Cb(Config.GoPros)
    end)

    CallbackModule.CreateCallback('Ethnic-misc/server/has-illegal-item', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            for k, v in pairs(Config.IllegalItems) do
                local ItemData = Player.Functions.GetItemByName(v)
                if ItemData ~= nil and ItemData.Amount > 0 then
                    Cb(v)
                end
            end
        end
        Cb(false)
    end)
    
    EventsModule.RegisterServer("Ethnic-misc/server/spray-place", function(Source, Coords, Heading, Type)
        local CustomId = math.random(11111, 99999)
        local NewSpray = {
            Id = CustomId,
            Name = "Spray-"..CustomId,
            Type = Type,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z - 2.0,
                H = Heading
            },
        }
        Config.Sprays[#Config.Sprays + 1] = NewSpray
        TriggerClientEvent('Ethnic-misc/client/sync-sprays', -1, NewSpray)
        TriggerClientEvent('Ethnic-misc/client/done-placing-spray', Source, CustomId)
    end)

    EventsModule.RegisterServer("Ethnic-misc/server/gopro-place", function(Source, Coords, Heading, Encrypted, IsVehicle, Vehicle)
        local CustomId = math.random(11111, 99999)
        local NewGoPro = {
            Id = CustomId,
            Name = "GoPro-"..CustomId,
            IsEncrypted = Encrypted,
            IsVehicle = IsVehicle,
            Vehicle = IsVehicle and Vehicle or false,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z,
                H = Heading
            },
            Timestamp = os.date(),
        }
        Config.GoPros[#Config.GoPros + 1] = NewGoPro
        TriggerClientEvent('Ethnic-misc/client/gopro-action', -1, 2, NewGoPro)
        TriggerClientEvent('Ethnic-ui/client/notify', Source, "gopro-placed", "You placed a GoPro ("..CustomId..")", 'success')
    end)
    
    EventsModule.RegisterServer('Ethnic-misc/server/send-me', function(Source, Text)
        TriggerClientEvent('Ethnic-misc/client/me', -1, Source, Text)
    end)
    
    EventsModule.RegisterServer('Ethnic-misc/server/goldpanning/get-loot', function(Source, Multiplier)
        print('[DEBUG:Misc]: Giving goldpanning loot. Multiplier: '..Multiplier)
        if Multiplier == 1 then

        elseif Multiplier == 2 then

        elseif Multiplier == 3 then

        end
    end)

    function ShuffleTable(tbl)
        local random = math.random
        local n = #tbl

        for i = n, 2, -1 do
            local j = random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end

    EventsModule.RegisterServer('Ethnic-misc/server/metal-detecting/get-loot', function(Source)
        print('[DEBUG:Misc]: Giving metal detecting loot.')

        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        local RandomChance = math.random(0, 100) / 100

        local ShuffledItems = {}
        for ItemName, Chance in pairs(Config.MetalDetectItems) do
            table.insert(ShuffledItems, { Name = ItemName, Chance = Chance })
        end
        ShuffleTable(ShuffledItems)

        for _, ItemData in ipairs(ShuffledItems) do
            if RandomChance <= ItemData.Chance then
                Player.Functions.AddItem(ItemData.Name, math.random(1, 4), false, {}, true)
                return
            end
        end

        Player.Functions.Notify('no-item', 'You did not find anything..', 'error')
    end)

    EventsModule.RegisterServer('Ethnic-misc/server/recycle/get-loot', function(Source)
        print('[DEBUG:Misc]: Giving recycle loot.')
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        Player.Functions.AddItem('recyclablematerial', math.random(5, 8), false, false, true)
    end)

    EventsModule.RegisterServer('Ethnic-misc/server/get-tea', function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        if Player.Functions.RemoveItem('water', 1) then
            Player.Functions.AddItem('mugoftea', 1, false, {}, true)
        end
    end)

    EventsModule.RegisterServer('Ethnic-misc/server/write-notepad', function(Source, Text)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
          
        local Notepad = Player.Functions.GetItemByName('notepad')
        if Notepad == nil then return end

        if Player.Functions.AddItem('notepad-page', 1, false, {Note = Text}, true) then
            Notepad.Info.Pages = Notepad.Info.Pages - 1
            Player.Functions.SetItemBySlotAndKey(Notepad.Slot, "Info", Notepad.Info)
            if Notepad.Info.Pages <= 0 then
                Player.Functions.RemoveItem('notepad', 1, Notepad.Slot, true)          
            end
        end
    end)
end)

RegisterNetEvent("Ethnic-misc/server/sprays/try-remove", function(Data)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    if Player.Functions.RemoveItem('scrubbingcloth', 1) then
        TriggerClientEvent('Ethnic-misc/client/sprays/remove', src, Data.Id)
    else
        Player.Functions.Notify('no-scrub-cloth', 'You do not seem to have a scrubbing cloth..', 'error')
    end
end)

RegisterNetEvent("Ethnic-misc/server/sprays/remove", function(Id)
    for SprayId, Spray in pairs(Config.Sprays) do
        if tonumber(SprayId) == tonumber(Id) then
            TriggerClientEvent('Ethnic-misc/client/sync-sprays', -1, Spray, true, SprayId)
            table.remove(Config.Sprays, SprayId)
            return
        end
    end
end)

RegisterNetEvent("Ethnic-misc/server/carry-target", function(TargetServer)
    local src = source
    TriggerClientEvent('Ethnic-misc/client/getting-carried', TargetServer, src)
    Carrying[src] = TargetServer
    Carried[TargetServer] = src
end)

RegisterNetEvent("Ethnic-misc/server/stop-carry", function()
    local src = source
    if Carrying[src] then
        TriggerClientEvent('Ethnic-misc/client/stop-carry', Carrying[src])
    elseif Carried[src] then
        TriggerClientEvent('Ethnic-misc/client/stop-carry', Carried[src])
    end
    Carrying[src] = nil
    Carried[TargetServer] = nil
end)

-- GoPro

RegisterNetEvent("Ethnic-misc/server/gopro-action", function(GoProId, Action, Bool)
    if Action == 'SetBlurred' then
        for k, v in pairs(Config.GoPros) do
            if tonumber(v.Id) == tonumber(GoProId) then
                Config.GoPros[k].Blurred = Bool
                TriggerClientEvent('Ethnic-misc/client/gopro-action', -1, 3, Config.GoPros[k])
                return
            end
        end
    end
end)