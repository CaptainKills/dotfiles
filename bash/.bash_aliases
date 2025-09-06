# SSH File System Aliases
alias sshfs-docker="sshfs danick@docker.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/docker -o IdentityFile=~/.ssh/id_docker"
alias sshfs-proxmox="sshfs danick@proxmox.danick.triantis.nl:/home/danick/proxmox /home/danick/sshfs/proxmox -o IdentityFile=~/.ssh/id_proxmox"
alias sshfs-pi="sshfs danick@pi.danick.triantis.nl:/home/danick/pi /home/danick/sshfs/pi -o IdentityFile=~/.ssh/id_rpi"
alias sshfs-web="sshfs danick@web.danick.triantis.nl:/home/danick/docker /home/danick/sshfs/web -o IdentityFile=~/.ssh/id_web"

# TU/e SSH 
# alias sshfs-tue="sshfs pcp25007@co24.ics.ele.tue.nl:/home/pcp/pcp25007 /home/danick/sshfs/tue" # 5LIM0
alias sshfs-tue="sshfs student@es-pynq059.ics.ele.tue.nl:/home/student /home/danick/sshfs/tue -o IdentityFile=~/.ssh/id_pynq" # 5LIB0

# TMUX Session Scripts
alias tmux-nvim="bash /home/danick/.config/tmux/tmux-nvim.sh"
alias tmux-tmux="bash /home/danick/.config/tmux/tmux-tmux.sh"
alias tmux-ansible="bash /home/danick/.config/tmux/tmux-ansible.sh"
alias tmux-docker="bash /home/danick/.config/tmux/tmux-docker.sh"
alias tmux-web="bash /home/danick/.config/tmux/tmux-web.sh"
alias tmux-tue="bash /home/danick/.config/tmux/tmux-tue.sh"
alias tmux-go="bash /home/danick/.config/tmux/tmux-go.sh"
alias tmux-typst="bash /home/danick/.config/tmux/tmux-typst.sh"
alias tmux-python="bash /home/danick/.config/tmux/tmux-python.sh"

