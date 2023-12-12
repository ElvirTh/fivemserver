PlayerModule, EventsModule, FunctionModule, VehicleModule, BlipModule, EntityModule, KeybindsModule = nil
PlayerData = {}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'Vehicle',
        'BlipManager',
        'Callback',
		'Entity',
		'Keybinds',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['Ethnic-base']:FetchModule('Player')
        EventsModule = exports['Ethnic-base']:FetchModule('Events')
        FunctionModule = exports['Ethnic-base']:FetchModule('Functions')
        VehicleModule = exports['Ethnic-base']:FetchModule('Vehicle')
        BlipModule = exports['Ethnic-base']:FetchModule('BlipManager')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
		EntityModule = exports['Ethnic-base']:FetchModule("Entity")
		KeybindsModule = exports['Ethnic-base']:FetchModule("Keybinds")
		InitHelicam() InitAlpr()
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
    Citizen.SetTimeout(1250, function()
		PoliceInit() InitZones()
		RemoveAllJobBlips() 
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-logout', function()
	TriggerServerEvent('Ethnic-police/server/clear-blip')
	RemoveAllJobBlips() 
	ResetJail()

	PlayerData = {}
end)

RegisterNetEvent('Ethnic-base/client/on-job-update', function(JobData, DutyUpdate)
	PlayerData.Job = JobData
	if JobData.Name == 'police' or JobData.Name == 'ems' and DutyUpdate then
		if not JobData.Duty then TriggerServerEvent('Ethnic-police/server/clear-blip') end
	end
	RemoveAllJobBlips()
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-police/client/open-police-store', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
		EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Police Safe', 'Store', 0, 0, Config.PoliceStore, 'PoliceStore')
    end
end)

RegisterNetEvent('Ethnic-police/client/open-police-locker', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
		EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', "personalsafe_"..PlayerModule.GetPlayerData().CitizenId, 'Stash', 30, 200)
	end
end)

RegisterNetEvent('Ethnic-police/client/rifle-rack', function()
	local Vehicle = GetVehiclePedIsIn(PlayerPedId())
	exports['Ethnic-ui']:ProgressBar('Unlocking Rifle Rack..', 1000, nil, nil, false, true, function(DidComplete)
		if DidComplete and exports['Ethnic-inventory']:CanOpenInventory() then
			EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', "riflerack_"..GetVehicleNumberPlateText(Vehicle), 'Stash', 3, 35)
		end
	end)
end)

RegisterNetEvent('Ethnic-police/client/open-police-trash', function()
    Citizen.SetTimeout(450, function()
        if exports['Ethnic-inventory']:CanOpenInventory() then
			EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'police_trash', 'Temp', 100, 2500)
	    end
    end)
end)

RegisterNetEvent('Ethnic-police/client/open-police-command-stash', function()
    Citizen.SetTimeout(450, function()
        if exports['Ethnic-inventory']:CanOpenInventory() then
			EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', "police_command_stash", 'Stash', 50, 2500)
	    end
    end)
end)

RegisterNetEvent('Ethnic-police/client/create-badge', function()
    Citizen.SetTimeout(650, function()
		local Data = {
			{Name = 'StateId', Label = 'StateId', Icon = 'fas fa-signature'},
			{Name = 'Image', Label = 'Image (URL)', Icon = 'fas fa-link'},
		}

		local BadgeInput = exports['Ethnic-ui']:CreateInput(Data)
		if BadgeInput['StateId'] and BadgeInput['Image'] then
			TriggerServerEvent('Ethnic-police/server/request-pd-badge', BadgeInput['StateId'], BadgeInput['Image'])
		end
    end)
end)

RegisterNetEvent('Ethnic-police/client/post-badge', function(Name, Rank, Department, Image)
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)

    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        EventsModule.TriggerServer("Ethnic-items/server/show-badge", Name, Rank, Department, Image)
    else
        EventsModule.TriggerServer("Ethnic-items/server/show-badge", Name, Rank, Department, Image, ClosestPlayer['ClosestServer'])
    end
end)

RegisterNetEvent('Ethnic-police/client/show-badge', function(Name, Rank, Department, Image)
	exports['Ethnic-ui']:SendUIMessage('Police', 'ShowBadge', {
		Name = Name,
		Rank = Rank,
		Department = Department,
		Image = Image
	})
end)

