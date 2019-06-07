#Init
autoload -U compinit promptinit
autoload -U colors && colors
compinit
promptinit

#Aliases
alias vi="nvim"
alias vim="nvim"
alias ls="ls -lh --color"
alias rm="rm -rfv"
alias cp="cp -av --reflink=auto"
alias mv="mv -v"
alias du="du -sh"
alias mkdir="mkdir -p"
alias dirs="dirs -v"
alias less="less -r"
alias more="less -r"
alias most="less -r"
alias sudo="sudo "
alias rsync="rsync -Pva"
alias neofetch="clear; neofetch"
alias -g sd="/home/tom/ScratchArea/"
alias matrix="cmatrix"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"
alias shutdown="sudo poweroff"
alias chrome="chromium"
alias mkpkg="makepkg -i"
alias explorer="nautilus"
alias cl="clear"
alias free="free -h"

if type exa > /dev/null
then 
	unalias ls
	alias ls="exa -lhgbHm --git "
fi

#ZSH Style and Options
zstyle ':completion:*' menu select
setopt completealiases
setopt extendedglob
unsetopt nomatch
prompt walters

#Functions
mkcdir () {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line

#Sourcing
if [ -d /etc/zsh/zshrc.d ]; then
  for file in /etc/zsh/zshrc.d/*; do
    source $file
  done
fi

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/ubin" ] ; then
    PATH="/ubin:$PATH"
fi

#Variables
export VISUAL="nvim"
export EDITOR="nvim"
export HISTFILE="~/zfile"
export GOPATH="~/.go"

eval $(ssh-agent) > /dev/null

#Alias expansion
globalias() {
   if [[ $LBUFFER =~ ' [A-Za-z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches


if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	source /usr/share/doc/pkgfile/command-not-found.zsh
else
	source /home/userfs/j/jehq500/Git/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

