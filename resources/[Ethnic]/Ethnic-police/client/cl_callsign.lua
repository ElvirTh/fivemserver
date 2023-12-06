    RegisterCommand("livery", function(source, args)
    
    local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    local num1 = tonumber(args[1])
        SetVehicleModKit(Veh, 0)
        SetVehicleMod(Veh, 48, num1, false)
    
    end)
    
    
    RegisterCommand("wintint", function(source, args)
    
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        SetVehicleWindowTint(vehicle, tonumber(args[1]))
    
    end)
    
    
    RegisterCommand("cleanveh", function(source, args)
    
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
        SetVehicleDirtLevel(vehicle, 0.0)
    
    end)
    
    RegisterCommand("callsignv", function(source, args) 
    
        local Veh = GetVehiclePedIsIn(GetPlayerPed(-1))
        local num1 = tonumber(args[1])
        local num2 = tonumber(args[2])
        local num3 = tonumber(args[3])
    
        SetVehicleModKit(Veh, 0)
        SetVehicleMod(Veh, 42, num1, false)
        SetVehicleMod(Veh, 44, num2, false)
        SetVehicleMod(Veh, 45, num3, false)
    
    end)
    