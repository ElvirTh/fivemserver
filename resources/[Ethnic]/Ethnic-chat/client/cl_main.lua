local ChatOpen, CanReceiveOOC, FunctionsModule, PlayerModule = false, true, nil, nil
local SpamFilter = {
    ["e passout"] = 5000,
    ["e passout2"] = 5000,
    ["e passout3"] = 5000,
    ["e passout4"] = 5000,
    ["e passout5"] = 5000,
    ["e slide"] = 5000,
}


local _Ready = false
AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Functions',
        'Player',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        FunctionsModule = exports['Ethnic-base']:FetchModule('Functions')
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

RegisterNetEvent('Ethnic-chat/client/toggle-OOC', function()
    CanReceiveOOC = not CanReceiveOOC
    if CanReceiveOOC then exports['Ethnic-ui']:Notify("chat", "You can see OOC 👀", "success")
    else exports['Ethnic-ui']:Notify("no-ooc", "You won't see OOC anymore..", "error") end
end)

RegisterNetEvent('Ethnic-ui/client/ui-reset', function()
    if ChatOpen then
        SetNuiFocus(false, false)
        ChatOpen = false
    end
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsControlJustPressed(0, 245) and not ChatOpen then -- Press T to open chat
                SetNuiFocus(true, false)
                SendNUIMessage({
                    Action = 'OpenChat',
                })
                ChatOpen = true
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and ChatOpen then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerId(), true)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('Ethnic-chat/client/post-message', function(Title, Message, Class)
    local ChatName = string.sub(Title, 1, 4)
    if (ChatName == 'OOC ' or ChatName == 'LOOC') and not CanReceiveOOC then return end

    local MessageData = {Header = Title, Message = Message, Type = Class}
    SendNUIMessage({
        Action = 'PostMessage',
        Message = MessageData
    })
end)

RegisterNetEvent('Ethnic-chat/client/send-identification', function(CitizenId, Firstname, Lastname, Date, Sex)
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)

    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        EventsModule.TriggerServer("Ethnic-items/server/show-identification", CitizenId, Firstname, Lastname, Date, Sex, nil)
    else
        EventsModule.TriggerServer("Ethnic-items/server/show-identification", CitizenId, Firstname, Lastname, Date, Sex, ClosestPlayer['ClosestServer'])
    end
end)

RegisterNetEvent('Ethnic-chat/client/post-identification', function(CitizenId, Firstname, Lastname, Date, Sex)
    local IdentificationData = {CitizenId = CitizenId, Firstname = Firstname, Lastname = Lastname, Date = Date, Sex = Sex}
    SendNUIMessage({
        Action = 'PostIdentificationCard',
        Identification = IdentificationData
    })
end)

RegisterNetEvent('Ethnic-chat/client/add-suggestion', function(Name, Desc, Args)
    local SuggestionData = {Name = Name, Description = Desc, Args = Args}
    SendNUIMessage({
        Action = 'AddSuggestion',
        Suggestion = SuggestionData
    })
end)

RegisterNetEvent('Ethnic-chat/client/refresh-suggestion', function()
    SendNUIMessage({Action = 'ClearSuggestions'})
end)

RegisterNetEvent('Ethnic-chat/client/clear-chat', function()
    SendNUIMessage({Action = 'ClearChat'})
end)

RegisterNetEvent("Ethnic-chat/client/local-ooc", function(ServerId, Name, Message)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(ServerId)), false)
    local TargetCoords = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(TargetCoords.x, TargetCoords.y, TargetCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 20.0) then
        TriggerEvent('Ethnic-chat/client/post-message', "LOOC | "..Name, Message, "normal")
    end
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('Chat/Execute', function(Data, Cb)
    local Message = Data.Value
    if Message:sub(1,1) == '/' then
        Message = Message:sub(2)
    end

    -- Checking if filter has any match to fix empty space bypass.
    local HasSpamFilter, FilteredWord = false, ""
    for k, v in pairs(SpamFilter) do
        if string.find(Message:lower(), k) then
            HasSpamFilter, FilteredWord = true, k
            break
        end
    end

    local HasCooldown = FunctionsModule.Throttled("chat-" .. FilteredWord, SpamFilter[FilteredWord])
    if not HasSpamFilter or (HasSpamFilter and not HasCooldown) then
        ExecuteCommand(Message)
        TriggerServerEvent('Ethnic-chat/server/log-execute', Message)
    else
        exports['Ethnic-ui']:Notify("command-cooldown", "You can't use this command yet..", "error")
    end

    Cb('Ok')
end)

RegisterNUICallback('Chat/Close', function(Data, Cb)
    SetNuiFocus(false, false)
    ChatOpen = false
    Cb('Ok')
end)

exports("GetSpamFilter", function()
    return SpamFilter
end)
