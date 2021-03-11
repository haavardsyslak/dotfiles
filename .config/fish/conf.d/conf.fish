function vim
	command nvim $argv
end

#function cat
#    command bat $argv
#end

set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Startup stuff
#setxkbmap -option caps:super
#xset r rate 300 50
#xcape -e 'Super_L=Escape'

set EDITOR nvim 
set VISUAL nvim 

alias py="python3"
alias :q="exit"
alias godnatt="poweroff"
alias y1="cd ~/uisfiles/year1"
alias lego="cd ~/uisfiles/year1/ing100/Lego"
alias gaa="git add --all"
alias gc="git commit"
alias gp="git push"
alias cpp="cd ~/programering/cpp"
alias i3conf="vim ~/.config/i3/config"
alias f="cd ~/.config/fish"
alias n="nvim"
alias notes="nvim ~/uisfiles/notes/index.md"
alias img="sxiv"
alias matlab="matlab&; disown"
alias neofetch="neofetch --ascii_colors 12 12"
alias config="git --git-dir=$HOME/syslak/dotfiles --work-tree=$HOME"

# VI bindings
fish_vi_key_bindings

#!/usr/bin/fish

set a (tty)
if [ $a = "/dev/tty1" ]
    pgrep xmonad; or starx
end

