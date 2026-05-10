# Bash Profile: Danick Triantis

# General Projects Directory
if [ -d "$HOME/Projects" ]; then
    export PROJECTS_DIR="$HOME/Projects"
else
    export PROJECTS_DIR=$HOME
fi

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
    export PATH
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
    export PATH
fi

# Fuzzy Finder
export FZF_ALT_C_COMMAND=
eval "$(fzf --bash)"

# Golang
export GOPATH="/home/danick/Projects/go"
export PATH=$PATH:/home/danick/Projects/go/bin

# Nvidia CUDA
export PATH=$PATH:/usr/local/cuda/bin
