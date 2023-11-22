local NearBank, ShowingInteraction = false, false

-- [ Code ] --

-- [ Functions ] --

function InitZones()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.BankLocations) do
            exports['Ethnic-polyzone']:CreateBox({
                center = v['Coords'], 
                length = v['Data']['Length'], 
                width = v['Data']['Width'],
            }, {
                name = 'banking'..k,
                minZ = v['Data']['MinZ'],
                maxZ = v['Data']['MaxZ'],
                heading = v['Heading'],
                hasMultipleZones = false,
                debugPoly = false,
            }, function() end, function() end)
        end
        exports['Ethnic-ui']:AddEyeEntry(GetHashKey("prop_fleeca_atm"), {
            Type = 'Model',
            Model = 'prop_fleeca_atm',
            SpriteDistance = 2.0,
            Options = {
                {
                    Name = 'open_atm',
                    Icon = 'fas fa-dollar-sign',
                    Label = 'Atm',
                    EventType = 'Client',
                    EventName = 'Ethnic-financials/client/open-banking',
                    EventParams = false,
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
        for i = 1, 3 do
            exports['Ethnic-ui']:AddEyeEntry(GetHashKey("prop_atm_0"..i), {
                Type = 'Model',
                Model = 'prop_atm_0'..i,
                SpriteDistance = 2.0,
                Options = {
                    {
                        Name = 'open_atm',
                        Icon = 'fas fa-dollar-sign',
                        Label = 'Atm',
                        EventType = 'Client',
                        EventName = 'Ethnic-financials/client/open-banking',
                        EventParams = false,
                        Enabled = function(Entity)
                            return true
                        end,
                    },
                }
            })
        end
        
    end)
end

-- [ Events ] --

RegisterNetEvent('Ethnic-polyzone/client/enter-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'banking' then
        if not NearBank then
            NearBank = true

            if not ShowingInteraction then
                ShowingInteraction = true
                exports['Ethnic-ui']:SetInteraction('[E] Bank', 'primary')
            end
            Citizen.CreateThread(function()
                while NearBank do
                    Citizen.Wait(4)
                    if IsControlJustReleased(0, 38) then
                        exports['Ethnic-ui']:HideInteraction()
                        TriggerEvent('Ethnic-financials/client/open-banking', true)
                    end
                end
            end)

        end
    end
end)

RegisterNetEvent('Ethnic-polyzone/client/leave-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'banking' then
        if NearBank then
            NearBank = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['Ethnic-ui']:HideInteraction()
            end
        end
    end
end)