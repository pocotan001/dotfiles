# Agent Tooling Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Make `make` reproducibly install declared Claude Code and Codex skills and Ponytail without tracking generated artifacts or machine-local Codex state.

**Architecture:** Add one Bash bootstrap script with `prepare`, `setup`, and `update` operations. `prepare` migrates the old Stow-managed state before Stow runs; `setup` restores skills, installs Ponytail only when absent, and links local skills. The Makefile orchestrates these operations, while a shell test uses a temporary `HOME` and mocked host CLIs to prove the script is idempotent.

**Tech Stack:** GNU Stow, Bash, `npx skills`, Claude Code CLI, Codex CLI, Make.

---

### Task 1: Add a failing bootstrap test harness

**Files:**
- Create: `tests/agent-tooling.test.sh`
- Create: `agents/tooling.sh`

**Step 1: Write the failing test**

Create `tests/agent-tooling.test.sh` as an executable Bash script with
`set -euo pipefail`. It must create a temporary repository fixture and a
temporary `HOME`, then remove both with a `trap`.

The fixture must contain:

```text
agents/.agents/skills/pr-address-comments/SKILL.md
agents/.claude/skills/pr-address-comments -> ../../.agents/skills/pr-address-comments
agents/.claude/skills/refactor -> ../../.agents/skills/refactor
agents/.codex/skills/pr-address-comments -> ../../.agents/skills/pr-address-comments
codex/.codex/config.toml
codex/.codex/config.toml.example
```

Create mock `npx`, `claude`, and `codex` executables ahead of the system
`PATH`. Each mock appends its arguments to `$CALL_LOG`. The `list` commands
must initially report no Ponytail marketplace or plugin, then report it after
the matching add/install command creates a marker file under `$HOME`.

The test must call:

```bash
HOME="$test_home" DOTFILES_ROOT="$fixture" PATH="$mock_bin:$PATH" \
  "$fixture/agents/tooling.sh" prepare
HOME="$test_home" DOTFILES_ROOT="$fixture" PATH="$mock_bin:$PATH" \
  "$fixture/agents/tooling.sh" setup
```

Assert all of the following:

```bash
test ! -e "$fixture/agents/.claude/skills/refactor"
test ! -e "$fixture/agents/.codex/skills/pr-address-comments"
test -f "$test_home/.codex/config.toml"
test -L "$test_home/.claude/skills/pr-address-comments"
test -L "$test_home/.codex/skills/pr-address-comments"
grep -Fx 'skills experimental_install --yes' "$CALL_LOG"
grep -Fx 'plugin marketplace add DietrichGebert/ponytail' "$CLAUDE_CALL_LOG"
grep -Fx 'plugin add ponytail@ponytail' "$CODEX_CALL_LOG"
```

Call `setup` a second time and assert that it does not append a second
marketplace-add or plugin-install command. Add a distinct unrelated file in
`$HOME/.claude/skills/` before migration and assert that it remains untouched.

**Step 2: Run the test to verify it fails**

Run:

```bash
bash tests/agent-tooling.test.sh
```

Expected: FAIL because `agents/tooling.sh` does not exist.

**Step 3: Commit the failing test**

```bash
git add tests/agent-tooling.test.sh
git commit -m "test(agents): cover tooling bootstrap"
```

### Task 2: Implement safe state migration and setup

**Files:**
- Modify: `agents/tooling.sh`
- Test: `tests/agent-tooling.test.sh`

**Step 1: Implement script structure**

Implement `agents/tooling.sh` as Bash with `set -euo pipefail`. Resolve the
repository root from `DOTFILES_ROOT` when set, otherwise from the parent of the
script directory:

```bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
root="${DOTFILES_ROOT:-$(cd "$script_dir/.." && pwd -P)}"
```

Require exactly one operation: `prepare`, `setup`, or `update`. Reject any
other argument with a nonzero exit status and usage text.

**Step 2: Implement `prepare`**

Implement a helper that removes a candidate only when it is a symlink whose
first-hop destination is under the expected legacy parent. For a relative
first-hop target, normalize it lexically with Node's `path.resolve` against
the candidate's directory; do not dereference the symlink's final component.

Apply it only to these paths:

```bash
"$HOME/.claude/skills/pr-address-comments"
"$HOME/.claude/skills/refactor"
"$HOME/.codex/skills/pr-address-comments"
```

Then remove the known legacy links inside `$root/agents/.claude/skills` and
`$root/agents/.codex/skills`, followed by empty parent directories only.

Migrate the old local Codex config before Stow can read it: when
`$root/codex/.codex/config.toml` exists, copy its contents to a temporary file
under `$HOME/.codex`, remove the repository-local file, and atomically replace
`$HOME/.codex/config.toml` with the temporary file. Do not overwrite a
non-legacy home config; emit a clear error instead.

**Step 3: Implement `setup`**

Ensure the home Codex config exists without overwriting it:

```bash
test -f "$HOME/.codex/config.toml" || \
  cp "$HOME/.codex/config.toml.example" "$HOME/.codex/config.toml"
```

