#source "$HOME/.cargo/env"

export EDITOR="nvim"
export TERMINAL="st"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/.local/go"
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$PATH
export PATH="$PATH:$HOME/.local/bin:/usr/local/go/bin"


# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export CONDARC="$XDG_CONFIG_HOME/conda/condarc"

# Disable files

export LESSHISTFILE=-

# . "$XDG_DATA_HOME/cargo/env"

# export LD_PRELOAD=/lib64/libfreetype.so
# . "/home/syslak/.local/share/cargo/env"
. "/home/syslak/.local/share/cargo/env"
