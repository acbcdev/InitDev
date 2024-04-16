#!/bin/bash

echo "Instalando dependencias"
./components/installDevPendecias.sh
echo "Instalando programas by Curl"
./components/installByCurl.sh
echo "Instalando Node"
./components/installNode.sh
echo "Creando directorios de desarrollo"
mkdir "$HOME"/Dev
mkdir "$HOME"/Dev/Proyectos
mkdir "$HOME"/Dev/Platzi
mkdir "$HOME"/Dev/Cmt
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh my zsh ya esta instalado"
else
  echo "Instalando oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
echo "Init Alias "
./components/initAlias.sh
echo "Configurando Git"
./components/gitconfi.sh

source "$HOME"/.zshrc
