#!/usr/bin/env bash

# use this to update kitty theme
# using `kitten theme` and press M to install
# this will create a local `current-theme.conf`

# this script will move and link
CONFIG_DIR=~/.config/kitty
kitten theme

if [[ ! -L "$CONFIG_DIR/current-theme.conf" ]]; then
    echo "detected changed theme in $CONFIG_DIR"
    mv -v $CONFIG_DIR .

    # to git root
    ln -sv $(readlink -f ./current-theme.conf) ~/.config/kitty/current-theme.conf
fi
