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
  ./installgh.sh dnf
  sudo dnf install "$dependencias"
elif [ "$package_manager" == "apt" ]; then

  sudo apt update
  ./installgh.sh apt
  sudo apt install "$dependencias"
elif [ "$package_manager" == "pacman" ]; then
  sudo pacman -Syu
  ./installgh.sh pacman
  sudo pacman -S "$dependencias"
else
  echo "Invalid package manager"
  exit 1
fi
