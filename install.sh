#!/bin/bash
# Installation script for jsbar sketchybar configuration

set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "================================"
echo "  jsbar Installation Script"
echo "================================"
echo

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This configuration is designed for macOS only${NC}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "Checking prerequisites..."
echo

missing_deps=()

if ! command_exists sketchybar; then
    missing_deps+=("sketchybar")
    echo -e "${YELLOW}⚠ SketchyBar not found${NC}"
else
    echo -e "${GREEN}✓ SketchyBar found${NC}"
fi

if ! command_exists aerospace; then
    missing_deps+=("aerospace")
    echo -e "${YELLOW}⚠ AeroSpace not found${NC}"
else
    echo -e "${GREEN}✓ AeroSpace found${NC}"
fi

# Check for Nerd Font (optional but recommended)
if ! fc-list 2>/dev/null | grep -qi "nerd" && ! system_profiler SPFontsDataType 2>/dev/null | grep -qi "nerd"; then
    echo -e "${YELLOW}⚠ Nerd Font not detected (recommended but optional)${NC}"
else
    echo -e "${GREEN}✓ Nerd Font detected${NC}"
fi

echo

# Show installation instructions for missing dependencies
if [ ${#missing_deps[@]} -ne 0 ]; then
    echo -e "${RED}Missing dependencies: ${missing_deps[*]}${NC}"
    echo
    echo "Please install missing dependencies:"
    echo
    
    for dep in "${missing_deps[@]}"; do
        case $dep in
            sketchybar)
                echo "  brew install felixkratz/formulae/sketchybar"
                ;;
            aerospace)
                echo "  brew install --cask nikitabobko/tap/aerospace"
                ;;
        esac
    done
    
    echo
    echo "Optional (but recommended):"
    echo "  brew tap homebrew/cask-fonts"
    echo "  brew install --cask font-blex-mono-nerd-font"
    echo
    
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Backup existing configurations
echo "Backing up existing configurations..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -d "$CONFIG_HOME/sketchybar" ]; then
    backup_path="$CONFIG_HOME/sketchybar.backup.$TIMESTAMP"
    echo "  Backing up sketchybar config to: $backup_path"
    mv "$CONFIG_HOME/sketchybar" "$backup_path"
fi

if [ -d "$CONFIG_HOME/aerospace" ]; then
    backup_path="$CONFIG_HOME/aerospace.backup.$TIMESTAMP"
    echo "  Backing up aerospace config to: $backup_path"
    mv "$CONFIG_HOME/aerospace" "$backup_path"
fi

echo

# Copy configurations
echo "Installing configurations..."

echo "  Copying sketchybar config..."
mkdir -p "$CONFIG_HOME"
cp -r "$SCRIPT_DIR/.config/sketchybar" "$CONFIG_HOME/"
chmod +x "$CONFIG_HOME/sketchybar/sketchybarrc"

echo "  Copying aerospace config..."
cp -r "$SCRIPT_DIR/.config/aerospace" "$CONFIG_HOME/"

echo -e "${GREEN}✓ Configurations installed${NC}"
echo

# Restart services
echo "Restarting services..."

if command_exists sketchybar; then
    echo "  Restarting SketchyBar..."
    killall sketchybar 2>/dev/null || true
    sleep 1
    sketchybar &
    echo -e "${GREEN}✓ SketchyBar started${NC}"
fi

if command_exists aerospace; then
    echo "  Reloading AeroSpace config..."
    aerospace reload-config
    echo -e "${GREEN}✓ AeroSpace config reloaded${NC}"
fi

echo
echo "================================"
echo -e "${GREEN}Installation complete!${NC}"
echo "================================"
echo
echo "Configuration files installed to:"
echo "  • $CONFIG_HOME/sketchybar/"
echo "  • $CONFIG_HOME/aerospace/"
echo
echo "Customization:"
echo "  • Edit $CONFIG_HOME/sketchybar/settings.lua for preferences"
echo "  • Edit $CONFIG_HOME/sketchybar/colors.lua for colors"
echo "  • Edit $CONFIG_HOME/aerospace/aerospace.toml for keybindings"
echo
echo "Troubleshooting:"
echo "  • Check logs: tail -f /tmp/sketchybar_*.log"
echo "  • Restart SketchyBar: brew services restart sketchybar"
echo "  • Reload AeroSpace: aerospace reload-config"
echo
echo "For more information, see README.md"
echo
