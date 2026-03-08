all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && npx skills experimental_install --yes
