#!/bin/bash

SESSION="$1"
WORKING_DIRECTORY="/home/danick/dotfiles/$1/"

# Check if Session is Running
if tmux has-session -t $SESSION 2>/dev/null; then
	if [ -n "$TMUX" ]; then
		tmux switch-client -t $SESSION
	else
		tmux attach-session -t $SESSION
	fi
	exit 0
fi

# Create Session
tmux new-session -d -s $SESSION -c $WORKING_DIRECTORY

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
if [ "$1" = "tmux" ]; then
	tmux send-keys -t $SESSION:1 "nvim tmux.conf" C-m
else
	tmux send-keys -t $SESSION:1 "nvim" C-m
fi

# Create Terminal Window
tmux new-window -t $SESSION:2 -c $WORKING_DIRECTORY
tmux rename-window -t $SESSION:2 "terminal"

# Attach Session
tmux select-window -t $SESSION:1
if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION
else
	tmux attach-session -t $SESSION
fi
