#!/bin/bash
# Ubuntu Copy as Path installer - Implements the Windows Copy as Path function for Ubuntu
# Author: Alfredo Sandoval
# Contact: Alfredo.Sandoval@protonmail.com

set -e

echo "=============================================="
echo "Starting setup for Ubuntu Copy as Path utility"
echo "=============================================="

# 1. Install dependencies with apt
echo "[1/4] Installing dependencies..."
sudo apt update
sudo apt install -y python3 python3-gi xclip libnotify-bin zenity dbus-x11 python3-pip python3-nautilus

# 2. Create the copy-as-path script
echo "[2/4] Creating copy-as-path script..."
sudo tee /usr/local/bin/copy-as-path.sh > /dev/null << 'EOF'
#!/bin/bash
# Copy path script for Ubuntu

# Function to copy to clipboard
copy_to_clipboard() {
    echo -n "$1" | xclip -selection clipboard
}

# Function to show notification
show_notification() {
    title="$1"
    message="$2"
    notify-send "$title" "$message"
}

# If arguments are provided, use them as paths
if [ $# -gt 0 ]; then
    paths=$(printf "%s\n" "$@")
    copy_to_clipboard "$paths"
    show_notification "Copy as Path" "Copied path(s) to clipboard."
    exit 0
fi

# Check for Nautilus environment variables
if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    copy_to_clipboard "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
    show_notification "Copy as Path" "Copied path(s) to clipboard."
    exit 0
fi

# If no paths provided, use current directory
current_dir=$(pwd)
copy_to_clipboard "$current_dir"
show_notification "Copy as Path" "Copied current directory path to clipboard."
EOF

echo "Making the script executable..."
sudo chmod +x /usr/local/bin/copy-as-path.sh

# 3. Set up for Nautilus (the default Ubuntu file manager)
echo "[3/4] Setting up for Nautilus..."

# Create nautilus python extension
mkdir -p "$HOME/.local/share/nautilus-python/extensions"
cat > "$HOME/.local/share/nautilus-python/extensions/copy_path_extension.py" << 'EOF'
import os
import subprocess
from gi.repository import Nautilus, GObject

class CopyPathExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        pass
        
    def menu_activate_cb(self, menu, files):
        paths = [f.get_location().get_path() for f in files]
        subprocess.run(['/usr/local/bin/copy-as-path.sh'] + paths)
    
    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name='CopyPathExtension::CopyPath',
            label='Copy as Path',
            tip='Copy the full path to the clipboard'
        )
        item.connect('activate', self.menu_activate_cb, files)
        return [item]
        
    def get_background_items(self, window, folder):
        item = Nautilus.MenuItem(
            name='CopyPathExtension::CopyPathFolder',
            label='Copy as Path',
            tip='Copy the folder path to the clipboard'
        )
        item.connect('activate', self.menu_activate_cb, [folder])
        return [item]
EOF

# 4. Set up GNOME keyboard shortcut (Shift+Alt+C)
echo "[4/4] Setting up keyboard shortcut (Shift+Alt+C)..."

# GNOME shortcut 
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ name "Copy Path"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ command "/usr/local/bin/copy-as-path.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ binding "<Shift><Control>c"

# Create a command-line utility
echo "Creating command-line utility 'copypath'..."
sudo tee /usr/local/bin/copypath > /dev/null << 'EOF'
#!/bin/bash
# Simple command-line utility to copy paths to clipboard

