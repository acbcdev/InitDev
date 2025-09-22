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
  mkdir "$HOME"/Dev/projects
  mkdir "$HOME"/Dev/platzi
  mkdir "$HOME"/Dev/cmt
fi

echo "Configurando Git"
./components/gitConfi.sh

echo "Reload your shell"
