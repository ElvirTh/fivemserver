local ChainObject, CurrentChain = nil, nil
local ItemsToChain = {
    ["cerberus-chain"] = {
        Model = "cerberus_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["cg-chain"] = {
        Model = "cg_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["cg2-chain"] = {
        Model = "cg_chain2",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["esv-chain"] = {
        Model = "esv_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["gg-chain"] = {
        Model = "gg_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["gsf-chain"] = {
        Model = "gsf_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["koil-chain"] = {
        Model = "koil_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["mdm-chain"] = {
        Model = "mdm_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["nbc-chain"] = {
        Model = "nbc_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["rl-chain"] = {
        Model = "rl_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
    ["seaside-chain"] = {
        Model = "seaside_chain",
        Pos = vector3(-0.02, 0.02, -0.06),
        Rot = vector3(-366.0, 19.0, -163.0)
    },
}


RegisterNetEvent("Ethnic-inventory/client/update-player", function()
    if not CurrentChain then return end
    Citizen.SetTimeout(500, function()
        local CerberusChain = exports['Ethnic-inventory']:HasEnoughOfItem('cerberus-chain', 1)
        local CGChain = exports['Ethnic-inventory']:HasEnoughOfItem('cg-chain', 1)
        local CG2Chain = exports['Ethnic-inventory']:HasEnoughOfItem('cg2-chain', 1)
        local ESVChain = exports['Ethnic-inventory']:HasEnoughOfItem('esv-chain', 1)
        local GGChain = exports['Ethnic-inventory']:HasEnoughOfItem('gg-chain', 1)
        local GSFChain = exports['Ethnic-inventory']:HasEnoughOfItem('gsf-chain', 1)
        local KoilChain = exports['Ethnic-inventory']:HasEnoughOfItem('koil-chain', 1)
        local MDMChain = exports['Ethnic-inventory']:HasEnoughOfItem('mdm-chain', 1)
        local NBCChain = exports['Ethnic-inventory']:HasEnoughOfItem('nbc-chain', 1)
        local RLChain = exports['Ethnic-inventory']:HasEnoughOfItem('rl-chain', 1)
        local SeasideChain = exports['Ethnic-inventory']:HasEnoughOfItem('seaside-chain', 1)
        if not CerberusChain or not CGChain or not CG2Chain or not ESVChain or not GGChain or not GSFChain or not KoilChain or not MDMChain or not NBCChain or not RLChain or not SeasideChain then
            DeleteObject(ChainObject)
            ChainObject, CurrentChain = nil, nil
            exports['Ethnic-ui']:Notify("chain-gone", "Chain left the chat..", "error")
        end
    end)
end)

RegisterNetEvent("Ethnic-items/client/use-chain", function(ChainId)
    SetPlayerChain(ChainId)
end)

function SetPlayerChain(ChainId)
    local ChainData = ItemsToChain[ChainId]
    if ChainData == nil then return exports['Ethnic-ui']:Notify("chain-fake", "What a fake chain..", "error") end

    TriggerEvent('Ethnic-animations/client/play-animation', "adjust")
    Citizen.Wait(3000)

    if ChainObject then
        DeleteObject(ChainObject)
        ChainObject, CurrentChain = nil, nil
        return
    end

    CurrentChain = ChainId
    if FunctionsModule.RequestModel(GetHashKey(ChainData.Model)) then
        local PedCoords = GetEntityCoords(PlayerPedId())
        ChainObject = CreateObject(GetHashKey(ChainData.Model), PedCoords.x, PedCoords.y, PedCoords.z + 1.0, true, true, false)
        AttachEntityToEntity(ChainObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 10706), ChainData.Pos.x, ChainData.Pos.y, ChainData.Pos.z, ChainData.Rot.x, ChainData.Rot.y, ChainData.Rot.z, true, true, false, true, 2, true)
    end
end