# If not running interactively, do nothing
[[ $- != *i* ]] && return

HISTFILE=~/.cache/zsh/history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt autocd extendedglob
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/syslak/.zshrc'

autoload -Uz compinit
compinit

eval "$(starship init zsh)"
# Open suse
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Arch
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

tmux has-session 2> /dev/null
if [[ $? -ne 0 ]]; then
  tmux new-session -s default
fi

