#!/bin/bash

check_session() {
	local session=$1

	if tmux has-session -t $session 2>/dev/null; then
		return 0
	fi

	return 1
}

attach_session() {
	local session=$1
	local window=1

	if tmux has-session -t $session 2>/dev/null; then
		if [ -n "$TMUX" ]; then
			tmux switch-client -t $session:$window
		else
			tmux attach-session -t $session:$window
		fi
	fi
}

create_session() {
	local session=$1
	local dir=$2

	tmux new-session -d -s $session -c $dir
}

create_window() {
	local session=$1
	local window=$2
	local dir=$3

	tmux new-window -t $session:$window -c $dir
	tmux rename-window -t $session:$window "terminal"
}

nvim_window() {
	local session=$1
	local window=$2
	local file=$3

	tmux rename-window -t $session:$window "nvim"
	tmux send-keys -t $session:$window "nvim $file" C-m
}

ssh_window() {
	local session=$1
	local window=$2

	local host=$3
	local dir=$4

	# Create SSH Window
	if [[ "$session" == *"sshfs"* ]]; then
		tmux rename-window -t $session:$window "ssh"
		tmux send-keys -t $session:$window "ssh $host" C-m
		tmux send-keys -t $session:$window "cd $dir; clear" C-m
	fi
}

ai_window() {
	local session=$1
	local window=$2

	tmux rename-window -t $session:$window "gemini"
	tmux send-keys -t $session:$window "agy" C-m
}

mount_ssh() {
	local sshfs_dir="$PROJECTS_DIR/sshfs/$1/"
	local ssh_host=$1
	local ssh_dir="/home/danick/"

	# Mount SSH Directory via SSH-FS
	if ! mountpoint -q $sshfs_dir; then
		sshfs $ssh_host:$ssh_dir $sshfs_dir
	fi
}

python_venv() {
	local session=$1
	local window=$2
	local dir=$3

	# Activate venv if it exists
	local check=$(ls -a $dir)
	if [[ "$check" == *".venv"* ]]; then
		tmux send-keys -t $session:$window "source .venv/bin/activate && clear" C-m
	fi
}

git_update() {
	local session=$1
	local window=$2
	local dir=$3

	# Refresh git if it exists
	local check=$(ls -a $dir)
	if [[ "$check" == *".git"* ]]; then
		tmux send-keys -t $session:$window "git fetch && git pull" C-m
	fi
}
