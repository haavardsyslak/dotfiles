#source "$HOME/.cargo/env"

alias vim="nvim"
alias py="python3"
alias jl="julia"
alias gaa="git add --all"
alias gc="git commit"
alias gp="git push"
alias img="sxiv"
alias neofetch="neofetch --ascii_colors 12 12"
alias config="git --git-dir=$HOME/repos/dotfiles --work-tree=$HOME"
alias ls="ls --color=auto"
alias dls="ranger $HOME/extra/downloads"
alias l="ls -lh"
alias cfg="$HOME/programering/scripts/cfg_finder.sh"
alias lock="dm-tool switch-to-greeter"
alias reboot="systemctl reboot"
alias poweroff="systemctl poweroff"
alias susp="systemctl suspend"
alias bt="bluetoothctl"
alias lazydot="GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME lazygit"

# Blueye aliases
alias dssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.101"
alias dscp="scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@192.168.1.101"

export EDITOR="nvim"
# export TERMINAL="zathura"
export VISUAL="nvim"
export GOPATH="$HOME/.local/go"
#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$PATH
export PATH="$PATH:$HOME/.local/bin:/usr/local/go/bin:$HOME/.local/go/bin"


# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}

export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter

# Disable files

export LESSHISTFILE=-

# . "$XDG_DATA_HOME/cargo/env"

# export LD_PRELOAD=/lib64/libfreetype.so
# . "/home/syslak/.local/share/cargo/env"
# . "/home/syslak/.local/share/cargo/env"
export PATH=$PATH:/$HOME/.pyenv
export PATH="$PATH:$HOME/source/cross-imx/scripts"
# export PATH=$PATH:/home/syslak/source/cross-imx/scripts
