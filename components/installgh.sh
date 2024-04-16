#!/bin/bash

# Instalando dependencias gh about package manager
instalar_gh() {
  packageManager=$1
  if [ "$packageManager" == "dnf" ]; then
    sudo dnf install 'dnf-command(config-manager)'
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install gh
  elif [ "$packageManager" == "apt" ]; then
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) &&
      sudo mkdir -p -m 755 /etc/apt/keyrings &&
      wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
      sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
      sudo apt update &&
      sudo apt install gh -y
    sudo apt install gh
  elif [ "$packageManager" == "pacman" ]; then
    sudo pacman -S github-cli
  else
    echo "On the Package error"
    exit 1
  fi

}

package=$1
echo "Instalando gh"
if [ -d "/usr/bin/gh" ]; then
  echo "gh ya esta instalado"
  gh --version
else
  instalar_gh "$package"

fi
