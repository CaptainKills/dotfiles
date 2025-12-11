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
	tmux rename-window -t $session:$window "ssh"
	tmux send-keys -t $session:$window "ssh $host" C-m
	tmux send-keys -t $session:$window "cd $dir; clear" C-m
}

ai_window() {
	local session=$1
	local window=$2

	tmux rename-window -t $session:$window "gemini"
	tmux send-keys -t $session:$window "gemini" C-m
}

mount_ssh() {
	local sshfs_dir="/home/danick/sshfs/$1/"
	local ssh_host=$1
	local ssh_dir=$2

	# Mount SSH Directory via SSH-FS
	if ! mountpoint -q $sshfs_dir; then
		sshfs $ssh_host:$ssh_dir $sshfs_dir
	fi
}

pick_subdir() {
	local dir=$1

	selected=$(find $dir -maxdepth 1 -type d | fzf --layout=reverse --height 40% --tmux 40% -q "$dir" --bind 'q:abort')
	fzf_status=$?

	if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
		echo ""
	else
		echo $selected
	fi
}

python_venv() {
	local session=$1
	local window=$2

	tmux send-keys -t $session:$window "source .venv/bin/activate && clear" C-m
}

git_update() {
	local session=$1
	local window=$2

	tmux send-keys -t $session:$window "git fetch && git pull" C-m
}
