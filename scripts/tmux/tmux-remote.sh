#!/bin/bash

SESSION="$1"
WORKING_DIRECTORY="/home/danick/sshfs/$1/"

SSH_HOST="$1"
SSH_DIRECTORY="$2"

# Check if Session is Running
if tmux has-session -t $SESSION 2>/dev/null; then
	if [ -n "$TMUX" ]; then
		tmux switch-client -t $SESSION
	else
		tmux attach-session -t $SESSION
	fi
	exit 0
fi

# Check if SSH-FS is Running
if ! mountpoint -q $WORKING_DIRECTORY; then
	sshfs $SSH_HOST:$SSH_DIRECTORY $WORKING_DIRECTORY
fi

# Create Session
tmux new-session -d -s $SESSION -c $WORKING_DIRECTORY

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
tmux send-keys -t $SESSION:1 "nvim" C-m

# Create SSH Window
tmux new-window -t $SESSION:2
tmux rename-window -t $SESSION:2 "ssh"
tmux send-keys -t $SESSION:2 "ssh $SSH_HOST" C-m
tmux send-keys -t $SESSION:2 "cd $SSH_DIRECTORY; clear" C-m

# Attach Session
tmux select-window -t $SESSION:1
if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION
else
	tmux attach-session -t $SESSION
fi
