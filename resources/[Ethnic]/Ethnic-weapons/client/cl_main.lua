local WeaponMode, HasScope, HasFireMode, CallbackModule, KeybindsModule, PreferencesModule = 'Full-Auto', false, false, nil, nil, nil
local HasCrosshair = nil
InVehicle = false

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Keybinds',
        'Preferences',
    }, function(Succeeded)
        if not Succeeded then return end
        KeybindsModule = exports['Ethnic-base']:FetchModule('Keybinds')
        CallbackModule = exports['Ethnic-base']:FetchModule('Callback')
        PreferencesModule = exports['Ethnic-base']:FetchModule('Preferences')
        _Ready = true
    end)
end)

RegisterNetEvent('Ethnic-base/client/on-login', function()
	Citizen.SetTimeout(1250, function()
        HasScope, WeaponMode, HasFireMode = false, 'Full-Auto', false
        TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Show', false)
        TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Value', WeaponMode)
        KeybindsModule.Add('switchFireMode', 'Weapons', 'Switch Fire Mode', '', false, 'Ethnic-weapons/client/switch-fire-mode')
        local Preferences = PreferencesModule.GetPreferences()
        if Preferences ~= nil and HasCrosshair == nil then
            HasCrosshair = Preferences.Hud.Crosshair
        end
	end)
end)

RegisterNetEvent('Ethnic-base/client/on-logout', function()
    HasScope, WeaponMode, HasFireMode = false, 'Full-Auto', false
    TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Show', false)
    TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Value', WeaponMode)
end)

RegisterNetEvent("Ethnic-base/client/player-spawned", function()
    CreateThread(function()
        for k, v in pairs(Shared.Weapons) do
            if v.AmmoType == 'AMMO_NONE' then 
                local WeaponHash = GetHashKey(k)
                SetWeaponDamageModifier(WeaponHash, v.Modifier)
            end
        end
        SetWeaponDamageModifier(GetHashKey('WEAPON_UNARMED'), 0.3)
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and IsPedArmed(PlayerPedId(), 6) then
            local Weapon, Type = GetSelectedPedWeapon(PlayerPedId()), 'Normal'
            if Shared.Weapons[Weapon] ~= nil and Shared.Weapons[Weapon]['WeaponID'] == 'weapon_sniperrifle2' then
                Type = 'Hunting'
            end

            if IsPlayerFreeAiming(PlayerId()) then
                HasScope = true
                if Type == 'Hunting' then
                    exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Hunting', Bool = true})
                else
                    if HasCrosshair ~= nil and HasCrosshair then 
                        exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Normal', Bool = true})
                    end
                end
            elseif HasScope then
                HasScope = false
                if Type == 'Hunting' then
                    exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Hunting', Bool = false})
                else
                    exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Normal', Bool = false})
                end
            end
        else
            if HasScope then
                exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Normal', Bool = false})
                exports['Ethnic-ui']:SendUIMessage('Scope', 'ToggleScope', {Type = 'Hunting', Bool = false})
            end
            Citizen.Wait(250)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and IsPedArmed(PlayerPedId(), 6) then
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            if Shared.Weapons[Weapon] ~= nil and Shared.Weapons[Weapon]['AmmoType'] ~= 'AMMO_FIRE' and Shared.Weapons[Weapon]['AmmoType'] ~= 'AMMO_NONE' then 
                local WeaponBullets = GetAmmoInPedWeapon(PlayerPedId(), Weapon)
                if IsPedShooting(PlayerPedId()) and Config.WeaponData ~= nil then
                    if WeaponBullets == 1 then
                        TriggerServerEvent("Ethnic-weapons/server/update-weapon-ammo", Config.WeaponData, 1)
                    else
                        TriggerServerEvent("Ethnic-weapons/server/update-weapon-ammo", Config.WeaponData, tonumber(WeaponBullets))
                    end
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and IsPedArmed(PlayerPedId(), 6) then
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            if Shared.Weapons[Weapon] ~= nil and Shared.Weapons[Weapon]['AmmoType'] ~= 'AMMO_FIRE' and Shared.Weapons[Weapon]['AmmoType'] ~= 'AMMO_TASER' and Shared.Weapons[Weapon]['AmmoType'] ~= 'AMMO_EMP' then
                if IsPedShooting(PlayerPedId()) and Config.WeaponData ~= nil then
                    TriggerServerEvent('Ethnic-police/server/create-evidence', 'Bullet', Config.WeaponData)
                    if not exports['Ethnic-police']:IsStatusAlreadyActive('gunpowder') then
                        TriggerEvent('Ethnic-police/client/evidence/set-status', 'gunpowder', 500)
                    end
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(450)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey('WEAPON_UNARMED') then
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            if Shared.Weapons[Weapon] ~= nil and (Shared.Weapons[Weapon]['AmmoType'] == 'AMMO_FIRE' or Shared.Weapons[Weapon]['AmmoType'] == 'AMMO_NONE') then
                if (IsPedInAnyVehicle(PlayerPedId()) and IsControlJustPressed(0, 24) and IsPedWeaponReadyToShoot(PlayerPedId())) or IsPedShooting(PlayerPedId()) then
                    Citizen.SetTimeout(400, function()
                        local DidRemove = CallbackModule.SendCallback("Ethnic-base/server/remove-item", Shared.Weapons[Weapon]['WeaponID'], 1, false, true)
                        TriggerEvent('Ethnic-inventory/client/reset-weapon')
                    end)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and IsPedArmed(PlayerPedId(), 6) then
            local Weapon = GetSelectedPedWeapon(PlayerPedId())
            if Shared.Weapons[Weapon] ~= nil and Shared.Weapons[Weapon]['SelectFire'] then
                if not HasFireMode then
                    HasFireMode = true
                    TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Show', true)
                end
                if WeaponMode == 'Burst' then
                    if IsControlJustPressed(0, 24) then
                        Citizen.Wait(350)
                        while IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) do
                            DisablePlayerFiring(PlayerId(), true)
                            Citizen.Wait(0)
                        end
                    end
                elseif WeaponMode == 'Single' then
                    if IsControlJustPressed(0, 24) then
                        Citizen.Wait(0)
                        while IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) do
                            DisablePlayerFiring(PlayerId(), true)
                            Citizen.Wait(0)
                        end
                    end
                else
                    Citizen.Wait(450)
                end
            else
                if HasFireMode then
                    HasFireMode = false
                    TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Show', false)
                end
                Citizen.Wait(450)
            end
        else
            if HasFireMode then
                HasFireMode = false
                TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Show', false)
            end
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

