-- Bar Configuration (Zen Style)

local colors = require("colors")
local settings = require("settings")

-- Configure bar appearance
sbar.bar({
    height = 40,
    color = colors.bar_color,
    border_width = 0,
    border_color = colors.transparent_bg,
    shadow = false,
    position = "top",
    sticky = true,
    padding_right = settings.paddings.bar_right,
    padding_left = settings.paddings.bar_left,
    y_offset = 0,
    margin = 0,
    blur_radius = 0,
    notch_width = 0,
})
