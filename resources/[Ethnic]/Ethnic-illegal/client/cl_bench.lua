local InsideBenchContainer = false

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('Ethnic-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'crafting_bench' then
        if not InsideBenchContainer then
            InsideBenchContainer = true
        end
    else
        return
    end
end)

RegisterNetEvent('Ethnic-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'crafting_bench' then
        if InsideBenchContainer then
            InsideBenchContainer = false
        end
    else
        return
    end
end)

RegisterNetEvent('Ethnic-illegal/client/open-crafting-bench', function()
    if exports['Ethnic-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('Ethnic-inventory/server/open-other-inventory', 'Bench Crafting', 'Crafting', 0, 0, Config.BenchCrafting)
    end
end)

-- [ Functions ] --

function IsInsideBenchContainer()
    return InsideBenchContainer
end
exports("IsInsideBenchContainer", IsInsideBenchContainer)

-- function IsContainerWhitelisted()
--     local CitizenId = PlayerModule.GetPlayerData().CitizenId
--     for k, v in pairs(Config.ContainerWhitelist) do
--         if CitizenId == v then
--             return true
--         end
--     end
--     return false
-- end
-- exports("IsContainerWhitelisted", IsContainerWhitelisted)