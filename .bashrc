source ~/.bash_aliases

export HISTSIZE=100000
export HISTFILESIZE=10000000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="bg:fg:ls:ll:cp:mv:rm:history:rmdir:kill"
export PATH=~/bin:$PATH
export GOPATH=~/workspace/go
export MYSYNC=$HOME/sync
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export PAGER=less

if [[ $OSTYPE == darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=Exgxcxdxcxegedabagacad
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [[ -x $(which gvim) ]]; then
    export EDITOR=gvim
elif [[ -x $(which vim) ]]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

# activate python
function activate() {
    if [[ -n "$1" ]]; then
        if [[ -f "$HOME/envs/$1/bin/activate" ]]; then
            FILE="$HOME/envs/$1/bin/activate"
            source $FILE
        elif [[ -f "$1/bin/activate" ]]; then
            FILE="$1/bin/activate"
            source $FILE
        else
            echo "Env $1 not found"
        fi
    elif [[ -L "./.env" && -d $(readlink .env) ]]; then
        source .env/bin/activate
    elif [[ -f pyproject.toml ]] && [[ -x $(which poetry) ]]; then
        poetry shell
    else
        # find the activate and do it
        FILE=$(find_activate)

        if [ $? -eq 0 ]; then
            echo -n "Source $FILE (Y/n) ? "
            read yn
            if [[ ${#yn} -eq 0 || $yn = 'y' ]]; then
                source $FILE;
            fi
        fi
    fi
}


function hgrep() {
    history | grep -iP -- "$*";
}

function mdc() {
    mkdir -p -v "$1" && cd "$1"
}

# TODO: not working in bash
# add jump support
# https://github.com/gsamokovarov/jump
# eval "$(jump shell)"

[[ -s /usr/share/git/completion/git-prompt.sh ]] && . /usr/share/git/completion/git-prompt.sh

if [[ -e ~/.yarn/bin ]]; then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

if [[ -e ~/sync ]]; then
    export COMMANDS=~/sync/stuff/commands
fi

[ -f ~/.bashrc_local ] && source ~/.bashrc_local

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# direnv
if [[ -x $(which direnv) ]]; then
    eval "$(direnv hook bash)"
fi
