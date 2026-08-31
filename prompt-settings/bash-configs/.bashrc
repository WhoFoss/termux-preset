# *********************************************
# * local: ${HOME}/.bashrc
# * WhoFoss
# -----------------------------------------------
# * General Configuration
# -----------------------------------------------

################# Terminal Configuration #################

# Enable checkwinsize
shopt -s checkwinsize

# Command history configuration
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups

################# Aliases #################

############# Basic Commands
alias ls='lsd'
alias l='ls -CF'
alias rm='rm -rfv'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias top='top -o %CPU'
alias h='history'
alias c='clear'
alias less='less -S'
alias e='exit'
alias s='sudo'
alias o='sudo'

# -----------------------------------------------
# Aliases: cat → bat
# -----------------------------------------------
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never -pp'
    alias catp='bat'
fi

############# File and Directory Management
alias src='source ~/.bashrc'
alias srcc='clear && source ~/.bashrc'
alias lists='nano /etc/apt/sources.list'
alias tt='clear;termux-reload-settings && source ../usr/etc/bash.bashrc'
alias ttsu='clear; tsu'
alias ports='netstat -tuln'
alias mem='ps aux --sort -rss'
alias update='apt update && apt upgrade'
alias upgrade='pkg update -y && pkg upgrade -y'
alias cdd='cd ~/Downloads'
alias cdm='cd ~/Music'
alias cdp='cd ~/Pictures'
alias cddc='cd ~/Documents'
alias cdw='cd ~/Workspace'
alias cdt='cd ~/Termux'
alias cds='cd ~/Scripts'
alias vi='vim'
alias rmrf='rm -rf'
alias mkdir='mkdir -p'

# Safe removal via trash-cli (instead of permanent deletion)
rm-trash() {
    command -v trash >/dev/null 2>&1 || { echo >&2 "trash-cli not found. Install with: pkg install trash-cli"; return 1; }
    trash "$@"
}
alias rmt='rm-trash'

############# Quick Directory Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

#### Autocompletion ###################

# cycle through all matches with 'TAB' key
bind 'TAB:menu-complete'

# necessary for programmable completion
shopt -s extglob

# cd when entering just a path
shopt -s autocd

############# Other Utilities
alias n='nano'
alias v='vim'
alias py='python'
alias py3='python3'
alias ip='curl ifconfig.me'
alias listen='nc -lvp'
alias myip='ip addr show wlan0 | grep inet | awk '\''{ print $2; }'\'''
alias cpuinfo='cat /proc/cpuinfo'
alias meminfo='cat /proc/meminfo'
alias diskinfo='df -h'
alias lsa='ls -a'

############# Network and Information Tools
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias calc='bc -l'
alias randpass='openssl rand -base64 12'
alias asciiart='curl http://artii.herokuapp.com/make\?text\=Termux'
alias diskusage='ncdu'
alias weather='curl wttr.in'
alias movieinfo='mediainfo'

############# Calendar and Timestamps
alias cal='cal -3'
alias timestamp='date +%s'

############# Encryption and Security
alias encrypt='gpg -c'
alias decrypt='gpg -d'
alias cve='searchsploit'

############# Network Information
alias whatismyip='curl ifconfig.me'
alias iptablesflush='iptables -F'

############# System Commands
alias rebootsys='sudo reboot'
alias poweroffsys='sudo poweroff'
alias encryptfile='openssl aes-256-cbc -a -salt -in'
alias decryptfile='openssl aes-256-cbc -d -a -in'
alias qr='qrcode-terminal'

############# Timers and Stopwatches
alias stopwatch='date && time read -sn 1 && echo && date'
alias timer='read -p "Enter time in seconds: " secs && echo "Timer started for $secs seconds." && sleep $secs && notify-send "Timer finished!"'

############# Network Tests
alias speedtest-cli='speedtest-cli --simple'
alias wifi='termux-wifi-connectioninfo'
alias battery='termux-battery-status'
alias shareterm='sshd'

############# Git and Version Control
alias gitinit='git init'
alias gita='git add .'
alias gitc='git commit -m'
alias gitp='git push'
alias gitlog='git log'
alias gitconf='git config --global user.name "Your Name" && git config --global user.email "youremail@example.com"'

############# Terminal Output to Termbin
alias tb="nc termbin.com 9999 2>/dev/null || echo 'Failed to connect to termbin'"

############# Ping Connection Tests
alias google='ping -t 3 www.google.com.br' # Ping Google every 3 seconds
alias uol='ping -t 3 www.uol.com.br' # Ping UOL every 3 seconds

############# GoFile
alias gofile="~/gofile"

################# Functions #################

