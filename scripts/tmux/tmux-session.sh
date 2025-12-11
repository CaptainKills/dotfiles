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
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"nvim")
	dir="/home/danick/dotfiles/nvim/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"scripts")
	dir="/home/danick/dotfiles/scripts/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"tmux")
	dir="/home/danick/dotfiles/tmux/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1 tmux.conf
	# Window 2: Terminal
	create_window $session 2 $dir
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;

# Programming
"c")
	dir=$(pick_subdir "/home/danick/c/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	git_update $session 2
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"go")
	dir=$(pick_subdir "/home/danick/go/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	git_update $session 2
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
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
	git_update $session 2
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"typst")
	dir=$(pick_subdir "/home/danick/typst/")
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"ansible")
	dir="/home/danick/ansible/"
	# Window 1: Neovim
	create_session $session $dir
	python_venv $session 1
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	python_venv $session 2
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;

# Remotes
"docker-proxmox")
	dir="/home/danick/sshfs/docker-proxmox/"

	# Mount SSH-FS
	mount_ssh "docker-proxmox" "/home/danick/docker/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-proxmox" "/home/danick/docker/"
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"docker-web")
	dir="/home/danick/sshfs/docker-web/"

	# Mount SSH-FS
	mount_ssh "docker-web" "/home/danick/docker/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-web" "/home/danick/docker/"
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;
"tue")
	dir="/home/danick/sshfs/tue/"

	# Mount SSH-FS
	mount_ssh "tue" "/home/student/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "tue" "/home/student/"
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;

# Default
*)
	exit 0
	;;
esac

attach_session $session
exit 0
