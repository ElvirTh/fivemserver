--[[
    App: Adverts (Yellow Pages)
]]

Adverts = {}
Adverts.Posts = {}

function Adverts.Render()
    SetAppUnread('advert', false)
    local CanPost = CallbackModule.SendCallback("Ethnic-phone/server/adverts/can-post")
    exports['Ethnic-ui']:SendUIMessage("Phone", "RenderAdvertsApp", {
        Posts = Adverts.Posts or {},
        CanPost = CanPost,
    })
end

RegisterNUICallback("Adverts/Post", function(Data, Cb)
    EventsModule.TriggerServer("Ethnic-phone/server/adverts-post", Data)
    Cb('Ok')
end)

RegisterNUICallback("Advert/RemovePost", function(Data, Cb)
    local Result = CallbackModule.SendCallback("Ethnic-phone/server/adverts/delete-post")
    Cb(Result)
end)

RegisterNetEvent("Ethnic-phone/client/adverts/sync-posts", function(Post, Delete)
    if Delete then
        table.remove(Adverts.Posts, Post)
    else
        table.insert(Adverts.Posts, Post)
    end

    if CurrentApp == 'advert' then
        local CanPost = CallbackModule.SendCallback("Ethnic-phone/server/adverts/can-post")
        exports['Ethnic-ui']:SendUIMessage("Phone", "RenderAdvertsApp", {
            Posts = Adverts.Posts or {},
            CanPost = CanPost,
        })
    else
        SetAppUnread('advert', true)
    end
end)