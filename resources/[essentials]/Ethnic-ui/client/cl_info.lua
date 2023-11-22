exports("SetInfo", function(Title, Description)
    exports['Ethnic-ui']:SendUIMessage("Info", "SetInfoData", {
        Title = Title,
        Description = Description,
    })
end)

exports("HideInfo", function()
    exports['Ethnic-ui']:SendUIMessage("Info", "HideInfo")
end)

RegisterNetEvent('Ethnic-ui/client/ui-reset', function()
    exports['Ethnic-ui']:HideInfo()
end)