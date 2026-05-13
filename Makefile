all:
	brew bundle
	test -f codex/.codex/config.toml || cp codex/.codex/config.toml.example codex/.codex/config.toml
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && mise install
	cd $(HOME) && npx skills experimental_install --yes
