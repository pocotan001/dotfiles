#!/bin/sh
set -eu

source="$HOME/.local/share/dotfiles/skills/pr-address-comments"

test -f "$source/SKILL.md"

link_skill() {
  skills_dir="$HOME/.$1/skills"
  link="$skills_dir/pr-address-comments"

  mkdir -p "$skills_dir"
  if [ -L "$link" ]; then
    target=$(/usr/bin/perl -e 'print readlink shift' "$link")
    if [ "$target" = "$source" ]; then
      return
    fi
    case "$target" in
      */agents/.agents/skills/pr-address-comments) rm "$link" ;;
      *) echo "refusing to replace existing skill: $link" >&2; exit 1 ;;
    esac
  elif [ -e "$link" ]; then
    echo "refusing to replace existing skill: $link" >&2
    exit 1
  fi

  ln -s "$source" "$link"
}

link_skill claude
link_skill codex
