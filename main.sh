#!/bin/bash

./components/installDevPendecias.sh
./components/installByCurl.sh
./components/installNode.sh
mkdir Dev
mkdir Dev/Proyectos
mkdir Dev/Platzi
mkdir Dev/Cmt
./components/initAlias.sh
./components/gitconfi.sh
