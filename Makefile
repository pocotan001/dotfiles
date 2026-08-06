.PHONY: all

all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && mise install
