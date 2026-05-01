#!/usr/bin/env bash

PKG_PACKAGES=(
    "wget" "git" "vim" "bat" "lsd" "ruby"
    "neofetch" "lolcat"
    "tput:ncurses-utils"
    "img2sixel:libsixel"
    "img2sixel:x264"
)

GEM_PACKAGES=("lolcat")

tsize=$(stty size | cut -d' ' -f2)
line() { printf '%*s\n' "$tsize" '' | tr ' ' "${1:--}"; }
center() { local p=$(( (tsize - ${#1}) / 2 )); printf "%${p}s%s\n" '' "$1"; }

clear
line
center "Dependency Installer"
line
echo

echo -e "\e[33mAtualizando repositórios...\e[0m"
yes | pkg update && yes | pkg upgrade
echo

for entry in "${PKG_PACKAGES[@]}"; do
    IFS=':' read -r cmd pkg <<< "$entry"
    pkg="${pkg:-$cmd}"
    command -v "$cmd" &>/dev/null || { echo -e "\e[33mInstalando $pkg...\e[0m"; pkg install -y "$pkg"; }
done

for gem in "${GEM_PACKAGES[@]}"; do
    command -v "$gem" &>/dev/null || { echo -e "\e[33mInstalando gem $gem...\e[0m"; gem install "$gem"; }
done

echo
line
center "Resumo"
line

for entry in "${PKG_PACKAGES[@]}"; do
    IFS=':' read -r cmd _ <<< "$entry"
    command -v "$cmd" &>/dev/null \
        && echo -e "$cmd: \e[32mOK\e[0m" \
        || echo -e "$cmd: \e[31mErro\e[0m"
done

for gem in "${GEM_PACKAGES[@]}"; do
    command -v "$gem" &>/dev/null \
        && echo -e "$gem: \e[32mOK\e[0m" \
        || echo -e "$gem: \e[31mErro\e[0m"
done

line
