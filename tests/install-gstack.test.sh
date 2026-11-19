#!/bin/sh
set -eu

repo=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT

mkdir -p "$test_dir/bin" "$test_dir/home/.claude/skills/gstack/.git"
printf '%s\n' '#!/bin/sh' 'printf "%s\\n" "{\\\"hooks\\\": {\\\"Stop\\\": [{\\\"_gstack_source\\\": \\\"gstack-timeline-stop\\\", \\\"hooks\\\": [{\\\"command\\\": \\\"$HOME/.claude/skills/gstack/hosts/claude/hooks/timeline-stop-hook\\\"}]}]}}" > "$HOME/.claude/settings.json"' > "$test_dir/home/.claude/skills/gstack/setup"
chmod +x "$test_dir/home/.claude/skills/gstack/setup"
cat > "$test_dir/bin/git" <<'EOF'
#!/bin/sh
if [ "$1" = "-C" ]; then
  shift 2
fi
case "$1" in
  remote) printf '%s\n' 'https://github.com/garrytan/gstack.git' ;;
  status|fetch|checkout|clone) exit 0 ;;
  *) exit 1 ;;
esac
EOF
chmod +x "$test_dir/bin/git"

HOME="$test_dir/home" PATH="$test_dir/bin:/usr/bin:/bin" CHEZMOI_SOURCE_DIR="$repo" \
  /bin/sh "$repo/assets/scripts/install-gstack.sh"

test -d "$test_dir/home/.local/share/gstack/.git"
test -L "$test_dir/home/.claude/skills/gstack"
test "$(/usr/bin/perl -e 'print readlink shift' "$test_dir/home/.claude/skills/gstack")" = "$test_dir/home/.local/share/gstack"
test "$(/usr/bin/perl -0ne 'print if /\$\{HOME\}/' "$test_dir/home/.claude/settings.json")" != ""
