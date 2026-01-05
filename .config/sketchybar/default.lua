-- Default Item Settings

local colors = require("colors")
local settings = require("settings")

-- Defaults for all items
sbar.default({
    updates = "when_shown",
    icon = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 15.5
        },
        color = colors.white,
        padding_left = settings.paddings.item_left,
        padding_right = settings.paddings.item_right,
        background = {
            image = {
                corner_radius = 0,
            },
        },
    },
    label = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Regular"],
            size = 15.5
        },
        color = colors.white,
        padding_left = settings.paddings.item_left,
        padding_right = settings.paddings.item_right,
    },
    background = {
        color = colors.item_bg_color,
        border_color = colors.transparent_bg,
        border_width = 0,
        height = 28,
        corner_radius = 0,
    },
    padding_left = settings.paddings.item_left,
    padding_right = settings.paddings.item_right,
    scroll_texts = false,
})
