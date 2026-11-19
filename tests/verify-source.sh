#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)

for file in \
  .chezmoiignore \
  .chezmoi.toml.tmpl \
  assets/Brewfile \
  dot_zshenv \
  dot_config/zsh/dot_zshrc \
  dot_config/git/config \
  dot_claude/settings.json \
  dot_codex/AGENTS.md \
  dot_codex/private_create_config.toml \
  skills-lock.json \
  dot_local/share/dotfiles/skills/pr-address-comments/SKILL.md \
  assets/agents/agency-agents.lock \
  assets/agents/gstack.lock; do
  test -f "$repo/$file"
done

test ! -e "$repo/Makefile"
test ! -e "$repo/agents/link-local-skills.sh"
test ! -e "$repo/agents/install-agency-agents.sh"

for script in "$repo"/.chezmoiscripts/* "$repo"/assets/scripts/* "$repo"/script/update; do
  sh -n "$script"
done

python3 -c 'import json, sys; [json.load(open(path)) for path in sys.argv[1:]]' \
  "$repo/dot_claude/settings.json" "$repo/dot_codex/hooks.json"
! rg -n -F '/Users/' "$repo" --glob '!.git/**' --glob '!legacy/**'
/bin/sh "$repo/tests/link-local-skills.test.sh"
/bin/sh "$repo/tests/install-gstack.test.sh"
