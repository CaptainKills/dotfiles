#!/bin/bash

SESSION="web"
WORKING_DIRECTORY="/home/danick/sshfs/web"

SSH_URL="danick@web.danick.triantis.nl"
SSH_DIRECTORY="/home/danick/docker"
SSH_KEY="/home/danick/.ssh/id_web"

# Check if Session is Running
if tmux has-session -t $SESSION 2> /dev/null; then
	tmux attach-session -t $SESSION
	exit 0
fi

# Check if SSH-FS is Running
if ! mountpoint -q $WORKING_DIRECTORY; then
	sshfs $SSH_URL:$SSH_DIRECTORY $WORKING_DIRECTORY -o IdentityFile=$SSH_KEY
fi

# Create Session
tmux new-session -d -s $SESSION

# Create Nvim Window
tmux rename-window -t $SESSION:1 "nvim"
tmux send-keys -t $SESSION:1 "cd $WORKING_DIRECTORY; clear" C-m
tmux send-keys -t $SESSION:1 "nvim" C-m

# Create SSH Window
tmux new-window -t $SESSION:2
tmux rename-window -t $SESSION:2 "ssh"
tmux send-keys -t $SESSION:2 "ssh $SESSION" C-m
tmux send-keys -t $SESSION:2 "cd $SSH_DIRECTORY; clear" C-m

# Attach Session
tmux select-window -t $SESSION:1
tmux attach-session -t $SESSION
