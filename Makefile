.PHONY: all

all:
	brew bundle
	stow --target ~/ --ignore '\.DS_Store' -Rv */
	cd $(HOME) && mise install
	$(CURDIR)/agents/link-local-skills.sh
	$(CURDIR)/agents/install-agency-agents.sh
