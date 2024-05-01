#!/bin/bash

add_alias_if_not_exist() {
  local new_alias=$1
  local alias_name
  # Extraer el nombre del alias
  alias_name=$(echo "$new_alias" | grep -oE "^alias \S+")

  # Verificar si el alias ya existe en el .zshrc
  if grep -q "$alias_name" "$zshrc"; then
    echo "El alias ${alias_name#alias } ya existe."
  else
    echo "$new_alias" >>"$zshrc"
    echo "Alias ${alias_name#alias } añadido."
  fi
}

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
  "alias pl='ping 8.8.8.8 '"
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
  "alias cb='cd ..'"
  "alias cbb='cd ../..'"
  "alias rgr='ranger'"
 "alias adios='poweroff'"	
 "alias speedtest='speedtest-cli'"
 "alias neo='fastfetch'"

)

zshrc="${HOME}/.zshrc"

if [ -w "$zshrc" ]; then
  # Añadir cada alias de la lista si no existe
  for ali in "${alias[@]}"; do
    add_alias_if_not_exist "$ali"
  done
else
  echo "Error: El archivo $zshrc no existe o no se puede escribir en él."
fi
