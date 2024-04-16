#!/bin/bash

alias=(
  "alias le='exa --level=1 --tree --icons'"
  "alias lr='exa --tree --level=1 --all --icons'"
  "alias rundev='pnpm run dev'"
  "alias runbuild='pnpm run build'"
  "alias runstart='pnpm run start'"
  "alias runtest='pnpm run test'"
  "alias cl='clear'"
  "alias toUpdate='sudo dnf update'"
  "alias toInstall='sudo dnf install'"
  "alias pl='ping 8.8.8.8 | lolcat'"
  "alias hm='cd ~'"
  "alias hd='cd ~/Dev/'"
  "alias projs='cd ~/Dev/Proyectos/'"
  "alias study='cd ~/Dev/Platzi/'"
  "alias OpenSrc='cd ~/Dev/Cmt'"
  "alias ggclone='git clone'"
  "alias ggcmt='git commit -am'"
  "alias ggadd='git add .'"
  "alias ggsta='git status'"
  "alias gglog='git log'"
  "alias ggswi='git switch'"
)

zshrc="${HOME}/.zshrc"

if [ -w "$zshrc" ]; then
  # Añadir cada alias de la lista si no existe
  for ali in "${alias[@]}"; do
    echo "$ali" >>"$zshrc"
  done
else
  echo "Error: El archivo $zshrc no existe o no se puede escribir en él."
fi
