# Created by newuser for 5.8

# If not running interactivleym, do nothinng
[[ $- != *i* ]] && return


set -o ignoreeof

# Alias
#alias mat="wid=$(xdo id); xdo hide; matlab; xdo show $wid"
 

function git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
     
}


export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/source/cross-imx/scripts:$PATH
export MAN_POSIXLY_CORRECT=1
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
export XCURSOR_SIZE=16

setopt PROMPT_SUBST
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}"$'\n'"$%b "

if [[ -n "$TMUX" ]]; then
    PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[cyan]%}%M %{$fg[magenta]%}%~%{$fg[red]%}%{$reset_color%}"$'\n'"$%b %"
else
    PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}%{$reset_color%}"$'\n'"$%b %"
fi

# PS1="%B%{$fg[red]%}%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}%{$reset_color%}"$'\n'"$%b %"
#PROMPT='%9c%{%F{green}%}$(gt_branch)%{%F{none}%} $ '
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
# setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Syntax highlighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# source /etc/zsh_completion.d/fzf-key-bindings
# source /etc/zsh_completion.d/fzf-key-bindings
#
source <(fzf --zsh)

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/syslak/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

tmux has-session 2> /dev/null
if [[ $? -ne 0 ]]; then
  tmux new-session -s default
fi



