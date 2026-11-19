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
  dot_agents/skills/pr-address-comments/SKILL.md \
  dot_agents/skills/create-github-pull-request-from-specification/SKILL.md \
  dot_claude/skills/symlink_pr-address-comments \
  dot_claude/skills/symlink_create-github-pull-request-from-specification \
  dot_codex/skills/symlink_pr-address-comments \
  dot_codex/skills/symlink_create-github-pull-request-from-specification \
  assets/agents/agency-agents.lock; do
  test -f "$repo/$file"
done

test ! -e "$repo/Makefile"
test ! -e "$repo/agents/install-agency-agents.sh"

for script in "$repo"/.chezmoiscripts/* "$repo"/assets/scripts/* "$repo"/script/update; do
  sh -n "$script"
done
zsh -n "$repo/dot_zshenv" "$repo/dot_config/zsh/dot_zprofile" "$repo/dot_config/zsh/dot_zshrc"

python3 -c 'import json, sys; [json.load(open(path)) for path in sys.argv[1:]]' \
  "$repo/dot_claude/settings.json" "$repo/dot_codex/hooks.json"
python3 -c 'import sys; compile(open(sys.argv[1]).read(), sys.argv[1], "exec")' \
  "$repo/dot_agents/skills/pr-address-comments/scripts/fetch_comments.py"
home_path="/$(printf '%s' Users)/"
if /usr/bin/find "$repo" -type f ! -path "$repo/.git/*" ! -path "$repo/docs/legacy/*" \
  -exec /usr/bin/grep -q -F "$home_path" {} \; -print -quit | /usr/bin/grep -q .; then
  echo "found an absolute home-directory path in managed source" >&2
  exit 1
fi
for agent in claude codex; do
  for skill in pr-address-comments create-github-pull-request-from-specification; do
    test "$(cat "$repo/dot_$agent/skills/symlink_$skill")" = "../../.agents/skills/$skill"
  done
done
