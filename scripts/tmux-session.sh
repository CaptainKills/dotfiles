#!/bin/bash

DOTFILES_DIR="$PROJECTS_DIR/dotfiles"
SCRIPTS_DIR="$DOTFILES_DIR/scripts/"

CATEGORIES=(
	# Dotfiles
	"bash"
	"nvim"
	"scripts"
	"tmux"
	"hypr"
	"waybar"
	"kitty"

	# Programming
	"ansible"
	"c"
	"go"
	"rust"
	"python"
	"typst"

	# Remotes
	"docker-proxmox"
	"docker-web"
	"tue"
)

source "$SCRIPTS_DIR/tmux-management.sh"

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
	dir="$DOTFILES_DIR/bash/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"nvim")
	dir="$DOTFILES_DIR/nvim/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"scripts")
	dir="$DOTFILES_DIR/scripts/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"tmux")
	dir="$DOTFILES_DIR/tmux/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1 tmux.conf
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"hypr")
	dir="$DOTFILES_DIR/hypr/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1 hyprland.conf
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"waybar")
	dir="$DOTFILES_DIR/waybar/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1 config.jsonc
	# Window 2: Terminal
	create_window $session 2 $dir
	;;
"kitty")
	dir="$DOTFILES_DIR/kitty/"

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1 kitty.conf
	# Window 2: Terminal
	create_window $session 2 $dir
	;;

# Programming
"ansible")
	dir="$PROJECTS_DIR/ansible/"

	# Window 1: Neovim
	create_session $session $dir
	python_venv $session 1
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	python_venv $session 2
	;;
"c")
	dir=$(pick_subdir "$PROJECTS_DIR/c/")

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
	dir=$(pick_subdir "$PROJECTS_DIR/go/")

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
"rust")
	dir=$(pick_subdir "$PROJECTS_DIR/rust/")

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
	dir=$(pick_subdir "$PROJECTS_DIR/python/")

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
	dir=$(pick_subdir "$PROJECTS_DIR/typst/")

	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: Terminal
	create_window $session 2 $dir
	# Window 3: AI
	create_window $session 3 $dir
	ai_window $session 3
	;;

# Remotes
"docker-proxmox")
	dir="$PROJECTS_DIR/sshfs/docker-proxmox/"

	# Mount SSH-FS
	mount_ssh "docker-proxmox" "/home/danick/docker/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-proxmox" "/home/danick/docker/"
	;;
"docker-web")
	dir="$PROJECTS_DIR/sshfs/docker-web/"

	# Mount SSH-FS
	mount_ssh "docker-web" "/home/danick/docker/"
	# Window 1: Neovim
	create_session $session $dir
	nvim_window $session 1
	# Window 2: SSH
	create_window $session 2 $dir
	ssh_window $session 2 "docker-web" "/home/danick/docker/"
	;;
"tue")
	dir="$PROJECTS_DIR/sshfs/tue/"

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
