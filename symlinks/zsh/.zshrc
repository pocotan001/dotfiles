#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

alias gs='~/Dropbox/Development/ca/girlstalk-server/'

#
# highlight
#

function hlcopy() {
    if [ -z "$2" ]
        then src="pbpaste"
    else
        src="cat $2"
    fi
    $src | highlight -O rtf --syntax $1 --font Menlo --style my-dark --font-size 28 | pbcopy
}

#
# Peco
#

alias -g B='`git branch | peco`'

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
