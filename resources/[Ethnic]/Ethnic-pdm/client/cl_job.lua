
RegisterNetEvent('Ethnic-pdm/client/open-job-store', function()
    local MenuItems = {}
    for k, v in pairs(Shared.Vehicles) do
        if v.ShopClass == 'Job' then
            local MenuData = {}
            MenuData['Title'] = v.Model..' '..v.Name
            MenuData['Desc'] = 'Purchase this vehicle for: $'.. FunctionsModule.GetTaxPrice(v.Price, 'Vehicle')..'.00'
            MenuData['Data'] = {['Event'] = 'Ethnic-pdm/client/try-buy-job-vehicle', ['Type'] = 'Client', ['VehicleData'] = v }
            MenuData['Type'] = 'Click'
            table.insert(MenuItems, MenuData)
        end
    end
    exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent('Ethnic-pdm/client/try-buy-job-vehicle', function(Data)
    EventsModule.TriggerServer('Ethnic-pdm/server/buy-vehicle', Data.VehicleData.Vehicle)
end)