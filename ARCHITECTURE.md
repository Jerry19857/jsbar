# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                          macOS System                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────┐         ┌──────────────────┐               │
│  │   AeroSpace    │◄────────┤  aerospace.toml  │               │
│  │ Window Manager │         └──────────────────┘               │
│  └────────┬───────┘                                             │
│           │ Events:                                             │
│           │ • workspace_change                                  │
│           │ • mode_change                                       │
│           │ • display_change                                    │
│           │ • front_app_switched                                │
│           ▼                                                      │
│  ┌────────────────────────────────────────────┐                │
│  │            SketchyBar                      │                │
│  │  ┌──────────────────────────────────────┐ │                │
│  │  │        sketchybarrc (main)          │ │                │
│  │  │               │                      │ │                │
│  │  │               ▼                      │ │                │
│  │  │          init.lua                    │ │                │
│  │  │               │                      │ │                │
│  │  │    ┌──────────┼──────────┐          │ │                │
│  │  │    ▼          ▼          ▼          │ │                │
│  │  │  bar.lua  default.lua  items/      │ │                │
│  │  └──────────────────────────────────────┘ │                │
│  └────────────────────────────────────────────┘                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Component Breakdown

### 1. Entry Point Layer

#### sketchybarrc
- **Role**: Main executable entry point
- **Type**: Lua script with shebang
- **Function**: Initializes Lua environment and loads init.lua
- **Path**: `~/.config/sketchybar/sketchybarrc`

### 2. Initialization Layer

#### init.lua
- **Role**: Core initialization
- **Responsibilities**:
  - Load sketchybar Lua module
  - Initialize configuration
  - Register events (aerospace_workspace_change, aerospace_mode_change)
  - Load all modules
  - Start event loop
  - Trigger initial updates

### 3. Configuration Layer

#### bar.lua
- **Purpose**: Bar appearance
- **Settings**:
  - Height: 40px
  - Transparent background
  - Position: top
  - Padding configuration

#### default.lua
- **Purpose**: Default item styles
- **Settings**:
  - Font family and sizes
  - Icon/label colors
  - Padding and spacing
  - Background styles

#### colors.lua
- **Purpose**: Color palette
- **Style**: Zen/transparent
- **Values**: ARGB hex format (0xAARRGGBB)

#### icons.lua
- **Purpose**: Icon definitions
- **Systems**: SF Symbols & NerdFont
- **Selection**: Based on settings.lua

#### settings.lua
- **Purpose**: User preferences
- **Customizable**:
  - Icon style choice
  - Padding values
  - Font selection

### 4. Helper Layer

#### helpers/aerospace.lua
- **Role**: AeroSpace communication interface
- **Pattern**: Object-oriented Lua class
- **Methods**:
  ```lua
  Aerospace.new()                 -- Constructor
  :exec(args)                     -- Execute CLI command
  :list_workspaces()              -- Get all workspaces
  :list_current()                 -- Get focused workspace
  :list_windows(workspace)        -- Get workspace windows
  :list_all_windows()             -- Get all windows
  :query_workspaces()             -- Query workspace info
  :list_modes()                   -- Get current mode
  :get_focused_window()           -- Get focused window
  ```

#### helpers/app_icons.lua
- **Role**: App icon mapping
- **Coverage**: 70+ applications
- **Function**: `get(app_name)` → icon string
- **Fallback**: Generic icon for unknown apps

### 5. Items Layer

#### items/init.lua
- **Role**: Items loader
- **Function**: Requires all item modules

#### items/workspaces.lua
- **Role**: Workspace display and management
- **Features**:
  - 9 workspace items (customizable)
  - Socket-based updates via Aerospace helper
  - Dynamic app icon display
  - Color-coded states:
    - Blue: Focused workspace
    - Grey: Non-empty workspace
    - Subdued: Empty workspace
- **Events**: 
  - Subscribes to `aerospace_workspace_change`
  - Click handler: Switch to workspace

#### items/front_app.lua
- **Role**: Current application display
- **Features**:
  - Shows app name and icon
  - Updates on focus changes
- **Events**: 
  - Subscribes to `front_app_switched`
  - Subscribes to `aerospace_workspace_change`

#### items/battery.lua
- **Role**: Battery status display
- **Features**:
  - Percentage display
  - Dynamic icons (5 levels + charging)
  - Color-coded warnings
- **Update Frequency**: 120 seconds
- **Events**: 
  - Subscribes to `routine`, `power_source_change`, `system_woke`

#### items/clock.lua
- **Role**: Time display
- **Format**: "Mon 01 12:00"
- **Position**: Right side
- **Update Frequency**: 10 seconds
- **Events**: 
  - Subscribes to `forced`, `routine`, `system_woke`

## Event Flow

### Workspace Change Event
```
User switches workspace in AeroSpace
    ↓
aerospace.toml: after-workspace-change hook
    ↓
sketchybar --trigger aerospace_workspace_change
    ↓
items/workspaces.lua: aerospace_workspace_change handler
    ↓
Aerospace helper: Query current workspace and windows
    ↓
Update workspace item colors and app icons
    ↓
items/front_app.lua: Update front app display
```

