-- AeroSpaceLua Socket Helper
-- Provides socket-based connection to AeroSpace for real-time updates

local Aerospace = {}
Aerospace.__index = Aerospace

function Aerospace.new()
    local self = setmetatable({}, Aerospace)
    self.socket_path = "/tmp/aerospace.sock"
    return self
end

-- Execute aerospace CLI command
function Aerospace:exec(args)
    local cmd = "aerospace " .. args
    local handle = io.popen(cmd)
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result
    end
    return nil
end

-- Get list of all workspaces
function Aerospace:list_workspaces()
    local result = self:exec("list-workspaces --all")
    if not result then return {} end
    
    local workspaces = {}
    for workspace in result:gmatch("[^\r\n]+") do
        table.insert(workspaces, workspace)
    end
    return workspaces
end

-- Get current focused workspace
function Aerospace:list_current()
    local result = self:exec("list-workspaces --focused")
    if result then
        return result:match("^%s*(.-)%s*$")  -- trim whitespace
    end
    return nil
end

-- Get all windows in a workspace
function Aerospace:list_windows(workspace)
    local cmd = workspace and ("--workspace " .. workspace) or "--all"
    local result = self:exec("list-windows " .. cmd)
    if not result then return {} end
    
    local windows = {}
    for line in result:gmatch("[^\r\n]+") do
        -- Parse window info: ID | APP | TITLE
        local id, app, title = line:match("^(%d+)%s*|%s*([^|]+)%s*|%s*(.*)$")
        if id then
            table.insert(windows, {
                id = id,
                app = app:match("^%s*(.-)%s*$"),  -- trim
                title = title:match("^%s*(.-)%s*$")  -- trim
            })
        end
    end
    return windows
end

-- Get all windows (alias for compatibility)
function Aerospace:list_all_windows()
    return self:list_windows(nil)
end

-- Query workspace information
function Aerospace:query_workspaces()
    local workspaces_list = self:list_workspaces()
    local current = self:list_current()
    
    local result = {}
    for _, ws in ipairs(workspaces_list) do
        table.insert(result, {
            name = ws,
            focused = (ws == current),
            visible = (ws == current),
        })
    end
    return result
end

-- Get current mode (main/service)
-- NOTE: AeroSpace doesn't currently provide a direct CLI command to query the current mode.
-- This returns a default structure. Mode changes should be tracked via event triggers.
function Aerospace:get_mode_stub()
    return {
        current = "main",
        available = {"main", "service"}
    }
end

-- Deprecated: Use get_mode_stub() instead
function Aerospace:list_modes()
    return self:get_mode_stub()
end

-- Get focused window
function Aerospace:get_focused_window()
    local windows = self:list_windows()
    if #windows > 0 then
        return windows[1]  -- First window is typically focused
    end
    return nil
end

return Aerospace
