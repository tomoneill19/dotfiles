#Init
autoload -U compinit promptinit
autoload -U colors && colors
compinit
promptinit

#Aliases
alias rm="rm -rfv"
alias cp="cp -av --reflink=auto"
alias mv="mv -v"
alias du="du -sh"
alias df="df -h"
alias mkdir="mkdir -p"
alias dirs="dirs -v"
alias less="less -r"
alias more="less -r"
alias sudo="sudo "
alias rsync="rsync -Pva"
alias neofetch="clear; neofetch"
alias -g sd="/home/tom/.ScratchArea/"
alias matrix="cmatrix"
alias reboot="sudo reboot"
alias poweroff="sudo poweroff"
alias shutdown="sudo poweroff"
alias chrome="chromium"
alias makepkg="makepkg -i"
alias cl="clear"
alias free="free -h"
alias xclip="xclip -selection clipboard"
alias vwd="dolphin ."

# Conditional Aliases
if type exa > /dev/null
then
    alias ls="exa -lhbHm --git "
    alias lst="exa -lhbHmT --git"
else
    alias ls="ls -lh --color"
fi
if type nvim > /dev/null
then
    alias vim="nvim"
    alias vi="nvim"
    export EDITOR=nvim
    export VISUAL=nvim
elif type vim > /dev/null
then
    alias vi="vim"
    alias nvim="vim"
    export EDITOR=vim
    export VISUAL=vim
else
    alias vim="vi"
    alias nvim="vi"
    export EDITOR=vi
    export VISUAL=vi
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

reload-zshrc () {
source ~/.zshrc
}

lls () {
    clear
    ls
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
export GOPATH="$HOME/.go"

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

# Plugins
if [ -f ~/.zsh/vi-mode.plugin.zsh ]; then
    source ~/.zsh/vi-mode.plugin.zsh
else
    echo "vi-mode plugin not loaded"
fi

if grep -Fxq "arch" /etc/os-release; then
    if [ -f ~/.zsh/git.plugin.zsh ]; then
        source ~/.zsh/git.plugin.zsh
    else
        echo "archlinux plugin not loaded"
    fi
fi

if [ -f ~/.zsh/globalias.plugin.zsh ]; then
    source ~/.zsh/globalias.plugin.zsh
else
    echo "globalias plugin not loaded"
fi

if [ -f ~/.zsh/git.plugin.zsh ]; then
    source ~/.zsh/git.plugin.zsh
else
    echo "git plugin not loaded"
fi

if [ -f ~/.zsh/you-should-use.plugin.zsh ]; then
    source ~/.zsh/you-should-use.plugin.zsh
else
    echo "you-should-use plugin not loaded"
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    echo "zsh-syntax-highlighting plugin not loaded"
fi

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    echo "zsh-autosuggestions plugin not loaded"
fi

if grep -Fxq "arch" /etc/os-release; then
    if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
        source /usr/share/doc/pkgfile/command-not-found.zsh
    else
        echo "pkgfile plugin not loaded"
    fi
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000
setopt SHARE_HISTORY

[ -f ~/.resh/shellrc ] && source ~/.resh/shellrc

