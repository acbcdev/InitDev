#!/bin/bash

# Instalando dependencias

# Nvm install
echo "Instalando Nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# oh my zsh
echo "Instalando Oh My Zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# bun
echo "Instalando bun"
curl -fsSL https://bun.sh/install | bash
