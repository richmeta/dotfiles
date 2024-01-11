if [ -d ~/bin ]; then
    PATH=$PATH:~/bin
fi

# non-interactive login scripts
[ -f ~/.zprofile_local ] && source ~/.zprofile_local 
