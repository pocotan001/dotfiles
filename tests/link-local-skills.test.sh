#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

mkdir -p "$test_dir/home/.local/share/dotfiles"
ln -s "$repo/dot_local/share/dotfiles/skills" "$test_dir/home/.local/share/dotfiles/skills"
HOME="$test_dir/home" /bin/sh "$repo/assets/scripts/link-local-skills.sh"

for agent in claude codex; do
  link="$test_dir/home/.$agent/skills/pr-address-comments"
  test -L "$link"
  test "$(/usr/bin/perl -e 'print readlink shift' "$link")" = "$test_dir/home/.local/share/dotfiles/skills/pr-address-comments"
done

rm "$test_dir/home/.claude/skills/pr-address-comments"
ln -s "$test_dir/legacy/agents/.agents/skills/pr-address-comments" "$test_dir/home/.claude/skills/pr-address-comments"
HOME="$test_dir/home" /bin/sh "$repo/assets/scripts/link-local-skills.sh"
test "$(/usr/bin/perl -e 'print readlink shift' "$test_dir/home/.claude/skills/pr-address-comments")" = "$test_dir/home/.local/share/dotfiles/skills/pr-address-comments"
