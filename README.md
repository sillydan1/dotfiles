# GTZs devmachine setup
This is where I keep all my magic. These files expect a UNIX based system.

Please note: I basically live all my life in the terminal - only to occasionally open `firefox`.
If I could have a firefox rendering engine _inside_ my terminal, I would prefer that.
This may be possible through `ghostty` or `alacritty` in the future, as they allow for direct GPU accelarated rendering.
This means that the only real thing that I need a windowing manager for is to manage my displays, be a GPU interface and
open the occasional GUI application that may be needed for drawing diagrams, viewing PDFs, playing games etc.

This means that my real "window manager" is `tmux` - so most of this config is very focused around that workflow.

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

## alacritty
I personally like `alacritty`, so this repo also adds a config file for that. However, you may need to clone the alacritty-theme repository in order to get proper colors.
```sh
git clone git@github.com:alacritty/alacritty-theme.git .config/alacritty/alacritty-theme
# remember to call stow after the clone
```
Note that the font size may have to be adjusted depending on your display.
The [documentation](https://alacritty.org/config-alacritty.html) says that the size is meant to be in "points per inch",
but that is a blatant [lie](https://github.com/alacritty/alacritty/issues/5505) - so just edit the font size as you desire.

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
Then start tmux, press `Ctrl+a, I` to install the plugins (these dotfile rebind `Ctrl+b` to `Ctrl+a`).

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

## Global gitignore
This repo contains a global gitignore that ignores some things that you should never ever ever commit.
You can enable it after you've `stow .`'d with the following command:
```sh
git config --global core.excludesfile ~/.gitignore_global
```


# Arch linux
I am using arch linux. Sometimes you just want to use one of the tty's.
This is a general guide for myself, as I tend to forget things.

## Hyprland
I also have a hyprland configuration (mostly just default where I removed some bloat).
When arch linux is just freshly installed (literally only `iwd` and perhaps a text editor is installed), hyprland may not work.
Dont install `hyprland` yet, make sure you have done these prerequisites first:

 - You have to be in the `seat` and `input` groups, you should also enable `seatd`:
 - Install `alacritty`, as that is my preferred terminal, this can be changed in the hyprland config
 - Install hyprland apps `waybar`, `hyprpaper` and `wmenu`
 - Install other random garbage such as `wl-clipboard`

```sh
sudo pacman -S alacritty waybar hyprpaper wmenu wl-clipboard ttf-meslo-nerd
sudo usermod seat input <user>
systemctl enable seatd
systemctl start seatd
```

## Missing Programs
A fresh arch linux (with no gui) is missing a lot.
 - `iwd` - install this (if you have an intel wifi-card (you very likely do)) using the installer.
   Make sure to create the `/etc/iwd/main.conf` file:
   ```
   [General]
   EnableEntworkConfiguration=true
   ```
   This can be done using raw `echo` and pipes.
   Truth be told, I have no idea how you're reading this document with no internet, but here we are.
   Also:
   ```sh
   systemctl enable systemd-resolved
   systemctl start systemd-resolved
   ```
- `neovim`
- `tmux` (see above)
- `git`
- `openssh` (use to generate ssh key and get going)
- `nvm` (see above)
- `lynx`
