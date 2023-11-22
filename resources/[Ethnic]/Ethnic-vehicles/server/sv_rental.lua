CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end 

    EventsModule.RegisterServer("Ethnic-vehicles/server/receive-rental-papers", function(Source, RandomPlate)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Info = {}
        Info.Plate = RandomPlate
        Player.Functions.AddItem('rental-papers', 1, false, Info, true)
    end)
end)