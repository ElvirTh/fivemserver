NearBollards = nil

function InitZones()
    Citizen.CreateThread(function()
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(410.12, -1028.21, 29.39),
            length = 6.0, 
            width = 17.0,
        }, {
            name = 'police_bollards_01',
            minZ = 28.0,
            maxZ = 32.2,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(410.01, -1020.72, 29.41), 
            length = 6.0, 
            width = 17.0,
        }, {
            name = 'police_bollards_02',
            minZ = 28.0,
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
            center = vector3(452.22, -1000.84, 27.67), 
            length = 6.6, 
            width = 20.6,
        }, {
            name = 'police_garage_01',
            minZ = 24.0,
            maxZ = 32.5,
            heading = 90.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(431.35, -1000.73, 27.71), 
            length = 6.6,
            width = 20.6,
        }, {
            name = 'police_garage_02',
            minZ = 24.0,
            maxZ = 32.5,
            heading = 90.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['Ethnic-polyzone']:CreateBox({
            center = vector3(489.32, -1020.25, 28.08), 
            length = 6.6,
            width = 20.6,
        }, {
            name = 'police_gate_back',
            minZ = 26.5,
            maxZ = 30.5,
            heading = 180.0,
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
    elseif PolyData.name == 'police_garage_01' then
        NearBollards = 'MRPD_GARAGE_01'
    elseif PolyData.name == 'police_garage_02' then
        NearBollards = 'MRPD_GARAGE_02'
    elseif PolyData.name == 'police_gate_back' then
        NearBollards = 'MRPD_BACK_GATE'
    else
        return
    end
end)

RegisterNetEvent('Ethnic-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'police_bollards_01' or PolyData.name == 'police_bollards_02' or PolyData.name == 'police_bollards_03' or  
    PolyData.name == 'police_garage_01' or PolyData.name == 'police_garage_02' or PolyData.name == 'police_gate_back' then
        NearBollards = nil
    else
        return
    end
end)