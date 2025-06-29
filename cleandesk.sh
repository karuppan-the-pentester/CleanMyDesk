#!/usr/bin/bash

echo "\n"
echo "===================="
echo "📦 Disk Usage Summary"
echo "===================="
lsblk

echo "\n"
echo "===================="
echo "📁 Root Directory Sizes (du -sh /*)"
echo "===================="
sudo du -sh /* 2>/dev/null

echo "\n"
echo "===================="
echo "🧹 Cleaning old package cache (paccache)"
echo "===================="
sudo paccache -r

echo "\n"
echo "===================="
echo "🗑️ Removing orphaned packages (pacman -Rns)"
echo "===================="
sudo pacman -Rns $(pacman -Qtdq 2>/dev/null) 2>/dev/null || echo "No orphan packages to remove."

echo "\n"
echo "===================="
echo "🗞️ Cleaning systemd journal logs (older than 7 days or >100MB)"
echo "===================="
sudo journalctl --vacuum-time=7d
sudo journalctl --vacuum-size=100M

echo "\n"
echo "===================="
echo "🗂️ Clearing system cache (/var/cache/*)"
echo "===================="
sudo rm -rf /var/cache/*

echo "\n"
echo "===================="
echo "🧊 Clearing temp files (/tmp/*)"
echo "===================="
sudo rm -rf /tmp/*

echo "\n"
echo "===================="
echo "👤 Clearing user cache (~/.cache/*)"
echo "===================="
rm -rf ~/.cache/*

echo "\n"
echo "===================="
echo "🧽 Cleaning orphaned Flatpak apps"
echo "===================="
flatpak uninstall --unused -y 2>/dev/null || echo "Flatpak not in use or nothing to remove."

echo "\n"
echo "===================="
echo "🐳 Cleaning Docker data (if using Docker)"
echo "===================="
if command -v docker &> /dev/null; then
    sudo docker system prune -af --volumes
else
    echo "Docker not installed. Skipping..."
fi

echo "\n"
echo "===================="
echo "📂 Cleaning user log files (~/.local/share/Trash, logs)"
echo "===================="
rm -rf ~/.local/share/Trash/* ~/.local/share/Trash/.Trash-*/files/* 2>/dev/null
rm -rf ~/.local/share/recently-used* ~/.local/share/RecentDocuments/* 2>/dev/null

echo "\n"
echo "===================="
echo "✅ Cleanup Complete!"
echo "===================="
