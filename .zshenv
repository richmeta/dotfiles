[ -f ~/.bash_aliases ] && source ~/.bash_aliases

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# non-interactive login scripts
[ -f ~/.zshenv_local ] && source ~/.zshenv_local