RegisterNetEvent('Ethnic-police/client/badge-anim', function()
	FunctionModule.RequestAnimDict("missfbi_s4mop")
	TaskPlayAnim(PlayerPedId(), "missfbi_s4mop", "swipe_card", 1.0, 1.0, -1, 8, 0, 0, 0, 0)
	exports['Ethnic-assets']:AttachProp('PdBadge')
	Citizen.SetTimeout(2500, function()
		exports['Ethnic-assets']:RemoveProps('PdBadge')
		ClearPedTasks(PlayerPedId())
	end)
end)

RegisterNetEvent('Ethnic-police/client/send-311', function(Data)
    if PlayerModule.GetPlayerData().Job ~= nil and (PlayerModule.GetPlayerData().Job.Name == 'police' or PlayerModule.GetPlayerData().Job.Name == 'ems') and PlayerModule.GetPlayerData().Job.Duty then
		TriggerEvent('Ethnic-chat/client/post-message', "311 | ("..Data['Id']..") "..Data['Who']..':', Data['Message'], 'warning')
	end
end)

RegisterNetEvent('Ethnic-police/client/send-911', function(Data, IsAnonymously)
	local StreetLabel = exports['Ethnic-base']:FetchModule('Functions').GetStreetName()
	EventsModule.TriggerServer('Ethnic-ui/server/send-civ-alert', StreetLabel, Data, IsAnonymously)

end)

RegisterNetEvent('Ethnic-police/client/send-911-chat', function(Data, IsAnonymously)
    if PlayerModule.GetPlayerData().Job ~= nil and (PlayerModule.GetPlayerData().Job.Name == 'police' or PlayerModule.GetPlayerData().Job.Name == 'ems') and PlayerModule.GetPlayerData().Job.Duty then
        if IsAnonymously then
			TriggerEvent('Ethnic-chat/client/post-message', "911 | Anonymous:", Data['Message'], 'error')
        else
			TriggerEvent('Ethnic-chat/client/post-message', "911 | ("..Data['Id']..") "..Data['Who']..':', Data['Message'], 'error')
        end
		PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)
    end
end)

RegisterNetEvent('Ethnic-police/client/send-reaction-to-dispatch', function(Data)
    if PlayerModule.GetPlayerData().Job ~= nil and (PlayerModule.GetPlayerData().Job.Name == 'police' or PlayerModule.GetPlayerData().Job.Name == 'ems') and PlayerModule.GetPlayerData().Job.Duty then
        TriggerEvent('Ethnic-chat/client/post-message', "911r -> ("..Data['Id']..') '..Data['Who'], Data['Message'], "error")
    end
end)

RegisterNetEvent('Ethnic-police/client/send-911-dispatch', function(Data, IsAnonymously)
    local StreetLabel = exports['Ethnic-base']:FetchModule('Functions').GetStreetName()
	EventsModule.TriggerServer('Ethnic-ui/server/send-911-call', Data, StreetLabel, IsAnonymously)
end)

RegisterNetEvent('Ethnic-items/client/used-spikes', function()
	Citizen.SetTimeout(500, function()
		if not IsPedInAnyVehicle(PlayerPedId()) then
			exports['Ethnic-ui']:ProgressBar('Planting Spikes..', 500, {['AnimName'] = 'plant_floor', ['AnimDict'] = 'weapons@first_person@aim_rng@generic@projectile@thermal_charge@', ['AnimFlag'] = 49}, nil, false, true, function(DidComplete)
				if DidComplete then
					local DidRemove = CallbackModule.SendCallback("Ethnic-base/server/remove-item", 'spikes', 1, false, true)
					if DidRemove then
						local SendData = {['Heading'] = {}, ['Coords'] = {}}
						SendData['Heading'] = GetEntityHeading(PlayerPedId())
						for i = 1, 3 do
							table.insert(SendData['Coords'], GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.5 + (3.5 * i), 0.15))
						end
						TriggerServerEvent('Ethnic-police/server/lay-down-spikes', SendData)
					end
				end
			end)
		else
			TriggerEvent('Ethnic-ui/client/notify', "police-spikes", "I don\'t think so..", 'error')
		end
	end)
end)

RegisterNetEvent('Ethnic-police/client/lay-down-spikes', function(SpikeData)
	local SpikeModel = GetHashKey('p_ld_stinger_s')
	local ModelLoaded = FunctionModule.RequestModel(SpikeModel)
	if ModelLoaded then
		for k, v in pairs(SpikeData['Coords']) do
			local SpikeObj = CreateObject(SpikeModel, v.x, v.y, v.z, false, true, true)
			PlaceObjectOnGroundProperly(SpikeObj)
			SetEntityHeading(SpikeObj, SpikeData['Heading'])
			FreezeEntityPosition(SpikeObj, true)
			TriggerEvent('Ethnic-police/client/watch-spikes', SpikeObj, v)
		end
	end
end)

RegisterNetEvent('Ethnic-police/client/watch-spikes', function(Object, Coords)
	local SpikeModel, SpikeTimer = GetHashKey('p_ld_stinger_s'), 0
	while SpikeTimer < 500 do
		local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local DriverPed = GetPedInVehicleSeat(Vehicle, -1)
		SpikeTimer = SpikeTimer + 1
		Citizen.Wait(1)	

		if DriverPed then
			local DimensionOne, DimensionTwo = GetModelDimensions(GetEntityModel(Vehicle))
			local LeftFront = GetOffsetFromEntityInWorldCoords(Vehicle, DimensionOne.x - 0.25, 0.25, 0.0)
			local RightFront = GetOffsetFromEntityInWorldCoords(Vehicle, DimensionTwo.x + 0.25,0.25,0.0)
			local LeftBack = GetOffsetFromEntityInWorldCoords(Vehicle, DimensionOne.x - 0.25,-0.85,0.0)
			local RightBack = GetOffsetFromEntityInWorldCoords(Vehicle, DimensionTwo.x + 0.25,-0.85,0.0)

			if #(Coords - LeftFront) < 1.5 and not IsVehicleTyreBurst(Vehicle, 0, true) then
				if IsEntityTouchingEntity(Vehicle, GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 5.0, SpikeModel, 0, 0, 0)) then
					VehicleModule.SetVehicleTyreBurst(Vehicle, 0, true, 1000.0)
				end
			end

			if #(Coords - RightFront) < 1.5 and not IsVehicleTyreBurst(Vehicle, 1, true) then
				if IsEntityTouchingEntity(Vehicle, GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 5.0, SpikeModel, 0, 0, 0)) then
					VehicleModule.SetVehicleTyreBurst(Vehicle, 1, true, 1000.0)
				end
			end

			if #(Coords - LeftBack) < 1.5 and not IsVehicleTyreBurst(Vehicle, 4, true) then
				if IsEntityTouchingEntity(Vehicle, GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 5.0, SpikeModel, 0, 0, 0)) then
					VehicleModule.SetVehicleTyreBurst(Vehicle, 2, true, 1000.0)
					VehicleModule.SetVehicleTyreBurst(Vehicle, 4, true, 1000.0)	
				end		      		
			end

			if #(Coords - RightBack) < 1.5 and not IsVehicleTyreBurst(Vehicle,5,true) then
				if IsEntityTouchingEntity(Vehicle, GetClosestObjectOfType(Coords.x, Coords.y, Coords.z, 5.0, SpikeModel, 0, 0, 0)) then
					VehicleModule.SetVehicleTyreBurst(Vehicle, 3, true, 1000.0)
					VehicleModule.SetVehicleTyreBurst(Vehicle, 5, true, 1000.0)	
				end 		
			end

		end
	end

	EntityModule.DeleteEntity(Object)
end)

RegisterNetEvent('Ethnic-police/client/open-employee-list', function()
	local CopsList = CallbackModule.SendCallback("Ethnic-police/server/get-all-cops-db")
	local MenuData = {}
	local EmployeeList = {}

	for k, v in pairs(CopsList) do
		local List = {
			['Title'] = v.Name..' ('..v.Job.Callsign..')',
			['Desc'] = 'Show Employee Info',
			['Data'] = {['Event'] = '', ['Type'] = ''},
			['SecondMenu'] = {
				{
					['Title'] = 'Employee',
					['Desc'] = v.Name,
					['Type'] = 'Click',
					['Data'] = { ['Event'] = '', ['Type'] = '' },
					['CloseMenu'] = false,
				},
				{
					['Title'] = 'Informations',
					['Desc'] = 'Callsign: '..v.Job.Callsign..'; Highcommand: '..(tostring(v.Job.HighCommand) == 'true' and 'Yes' or 'No')..'<br>Department: '..v.Job.Department..'; Rank: '..v.Job.Rank,
					['Type'] = 'Click',
					['Data'] = { ['Event'] = '', ['Type'] = '' },
					['CloseMenu'] = false,
				},
				{
					['Title'] = 'Salary',
					['Desc'] = 'Current Salary: $'..v.Job.Salary..'.00',
					['Type'] = 'Click',
					['Data'] = { ['Event'] = '', ['Type'] = '' },
					['CloseMenu'] = false,
				},
				{
					['Title'] = 'Fire Employee',
					['Type'] = 'Click',
					['Data'] = { ['Event'] = 'Ethnic-police/client/fire-police', ['Type'] = 'Client', ['CitizenId'] = v.CitizenId },
				}
			},
		}
		table.insert(EmployeeList, List)
	end

	MenuData[#MenuData + 1] = {
		['Title'] = 'Employee List ('..#EmployeeList..')',
		['Desc'] = 'Show all employees',
		['Data'] = {['Event'] = '', ['Type'] = ''},
		['SecondMenu'] = EmployeeList,
	}
	MenuData[#MenuData + 1] = {
		['Title'] = 'Hire Person',
		['Desc'] = 'Hire someone',
		['Data'] = {['Event'] = 'Ethnic-police/client/hire-police', ['Type'] = 'Client'},
	}
	MenuData[#MenuData + 1] = {
		['Title'] = 'Fire Person',
		['Desc'] = 'Fire someone using State id',
		['Data'] = {['Event'] = 'Ethnic-police/client/fire-police', ['Type'] = 'Client'},
	}

	exports['Ethnic-ui']:OpenContext({ ['MainMenuItems'] = MenuData }) 
end)

