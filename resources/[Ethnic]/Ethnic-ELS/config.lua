outputLoading = false
playButtonPressSounds = true
printDebugInformation = false

vehicleSyncDistance = 150
environmentLightBrightness = 0.006
lightDelay = 5 -- Time in MS
flashDelay = 15

panelEnabled = true
panelType = "original"
panelOffsetX = 0.0
panelOffsetY = 0.0

allowedPanelTypes = {
    "original",
    "old"
}

-- https://docs.fivem.net/game-references/controls

shared = {
    horn = 86,
}

keyboard = {
    modifyKey = 128,
    stageChange = 85, -- E
    guiKey = 199, -- P
    takedown = 83, -- =
    siren = {
        tone_one = 62, -- Left CTRL
    },
    pattern = {
        primary = 110, -- NUMPAD 5
    },
}

controller = {
    modifyKey = 73,
    stageChange = 80,
    takedown = 74,
    siren = {
        tone_one = 173,
        tone_two = 85,
        tone_three = 172,
    },
}