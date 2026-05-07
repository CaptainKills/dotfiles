# Bash Aliases: Danick Triantis

DOMAIN=danick.triantis.nl
USER=danick

SSHFS_DIR="$PROJECTS_DIR/sshfs"

# SSH File System Aliases
alias sshfs-docker="sshfs danick@docker.$DOMAIN:/home/danick/docker $SSHFS_DIR/docker-proxmox -o IdentityFile=~/.ssh/id_docker"
alias sshfs-proxmox="sshfs danick@proxmox.$DOMAIN:/home/danick/proxmox $SSHFS_DIR/proxmox -o IdentityFile=~/.ssh/id_proxmox"
alias sshfs-pi="sshfs danick@pi.$DOMAIN:/home/danick/pi $SSHFS_DIR/pi -o IdentityFile=~/.ssh/id_rpi"
alias sshfs-web="sshfs danick@web.$DOMAIN:/home/danick/docker $SSHFS_DIR/docker-web -o IdentityFile=~/.ssh/id_web"

# TU/e SSH
# alias sshfs-tue="sshfs ...@...:/... /home/danick/Projects/sshfs/tue -o IdentityFile=~/.ssh/id_tue"

# TMUX Session Scripts
alias session="bash $PROJECTS_DIR/dotfiles/scripts/tmux-session.sh"
