export LANG=ja_JP.UTF-8

# Enable colors
autoload -U colors
colors

# History in cache directory
export HISTFILE="$HOME/.config/zsh/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files

# Set options
setopt appendhistory
setopt auto_cd
setopt extended_glob
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt ignore_eof
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt no_flow_control
setopt print_eight_bit
setopt pushd_ignore_dups
setopt share_history

# Starship
eval "$(starship init zsh)"

# asdf
export PATH="$HOME/.asdf/shims:$PATH"

# Git alias
alias g='git'
compdef g=git
alias gf='git fetch'
compdef _git gst=git-fetch
alias gl='git pull'
compdef _git gl=git-pull
alias gp='git push'
compdef _git gp=git-push
alias gco='git checkout'
compdef _git gco=git-checkout
