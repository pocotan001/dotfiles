#!/bin/sh
set -eu

source_dir=${CHEZMOI_SOURCE_DIR:-"$HOME/.local/share/chezmoi"}
lock="$source_dir/assets/agents/gstack.lock"
repository=$(sed -n 's/^repository=//p' "$lock")
revision=$(sed -n 's/^revision=//p' "$lock")
target="$HOME/.local/share/gstack"
link="$HOME/.claude/skills/gstack"

test "$repository" = "https://github.com/garrytan/gstack.git"
test "${#revision}" -eq 40
case "$revision" in *[!0123456789abcdef]*) exit 1 ;; esac

if [ ! -e "$target" ] && [ ! -L "$target" ] && [ -d "$link" ] && [ ! -L "$link" ]; then
  test -d "$link/.git"
  test "$(git -C "$link" remote get-url origin)" = "$repository"
  test -z "$(git -C "$link" status --porcelain)"
  mkdir -p "$(dirname "$target")"
  mv "$link" "$target"
fi

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
"$target/setup"

# gstack writes an absolute home-directory path; keep the managed config portable.
settings="$HOME/.claude/settings.json"
gstack_hook="$HOME/.claude/skills/gstack/hosts/claude/hooks/timeline-stop-hook"
portable_gstack_hook='if [ -n "${HOME-}" ] && [ -x "${HOME}/.claude/skills/gstack/hosts/claude/hooks/timeline-stop-hook" ]; then "${HOME}/.claude/skills/gstack/hosts/claude/hooks/timeline-stop-hook"; fi'
if [ -f "$settings" ]; then
  GSTACK_HOOK="$gstack_hook" PORTABLE_GSTACK_HOOK="$portable_gstack_hook" \
    /usr/bin/perl -0pi -e 's/\Q$ENV{GSTACK_HOOK}\E/$ENV{PORTABLE_GSTACK_HOOK}/g' "$settings"
fi

mkdir -p "$(dirname "$link")"
if [ -L "$link" ]; then
  current=$(/usr/bin/perl -e 'print readlink shift' "$link")
  test "$current" = "$target"
elif [ -e "$link" ]; then
  echo "refusing to replace existing gstack skill: $link" >&2
  exit 1
fi
if [ ! -e "$link" ] && [ ! -L "$link" ]; then
  ln -s "$target" "$link"
fi
