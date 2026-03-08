all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	$(MAKE) agents

# AI エージェントのスキルと設定を同期する
#   - .skill-lock.json から外部スキルを復元
#   - AGENTS.md を claude/codex にリンク
agents:
	npx skills experimental_install --yes
	@mkdir -p $(HOME)/.claude/skills $(HOME)/.codex/skills
	@ln -sf $(HOME)/.agents/AGENTS.md $(HOME)/.claude/CLAUDE.md
	@ln -sf $(HOME)/.agents/AGENTS.md $(HOME)/.codex/AGENTS.md
	@for skill in $(HOME)/.agents/skills/*/; do \
		ln -sfn "$$skill" $(HOME)/.claude/skills/; \
		ln -sfn "$$skill" $(HOME)/.codex/skills/; \
	done
