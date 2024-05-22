# Dotfiles

Personal configuration files for tmux and nvim.

## TMUX

Configuration files for tmux can be found in the `tmux` folder.

## NVIM

Configuration files for nvim can be found in the `nvim` folder.

### NVIM Installation

Neovim can be installed as follows:

Install the following prerequisite packages:

```bash
sudo apt install python3 python3-pip python3-venv
sudo apt install git wget curl unzip gzip tar

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source .bashrc && nvm install node
```

Install Neovim via the latest release:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

echo "export PATH="\$PATH:/opt/nvim-linux64/bin"" >> .bashrc
source .bashrc && nvim
```
