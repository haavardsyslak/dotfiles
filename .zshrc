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
zmodload zsh/complist
compinit

zstyle ':completion:*' menu select
bindkey -M menuselect 'h' vi-backwared-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-dowm-line-or-history
bindkey -M menuselect 'l' vi-forward


setopt autocd # Auto cd into typed dir
stty stop undef # Disable Ctrl-S to freeze terminal

eval "$(starship init zsh)"
# Open suse
# source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Arch
source $HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# else
# 	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# 	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fi

source <(fzf --zsh)

if tty | grep -vq "tty"; then
	tmux has-session 2> /dev/null
	if [[ $? -ne 0 ]]; then
		tmux new-session -s default
	fi
fi

