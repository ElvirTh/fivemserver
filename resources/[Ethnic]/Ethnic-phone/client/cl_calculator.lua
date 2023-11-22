--[[
    App: Calculator
]]

Calculator = {}

function Calculator.Render()
    SetAppUnread('calculator', false)
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderCalculatorApp", {})
end

