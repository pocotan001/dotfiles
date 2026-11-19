#!/bin/sh
set -eu

source_dir=${CHEZMOI_SOURCE_DIR:-"$HOME/.local/share/chezmoi"}
lock="$source_dir/assets/agents/agency-agents.lock"
repository=$(sed -n 's/^repository=//p' "$lock")
revision=$(sed -n 's/^revision=//p' "$lock")
target="$HOME/.local/share/agency-agents"

test "$repository" = "https://github.com/msitarzewski/agency-agents.git"
test "${#revision}" -eq 40
case "$revision" in *[!0123456789abcdef]*) exit 1 ;; esac

if [ -e "$target" ] || [ -L "$target" ]; then
  test -d "$target/.git"
  test "$(git -C "$target" remote get-url origin)" = "$repository"
  test -z "$(git -C "$target" status --porcelain)"
else
  mkdir -p "$(dirname "$target")"
  git clone "$repository" "$target"
fi

git -C "$target" fetch --depth=1 origin "$revision"
git -C "$target" checkout --detach "$revision"
"$target/scripts/convert.sh" --tool codex
"$target/scripts/install.sh" --tool codex --link --no-interactive --no-convert
