#!/usr/bin/env bash

PKG_PACKAGES=(
    "tmux" "wget" "git" "lsd"
    "fzf" "fd" "vim" "bat" 
    "tput:ncurses-utils"
    "img2sixel:libsixel"
)

tsize=$(stty size 2>/dev/null | cut -d' ' -f2)
[[ -z "$tsize" || "$tsize" -eq 0 ]] && tsize=80

line()   { printf '%*s\n' "$tsize" '' | tr ' ' "${1:--}"; }
center() { local p=$(( (tsize - ${#1}) / 2 )); printf "%${p}s%s\n" '' "$1"; }

header() {
    clear
    line
    center "$1"
    line
    echo
}

header "Dependency Installer"

echo -e "\e[33mAtualizando repositórios...\e[0m"
yes | pkg update

for entry in "${PKG_PACKAGES[@]}"; do
    IFS=':' read -r cmd pkg <<< "$entry"
    pkg="${pkg:-$cmd}"
    if ! command -v "$cmd" &>/dev/null; then
        header "Instalando $pkg"
        pkg install -y "$pkg"
        sleep 0.3
    fi
done

header "Resumo"

for entry in "${PKG_PACKAGES[@]}"; do
    IFS=':' read -r cmd _ <<< "$entry"
    command -v "$cmd" &>/dev/null \
        && echo -e "$cmd: \e[32mOK\e[0m" \
        || echo -e "$cmd: \e[31mErro\e[0m"
done

line
