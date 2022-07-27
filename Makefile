all: brew stow nvm fisher

# Homebrew
# https://brew.sh/
brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
	brew bundle

# nvm
# https://github.com/nvm-sh/nvm
nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Create symlinks with GNU Stow
# https://www.gnu.org/software/stow/
stow: brew
	@stow --target ~/ --ignore '\.DS_Store' -Rv */

# Fisher
# https://github.com/jorgebucaran/fisher
fisher: brew stow
	curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher \
	fisher update
