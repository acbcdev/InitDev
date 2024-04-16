#!/bin/bash

# Instalando dependencias
# verificar si existe nvm

if [ -d "$HOME/.nvm" ]; then
  echo "Nvm ya esta instalado"
  nvm i node
  echo "Instalando dependencias node"
  npm i -g pnpm yarn nodemon
else
  echo "Instalando Nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
