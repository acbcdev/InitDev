#!/bin/bash

# Instalando dependencias
# verificar si existe nvm

if [ -d "$HOME/.fnm" ]; then
  echo "fnm ya esta instalado"
  fnm install 20
  echo "Instalando dependencias node"
  npm i -g pnpm
fi
