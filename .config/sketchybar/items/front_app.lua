-- Front App Display

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons_helper = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
    display = "active",
    icon = {
        drawing = true,
        color = colors.white,
    },
    label = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Semibold"],
            size = 15.5
        },
        color = colors.white,
    },
    updates = true,
    background = {
        color = colors.transparent_bg,
    },
})

front_app:subscribe("front_app_switched", function(env)
    local app_name = env.INFO or "Finder"
    local app_icon = app_icons_helper.get(app_name)
    
    front_app:set({
        icon = { string = app_icon },
        label = { string = app_name }
    })
end)

front_app:subscribe("aerospace_workspace_change", function(env)
    -- Trigger front app update
    sbar.trigger("front_app_switched")
end)
