#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

HOME="$test_dir/home" DOTFILES_ROOT="$repo" "$repo/agents/link-local-skills.sh"
HOME="$test_dir/home" DOTFILES_ROOT="$repo" "$repo/agents/link-local-skills.sh"

source_path=$(perl -MCwd=abs_path -e 'print abs_path(shift), "\n"' "$repo/agents/.agents/skills/pr-address-comments")
for agent in claude codex; do
  link="$test_dir/home/.$agent/skills/pr-address-comments"
  test -L "$link"
  test "$(perl -MCwd=abs_path -e 'print abs_path(shift), "\n"' "$link")" = "$source_path"
done
