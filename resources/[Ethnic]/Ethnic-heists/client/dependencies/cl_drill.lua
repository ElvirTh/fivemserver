
function DrillMinigame()
    local Promise = promise:new()

    FunctionsModule.RequestAnimDict("anim@heists@fleeca_bank@drilling")
    TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
    exports['Ethnic-assets']:AttachProp('Drill')

    exports['Ethnic-ui']:StartDrilling(function(Outcome)
        exports['Ethnic-assets']:RemoveProps()
        exports["Ethnic-inventory"]:SetBusyState(false)
        StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)

        Promise:resolve(Outcome)
    end)

    if not IsWearingHandshoes() and math.random(1, 100) <= 85 then
        TriggerServerEvent("Ethnic-police/server/create-evidence", 'Fingerprint')
    end

    return Citizen.Await(Promise)
end
exports("DrillMinigame", DrillMinigame)