if [ $# -eq 0 ]; then
    # No arguments, copy curr`e`nt directory
    /usr/local/bin/copy-as-path.sh "$(pwd)"
else
    # Copy paths of specified files/directories
    /usr/local/bin/copy-as-path.sh "$@"
fi
EOF
sudo chmod +x /usr/local/bin/copypath

# Restart Nautilus
echo "Restarting Nautilus..."
nautilus -q &>/dev/null || true

echo ""
echo "=============================================="
echo "Setup Complete!"
echo "=============================================="
echo ""
echo "Copy as Path functionality has been installed with these integration points:"
echo ""
echo "1. Right-click menu in Nautilus file manager"
echo "2. Keyboard shortcut: Shift+Alt+C"
echo "3. Command line: Use 'copypath [file1] [file2] ...' to copy paths"
echo ""
echo "You may need to log out and log back in for all changes to take effect."
echo "=============================================="
#!/bin/bash
# Ubuntu Copy as Path installer
# Author: Alfredo Sandoval

set -e

echo "=============================================="
echo "Starting setup for Ubuntu Copy as Path utility"
echo "=============================================="

# 1. Install dependencies with apt
echo "[1/4] Installing dependencies..."
sudo apt update
sudo apt install -y python3 python3-gi xclip libnotify-bin zenity dbus-x11 python3-pip python3-nautilus

# 2. Create the copy-as-path script
echo "[2/4] Creating copy-as-path script..."
sudo tee /usr/local/bin/copy-as-path.sh > /dev/null << 'EOF'
#!/bin/bash
# Copy path script for Ubuntu

# Function to copy to clipboard
copy_to_clipboard() {
    echo -n "$1" | xclip -selection clipboard
}

# Function to show notification
show_notification() {
    title="$1"
    message="$2"
    notify-send "$title" "$message"
}

# If arguments are provided, use them as paths
if [ $# -gt 0 ]; then
    paths=$(printf "%s\n" "$@")
    copy_to_clipboard "$paths"
    show_notification "Copy as Path" "Copied path(s) to clipboard."
    exit 0
fi

# Check for Nautilus environment variables
if [ -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]; then
    copy_to_clipboard "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
    show_notification "Copy as Path" "Copied path(s) to clipboard."
    exit 0
fi

# If no paths provided, use current directory
current_dir=$(pwd)
copy_to_clipboard "$current_dir"
show_notification "Copy as Path" "Copied current directory path to clipboard."
EOF

echo "Making the script executable..."
sudo chmod +x /usr/local/bin/copy-as-path.sh

# 3. Set up for Nautilus (the default Ubuntu file manager)
echo "[3/4] Setting up for Nautilus..."

# Create nautilus python extension
mkdir -p "$HOME/.local/share/nautilus-python/extensions"
cat > "$HOME/.local/share/nautilus-python/extensions/copy_path_extension.py" << 'EOF'
import os
import subprocess
from gi.repository import Nautilus, GObject

class CopyPathExtension(GObject.GObject, Nautilus.MenuProvider):
    def __init__(self):
        pass
        
    def menu_activate_cb(self, menu, files):
        paths = [f.get_location().get_path() for f in files]
        subprocess.run(['/usr/local/bin/copy-as-path.sh'] + paths)
    
    def get_file_items(self, window, files):
        item = Nautilus.MenuItem(
            name='CopyPathExtension::CopyPath',
            label='Copy as Path',
            tip='Copy the full path to the clipboard'
        )
        item.connect('activate', self.menu_activate_cb, files)
        return [item]
        
    def get_background_items(self, window, folder):
        item = Nautilus.MenuItem(
            name='CopyPathExtension::CopyPathFolder',
            label='Copy as Path',
            tip='Copy the folder path to the clipboard'
        )
        item.connect('activate', self.menu_activate_cb, [folder])
        return [item]
EOF

# 4. Set up GNOME keyboard shortcut (Shift+Ctrl+C)
echo "[4/4] Setting up keyboard shortcut (Shift+Ctrl+C)..."

# GNOME shortcut
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ name "Copy Path"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ command "/usr/local/bin/copy-as-path.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ binding "<Shift><Control>c"

# Create a command-line utility
echo "Creating command-line utility 'copypath'..."
sudo tee /usr/local/bin/copypath > /dev/null << 'EOF'
#!/bin/bash
# Simple command-line utility to copy paths to clipboard

if [ $# -eq 0 ]; then
    # No arguments, copy current directory
    /usr/local/bin/copy-as-path.sh "$(pwd)"
else
    # Copy paths of specified files/directories
    /usr/local/bin/copy-as-path.sh "$@"
fi
EOF
sudo chmod +x /usr/local/bin/copypath

# Restart Nautilus
echo "Restarting Nautilus..."
nautilus -q &>/dev/null || true

echo ""
echo "=============================================="
echo "Setup Complete!"
echo "=============================================="
echo ""
echo "Copy as Path functionality has been installed with these integration points:"
echo ""
echo "1. Right-click menu in Nautilus file manager"
echo "2. Keyboard shortcut: Shift+Ctrl+C"
echo "3. Command line: Use 'copypath [file1] [file2] ...' to copy paths"
echo ""
echo "You may need to log out and log back in for all changes to take effect."
echo "=============================================="
