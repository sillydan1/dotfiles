# GTZs devmachine setup
This is where I keep all my magic. These files expect a UNIX based system.

## Installation

### stow
You must have `stow` installed for this to work.
```sh
# Ubuntu
sudo apt install stow
# MacOS
brew install stow
# Arch
sudo pacman -S stow
```

Then simply do this:
```sh
git clone git@github.com/sillydan1/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
```

## Secrets
If you have any aliases, paths, env variables or anything else that you don't want to share, you can put them in a file called `secrets` in the root of the dotfiles directory.
This file will be ignored by git, but still loaded automatically by the shell-rc file(s) so you can put whatever you want in there.

## tmux
Install tmux and the tmux plugin manager
```sh
# ubuntu
sudo apt install tmux
# MacOS
brew install tmux
# Arch
sudo pacman -S tmux
```
Then install the plugin manager
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then start tmux, press `Ctrl+a, I` to install the plugins.

## neovim
Install the latest neovim from https://github.com/neovim/neovim
Note that these files expect neovim v0.9+, so the package manager distribution may not be good enough (looking at you debian & ubuntu)
```sh
# Ubuntu
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
./nvim-linux64/bin/nvim
# MacOS
brew install neovim
# Arch
sudo pacman -S neovim
```

## lazygit
```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

## ripgrep
Prefer to use the cargo package, but this can work in a pinch (not necessarily up to date):
```sh
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

## nodejs
Simply install nvm with this
```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
```

Then install and use node 20 (latest is a bit too snazzy) like so:
```sh
nvm i 20
nvm use node
```
