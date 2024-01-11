#!/usr/bin/env bash

[ ! -f ~/.vimrc ] && ln -sv ~/.vim/vimrc ~/.vimrc
[ ! -f ~/.gvimrc ] && ln -sv ~/.vim/gvimrc ~/.gvimrc


function yn() {
    local prompt="$1 [Yn]: "

    while true; do
        echo -n "$prompt"
        read yn
        case $yn in
            [Yy]* | "" )
                return 0;;
            [Nn]* )
                return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
