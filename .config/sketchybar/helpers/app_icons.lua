-- App-specific icons mapping

local icons = require("icons")

local app_icons = {
    -- Terminals
    ["Alacritty"] = "",
    ["kitty"] = "",
    ["WezTerm"] = "",
    ["iTerm2"] = "",
    ["Terminal"] = "",
    
    -- Browsers
    ["Arc"] = "󰞍",
    ["Safari"] = "󰀹",
    ["Firefox"] = "",
    ["Chrome"] = "",
    ["Google Chrome"] = "",
    ["Brave Browser"] = "󰖟",
    ["Edge"] = "󰇩",
    
    -- Development
    ["Code"] = "󰨞",
    ["Visual Studio Code"] = "󰨞",
    ["Xcode"] = "",
    ["IntelliJ IDEA"] = "",
    ["PyCharm"] = "",
    ["WebStorm"] = "",
    ["Android Studio"] = "",
    ["Neovim"] = "",
    
    -- Communication
    ["Slack"] = "󰒱",
    ["Discord"] = "󰙯",
    ["Telegram"] = "",
    ["Messages"] = "󰍡",
    ["Mail"] = "󰇮",
    ["Microsoft Teams"] = "󰊻",
    ["Zoom"] = "",
    
    -- Productivity
    ["Notion"] = "󰈙",
    ["Obsidian"] = "󱓷",
    ["Notes"] = "󰠮",
    ["Calendar"] = "",
    ["Reminders"] = "",
    
    -- Music/Media
    ["Spotify"] = "",
    ["Music"] = "",
    ["Apple Music"] = "",
    ["VLC"] = "󰕼",
    
    -- System
    ["System Settings"] = "",
    ["System Preferences"] = "",
    ["Finder"] = "󰀶",
    ["Activity Monitor"] = "",
    
    -- Other
    ["Docker"] = "󰡨",
    ["Postman"] = "",
    ["1Password"] = "󰷡",
}

-- Get icon for app name
local function get_app_icon(app_name)
    if app_name == nil or app_name == "" then
        return icons.gear
    end
    
    local icon = app_icons[app_name]
    if icon then
        return icon
    end
    
    -- Return generic icon if not found
    return "󰘔"
end

return {
    get = get_app_icon,
    apps = app_icons,
}
