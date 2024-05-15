#!/bin/bash

# Instalando dependencias
# verificar si existe nvm

if [ -d "$HOME/.fnm" ]; then
  echo "fnm ya esta instalado"
  fnm install 20
  echo "Instalando dependencias node"
  npm i -g pnpm yarn nodemon
else
  echo "Instalando Nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
