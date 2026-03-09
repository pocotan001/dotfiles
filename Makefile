all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && asdf install
	cd $(HOME) && npx skills experimental_install --yes
	for d in $(HOME)/.agents/skills/*/; do ln -sfn ../../.agents/skills/$$(basename $$d) $(HOME)/.claude/skills/$$(basename $$d); done
