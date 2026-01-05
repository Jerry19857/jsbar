-- Clock/Time Display

local colors = require("colors")
local settings = require("settings")

local clock = sbar.add("item", "clock", {
    position = "right",
    update_freq = 10,
    icon = {
        drawing = false,
    },
    label = {
        string = "Mon 01 12:00",
        width = 0,
        align = "right",
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Semibold"],
            size = 15.5
        },
        color = colors.white,
    },
    padding_left = 10,
    padding_right = 10,
    background = {
        color = colors.transparent_bg,
    },
})

clock:subscribe({"forced", "routine", "system_woke"}, function(env)
    clock:set({
        label = os.date("%a %d %H:%M")
    })
end)
