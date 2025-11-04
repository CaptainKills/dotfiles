#!/bin/bash

SCRIPTS_DIR=/home/danick/dotfiles/scripts/tmux
CATEGORIES=(
	# Dotfiles
	"bash"
	"nvim"
	"scripts"
	"tmux"

	# Programming
	"c"
	"go"
	"python"
	"typst"
	"ansible"

	# Remotes
	"docker-proxmox"
	"docker-web"
	"tue"
)

source $SCRIPTS_DIR/tmux-management.sh

# Select Session
session=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --layout=reverse --height 40% --tmux 40% --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$session" ]]; then
	exit 0
fi

# Attach to Session if it exists
check_session $session
if [[ $? -eq 0 ]]; then
	attach_session $session
	exit 0
fi

# Create New Session
case $session in
# Dotfiles
"bash")
	dir="/home/danick/dotfiles/bash/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"nvim")
	dir="/home/danick/dotfiles/nvim/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"scripts")
	dir="/home/danick/dotfiles/scripts/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"tmux")
	dir="/home/danick/dotfiles/tmux/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;

# Programming
"c")
	dir=$(pick_subdir "/home/danick/c/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"go")
	dir=$(pick_subdir "/home/danick/go/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"python")
	dir=$(pick_subdir "/home/danick/python/")
	# Window 1: Neovim
	create_session $session $dir
	python_venv $session 1
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	python_venv $session 2
	;;
"typst")
	dir=$(pick_subdir "/home/danick/typst/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"ansible")
	dir="/home/danick/ansible/"
	# Window 1: Neovim
	create_session $session $dir
	python_venv $session 1
	attach_session $session
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	python_venv $session 2
	;;

# Remotes
"docker-proxmox")
	dir="/home/danick/sshfs/docker-proxmox/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-proxmox" "/home/danick/docker/"
	;;
"docker-web")
	dir="/home/danick/sshfs/docker-web/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-web" "/home/danick/docker/"
	;;
"tue")
	dir="/home/danick/sshfs/tue/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "tue" "/home/student/"
	;;

# Default
*)
	exit 0
	;;
esac

attach_session $session
exit 0
