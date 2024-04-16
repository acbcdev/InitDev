#!/bin/bash

# Instalando dependencias
# selecionar admin de devpendencias dnf apt pacman
# dependencias git Curl zsh ranger lolcat exa

dependencias="git curl zsh ranger lolcat exa neofetch"
read -rp "Choose your package manager (dnf pacman apt): " package_manager

while [ "$package_manager" != "dnf" ] && [ "$package_manager" != "apt" ] && [ "$package_manager" != "pacman" ]; do
  echo "Invalid package manager"
  read -rp "Choose your package manager (dnf pacman apt): " package_manager
done

if [ "$package_manager" == "dnf" ]; then

  sudo dnf update
  sudo dnf install $dependencias

  echo "Instalando gh"
  ./install_gh.sh "dnf"

elif [ "$package_manager" == "apt" ]; then

  sudo apt update
  sudo apt install $dependencias
  echo "Instalando gh"
  ./install_gh.sh "apt"
elif [ "$package_manager" == "pacman" ]; then
  sudo pacman -Syu
  sudo pacman -S $dependencias
  echo "Instalando gh"
  ./install_gh.sh "pacman"
else
  echo "Invalid package manager"
  exit 1
fi
