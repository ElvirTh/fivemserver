
function InitPdmZones()
    Citizen.CreateThread(function()
        exports['Ethnic-ui']:AddEyeEntry("pdm_tablet_1", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-33.06, -1103.5, 26.42),
                Length = 0.3,
                Width = 0.35,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 70.0,
                    minZ = 26.42,
                    maxZ = 26.62
                },
            },
            Options = {
                {
                    Name = 'pdm_tablet',
                    Icon = 'fas fa-shopping-basket',
                    Label = 'View Catalog',
                    EventType = 'Client',
                    EventName = 'Ethnic-pdm/client/open-pdm-catalog',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['Ethnic-ui']:AddEyeEntry("pdm-store", {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 5.0,
            Distance = 5.0,
            Position = vector4(-50.24, -1089.09, 25.40, 153.98),
            Model = 's_m_m_highsec_01',
            Anim = {},
            Props = {},
            Options = {
                {
                    Name = 'pdm-store',
                    Icon = 'fas fa-car',
                    Label = 'Job Vehicles',
                    EventType = 'Client',
                    EventName = 'Ethnic-pdm/client/open-job-store',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['Ethnic-ui']:AddEyeEntry("bike-store", {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 7.0,
            Distance = 7.0,
            Position = vector4(-1107.50, -1694.84, 3.50, 320.44),
            Model = 'u_m_y_sbike',
            Anim = {},
            Props = {},
            Options = {
                {
                    Name = 'bike-store',
                    Icon = 'far fa-bicycle',
                    Label = 'Purchase Bicycle',
                    EventType = 'Client',
                    EventName = 'Ethnic-pdm/client/open-bicycle-store',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(-55.72, -1098.45, 26.42), 
            length = 58.4, 
            width = 61.4,
        }, {
            name = 'pdm_zone',
            minZ = 25.42,
            maxZ = 33.82,
            heading = 70.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end)
end

RegisterNetEvent('Ethnic-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'pdm_zone' then
        ShowShowroomVehicles()
    else
        return
    end
end)

RegisterNetEvent('Ethnic-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'pdm_zone' then
        RemoveShowroomVehicles()
    else
        return
    end
end)