AddEventHandler('Ethnic-threads/entered-vehicle', function()
    InVehicle = true
    SetVehicleAiming()
end)

AddEventHandler('Ethnic-threads/exited-vehicle', function()
    InVehicle = false
end)

RegisterNetEvent('Ethnic-preferences/client/update', function(PreferencesData)
    if next(PreferencesData) == nil then return print("Preferences is empty") end
    HasCrosshair = PreferencesData.Hud['Crosshair']
end)

RegisterNetEvent('Ethnic-weapons/client/set-current-weapon', function(WeaponData)
    Config.WeaponData = WeaponData
end)

RegisterNetEvent('Ethnic-weapons/client/switch-fire-mode', function(OnPress)
    if not OnPress then return end
    if WeaponMode == 'Full-Auto' then
        WeaponMode = 'Burst'
    elseif WeaponMode == 'Burst' then
        WeaponMode = 'Single'
    elseif WeaponMode == 'Single' then
        WeaponMode = 'Full-Auto'
    end
    TriggerEvent('Ethnic-ui/client/set-hud-values', 'FireMode', 'Value',  WeaponMode)
end)

RegisterNetEvent('Ethnic-items/client/reload-ammo', function(AmmoType, AmmoName)
    local Weapon = GetSelectedPedWeapon(PlayerPedId())
    local WeaponBullets = GetAmmoInPedWeapon(PlayerPedId(), Weapon)

    if Shared.Weapons[Weapon] == nil or Shared.Weapons[Weapon].AmmoType == nil then return end
    if Shared.Weapons[Weapon].AmmoType ~= AmmoType then return end

    if WeaponBullets <= Shared.Weapons[Weapon].MaxAmmo then
        exports['Ethnic-inventory']:SetBusyState(true)
        exports['Ethnic-ui']:ProgressBar('Reloading..', 3500, false, false, false, true, function(DidComplete)
            if DidComplete then
                exports['Ethnic-inventory']:SetBusyState(false)
                local DidRemove = CallbackModule.SendCallback("Ethnic-base/server/remove-item", AmmoName, 1, false, true)
                if DidRemove then
                    local NewAmmo = Shared.Weapons[Weapon].MaxAmmo
                    SetAmmoInClip(PlayerPedId(), Weapon, 0) SetPedAmmo(PlayerPedId(), Weapon, NewAmmo)
                    TriggerServerEvent("Ethnic-weapons/server/update-weapon-ammo", Config.WeaponData, tonumber(NewAmmo))
                end
            else
                exports['Ethnic-inventory']:SetBusyState(false)
            end
        end)
    end
end)

RegisterNetEvent("Ethnic-weapons/client/set-ammo", function(Ammo)
    local Weapon = GetSelectedPedWeapon(PlayerPedId())
    if Weapon == GetHashKey("weapon_unarmed") then return end
    if Shared.Weapons[Weapon] == nil or Shared.Weapons[Weapon].AmmoType == nil then return end
    SetAmmoInClip(PlayerPedId(), Weapon, 0)
    SetPedAmmo(PlayerPedId(), Weapon, Ammo)
    TriggerServerEvent("Ethnic-weapons/server/update-weapon-ammo", Config.WeaponData, Ammo)
end)