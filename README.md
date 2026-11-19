# Dotfiles

This repository is a [chezmoi](https://www.chezmoi.io/) source directory for
macOS. It restores the shared shell, Git, mise, terminal, Claude, Codex, and
agent-tooling configuration. Credentials, app data, caches, histories, and
machine-local Codex state are deliberately not versioned.

## New machine

```sh
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply pocotan001
```

The command installs chezmoi, clones this repository, installs Homebrew when
needed, then restores the declared packages and configuration. The Homebrew
installer can require Xcode Command Line Tools and an administrator password.

## Daily use

```sh
chezmoi update
chezmoi diff
```

`chezmoi update` only installs missing Brewfile entries; it does not upgrade
installed packages. Use `sh script/update` when you intentionally want
upgrades. It also imports an updated `skills-lock.json` into this source
directory for review and commit.

## Agent tooling

The repository owns the local `pr-address-comments` and
`create-github-pull-request-from-specification` skills. They are managed
directly in `~/.agents/skills`, with chezmoi-managed agent-specific links.
Third-party skills come from `skills-lock.json` and are linked to both agents.
Agency Agents is installed at the revision in
`assets/agents/`, not from a moving branch. Ponytail is installed through the
vendor CLIs.

After Ponytail is installed or updated, review its hooks in Codex with
`/hooks`; hook trust is intentionally a per-machine decision.

## Verification

```sh
tests/verify-source.sh
chezmoi doctor
brew bundle check --no-upgrade --file "$(chezmoi source-path)/assets/Brewfile"
chezmoi diff
```
