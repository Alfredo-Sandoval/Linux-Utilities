#!/bin/bash
# uninstall-copy-as-path.sh - Removes the Copy as Path functionality from Ubuntu
# Author: Alfredo Sandoval
# Contact: Alfredo.Sandoval@protonmail.com

echo "=============================================="
echo "Uninstalling Copy as Path utility for Ubuntu"
echo "=============================================="

# 1. Remove scripts created by the installer
echo "[1/3] Removing utility scripts..."
sudo rm -f /usr/local/bin/copy-as-path.sh
sudo rm -f /usr/local/bin/copypath

# 2. Remove Nautilus extension
echo "[2/3] Removing Nautilus extension..."
rm -f "$HOME/.local/share/nautilus-python/extensions/copy_path_extension.py"

# 3. Remove keyboard shortcut
echo "[3/3] Removing keyboard shortcut..."
# Get current custom keybindings
current_bindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)

# If there's only our copy-path binding, reset to empty array
if [[ "$current_bindings" == "[\'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/\']" ]]; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[]"
else
    # More complex case - we'd need to remove just our binding from the array
    # This is a simplification; manual cleanup may be needed for multiple bindings
    echo "Multiple keyboard shortcuts detected. The Copy Path shortcut has been disabled,"
    echo "but you may need to manually clean up the shortcuts list in Settings."
    gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ name
    gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ command
    gsettings reset org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/copy-path/ binding
fi

# Restart Nautilus to apply changes
echo "Restarting Nautilus..."
nautilus -q &>/dev/null || true

echo ""
echo "=============================================="
echo "Uninstallation Complete!"
echo "=============================================="
echo ""
echo "Copy as Path functionality has been removed from your system."
echo "Note: The dependencies installed (python3-gi, xclip, etc.) have not been removed"
echo "as they may be used by other applications. You can remove them manually if desired."
echo ""
echo "You may need to log out and log back in for all changes to take full effect."
echo "=============================================="
