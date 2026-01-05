-- Workspace Items (Aerospace Integration with Socket)

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons_helper = require("helpers.app_icons")
local Aerospace = require("helpers.aerospace")

-- Create aerospace socket connection
local aerospace = Aerospace.new()

-- Workspace IDs (customize as needed)
local workspaces = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Create workspace items
for _, workspace in ipairs(workspaces) do
    local space = sbar.add("item", "space." .. workspace, {
        icon = {
            string = workspace,
            padding_left = 10,
            padding_right = 10,
            color = colors.white,
            font = {
                family = settings.font.text,
                style = settings.font.style_map["Bold"],
                size = 16.0
            }
        },
        label = {
            drawing = false,
        },
        padding_left = 2,
        padding_right = 2,
        background = {
            color = colors.transparent_bg,
            border_width = 0,
        },
        click_script = "aerospace workspace " .. workspace,
    })
    
    -- Subscribe to aerospace events
    space:subscribe("aerospace_workspace_change", function(env)
        local focused = aerospace:list_current()
        local is_focused = (focused == workspace)
        
        if is_focused then
            -- Get windows in this workspace
            local windows = aerospace:list_windows(workspace)
            local window_icons = {}
            
            for _, win in ipairs(windows) do
                local app_icon = app_icons_helper.get(win.app)
                table.insert(window_icons, app_icon)
            end
            
            -- Update label to show app icons
            if #window_icons > 0 then
                space:set({
                    icon = { color = colors.blue },
                    label = { 
                        string = table.concat(window_icons, " "),
                        drawing = true,
                    }
                })
            else
                space:set({
                    icon = { color = colors.blue },
                    label = { drawing = false }
                })
            end
        else
            -- Check if workspace has windows
            local windows = aerospace:list_windows(workspace)
            if #windows > 0 then
                space:set({
                    icon = { color = colors.grey },
                    label = { drawing = false }
                })
            else
                space:set({
                    icon = { color = colors.subtext },
                    label = { drawing = false }
                })
            end
        end
    end)
    
    -- Initial update
    space:subscribe("forced", function(env)
        sbar.trigger("aerospace_workspace_change")
    end)
end

-- Add separator after workspaces
local separator_left = sbar.add("item", "separator.left", {
    icon = {
        string = "|",
        color = colors.grey,
    },
    label = { drawing = false },
    padding_left = 5,
    padding_right = 5,
    background = { color = colors.transparent_bg },
})

-- Mode indicator (main/service)
local mode_indicator = sbar.add("item", "aerospace.mode", {
    icon = {
        string = icons.gear,
        color = colors.white,
    },
    label = {
        string = "main",
        color = colors.white,
    },
    padding_left = 5,
    padding_right = 10,
    background = { color = colors.transparent_bg },
})

mode_indicator:subscribe("aerospace_mode_change", function(env)
    local modes = aerospace:list_modes()
    local current_mode = modes.current or "main"
    
    mode_indicator:set({
        label = { string = current_mode }
    })
end)
