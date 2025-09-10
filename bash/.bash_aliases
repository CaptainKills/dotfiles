# SSH File System Aliases
alias sshfs-docker="sshfs danick@docker.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/docker -o IdentityFile=~/.ssh/id_docker"
alias sshfs-proxmox="sshfs danick@proxmox.danick.triantis.nl:/home/danick/proxmox /home/danick/sshfs/proxmox -o IdentityFile=~/.ssh/id_proxmox"
alias sshfs-pi="sshfs danick@pi.danick.triantis.nl:/home/danick/pi /home/danick/sshfs/pi -o IdentityFile=~/.ssh/id_rpi"
alias sshfs-web="sshfs danick@web.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/web -o IdentityFile=~/.ssh/id_web"

# TU/e SSH
# alias sshfs-tue="sshfs pcp25007@co24.ics.ele.tue.nl:/home/pcp/pcp25007 /home/danick/sshfs/tue" # 5LIM0
alias sshfs-tue="sshfs student@es-pynq059.ics.ele.tue.nl:/home/student /home/danick/sshfs/tue -o IdentityFile=~/.ssh/id_pynq" # 5LIB0

# TMUX Session Scripts
alias session="bash /home/danick/dotfiles/scripts/tmux/tmux-session.sh"
