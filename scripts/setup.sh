#!/bin/bash

DOTFILES=$HOME/dotfiles
CONFIG=$HOME/.config

link() {
	SRC=$1
	DEST=$2
	echo "Creating directory link for '$SRC' to '$DEST'."

	rm -rf "$DEST"
	ln -s "$SRC" "$DEST"
}

# INFO: --- BASH ---
# if [ ! -L "$HOME/.profile" ]; then
# 	link "$DOTFILES/bash/.profile" "$HOME/.profile"
# fi

# if [ ! -L "$HOME/.bashrc" ]; then
# 	link "$DOTFILES/bash/.bashrc" "$HOME/.bashrc"
# fi

if [ ! -L "$HOME/.bash_aliases" ]; then
	link "$DOTFILES/bash/.bash_aliases" "$HOME/.bash_aliases"
fi

if [ ! -L "$HOME/.bash_logout" ]; then
	link "$DOTFILES/bash/.bash_logout" "$HOME/.bash_logout"
fi

# INFO: --- .Config --- 
if [ ! -d "$CONFIG" ]; then
	echo "Ceating directory ~/.config"
	mkdir "$CONFIG"
fi

# INFO: --- NVIM --- 
if [ ! -L "$CONFIG/nvim" ]; then
	link "$DOTFILES/nvim" "$CONFIG/nvim"
fi

# INFO: --- TMUX --- 
if [ ! -L "$CONFIG/tmux" ]; then
	link "$DOTFILES/tmux" "$CONFIG/tmux"
fi


