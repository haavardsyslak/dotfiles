#source "$HOME/.cargo/env"

export EDITOR="nvim"
export TERMINAL="st"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/.local/go"
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$PATH
export PATH="$PATH:$HOME/.local/bin"


export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

# Disable files

export LESSHISTFILE=-
. "$HOME/.cargo/env"
