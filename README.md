# GTZs devmachine setup
This is where I keep all my magic. These files expect a UNIX based system.

## tmux
 - First off, install tmux (e.g. `brew install tmux` or `apt install tmux`)
 - `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
 - then place `.tmux.conf` file into your $HOME dir
 - start tmux
 - Press Ctrl+a, I (capital I)
 - shit will install
 - you probably need to reopen a terminal
 - ???
 - profit!

## neovim
Install the latest neovim from https://github.com/neovim/neovim
Note that these files expect neovim v0.9+, so the package manager distribution may not be good enough (looking at you debian & ubuntu)
```
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
./nvim-linux64/bin/nvim
```
Consider adding the bin path to your $PATH as well

## Lazygit
```sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

## ripgrep
Prefer to use the cargo package, but this can work in a pinch (not necessarily up to date):
```
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

## npn (used for many language servers)
Simply install nvm with this
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
```
Then install and use node like so:
```
nvm install node
nvm use node
```
