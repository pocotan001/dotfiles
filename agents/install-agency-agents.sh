#!/bin/sh
set -eu

repo_dir=${AGENCY_AGENTS_DIR:-"$HOME/.local/share/agency-agents"}
repo_url=https://github.com/msitarzewski/agency-agents.git

if [ -e "$repo_dir" ] || [ -L "$repo_dir" ]; then
  if [ ! -d "$repo_dir/.git" ] || [ "$(git -C "$repo_dir" remote get-url origin)" != "$repo_url" ]; then
    echo "expected Agency Agents repository: $repo_dir" >&2
    exit 1
  fi
  git -C "$repo_dir" fetch origin main
  git -C "$repo_dir" checkout main
  git -C "$repo_dir" pull --ff-only origin main
else
  mkdir -p "$(dirname "$repo_dir")"
  git clone "$repo_url" "$repo_dir"
fi

"$repo_dir/scripts/convert.sh" --tool codex
"$repo_dir/scripts/install.sh" --tool codex --link --no-interactive --no-convert