RegisterNetEvent("Ethnic-police/client/fire-police", function()
	local PlayerData = PlayerModule.GetPlayerData()
	if PlayerData.Job.Name ~= 'police' or not PlayerData.Job.Duty or not PlayerData.Job.HighCommand then return end
	Citizen.SetTimeout(450, function()
        local Data = {{Name = 'StateId', Label = 'State Id', Icon = 'fas fa-user'}}
        local FireInput = exports['Ethnic-ui']:CreateInput(Data)
		if FireInput['StateId'] then
			EventsModule.TriggerServer('Ethnic-police/server/fire-employee', FireInput['StateId'])
		else
			TriggerEvent('Ethnic-ui/client/notify', 'police-error', "An error occured! (You can\'t leave this empty)", 'error')
		end
    end)
end)

RegisterNetEvent('Ethnic-police/client/hire-police', function()
	local PlayerData = PlayerModule.GetPlayerData()
	if PlayerData.Job.Name ~= 'police' or not PlayerData.Job.Duty or not PlayerData.Job.HighCommand then return end
	Citizen.SetTimeout(450, function()
        local Data = {{Name = 'StateId', Label = 'State Id', Icon = 'fas fa-user'}}
        local HireInput = exports['Ethnic-ui']:CreateInput(Data)
		if HireInput['StateId'] then
			EventsModule.TriggerServer('Ethnic-police/server/hire-employee', HireInput['StateId'])
		else
			TriggerEvent('Ethnic-ui/client/notify', 'police-error', "An error occured! (You can\'t leave this empty)", 'error')
		end
    end)
end)

-- Fines

RegisterNetEvent("Ethnic-police/client/give-fine", function()
	local PlayerData = PlayerModule.GetPlayerData()
	if PlayerData.Job.Name ~= 'police' or not PlayerData.Job.Duty then return end
    local Data = {
		{Name = 'StateId', Label = 'State Id', Icon = 'fas fa-user'},
		{Name = 'Title', Label = 'Fine Title', Icon = 'fas fa-heading'},
		{Name = 'Amount', Label = 'Fine Amount', Icon = 'fas fa-dollar-sign'},
		{Name = 'Expires', Label = 'Expire (In Days)', Icon = 'fas fa-clock'},
	}
    local FineInput = exports['Ethnic-ui']:CreateInput(Data)
    if FineInput['StateId'] then
        EventsModule.TriggerServer('Ethnic-phone/server/debts/add', FineInput['StateId'], FineInput['Title'] or 'Police Fine', FineInput['Amount'] or 1000, FineInput['Expires'] or 7)
    else
        TriggerEvent('Ethnic-ui/client/notify', 'police-error', "An error occured! (You can\'t leave this empty)", 'error')
    end
end)

RegisterNetEvent('Ethnic-police/client/fire-police', function(Data)
	if Data.CitizenId == nil or Data.CitizenId == '' then return end
	EventsModule.TriggerServer('Ethnic-police/server/fire-employee', Data.CitizenId)
end)

-- [ Functions ] --

function PoliceInit()
    Citizen.SetTimeout(3500, function()
		PlayerData = PlayerModule.GetPlayerData()
        if PlayerData.MetaData['Handcuffed'] then Config.Handcuffed = true end
    end)
	KeybindsModule.Add('escortPlayer', 'Player', 'Toggle Escort', '', false, 'Ethnic-police/client/toggle-escort')	
end

function GetTotalOndutyCops()
	local ActiveCops = CallbackModule.SendCallback("Ethnic-police/server/get-active-cops")
	return ActiveCops
end
exports('GetTotalOndutyCops', GetTotalOndutyCops)
	