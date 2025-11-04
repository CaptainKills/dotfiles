#!/bin/bash

SESSION="$1"
WORKING_DIRECTORY="/home/danick/$1"

# Check if Session is Running
if tmux has-session -t $SESSION 2>/dev/null; then
	if [ -n "$TMUX" ]; then
		tmux switch-client -t $SESSION
	else
		tmux attach-session -t $SESSION
	fi
	exit 0
fi

# Fuzzy Pick Subdirectory
selected=$(find $WORKING_DIRECTORY -maxdepth 1 -type d | fzf --layout=reverse --height 40% --tmux 40% -q "$WORKING_DIRECTORY" --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
	exit 0
else
	WORKING_DIRECTORY="$selected"
fi

# Create Session
tmux new-session -d -s $SESSION -c $WORKING_DIRECTORY

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
if [ "$1" = "python" ] || [ "$1" = "ansible" ]; then
	tmux send-keys -t $SESSION:1 "source .venv/bin/activate && clear" C-m
fi
tmux send-keys -t $SESSION:1 "nvim" C-m

# Create Terminal Window
tmux new-window -t $SESSION:2 -c $WORKING_DIRECTORY
tmux rename-window -t $SESSION:2 "terminal"

# (Python) Enable Virtual Environment
if [ "$1" = "python" ] || [ "$1" = "ansible" ]; then
	tmux send-keys -t $SESSION:2 "source .venv/bin/activate && clear" C-m
fi

# Attach Session
tmux select-window -t $SESSION:1
if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION
else
	tmux attach-session -t $SESSION
fi
