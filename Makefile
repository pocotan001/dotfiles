all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	$(MAKE) agents

# AI エージェントのスキルと設定を同期する
#   - skills-lock.json からスキルを復元
#   - AGENTS.md を claude/codex にリンク
agents:
	cd $(HOME) && npx skills experimental_install --yes
	@ln -sf $(HOME)/.agents/AGENTS.md $(HOME)/.claude/CLAUDE.md
	@ln -sf $(HOME)/.agents/AGENTS.md $(HOME)/.codex/AGENTS.md
