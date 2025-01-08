#!/bin/bash

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

dnf check-update

sudo dnf install code code-insiders

flatpak install flathub com.brave.Browser
flatpak install flathub io.github.andreibachim.shortcut
flatpak install flathub org.gnome.Extensions
flatpak install flathub com.bitwarden.desktop