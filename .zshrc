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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
