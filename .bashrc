# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ==============================================================================
# Weather comment
# WTTR_PARAMS is space-separated URL parameters, many of which are single characters that can be
# lumped together. For example, "F q m" behaves the same as "Fqm".
if [[ -z "$WTTR_PARAMS" ]]; then
  # Form localized URL parameters for curl
  if [[ -t 1 ]] && [[ "$(tput cols)" -lt 125 ]]; then
      WTTR_PARAMS+='n'
  fi 2> /dev/null
  for _token in $( locale LC_MEASUREMENT ); do
    case $_token in
      1) WTTR_PARAMS+='m' ;;
      2) WTTR_PARAMS+='u' ;;
    esac
  done 2> /dev/null
  unset _token
  export WTTR_PARAMS
fi

# --- Custom commands
wttr() {
  local location="${1// /+}"
  command shift
  local args=""
  for p in $WTTR_PARAMS "$@"; do
    args+=" --data-urlencode $p "
  done
  curl -fGsS -H "Accept-Language: ${LANG%_*}" $args --compressed "wttr.in/${location}"
}

export HISTTIMEFORMAT="%d/%m/%y %T "
export PATH="$PATH:$HOME/Applications/nvim-linux64/bin"
export PATH="$PATH:$HOME/Applications/"
export PATH="$PATH:$HOME/Applications/gradle-8.5/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export EDITOR=vim
export CMAKE_GENERATOR=Ninja

# Load node version manager
if [ -d $HOME/.config/nvm ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm use 20
fi
if [ -d $HOME/.nvm ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm use 20
fi

# aliasses
alias lg="lazygit"
if [ -x "$(command -v fzf)" ]; then
  alias fman="compgen -c | fzf | xargs man"
  eval "$(fzf --bash)"
fi
if [ -x "$(command -v eza)" ]; then
  alias ls="eza"
  alias ll="eza -lah"
fi

if [ -x "$(command -v xbacklight)" ]; then
  alias minimum_brightness="xbacklight -set 0.12%"
  alias maximum_brightness="xbacklight -set 100%"
elif [[ -x "$(command -v brightnessctl)" ]]; then
  alias minimum_brightness="brightnessctl s 1"
  alias maximum_brightness="brightnessctl s 100%"
fi

alias flip_coin="echo \$((1 + \$RANDOM % 2))"
alias vev="uv v && source .venv/bin/activate && uv pip install -e .[dev] && uv pip install neovim"
alias v="source .venv/bin/activate"
alias scim="TERM=xterm-256color sc-im"
alias n="nvim"

# Load all the secrets from the secrets folder (assuming this repo is in $HOME/dotfiles)
if [ -d $HOME/dotfiles/secrets ]; then
  for f in $HOME/dotfiles/secrets/*; do
    source $f
  done
fi

# ruby shit
if [ -x "$(command -v gem)" ]; then
  export GEM_HOME="$(gem env user_gemhome)"
  export PATH="$PATH:$GEM_HOME/bin"
fi

# set repeat rate.
if [[ "$XDG_SESSION_TYPE" == "x11" ]]; then
  xset r rate 200 75
fi

# Custom thing that helps you create .epub files from manpages
if [ -x "$(command -v manbook)" ]; then
  mantoepub ()
  {
    manbook $1
    pandoc -f html -t epub3 -o $1.epub $1.html
  }
fi

# Emacs shit (experimental)
if [ -x "$(command -v emacs)" ]; then
  alias emacs="emacs -nw"
fi

# enable syntax highlighting in the manpages
export MANPAGER="less -R --use-color -Dd+r -Du+b"

# Set firefox as default browser
export BROWSER="firefox"

# Pretty print some information
clear
if [ -x "$(command -v pfetch)" ]; then
  pfetch
elif [ -x "$(command -v neofetch)" ]; then
  neofetch
elif [ -x "$(command -v fastfetch)" ]; then
  fastfetch
elif [ -x "$(command -v cowsay)" ]; then
  cowsay "Greetings $USER!"
else
  echo "Hello $USER!"
fi