############# History Search Helper
# usage: his query1 query2 queryn...
# example: his ssh 192 (search all ssh commands with IPs including 192)
# example: his sed jsx react (search all sed commands with "jsx" and "react")
function his() {
    # Store complete history in a variable
    commandlog=$(history | grep -oE "[a-zA-Z]{1}.*" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' | sort | uniq)

    # For each parameter passed to this function, execute case-insensitive grep
    for var in "$@"; do
        commandlog=$(echo "$commandlog" | grep -i "$var")
    done

    # Display results
    echo "$commandlog"
}

############# Interactive History Search (fzf)
hrun() {
    local selected=$(history | awk '{$1=""; print $0}' | sort -u | fzf \
        --height=80% \
        --border \
        --prompt="History: " \
        --preview='echo {}' \
        --preview-window='down:20%:wrap')

    [[ -n "$selected" ]] && {
        echo -e "\nExecuting: $selected"
        eval "$selected"
    }
}

############# Interactive File/Directory Search (fzf)
ff() {
    local selected=$(fzf \
        --height=80% \
        --border \
        --prompt="Search: " \
        --preview='cat {} 2>/dev/null | head -50' \
        --preview-window='down:50%:wrap' \
        < <(find ${1:-.} 2>/dev/null))

    [[ -z "$selected" ]] && return

    if [[ -d "$selected" ]]; then
        cd "$selected"
    elif [[ -f "$selected" ]]; then
        nano "$selected"
    fi
}

############# IP Locator
function @ip-locator() {
    local USAGE="usage: ip-locator <ip> [<ip>..]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    curl ipinfo.io/$1 && shift
    while [ "$1" != "" ]; do
        curl ipinfo.io/$1
        shift
    done
}

############# Domain IP Resolver
function @ip-resolver() {
    local USAGE="usage: ip-resolver <domain-name> [<domain-name>..]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    [ $# -eq 0 ] && (>&2 echo $USAGE) && return
    while [ "$1" != "" ]; do
        echo "$1 "
        dig +short @resolver1.opendns.com $1
        shift
    done
}

############# Package Selector/Installer (fzf)
pkgm() {
    local selected=$(apt-cache pkgnames 2>/dev/null | sort | fzf \
        --multi \
        --height=80% \
        --border \
        --prompt="Select packages: " \
        --preview='apt-cache show {} 2>/dev/null | head -100' \
        --preview-window='down:50%:wrap' \
        --bind='ctrl-a:select-all,ctrl-d:deselect-all')

    [[ -n "$selected" ]] && {
        echo -e "\nInstalling: $selected"
        pkg install -y $selected
    }
}

############# JSON File Validator
function jsv() {
    local USAGE="usage: jsv <file.json> [<file.json>..]"
    [ -z "$1" ] && (>&2 echo $USAGE) && return
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    command -v python3 >/dev/null 2>&1 || { echo >&2 "Command python3 not found"; return; }
    while [ "$1" != "" ]; do
        echo -n "$1: "
        cat $1 | python3 -m json.tool >/dev/null && echo "OK"
        shift
    done
}

############# Convert Filenames to Lowercase
function lcfile() {
    local USAGE="usage: lcfile <file> [<file>..]"

    [ "$1" = "" ] && (>&2 echo $USAGE) && return
    [ "$1" = "-h" ] && (>&2 echo $USAGE) && return
    [ "$1" = "--help" ] && (>&2 echo $USAGE) && return

    while [ "$1" != "" ]; do
        if [ -e "$1" ]; then
            local DST=$(dirname "$1")/$(basename "$1" | tr '[A-Z]' '[a-z]')
            [ ! -e "${DST}" ] && mv -T "$1" "${DST}" || (>&2 echo "failed to rename: $1")
        else
            (>&2 echo "invalid file: $1")
        fi
        shift
    done
}

############# Replace Substring in Filenames
function rsfile() {
    local USAGE="usage: rsfile <search-string> <replace-string> <file> [<file>..]"
    local sstr=""
    local rstr=""

    while [ "${rstr}" == "" ]; do
        [ "$1" = "" ] && (>&2 echo $USAGE) && return
        [ "$1" = "-h" ] && (>&2 echo $USAGE) && return
        [ "$1" = "--help" ] && (>&2 echo $USAGE) && return
        if [ "${sstr}" == "" ]; then
            sstr="$1"
        else
            rstr="$1"
        fi
        shift
    done

    while [ "$1" != "" ]; do
        if [ -e "$1" ]; then
            local FNAME=$(basename "$1")
            local DST=$(dirname "$1")/${FNAME/${sstr}/${rstr}}
            [ ! -e "${DST}" ] && mv -T "$1" "${DST}" || (>&2 echo "failed to rename: $1")
        else
            (>&2 echo "invalid file: $1")
        fi
        shift
    done
}

############# Remove Non-ASCII Characters
function ascify() {
    local USAGE="usage: ascify <file> [<file>..]"
    [ -z "$1" ] && (>&2 echo $USAGE) && return
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    while [ "$1" != "" ]; do
        tr -cd '\11\12\15\40-\176' <$1
        shift
    done
}

############# Remove Trailing Whitespace
function trim-ws() {
    local USAGE="usage: trim-ws <file> [<file>..]"
    [ -z "$1" ] && (>&2 echo $USAGE) && return
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    sed -i 's/[ \t]*$//' $@
}

############# Replace Tabs with Spaces
function trim-tab() {
    local USAGE="usage: trim-tab <file> [<file>..]"
    [ -z "$1" ] && (>&2 echo $USAGE) && return
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    command -v sponge >/dev/null 2>&1 || { echo >&2 "Sponge not found. Install moreutils"; return; }
    while [ "$1" != "" ]; do
        expand -t 4 "$1" | sponge "$1"
        shift
    done
}

############# Code Signature Analysis
function code-analysis() {
    for i in $@; do
        echo -n "$i: "
        sed 's/[^"{};]//g' $i | tr -d '\n'
        echo
    done
}

############# Generate Random Password
function genpasswd() {
    local PWDLEN=${1:-32}
    tr -dc A-Za-z0-9_ </dev/urandom | head -c ${PWDLEN} | xargs
}

############# Generate PIN Code
function genpin() {
    local PINLEN=${1:-4}
    tr -dc 0-9 </dev/urandom | head -c ${PINLEN} | xargs
}

############# Caesar Cipher / ROT-13
function rot13() {
    if [ $# = 0 ]; then
        tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
    else
        tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" <$1
    fi
}

############# Show Process Threads
function atop() {
    [ -z "$1" ] && (>&2 echo "usage: atop <process-name>") && return
    top -H -p $(pgrep $1)
}

############# List Most Used Commands in History
function xtop() {
    local N=${1:-10}
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head -n $N
}

############# Find C and C++ Source Files
function c-src() {
    local USAGE="usage: c-src [directory]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    local SRC=.
    [ -n "$1" ] && local SRC="$1"
    find ${SRC} -regextype posix-extended -regex "^.*\.(cpp|hpp|c|h)$" | grep -ve "^\.\/debian"
}

############# Find Python Source Files
function py-src() {
    local USAGE="usage: py-src [directory]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    local SRC=.
    [ -n "$1" ] && local SRC="$1"
    find ${SRC} -name "*.py"
}

############# Find R Source Files
function r-src() {
    local USAGE="usage: r-src [directory]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    local SRC=.
    [ -n "$1" ] && local SRC="$1"
    find ${SRC} -regex ".*\.[rR]"
}

############# Find JSON Files
function json-src() {
    local USAGE="usage: json-src [directory]"
    [ "$1" == "-h" ] && (>&2 echo $USAGE) && return
    local SRC=.
    [ -n "$1" ] && local SRC="$1"
    find ${SRC} -iname "*.json"
}

############# Extract Compressed Files
function extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "'$1' cannot be extracted using the 'extract' function" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

############# Clone Repository
function clone() {
    if [ $# -lt 1 ]; then
        echo "Usage: clone <repository_url>"
        return 1
    fi

    default_destination="$HOME/clones"
    counter=1

    # Find the next available directory number
    while [ -d "$default_destination/clone-$counter" ]; do
        counter=$((counter + 1))
    done

    destination="$default_destination/clone-$counter"

    git clone -q "$1" "$destination"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone."
        return 1
    fi

    echo "Clone successful. Repository cloned to '$destination'"
}

############# Command Not Found Handler
command_not_found_handle() {
    echo -e '\033[1;31m[\033[1;33m!\033[1;31m]\033[0m Command \033[1;36m'"$1"'\033[0m not found.'
    return 127
}

############# Custom cd Function
cd() {
    if [ "$1" == ".." ]; then
        builtin cd .. && ls
    elif [ -n "$1" ]; then
        builtin cd "$1" && ls
    else
        builtin cd && ls
    fi
}

############# Backup Configuration
function backup-bashrc() {
    cp ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d)
    echo "Backup of .bashrc created!"
}

function restore-bashrc() {
    local latest_backup=$(ls -t ~/.bashrc.backup.* 2>/dev/null | head -n1)
    if [ -n "$latest_backup" ]; then
        cp "$latest_backup" ~/.bashrc
        source ~/.bashrc
        echo ".bashrc restored from: $latest_backup"
    else
        echo "No backup found!"
    fi
}

############# Restore Termux bash.bashrc from Backup
crb() {
    b="/data/data/com.termux/files/usr/etc/bash.bashrc"
    [[ ! -f "$b" || $(wc -c < "$b" 2>/dev/null || echo 0) -lt 100 ]] && \
    [[ -f "${b}.bkp" ]] && \
    cat "${b}.bkp" > "$b" && \
    echo "bash.bashrc restored!" && \
    { [[ $- == *i* ]] && source "$b" && echo "Reloaded!"; } || \
    echo "bash.bashrc OK"
}

############# Create Directory and Enter It
mkcd() { mkdir -p "$1" && cd "$1"; }

############# Search Files by Name
search() { find . -type f -name "$1" 2>/dev/null; }

############# List Largest Files/Directories in Current Directory
biggest() { du -sh * 2>/dev/null | sort -rh | head -${1:-10}; }

############# Create Backup with Timestamp
bak() { cp "$1"{,.bak.$(date +%Y%m%d%H%M%S)}; }

############# Check if Port is in Use
portcheck() { ss -tulanp 2>/dev/null | grep ":$1 " || echo "Port $1 is free"; }
