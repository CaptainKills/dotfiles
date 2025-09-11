#!/bin/bash

CATEGORIES=(
	# Dotfiles
	"bash"
	"nvim"
	"scripts"
	"tmux"

	# Applications
	"ansible"

	# Programming
	"go"
	"python"
	"typst"

	# Remotes
	"docker"
	"web"
	"tue"
)

SCRIPTS_DIR=/home/danick/dotfiles/scripts/tmux

selected=$(printf "%s\n" "${CATEGORIES[@]}" | fzf --tmux 40% --bind 'q:abort')
fzf_status=$?

if [[ $fzf_status -ne 0 || -z "$selected" ]]; then
	exit 0
fi

case $selected in
# Dotfiles
"bash")
	source $SCRIPTS_DIR/tmux-bash.sh
	;;
"nvim")
	source $SCRIPTS_DIR/tmux-nvim.sh
	;;
"scripts")
	source $SCRIPTS_DIR/tmux-scripts.sh
	;;
"tmux")
	source $SCRIPTS_DIR/tmux-tmux.sh
	;;

# Applications
"ansible")
	source $SCRIPTS_DIR/tmux-ansible.sh
	;;

# Programming
"go")
	source $SCRIPTS_DIR/tmux-go.sh
	;;
"python")
	source $SCRIPTS_DIR/tmux-python.sh
	;;
"typst")
	source $SCRIPTS_DIR/tmux-typst.sh
	;;

# Remotes
"docker")
	source $SCRIPTS_DIR/tmux-docker.sh
	;;
"web")
	source $SCRIPTS_DIR/tmux-web.sh
	;;
"tue")
	source $SCRIPTS_DIR/tmux-tue.sh
	;;

# Default
*)
	exit 0
	;;
esac

exit 0
