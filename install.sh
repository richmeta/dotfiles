#!/usr/bin/env bash

set -e

# install shell/scripts for bash/zsh

rcfile() {
    local fn=~/$1              # eg ~/.bashrc
    local src="$PWD/$1"
    if [[ -f $fn ]]; then
        echo "moving $fn to $fn.old"
        mv $fn "$fn.old"
    fi

    if [[ ! -L $fn ]]; then
        ln -sv $src $fn
    fi
}

rcfile ".bashrc"
rcfile ".bash_profile"
rcfile ".bash_aliases"
rcfile ".zshenv"
rcfile ".zshrc"
rcfile ".zprofile"
rcfile ".tmux.conf"
rcfile ".rgignore"
rcfile ".ripgreprc"

# tmux
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
fi

# vim
if [ ! -e ~/.vim ]; then
    ln -sv $(readlink -f .vim) ~/.vim
    .vim/install.sh
fi

# dirs
[ ! -d ~/.config ] && mkdir -p ~/.config

# nvim
if [ ! -e ~/.config/nvim ]; then
    ln -sv $(readlink -f .config/nvim) ~/.config/nvim 
fi

# i3
if [ ! -e ~/.config/i3 ]; then
    ln -sv $(readlink -f .config/i3) ~/.config/i3 
fi

# ctags
if [ ! -e ~/.config/ctags ]; then
    ln -sv $(readlink -f .config/ctags) ~/.config/ctags 
fi

# vifm
if [ ! -e ~/.config/vifm ]; then
    ln -sv $(readlink -f .config/vifm) ~/.config/vifm 
fi

# git
mkdir -p ~/.config/git
if [ ! -e ~/.config/git/ignore ]; then
    ln -sv $(readlink -f .config/git/ignore) ~/.config/git/ignore
    git config --global core.excludesFile $HOME/.config/git/ignore
fi

# black
if [ ! -e ~/.config/black ]; then
    ln -sv $(readlink -f .config/black) ~/.config/black
fi

