#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
repo=${DOTFILES_ROOT:-${CONDUCTOR_ROOT_PATH:-$(dirname "$script_dir")}}
source_dir="$repo/agents/.agents/skills"

if [ ! -f "$source_dir/pr-address-comments/SKILL.md" ]; then
  echo "missing local skill source: $source_dir/pr-address-comments" >&2
  exit 1
fi

canonical_path() {
  perl -MCwd=abs_path -e 'my $path = abs_path(shift) // exit 1; print $path, "\n"' "$1"
}

source_path=$(canonical_path "$source_dir/pr-address-comments")

for agent in claude codex; do
  skills_dir="$HOME/.$agent/skills"
  link="$skills_dir/pr-address-comments"

  if [ -e "$skills_dir" ] || [ -L "$skills_dir" ]; then
    if [ ! -d "$skills_dir" ] || [ -L "$skills_dir" ]; then
      echo "expected directory: $skills_dir" >&2
      exit 1
    fi
  else
    mkdir -p "$skills_dir"
  fi

  if [ -e "$link" ] || [ -L "$link" ]; then
    if [ -L "$link" ] && [ "$(canonical_path "$link")" = "$source_path" ]; then
      continue
    fi
    echo "refusing to replace existing skill: $link" >&2
    exit 1
  fi

  ln -s "$source_path" "$link"
done
