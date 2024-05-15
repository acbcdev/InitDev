#!/bin/bash

echo "Instalando dependencias"
./components/installDevPendecias.sh
echo "Instalando programas by Curl"
./components/installByCurl.sh
echo "Instalando Node"
./components/installNode.sh
echo "Creando directorios de desarrollo"
if [ -d "$HOME/Dev" ]; then
  echo "Directorio Dev ya existe"
else
  echo "Creando directorio Dev"
  mkdir "$HOME"/Dev
  mkdir "$HOME"/Dev/Proyectos
  mkdir "$HOME"/Dev/Platzi
  mkdir "$HOME"/Dev/Cmt
fi

echo "Configurando Git"
./components/gitconfi.sh

source "$HOME"/.zshrc
