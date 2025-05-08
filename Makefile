all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
