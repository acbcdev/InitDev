#!/bin/bash

echo "Instalando dependencias"
./components/installDevPendecias.sh
echo "Instalando programas by Curl"
./components/installByCurl.sh
echo "Instalando Node"
./components/installNode.sh
echo "Creando directorios de desarrollo"
mkdir Dev
mkdir Dev/Proyectos
mkdir Dev/Platzi
mkdir Dev/Cmt
echo "Init Alias "
./components/initAlias.sh
echo "Configurando Git"
./components/gitconfi.sh

zsh
