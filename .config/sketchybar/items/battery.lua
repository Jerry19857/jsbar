-- Battery Status

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local battery = sbar.add("item", "battery", {
    position = "right",
    update_freq = 120,
    icon = {
        string = icons.battery._100,
        color = colors.white,
    },
    label = {
        string = "100%",
        color = colors.white,
    },
    background = {
        color = colors.transparent_bg,
    },
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function(env)
    local handle = io.popen("pmset -g batt")
    local battery_info = handle:read("*a")
    handle:close()
    
    -- Parse battery percentage
    local percentage = battery_info:match("(%d+)%%")
    local charging = battery_info:match("AC Power") ~= nil
    
    if percentage then
        local percent = tonumber(percentage)
        local icon_name = icons.battery._100
        
        -- Select appropriate icon
        if charging then
            icon_name = icons.battery.charging
        elseif percent > 80 then
            icon_name = icons.battery._100
        elseif percent > 60 then
            icon_name = icons.battery._75
        elseif percent > 40 then
            icon_name = icons.battery._50
        elseif percent > 20 then
            icon_name = icons.battery._25
        else
            icon_name = icons.battery._0
        end
        
        -- Set color based on level
        local icon_color = colors.white
        if not charging and percent < 20 then
            icon_color = colors.red
        elseif not charging and percent < 40 then
            icon_color = colors.yellow
        elseif charging then
            icon_color = colors.green
        end
        
        battery:set({
            icon = { 
                string = icon_name,
                color = icon_color
            },
            label = { 
                string = percent .. "%",
                color = colors.white
            }
        })
    end
end)
