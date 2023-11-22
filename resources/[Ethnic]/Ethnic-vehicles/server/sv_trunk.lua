local OccupiedTrunks = {}

CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end 

    CallbackModule.CreateCallback('Ethnic-vehicles/server/is-trunk-empty', function(Source, Cb, Plate)
        if OccupiedTrunks[Plate] then
            Cb(false)
        else
            Cb(true)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("Ethnic-vehicles/server/set-trunk-occupied", function(Plate, Bool)
    OccupiedTrunks[Plate] = Bool
end)
