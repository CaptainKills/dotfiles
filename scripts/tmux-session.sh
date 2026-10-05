#!/bin/bash

DOTFILES_DIR="$PROJECTS_DIR/dotfiles"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

source "$SCRIPTS_DIR/tmux-management.sh"

# Select Project
project=$(find $PROJECTS_DIR -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | fzf --layout=reverse --height 40% --tmux 40% --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$project" ]]; then
	exit 0
fi

# Select Directory
directory=$(find $PROJECTS_DIR/$project/ -maxdepth 1 -type d | fzf --layout=reverse --height 40% --tmux 40% --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$directory" ]]; then
	exit 0
fi

# Create Session Name
if [[ $directory == */ ]]; then
	session="$project"
else
	session="$project/${directory##*/}"
fi

# Attach to Session if it exists
check_session $session
if [[ $? -eq 0 ]]; then
	attach_session $session
	exit 0
fi

# Mount SSH-FS if needed
if [[ "$directory" == *"sshfs"* ]]; then
	mount_ssh ${directory##*/}

	ssh_host=${directory##*/}

	directory=$(find $directory -maxdepth 1 -type d | fzf --layout=reverse --height 40% --tmux 40% -q $directory/ --bind 'q:abort')
	fzf_status=$?

	if [[ $fzf_status -ne 0 || -z "$directory" ]]; then
		exit 0
	fi
fi

# Window 1: Neovim
create_session $session $directory
python_venv $session 1 $directory
nvim_window $session 1

# Window 2: Terminal
create_window $session 2 $directory
ssh_window $session 2 $ssh_host ${directory##*/}
python_venv $session 2 $directory
git_update $session 2 $directory

# Window 3: AI
create_window $session 3 $directory
python_venv $session 3 $directory
ai_window $session 3

attach_session $session
exit 0
