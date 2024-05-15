#!/bin/bash

# Instalando dependencias

# bun
echo "Instalando bun"
if [ -d "$HOME/.bun" ]; then
  echo "Bun ya esta instalado"
else
  curl -fsSL https://bun.sh/install | bash
fi

if [ -d "$HOME/.fnm" ]; then
  echo "fnm ya esta instalado"
else
  curl -fsSL https://fnm.vercel.app/install | bash
fi
