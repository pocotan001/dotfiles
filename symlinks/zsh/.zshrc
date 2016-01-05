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

function peco-cdr() {
  echo "cdr is required"
  # cdr is required
  local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
  if [ -n "$selected_dir" ]; then
    echo "cd ${selected_dir}"
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-cdr
bindkey '^@' peco-cdr

#
# Gulp
#

# Completion for gulp
# https://github.com/gulpjs/gulp/tree/master/completion
function _gulp_completion() {
    compls=$(gulp --tasks-simple)
    completions=(${=compls})
    compadd -- $completions
}

compdef _gulp_completion gulp
