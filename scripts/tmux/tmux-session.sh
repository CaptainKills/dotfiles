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
	"c"
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
	source $SCRIPTS_DIR/tmux-dotfiles.sh "bash"
	;;
"nvim")
	source $SCRIPTS_DIR/tmux-dotfiles.sh "nvim"
	;;
"scripts")
	source $SCRIPTS_DIR/tmux-dotfiles.sh "scripts"
	;;
"tmux")
	source $SCRIPTS_DIR/tmux-dotfiles.sh "tmux"
	;;

# Applications
"ansible")
	source $SCRIPTS_DIR/tmux-ansible.sh
	;;

# Programming
"c")
	source $SCRIPTS_DIR/tmux-programming.sh "c"
	;;
"go")
	source $SCRIPTS_DIR/tmux-programming.sh "go"
	;;
"python")
	source $SCRIPTS_DIR/tmux-programming.sh "python"
	;;
"typst")
	source $SCRIPTS_DIR/tmux-programming.sh "typst"
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
