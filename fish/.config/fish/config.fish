# Starship
# https://starship.rs/
starship init fish | source

# asdf
# https://asdf-vm.com/
echo -e "\nsource "(brew --prefix asdf)"/libexec/asdf.fish" >> ~/.config/fish/config.fish
source /opt/homebrew/opt/asdf/libexec/asdf.fish

# iTerm2 shell integration
# https://iterm2.com/documentation-shell-integration.html
# test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
