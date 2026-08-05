# Agent Tooling Management Design

## Goal

Manage Claude Code and Codex skills and plugins from this dotfiles repository
without committing downloaded plugin caches, generated skill links, or
machine-specific Codex state.

The normal setup command must install the declared tooling on a new machine.
Updates must be explicit rather than a side effect of normal setup.

## Principles

- Git stores declarations and locally maintained skill sources.
- Official CLIs install and update third-party skills and plugins.
- Generated artifacts are not Stow inputs and are not committed.
- Codex hook trust remains an explicit per-machine decision.
- The workflow must not introduce a new package manager or configuration format.

## Repository Layout

`agents/skills-lock.json` remains the declaration for third-party skills
managed by `npx skills`.

`agents/.agents/skills/` contains only locally maintained skills. The existing
`pr-address-comments` skill remains here.

`agents/local-skills/` is removed. It is a duplicate, incomplete location and
is neither the canonical source nor an installation target.

`agents/.claude/skills/` and `agents/.codex/skills/` are removed from the
repository. They currently contain generated links, including a stale
`refactor` link. Stow does not observe `.gitignore`, so leaving them in the
package can deploy stale links even while Git ignores them.

The root `.gitignore` continues to exclude generated skill directories and the
machine-local `codex/.codex/config.toml`.

## Setup Flow

`make` remains the single normal setup command. After Stow has deployed the
tracked dotfiles, it runs an agent-tooling setup target that:

1. Restores third-party skills from `~/skills-lock.json` with `npx skills
   experimental_install --yes`.
2. Ensures the Ponytail marketplace and `ponytail@ponytail` plugin are present
   in Claude Code.
3. Ensures the same marketplace and plugin are present in Codex.
4. Creates the Claude Code and Codex links required for each locally maintained
   skill from `~/.agents/skills/`.

The setup command is idempotent: it first checks whether each marketplace,
plugin, and local-skill link is already present before adding it.

The commands for Ponytail remain the vendor-supported commands:

```sh
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
```

The implementation wraps these commands in a small shell script so the
Makefile stays readable and the checks are shared by setup and verification.

## Update Flow

Normal `make` does not update external content.

`make update-agents` is the only update entry point. It updates the declared
skills with `npx skills update`, refreshes the Ponytail marketplace through
each host CLI, and reinstalls the selected plugin revision when the host
requires it. A skills update that changes `agents/skills-lock.json` is
reviewed and committed.

Ponytail follows the revision supplied by its official marketplace. Its cache
is not vendored or pinned in this repository. This is the lowest-maintenance
choice; pinning requires a separate source checkout and manual compatibility
maintenance.

## Hooks And Local State

Claude Code persists plugin enablement in its tracked `settings.json`; this is
acceptable shared configuration and remains committed.

Codex persists marketplaces, plugin enablement, project trust, machine paths,
and hook trust hashes in `~/.codex/config.toml`. That file remains local-only.
On a new machine, setup installs Ponytail, then the user starts Codex and uses
`/hooks` to inspect and trust its hooks. This confirmation is deliberately not
automated or copied between machines.

Downloaded plugin caches under `~/.claude/plugins/` and `~/.codex/plugins/`
are host-managed state and remain untracked.

## Verification

The implementation is complete when:

1. `make agent-tooling` can run twice without changing the declared state or
   failing because Ponytail is already installed.
2. `claude plugin list` reports `ponytail@ponytail` enabled.
3. `codex plugin list` reports `ponytail@ponytail` installed and enabled.
4. `npx skills list --json` contains every skill declared in
   `agents/skills-lock.json`.
5. `~/.claude/skills/pr-address-comments` and
   `~/.codex/skills/pr-address-comments` resolve to the tracked local skill.
6. The repository no longer contains ignored `agents/.claude/skills/` or
   `agents/.codex/skills/` entries.
7. `git diff --check` passes and a clean checkout followed by `make` leaves
   only expected host-managed files outside the repository.
