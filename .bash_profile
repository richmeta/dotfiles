# non-interactive login scripts
[ -f ~/.bashrc ] && source ~/.bashrc
[ -f ~/.bash_local_profile ] && source ~/.bash_local_profile

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi
