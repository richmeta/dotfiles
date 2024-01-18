#!/usr/bin/env bash

[ ! -f ~/.vimrc ] && ln -sv ~/.vim/vimrc ~/.vimrc
[ ! -f ~/.gvimrc ] && ln -sv ~/.vim/gvimrc ~/.gvimrc

# vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall +qall
