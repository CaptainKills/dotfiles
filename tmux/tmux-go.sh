#!/bin/bash

SESSION="go"
WORKING_DIRECTORY="/home/danick/go"

# Check if Session is Running
if tmux has-session -t $SESSION 2> /dev/null; then
	tmux attach-session -t $SESSION
	exit 0
fi

# Create Session
tmux new-session -d -s $SESSION

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
tmux send-keys -t $SESSION:1 "cd $WORKING_DIRECTORY; clear" C-m
tmux send-keys -t $SESSION:1 "nvim" C-m

# Create Terminal Window
tmux new-window -t $SESSION:2
tmux rename-window -t $SESSION:2 "terminal"
tmux send-keys -t $SESSION:2 "cd $WORKING_DIRECTORY; clear" C-m

# Attach Session
tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
