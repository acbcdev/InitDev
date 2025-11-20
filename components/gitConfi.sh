#!/bin/bash
# Configuración de git

gitignore_global="# Variables de Entorno
.env
# General
.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon


# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

### macOS Patch ###
# iCloud generated files
*.icloud
"
echo -e "$gitignore_global" > ~/.gitignore_global

# name and email

read -rp "Enter your email: " email
read -rp "Enter your name: " name

git config --global user.email "$email"
git config --global user.name "$name"
git config --global init.defaultBranch main
git config --global core.editor "nvim"
git config --global core.excludesfile ~/.gitignore_global
git config --global merge.ff only

echo "Git configuration completed. ✔️"
