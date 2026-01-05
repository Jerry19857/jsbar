# jsbar - SketchyBar Configuration

A complete, minimal SketchyBar configuration that combines:
- **Zen/minimal style** from sbar-zen (transparent bar, clean design)
- **Aerospace socket connection** from sbar-sws (real-time workspace updates)
- **Comprehensive icon system** (SF Symbols + NerdFont support)

## Features

- 🎨 **Transparent Bar**: Minimal, zen aesthetic with fully transparent background
- 🚀 **Aerospace Integration**: Socket-based connection for real-time workspace updates
- 🎯 **Smart Workspace Indicator**: Shows current workspace with app icons
- 🖥️ **Front App Display**: Current application name with icon
- 🔋 **Battery Status**: Battery level with dynamic icons
- 🕒 **Clock**: Simple time display
- 🎨 **Dual Icon System**: Choose between SF Symbols or NerdFont

## Prerequisites

Before installing, you need:

1. **SketchyBar** - A highly customizable macOS status bar
   ```bash
   brew install felixkratz/formulae/sketchybar
   ```

2. **AeroSpace** - A tiling window manager for macOS
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```

3. **BlexMono Nerd Font** (or similar Nerd Font)
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-blex-mono-nerd-font
   ```

4. **Lua** (usually pre-installed on macOS)
   ```bash
   lua -v  # Check if installed
   ```

## Installation

1. **Clone this repository**:
   ```bash
   # Clone your fork or the original repository
   git clone https://github.com/YOUR_USERNAME/jsbar.git
   cd jsbar
   
   # Or use the automated install script:
   ./install.sh
   ```

2. **Copy configuration files**:
   ```bash
   # Backup existing configs (if any)
   [ -d ~/.config/sketchybar ] && mv ~/.config/sketchybar ~/.config/sketchybar.backup
   [ -d ~/.config/aerospace ] && mv ~/.config/aerospace ~/.config/aerospace.backup
   
   # Copy new configs
   cp -r .config/sketchybar ~/.config/
   cp -r .config/aerospace ~/.config/
   
   # Make sketchybarrc executable
   chmod +x ~/.config/sketchybar/sketchybarrc
   ```

3. **Start services**:
   ```bash
   # Start SketchyBar
   brew services start sketchybar
   
   # Start AeroSpace (or restart if already running)
   aerospace reload-config
   ```

## Configuration

### Customization

Edit `~/.config/sketchybar/settings.lua` to customize:

```lua
return {
    -- Icon Style: "NerdFont" or "SF Symbols"
    icons = "SF Symbols",
    
    -- Padding
    paddings = {
        bar_left = 10,
        bar_right = 10,
        item_left = 5,
        item_right = 5,
    },
    
    -- Font configuration
    font = {
        text = "BlexMono Nerd Font",
        -- ...
    }
}
```

### Colors

Edit `~/.config/sketchybar/colors.lua` to change colors:

```lua
return {
    white = 0xffffffff,
    bar_color = 0x00000000,  -- Transparent
    -- ...
}
```

### Workspaces

The default configuration supports workspaces 1-9. To customize, edit:
`~/.config/sketchybar/items/workspaces.lua`

### AeroSpace Keybindings

Edit `~/.config/aerospace/aerospace.toml` to customize keybindings:

```toml
[mode.main.binding]
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'
# ...
```

## File Structure

```
.config/
├── aerospace/
│   └── aerospace.toml          # Aerospace window manager config
└── sketchybar/
    ├── sketchybarrc            # Main entry point (Lua-based)
    ├── init.lua                # Lua initialization
    ├── bar.lua                 # Bar configuration (zen style)
    ├── colors.lua              # Color definitions
    ├── default.lua             # Default item settings
    ├── icons.lua               # Icon definitions (NerdFont + SF Symbols)
    ├── settings.lua            # User settings
    ├── helpers/
    │   ├── aerospace.lua       # AeroSpaceLua socket helper
    │   └── app_icons.lua       # App-specific icons
    └── items/
        ├── init.lua            # Items initialization
        ├── workspaces.lua      # Aerospace workspaces (socket-based)
        ├── front_app.lua       # Current app display
        ├── battery.lua         # Battery status
        └── clock.lua           # Clock display
```

## Troubleshooting

### SketchyBar not showing
```bash
# Check if SketchyBar is running
ps aux | grep sketchybar

# Restart SketchyBar
brew services restart sketchybar

# Check logs
tail -f /tmp/sketchybar_*.log
```

### Workspace not updating
```bash
# Check AeroSpace is running
ps aux | grep aerospace

# Reload AeroSpace config
aerospace reload-config

# Test workspace change manually
sketchybar --trigger aerospace_workspace_change
```

### Icons not showing correctly
- Make sure BlexMono Nerd Font is installed
- Try switching icon style in `settings.lua`:
  ```lua
  icons = "NerdFont"  -- or "SF Symbols"
  ```

## References

This configuration is inspired by:
- **sbar-zen** - Minimal, transparent bar design
- **sbar-sws** - Aerospace socket integration and comprehensive icons

## License

MIT License - Feel free to use and modify as needed.

## Contributing

Issues and pull requests are welcome! Please feel free to contribute improvements.