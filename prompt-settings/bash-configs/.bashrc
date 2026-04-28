for f in motd.sh motd-playstore motd; do
    rm -f "/data/data/com.termux/files/usr/etc/$f"
done
if [[ ${EUID} == 0 ]] ; then   
PS1='\[\e[31m\]┌──(\[\e[38;5;27;1m\]root\[\e[0;31m\])\[\e[38;5;27m\]┉\[\e[0;31m\][\[\e[38;5;27m\]${PWD/*\//}\[\e[0;31m\]]\n\[\e[31m\]╰─\[\e[91;1m\]#\[\e[0m\] '
else
PS1='\[\e[31m\]┌──(\[\e[38;5;27;1m\]WhoFoss\[\e[0;31m\])\[\e[38;5;27m\]┉\[\e[0;31m\][\[\e[38;5;27m\]${PWD/*\//}\[\e[0;31m\]]\n\[\e[31m\]╰─\[\e[38;5;27;1m\]>\[\e[0m\] '
fi
