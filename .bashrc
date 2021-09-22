#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '


export EDITOR="nvim"
export TERMINAL="st -e fish"
export VISUAL="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
