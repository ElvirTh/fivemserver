RegisterNUICallback('MDW/Legislation/Get', function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-mdw/server/get-legislation")
    Cb(Result)
end)

RegisterNUICallback('MDW/Legislation/Create', function(Data, Cb)
    EventsModule.TriggerServer('Ethnic-mdw/server/create-legislation', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Legislation/Update', function(Data, Cb)
    EventsModule.TriggerServer('Ethnic-mdw/server/update-legislation', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Legislation/Delete', function(Data, Cb)
    EventsModule.TriggerServer('Ethnic-mdw/server/delete-legislation', Data)
    Cb('Ok')
end)