Restore declared skills exactly once per invocation:

```bash
(cd "$HOME" && npx skills experimental_install --yes)
```

Use the current list output to avoid duplicate native plugin commands:

```bash
claude plugin marketplace list
claude plugin list
codex plugin marketplace list
codex plugin list
```

When Ponytail is absent, run the official commands:

```bash
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
```

Finally, create direct relative links from `~/.claude/skills/` and
`~/.codex/skills/` to `~/.agents/skills/pr-address-comments`. If a destination
already exists but is not the expected link, fail with its path instead of
replacing it.

**Step 4: Implement `update`**

Run the approved explicit update sequence:

```bash
(cd "$HOME" && npx skills update --yes)
claude plugin marketplace update ponytail
claude plugin install ponytail@ponytail
codex plugin marketplace upgrade ponytail
codex plugin add ponytail@ponytail
```

Print a final Codex reminder that changed Ponytail hooks require review in
`/hooks`; do not bypass or persist hook trust.

**Step 5: Run the test to verify it passes**

Run:

```bash
bash tests/agent-tooling.test.sh
bash -n agents/tooling.sh
```

Expected: both commands exit 0.

**Step 6: Commit the implementation**

```bash
git add agents/tooling.sh tests/agent-tooling.test.sh
git commit -m "feat(agents): bootstrap skills and plugins"
```

### Task 3: Make Stow orchestration declarative

**Files:**
- Modify: `Makefile`
- Delete: `agents/local-skills/`
- Delete: `agents/.claude/skills/pr-address-comments`
- Delete: `agents/.claude/skills/refactor`
- Delete: `agents/.codex/skills/pr-address-comments`
- Delete: `codex/.codex/config.toml`
- Test: `tests/agent-tooling.test.sh`

**Step 1: Extend the test for Makefile ordering**

Add an assertion that `prepare` is called before Stow and `setup` after Stow.
Use a mock `stow` executable that records its invocation, then compare call-log
line numbers with `awk`.

**Step 2: Update Makefile targets**

Replace the monolithic `all` recipe with `.PHONY` targets named `all`,
`agent-tooling`, and `update-agents`.

`all` must run the current Homebrew setup, invoke
`$(CURDIR)/agents/tooling.sh prepare`, run Stow, run the existing `mise`
installation, then invoke `$(MAKE) agent-tooling`.

`agent-tooling` must invoke:

```make
$(CURDIR)/agents/tooling.sh setup
```

`update-agents` must invoke:

```make
$(CURDIR)/agents/tooling.sh update
```

Use `$(CURDIR)` rather than a relative script path so `make -C` works.

**Step 3: Remove generated Stow inputs**

Remove `agents/local-skills/`, the ignored `agents/.claude/skills/` and
`agents/.codex/skills/` trees, and the ignored
`codex/.codex/config.toml`. Keep `agents/.agents/skills/pr-address-comments/`
and `codex/.codex/config.toml.example`.

**Step 4: Run tests**

Run:

```bash
bash tests/agent-tooling.test.sh
make -n all
make -n agent-tooling
make -n update-agents
```

Expected: the shell test passes; dry runs show `prepare` before `stow` and
`setup` after it; no dry run references
`codex/.codex/config.toml` inside the repository.

**Step 5: Commit the orchestration change**

```bash
git add Makefile agents codex
git commit -m "refactor(agents): remove generated Stow inputs"
```

### Task 4: Document the user workflow and commit shared Claude state

**Files:**
- Modify: `README.md`
- Modify: `claude/.claude/settings.json`
- Test: `tests/agent-tooling.test.sh`

**Step 1: Update README**

Replace the current skills-only section with an "Agent Tooling" section that
states:

- `make` installs all declared skills and Ponytail for Claude Code and Codex.
- `make update-agents` is the explicit external-content update command.
- `agents/skills-lock.json` is committed when third-party skills change.
- locally maintained skills live in `agents/.agents/skills/`.
- Codex requires a first-run `/hooks` review after Ponytail installation or a
  hook update.

Update the Codex config paragraph to say the template is copied directly to
`~/.codex/config.toml` after Stow and is never stored in the repository.

**Step 2: Preserve shared Claude plugin declaration**

Keep the Ponytail marketplace and enabled-plugin entry in
`claude/.claude/settings.json`. Confirm the change contains only the Ponytail
entry and does not reformat unrelated settings.

**Step 3: Run final verification**

Run:

```bash
bash tests/agent-tooling.test.sh
bash -n agents/tooling.sh
git diff --check
claude plugin list | rg -A3 -B1 'ponytail@ponytail'
codex plugin list | rg 'ponytail@ponytail'
(cd "$HOME" && npx skills list --json)
```

Expected: all checks pass; both plugin list commands report Ponytail enabled;
the skills list is valid JSON.

**Step 4: Commit documentation and configuration**

```bash
git add README.md claude/.claude/settings.json
git commit -m "docs(agents): document tooling workflow"
```
