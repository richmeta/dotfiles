# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# NOTE: $PATH set in ~/.zprofile
# important for gui apps like gvim

export HISTFILE=~/.zsh_history
export HISTORY_IGNORE="(ls|ll|cd|pwd|cp|mv|rm|yt-dlp|yt|kill|rmdir) *"
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY_TIME
export GOPATH=~/workspace/go
export MYSYNC=$HOME/sync
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export PAGER=less

zshaddhistory() {
    emulate -L zsh
    [[ $1 != ${~HISTORY_IGNORE} ]]
}

zshaddhistory() {
    emulate -L zsh
    [[ $1 != ${~HISTORY_IGNORE} ]]
}

if [[ $OSTYPE == darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=Exgxcxdxcxegedabagacad
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [[ $OSTYPE == darwin* ]] && [[ -x $(which nvim) ]]; then
    export EDITOR=nvim
elif [[ -x $(which gvim) ]]; then
    export EDITOR=gvim
elif [[ -x $(which vim) ]]; then
    export EDITOR=vim
else
    export EDITOR=vi
fi
export VISUAL="$EDITOR"

# activate python
function activate() {
    if [[ -n "$1" ]]; then
        if [[ -f "$HOME/envs/$1/bin/activate" ]]; then
            source "$HOME/envs/$1/bin/activate"
        elif [[ -f "$1/bin/activate" ]]; then
            source "$1/bin/activate"
        else
            echo "Env $1 not found"
        fi
    elif [[ -L "./.env" && -d $(readlink .env) ]]; then
        source .env/bin/activate
    elif [[ -f pyproject.toml ]] && [[ -x $(which poetry) ]]; then
        env=$(poetry env info --path)
        if [[ -n "$env" ]]; then
            source "$env/bin/activate"
        fi
    else
        # find the activate and do it
        file=$(find_activate)
        if [ $? -eq 0 ]; then
            echo -n "Source $file (Y/n) ? "
            read yn
            if [[ ${#yn} -eq 0 || $yn = 'y' ]]; then
                source $file;
            fi
        fi
    fi
}

function hgrep() {
    grep -iP ~/.zsh_history -- "$*";
}

function mdc() {
    mkdir -p -v "$1" && cd "$1"
}

if [[ -x $(which jump) ]]; then
    # add jump support
    # https://github.com/gsamokovarov/jump
    eval "$(jump shell)"
fi

bindkey -e

if [[ -e ~/.yarn/bin ]]; then
    export PATH="$HOME/.yarn/bin:$PATH"
fi

if [[ -e ~/sync ]]; then
    export COMMANDS=~/sync/stuff/commands
fi

function precmd() hr


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk
#


zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting
if [[ -x $(which nix) ]]; then
    # nix with zsh
    zinit light chisui/zsh-nix-shell
fi
zplugin ice depth=1
zplugin light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
### End of Zinit's installer chunk

autoload -Uz compinit && compinit

[ -f ~/.zshrc_local ] && source ~/.zshrc_local

# direnv
if [[ -x $(which direnv) ]]; then
    eval "$(direnv hook zsh)"
fi
