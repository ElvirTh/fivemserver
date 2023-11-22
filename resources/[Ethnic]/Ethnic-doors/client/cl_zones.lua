NearBollards = nil

function InitZones()
    Citizen.CreateThread(function()
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(410.9, -1028.66, 29.2), 
            length = 5.2, 
            width = 12.6,
        }, {
            name = 'police_bollards_01',
            minZ = 28.2,
            maxZ = 32.2,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(412.76, -1020.29, 29.35), 
            length = 5.0, 
            width = 14.2,
        }, {
            name = 'police_bollards_02',
            minZ = 28.35,
            maxZ = 32.35,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(-453.24, 6028.62, 31.34), 
            length = 5.6, 
            width = 15.8,
        }, {
            name = 'police_bollards_03',
            minZ = 30.34,
            maxZ = 33.74,
            heading = 45.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(431.44, -1001.39, 25.79), 
            length = 30,
            width = 6,
        }, {
            name = 'police_garage_01',
            minZ = 24.7,
            maxZ = 33,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(452.49, -1001.44, 25.79), 
            length = 30, 
            width = 6,
        }, {
            name = 'police_garage_02',
            minZ = 24.7,
            maxZ = 33,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end)
end

RegisterNetEvent('Ethnic-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'police_bollards_01' then
        NearBollards = 'MRPD_BOLLARDS_02'
    elseif PolyData.name == 'police_bollards_02' then
        NearBollards = 'MRPD_BOLLARDS_01'
    elseif PolyData.name == 'police_bollards_03' then
        NearBollards = 'PBSO_BOLLARDS_01'
    elseif PolyData.name =='police_garage_01' then
        NearBollards = 'MRPD_GARAGE_01'
    elseif PolyData.name == 'police_garage_02' then 
        NearBollards = 'MRPD_GARAGE_02'
    else
        return
    end
end)

RegisterNetEvent('Ethnic-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'police_bollards_01' or PolyData.name == 'police_bollards_02' or PolyData.name == 'police_bollards_03'  or PolyData.name == 'police_garage_01' or PolyData.name =='police_garage_02' then
        NearBollards = nil
    else
        return
    end
end)