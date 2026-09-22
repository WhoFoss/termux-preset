#!/usr/bin/env bash

# --- cores
G=$'\e[1;32m'   # verde
Y=$'\e[1;33m'   # amarelo
C=$'\e[1;36m'   # ciano
B=$'\e[1m'      # bold
D=$'\e[2m'      # dim
R=$'\e[1;31m'   # vermelho
N=$'\e[0m'      # reset

# --- helpers de UI
ui_line() {
  local name="$1" status="$2" suffix="${3:-}"
  local dots
  dots=$(printf '%*s' $((PAD - ${#name})) '' | tr ' ' '.')
  if [[ "$status" == "ok" ]]; then
    printf "${B}%s${N} ${D}%s${N} ${G}%s${N}%s\n" "$name" "$dots" "$status" "$suffix"
  else
    printf "${B}%s${N} ${D}%s${N} ${R}%s${N}%s\n" "$name" "$dots" "$status" "$suffix"
  fi
}
ui_ok()   { printf "\n${G}+${N} %s\n" "$*"; }
ui_erro() { printf "\n${R}-${N} %s\n" "$*"; }

# --- cursor
printf "\033[?25l"
trap 'printf "\033[?12l\033[?25h"' EXIT

# --- Remover motd
for f in motd motd.sh motd-playstore; do
    rm -f "$HOME/../usr/etc/$f"
done

# --- URLs
declare -A urls=(
    ["aesthetic.jpg"]="${HOME}/.config/neofetch|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/assets/aesthetic.jpg"
    ["logo.png"]="${HOME}/.config/neofetch|https://github.com/WhoFoss/termux-preset/raw/refs/heads/main/assets/logo.png"
    ["termux.properties"]="$HOME/.termux|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/termux-configs/termux.properties"
    [".nanorc"]="$HOME|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/shell-config/config-files/.nanorc"
    ["colors.properties"]="$HOME/.termux|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/termux-configs/color-schemes"
    ["font.ttf"]="$HOME/.termux|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/shell-config/config-files/font.ttf"
    [".bashrc"]="$HOME|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/bash-configs/.bashrc"
    ["bash.bashrc"]="$PREFIX/etc|https://raw.githubusercontent.com/WhoFoss/termux-preset/refs/heads/main/prompt-settings/bash-configs/bash.bashrc"
)

# --- padding adaptativo
PAD=0
for name in "${!urls[@]}"; do
    (( ${#name} > PAD )) && PAD=${#name}
done
PAD=$((PAD + 10))

# --- cabeçalho
clear
printf "${B}termux-preset${N} ${D}— bootstrap${N}\n\n"

# --- loop
erros=0
for arq in "${!urls[@]}"; do
    dest="${urls[$arq]%%|*}"
    url="${urls[$arq]##*|}"

    suffix=""
    if [ -e "$dest/$arq" ]; then
        cp "$dest/$arq" "$dest/$arq.bkp"
        suffix="  ${Y}(bkp)${N}"
    fi

    if curl -fsSLo "$dest/$arq" "$url" 2>/dev/null; then
        ui_line "$arq" "ok" "$suffix"
    else
        ui_line "$arq" "ERRO"
        ((erros++))
    fi
done

termux-reload-settings

# --- resumo final
if (( erros == 0 )); then
    ui_ok "Concluído."
else
    ui_erro "Concluído com $erros erro(s)."
fi
