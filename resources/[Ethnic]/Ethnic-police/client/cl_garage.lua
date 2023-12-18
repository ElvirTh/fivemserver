RegisterNetEvent('Ethnic-police/client/try-purchase-vehicle', function()
    Citizen.SetTimeout(450, function()
        local MenuItems = {}
        for k, v in pairs(Config.PurchaseVehicles) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v)]
            MenuData['Title'] = SharedData ~= nil and SharedData.Model..' '..SharedData.Name or GetLabelText(GetDisplayNameFromVehicleModel(v))
            MenuData['Desc'] = 'Price: $'..SharedData.Price..'.00 (Bank)'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Purchase Vehicle',
                    ['Type'] = 'Click',
                    ['CloseMenu'] = true,
                    ['Data'] = { ['Event'] = 'Ethnic-police/client/purchase-vehicle', ['Type'] = 'Client', ['BuyModel'] = v, ['BuyData'] = SharedData },
                },
            }
            table.insert(MenuItems, MenuData)
        end
        exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    end)
end)

RegisterNetEvent('Ethnic-police/client/purchase-vehicle', function(Data)
    SetTimeout(500, function()
        local InputData = {{Name = 'StateId', Label = 'State Id (Empty is self)', Icon = 'fas fa-user'}}
        local HireInput = exports['Ethnic-ui']:CreateInput(InputData)
        EventsModule.TriggerServer('Ethnic-police/server/purchase-police-vehicle', Data, HireInput['StateId'])
    end)
end)

-- Garage
RegisterNetEvent('Ethnic-menu/client/open-garage-heli', function(CurrentPad)
    if CurrentPad == 'Police' then
        local MenuItems = {}
        for k, v in pairs(Config.HeliPad) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v.Model)]
            MenuData['Title'] = SharedData ~= nil and SharedData.Model..' '..SharedData.Name or GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
            MenuData['Desc'] = 'Police Issued Helicopter'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Take Out Vehicle',
                    ['Type'] = 'Click',
                    ['CloseMenu'] = true,
                    ['Data'] = { ['Event'] = 'Ethnic-police/client/take-out-heli', ['Type'] = 'Client', ['HeliData'] = v },
                },
            }
            table.insert(MenuItems, MenuData)
        end 
        exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    else
        return
    end
end)

RegisterNetEvent('Ethnic-police/client/take-out-heli', function(Data)
    local Player = PlayerModule.GetPlayerData()
    local HeliData = Data.HeliData
    if HeliData ~= nil then
        local VehicleCoords = {['X'] = HeliData.Coords.x, ['Y'] = HeliData.Coords.y, ['Z'] = HeliData.Coords.z, ['Heading'] = HeliData.Coords.w}
        local Vehicle = VehicleModule.SpawnVehicle(HeliData.Model, VehicleCoords, nil, false)
        if Vehicle ~= nil then
            Citizen.SetTimeout(250, function()
                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                exports['Ethnic-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                exports['Ethnic-vehicles']:SetVehicleKeys(Plate, true, false)
                SetVehicleModKit(Vehicle['Vehicle'], 0)
                if Player.Job.Department ~= nil and Player.Job.Department == 'LSPD' then
                    SetVehicleLivery(Vehicle['Vehicle'], 0)
                elseif Player.Job.Department ~= nil and Player.Job.Department == 'BCSO' then
                    SetVehicleLivery(Vehicle['Vehicle'], 1)
                else
                    SetVehicleLivery(Vehicle['Vehicle'], 2)
                end
                NetworkFadeInEntity(Vehicle['Vehicle'], 0)
            end)
        end
    end
end)

RegisterNetEvent('Ethnic-menu/client/open-pd-menu',function(CurrentPad)
    if CurrentPad == 'Police' then
        local MenuItems = {}
        for k, v in pairs(Config.PolicePad) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v.Model)]
            MenuData['Title'] = SharedData ~= nil and SharedData.Model..' '..SharedData.Name or GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
            MenuData['Desc'] = 'Police Issued Vehicle'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Take Out Vehicle',
                    ['Type'] = 'Click',
                    ['CloseMenu'] = true,
                    ['Data'] = { ['Event'] = 'Ethnic-police/client/take-out-pdvehicle', ['Type'] = 'Client', ['PoliceData'] = v },
                },
            }
            table.insert(MenuItems, MenuData)
        end
        exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    else
        return
    end
