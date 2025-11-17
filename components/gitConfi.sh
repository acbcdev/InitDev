#!/bin/bash
# Configuración de git
# name and email
read -rp "Enter your email: " email
read -rp "Enter your name: " name

git config --global user.email "$email"
git config --global user.name "$name"
git config --global init.defaultBranch main
git config --global core.editor "code"

echo "Git configuration completed. ✔️"
