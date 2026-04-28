#!/bin/bash
img2sixel -w 500 ~/.config/neofetch/eu.png
printf '\033[16A'
COLUMNS=28 neofetch --backend off 2>/dev/null | whio
    printf '\033[28C%s\n' "$line"
done
printf '\033[?25h'
printf '\033[0B\n'