### Front App Change Event
```
User focuses different app
    ↓
aerospace.toml: on-focused-monitor-changed hook
    ↓
sketchybar --trigger front_app_switched
    ↓
items/front_app.lua: front_app_switched handler
    ↓
helpers/app_icons.lua: Get app icon
    ↓
Update front app item with name and icon
```

### Battery Status Update
```
Timer expires (120s) OR Power source changes
    ↓
items/battery.lua: routine/power_source_change handler
    ↓
Execute pmset -g batt command
    ↓
Parse battery percentage and charging status
    ↓
Select appropriate icon (5 levels + charging)
    ↓
Set color based on level (red/yellow/green/white)
    ↓
Update battery item
```

## Data Flow: Workspace Display

```
┌──────────────┐
│  AeroSpace   │
│    State     │
└──────┬───────┘
       │
       │ CLI: aerospace list-workspaces --all
       │ CLI: aerospace list-workspaces --focused
       │ CLI: aerospace list-windows --workspace X
       │
       ▼
┌──────────────────┐
│ Aerospace Helper │
│  (aerospace.lua) │
└──────┬───────────┘
       │
       │ Returns: workspace list, focused ws, windows
       │
       ▼
┌───────────────────┐
│  Workspaces Item  │
│ (workspaces.lua)  │
└──────┬────────────┘
       │
       │ For each window, lookup app icon
       │
       ▼
┌──────────────────┐
│  App Icons       │
│ (app_icons.lua)  │
└──────┬───────────┘
       │
       │ Returns: Icon string (NerdFont or SF Symbol)
       │
       ▼
┌──────────────────┐
│  SketchyBar UI   │
│  Display Update  │
└──────────────────┘
```

## Module Dependencies

```
sketchybarrc
    └── init.lua
        ├── bar.lua
        │   ├── colors.lua
        │   └── settings.lua
        ├── default.lua
        │   ├── colors.lua
        │   └── settings.lua
        └── items/init.lua
            ├── items/workspaces.lua
            │   ├── colors.lua
            │   ├── icons.lua
            │   ├── settings.lua
            │   ├── helpers/app_icons.lua
            │   │   └── icons.lua
            │   └── helpers/aerospace.lua
            ├── items/front_app.lua
            │   ├── colors.lua
            │   ├── icons.lua
            │   ├── settings.lua
            │   └── helpers/app_icons.lua
            ├── items/battery.lua
            │   ├── colors.lua
            │   ├── icons.lua
            │   └── settings.lua
            └── items/clock.lua
                ├── colors.lua
                └── settings.lua
```

## Customization Points

### Easy Customizations (No Code Changes)
1. **Icon Style**: Edit `settings.lua`, change `icons` value
2. **Colors**: Edit `colors.lua`, modify color values
3. **Padding**: Edit `settings.lua`, adjust padding values
4. **Keybindings**: Edit `aerospace.toml`, modify key mappings

### Medium Customizations (Minimal Code)
1. **Add Workspaces**: Edit `items/workspaces.lua`, extend workspace array
2. **Add App Icons**: Edit `helpers/app_icons.lua`, add entries to app_icons table
3. **Bar Height**: Edit `bar.lua`, change height value
4. **Clock Format**: Edit `items/clock.lua`, modify os.date() format

### Advanced Customizations (More Code)
1. **Add New Items**: Create new file in `items/`, require in `items/init.lua`
2. **Add New Events**: Register in `init.lua`, implement handlers
3. **Change Layout**: Modify item positions and grouping
4. **Add Animations**: Implement in item update handlers

## Best Practices

### When Adding New Items
1. Create file in `items/` directory
2. Require necessary modules (colors, icons, settings)
3. Use `sbar.add()` to create item
4. Subscribe to relevant events
5. Add require statement to `items/init.lua`

### When Adding New App Icons
1. Find the exact app name (check in Activity Monitor)
2. Choose appropriate icon from NerdFont or SF Symbols
3. Add to both `sf_symbols` and `nerdfont` tables in `app_icons.lua`
4. Test by opening the app and checking workspace display

### When Modifying Events
1. Ensure event is registered in `init.lua`
2. Ensure event is triggered in `aerospace.toml`
3. Implement handler in relevant item file
4. Test trigger manually: `sketchybar --trigger event_name`

## Performance Considerations

### Socket-Based Architecture Benefits
- **Real-time updates**: No polling, events pushed immediately
- **Low overhead**: Only updates when changes occur
- **Efficient**: Aerospace CLI calls only when needed

### Update Frequencies
- **Workspaces**: Event-driven (instant)
- **Front App**: Event-driven (instant)
- **Battery**: 120 seconds (reduces system calls)
- **Clock**: 10 seconds (balance between accuracy and CPU)

### Optimization Tips
1. Don't add unnecessary `routine` subscriptions
2. Use longer update_freq for infrequently changing items
3. Cache Aerospace queries where possible
4. Minimize number of windows queried simultaneously
