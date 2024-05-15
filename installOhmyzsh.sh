#!/bin/bash
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh my zsh ya esta instalado"
else
  echo "Instalando oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
