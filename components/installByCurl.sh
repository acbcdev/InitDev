#!/bin/bash

# Instalando dependencias

# Nvm install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# bun
curl -fsSL https://bun.sh/install | bash
