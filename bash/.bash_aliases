# SSH File System Aliases
alias sshfs-docker="sshfs danick@docker.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/docker -o IdentityFile=~/.ssh/id_docker"
alias sshfs-proxmox="sshfs danick@proxmox.danick.triantis.nl:/home/danick/proxmox /home/danick/sshfs/proxmox -o IdentityFile=~/.ssh/id_proxmox"
alias sshfs-pi="sshfs danick@pi.danick.triantis.nl:/home/danick/pi /home/danick/sshfs/pi -o IdentityFile=~/.ssh/id_rpi"
alias sshfs-web="sshfs danick@web.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/web -o IdentityFile=~/.ssh/id_web"

# TU/e SSH 
# alias sshfs-tue="sshfs pcp25007@co24.ics.ele.tue.nl:/home/pcp/pcp25007 /home/danick/sshfs/tue" # 5LIM0
alias sshfs-tue="sshfs student@es-pynq059.ics.ele.tue.nl:/home/student /home/danick/sshfs/tue -o IdentityFile=~/.ssh/id_pynq" # 5LIB0

# TMUX Session Scripts
SCRIPTS_DIR=/home/danick/dotfiles/scripts

alias tmux-nvim="bash $SCRIPTS_DIR/tmux-nvim.sh"
alias tmux-tmux="bash $SCRIPTS_DIR/tmux-tmux.sh"
alias tmux-ansible="bash $SCRIPTS_DIR/tmux-ansible.sh"
alias tmux-docker="bash $SCRIPTS_DIR/tmux-docker.sh"
alias tmux-web="bash $SCRIPTS_DIR/tmux-web.sh"
alias tmux-tue="bash $SCRIPTS_DIR/tmux-tue.sh"
alias tmux-go="bash $SCRIPTS_DIR/tmux-go.sh"
alias tmux-typst="bash $SCRIPTS_DIR/tmux-typst.sh"
alias tmux-python="bash $SCRIPTS_DIR/tmux-python.sh"

