all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && mise install
	cd $(HOME) && npx skills experimental_install --yes