end)

RegisterNetEvent('Ethnic-police/client/take-out-pdvehicle',function(Data)
    local Player = PlayerModule.GetPlayerData
    local PoliceData = Data.PoliceData
    if PoliceData ~= nil then
        local VehicleCoords = {['X'] = PoliceData.Coords.x, ['Y'] = PoliceData.Coords.y, ['Z'] = PoliceData.Coords.z, ['Heading'] = PoliceData.Coords.w}
        local Vehicle = VehicleModule.SpawnVehicle(PoliceData.Model, VehicleCoords, nil, false)
        local vehicle = SetVehicleColours(Vehicle['Vehicle'],61,61)
        local vehicle = SetVehicleNumberPlateText(Vehicle['Vehicle'],"POLICE")
        if Vehicle ~= nil then
            Citizen.SetTimeout(250, function()
                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                exports['Ethnic-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                exports['Ethnic-vehicles']:SetVehicleKeys(Plate, true, false)
                SetVehicleModKit(Vehicle['Vehicle'], 0)

                

                SetVehicleMod(Vehicle['Vehicle'],11,3,false) --engine
                SetVehicleMod(Vehicle['Vehicle'],12,2,false) --brakes
                SetVehicleMod(Vehicle['Vehicle'],13,2,false) --transmission
                SetVehicleMod(Vehicle['Vehicle'],15,3,false) --suspension
                SetVehicleMod(Vehicle['Vehicle'],16,4,false) --armor
                SetVehicleMod(Vehicle['Vehicle'],18,0,false) --turbo

                SetVehicleDirtLevel(Vehicle['Vehicle'], 0.0) --spawn car clean


                SetVehicleExtra(Vehicle['Vehicle'],1,0)
                SetVehicleExtra(Vehicle['Vehicle'],2,0)
                SetVehicleExtra(Vehicle['Vehicle'],3,0)
                SetVehicleExtra(Vehicle['Vehicle'],4,0)
                SetVehicleExtra(Vehicle['Vehicle'],5,0)
                SetVehicleExtra(Vehicle['Vehicle'],6,0)
                SetVehicleExtra(Vehicle['Vehicle'],7,0)
                SetVehicleExtra(Vehicle['Vehicle'],8,0)
                SetVehicleMod(Vehicle['Vehicle'],0,0,false) --spoiler
                SetVehicleMod(Vehicle['Vehicle'],1,0,false) -- front bumper
                SetVehicleMod(Vehicle['Vehicle'],2,2,false) -- rear bumper
                SetVehicleMod(Vehicle['Vehicle'],3,0,false) -- skirts
                SetVehicleMod(Vehicle['Vehicle'],6,0,false) -- grille
                SetVehicleMod(Vehicle['Vehicle'],4,0,false) -- Exhaust

                SetVehicleMod(Vehicle['Vehicle'],23,2,false) --front wheels

                SetVehicleMod(Vehicle['Vehicle'],28,0,false) --ornament
                SetVehicleMod(Vehicle['Vehicle'],29,0,false) --dasboard
                
            end)
        end
    end
end)

-- [ Functions ] --

function GetClearSpawnPoint()
    local CurrentGarage = GetCurrentGarage()
    if CurrentGarage ~= nil then
        for k, v in pairs(Config.ParkingSlots[CurrentGarage]) do
            if VehicleModule.CanVehicleSpawnAtCoords(v, 1.85) then
                return v
            end
        end
        return false
    else
        return false
    end
end

function GetClearDepotSpawnPoint()
    for k, v in pairs(Config.DepotParkingSpots) do
        if VehicleModule.CanVehicleSpawnAtCoords(v, 1.85) then
            return v
        end
    end
    return false
end

function IsVehicleStillAvailable(Plate)
    local State = CallbackModule.SendCallback("Ethnic-police/server/get-vehicle-state", Plate)
    if State == false or State == 'Out' then return false end
    return true
end

function GetGarageData(Type)
    local Vehicles = CallbackModule.SendCallback("Ethnic-police/server/get-garage", Type)
    return Vehicles
end

