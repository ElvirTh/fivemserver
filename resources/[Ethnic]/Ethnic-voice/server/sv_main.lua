-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("Ethnic-voice/server/connection-state", function(State)
    local Source = source
    Config.VoiceEnabled = State
    TriggerClientEvent('Ethnic-voice/client/connection-state', Source, State)
end)

RegisterNetEvent("Ethnic-voice/server/transmission-state", function(Context, Transmitting)
    local Source = source
    TriggerClientEvent('Ethnic-voice/client/transmission-state', -1, Source, Context, Transmitting)
end)

RegisterNetEvent("Ethnic-voice/server/transmission-state-radio", function(Group, Context, Transmitting, IsMult)
	local Source = source
    if IsMult then
        for k, v in pairs(Group) do
            TriggerClientEvent('Ethnic-voice/client/transmission-state', v, Source, Context, Transmitting)
        end
    else
        TriggerClientEvent('Ethnic-voice/client/transmission-state', Group, Source, Context, Transmitting)
    end
end)