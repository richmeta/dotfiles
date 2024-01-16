#!/usr/bin/env bash

set -e

# install shell/scripts for bash/zsh

rcfile() {
    local fn=~/.$1              # eg ~/.bashrc
    local src="$PWD/$1"
    if [[ -f $fn ]]; then
        echo "moving $fn to $fn.old"
        mv $fn "$fn.old"
    fi

    if [[ ! -L $fn ]]; then
        ln -sv $src $fn
    fi
}

rcfile bashrc
rcfile bash_profile
rcfile bash_aliases
rcfile zshenv
rcfile zshrc
rcfile zprofile


if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi
