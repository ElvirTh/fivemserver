--[[
    App: Mails
]]

Mails = {}
Mails.Log = {}

function Mails.Render()
    SetAppUnread('mails', false)
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderMailsApp", {
        Mails = Mails.Log[PlayerModule.GetPlayerData().CitizenId] or {}
    })
end

RegisterNetEvent('Ethnic-phone/client/mails/send-mail', function(MailData)
    if CurrentApp ~= 'mails' then SetAppUnread('mails', true) end

    local CitizenId = PlayerModule.GetPlayerData().CitizenId
    if Mails.Log[CitizenId] == nil then Mails.Log[CitizenId] = {} end
    table.insert(Mails.Log[CitizenId], MailData)

    local Preferences = PreferencesModule.GetPreferences()
    if Preferences.Phone.Notifications['Email'] then
        TriggerEvent('Ethnic-phone/client/notification', {
            Title = "Email",
            Message = MailData.Content,
            Icon = "fas fa-envelope-open",
            IconBgColor = "#15bcce",
            IconColor = "white",
            Sticky = false,
            Duration = 4000,
        })
    end
    
    if CurrentApp == 'mails' then
        exports['Ethnic-ui']:SendUIMessage("Phone", "RenderMailsApp", {
            Mails = Mails.Log[CitizenId] or {}
        })
    end
end)