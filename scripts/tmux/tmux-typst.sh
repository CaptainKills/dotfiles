#!/bin/bash

SESSION="typst"
WORKING_DIRECTORY="/home/danick/typst/"

# Check if Session is Running
if tmux has-session -t $SESSION 2>/dev/null; then
	tmux attach-session -t $SESSION
	exit 0
fi

# Fuzzy Pick Subdirectory
selected=$(find $WORKING_DIRECTORY -maxdepth 1 -type d | fzf --tmux 40% -q "$WORKING_DIRECTORY" --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
	WORKING_DIRECTORY="$WORKING_DIRECTORY"
else
	WORKING_DIRECTORY="$selected"
fi

# Create Session
tmux new-session -d -s $SESSION -c $WORKING_DIRECTORY

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
tmux send-keys -t $SESSION:1 "nvim" C-m

# Create Terminal Window
tmux new-window -t $SESSION:2 -c $WORKING_DIRECTORY
tmux rename-window -t $SESSION:2 "terminal"

# Attach Session
tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
