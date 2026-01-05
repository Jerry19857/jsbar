-- SketchyBar Lua Configuration Initialization

-- Add the sketchybar module to package.cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Load sketchybar module
sbar = require("sketchybar")

-- Initialize sketchybar
sbar.begin_config()

-- Load configuration modules
require("bar")        -- Bar appearance (zen style)
require("default")    -- Default item settings

-- Add aerospace event
sbar.event_manager.add_event("aerospace_workspace_change")
sbar.event_manager.add_event("aerospace_mode_change")

-- Load items
require("items")

-- Run the event loop
sbar.event_loop()

-- Finalize configuration
sbar.end_config()

-- Trigger initial updates
sbar.trigger("aerospace_workspace_change")
sbar.trigger("front_app_switched")
sbar.trigger("forced")
