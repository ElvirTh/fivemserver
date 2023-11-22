-- [ Code ] --

RegisterNetEvent('Ethnic-assets/server/error-log', function(Resource, Args)
    SendToDiscord("```Error in "..Resource..'```', Args)
end)

-- [ Functions ] --

function SendToDiscord(Name, Args)
    local connect = {
          {
              ["color"] = 16711680,
              ["title"] = ""..Name.."",
              ["description"] = Args,
              ["footer"] = {
                  ["text"] = "Ethnic Logs",
              },
          }
      }
    PerformHttpRequest('https://ptb.discord.com/api/webhooks/816007243660394517/Crd1ha6EcYFMclisd_6jUbqCEYCkP1CQ35EzCUk9uxKSOljJ47tT1fYRk_ci95uOK4jS', function(err, text, headers) end, 
    'POST', json.encode({username = "Ethnic - Error Log", embeds = connect, avatar_url = "https://i.imgur.com/omxrzjn.png"}), { ['Content-Type'] = 'application/json' })
end