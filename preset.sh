#!/bin/bash

r="\033[1;31m" g="\033[1;32m" x="\033[0m"

ok()  { echo -e "${x}[${g}+${x}] $1"; }
err() { echo -e "[${r}!${x}] $1"; }
warn(){ echo -e "[${r}!${x}] $1\n"; }

echo -en "\033[?25l"  # hide cursor
trap 'echo -en "\033[?12l\033[?25h"' EXIT  # restore on exit

# Remover motd
for f in motd motd.sh motd-playstore; do
    rm -f "$HOME/../usr/etc/$f"
done
warn "Arquivos motd removidos"

# URLs
declare -A urls=(
    ["termux.properties"]="https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/termux-configs/termux.properties"
    [".nanorc"]="https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/shell-config/config-files/.nanorc"
    ["colors.properties"]="https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/color-schemes/color-schemes"
    ["font.ttf"]="https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/shell-config/config-files/font.ttf"
    [".bashrc"]="https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/bash-configs/.bashrc"
)

ok "Iniciando configurações do Termux..."

total=${#urls[@]}; i=0

for arq in "${!urls[@]}"; do
    i=$((i+1))
    dest=$([[ "$arq" =~ ^\. ]] && echo "$HOME" || echo "$HOME/.termux")

    [ -e "$dest/$arq" ] && cp "$dest/$arq" "$dest/$arq.bkp" && ok "Backup: $arq.bkp"

    if curl -sLo "$dest/$arq" "${urls[$arq]}"; then
        ok "[$i/$total] $arq aplicado"
    else
        err "[$i/$total] Falha: $arq"
    fi
done

termux-reload-settings
ok "Concluído."
