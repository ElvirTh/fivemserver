RegisterNetEvent("Ethnic-misc/client/write-note", function()
    TriggerEvent("Ethnic-animations/client/play-animation", "notepad")
    exports['Ethnic-ui']:SetNuiFocus(true, true)
    exports['Ethnic-assets']:AttachProp('Notepad')
    exports['Ethnic-assets']:AttachProp('Pencil')
    exports['Ethnic-ui']:SendUIMessage("Notepad", "OpenNotepad", {
        Writing = true,
        Note = ""
    })
end)

RegisterNetEvent("Ethnic-misc/client/open-note", function(ItemInfo)
    TriggerEvent("Ethnic-animations/client/play-animation", "notepad")
    exports['Ethnic-ui']:SetNuiFocus(true, true)
    exports['Ethnic-assets']:AttachProp('Notepad')
    exports['Ethnic-assets']:AttachProp('Pencil')
    exports['Ethnic-ui']:SendUIMessage("Notepad", "OpenNotepad", {
        Writing = false,
        Note = ItemInfo.Note
    })
end)

RegisterNUICallback("Notepad/Close", function(Data, Cb)
    CloseNotepad()
    Cb("ok")
end)

RegisterNUICallback("Notepad/Save", function(Data, Cb)
    EventsModule.TriggerServer("Ethnic-misc/server/write-notepad", Data.Text)
    CloseNotepad()
    Cb("ok")
end)

function CloseNotepad()
    TriggerEvent("Ethnic-animations/client/clear-animation")
    exports['Ethnic-ui']:SetNuiFocus(false, false)
    exports['Ethnic-ui']:SendUIMessage("Notepad", "CloseNotepad")
    exports['Ethnic-assets']:RemoveProps()
end