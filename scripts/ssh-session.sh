#!/bin/bash

# Before
sudo systemctl start sshd
sudo systemctl status sshd
sleep 1

# During
brightnessctl -q -s set 1%
killall hypridle
hyprlock 1>/dev/null

# After
echo -e "\n\n\n\n"
brightnessctl -r 1>/dev/null
sudo systemctl stop sshd
sudo systemctl status sshd
hypridle 1>/dev/null &
disown
