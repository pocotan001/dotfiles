# Dotfiles

Clone this repository

```sh
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

[Install Homebrew](https://brew.sh/)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Run the following command

```sh
make
```

## Codex config

`codex/.codex/config.toml.example` is stowed as the shared Codex configuration
template. Tooling setup copies it directly to `~/.codex/config.toml` only when
that path does not exist and is not a symlink. This repository never stores
local Codex configuration.

## Agent Tooling

`make` installs the machine bootstrap: Homebrew packages, Stow-managed
configuration, mise runtimes, repository-local skills, and the latest
[Agency Agents](https://github.com/msitarzewski/agency-agents) Codex agents.
Agency Agents is installed with its official conversion and `--link` install
scripts from `~/.local/share/agency-agents`; rerunning `make` updates it from
the `main` branch.

On a new machine, run `make`, then ask an AI to follow
`agents/AGENT_TOOLING.md` to install or update externally managed skills and
Ponytail. On an existing machine upgrading from the legacy layout, ask an AI to
run the guide's migration preflight before the first `make`, then run `make` and
continue with the guide's setup. Repository-local skills live in
`agents/.agents/skills` and are linked by `make`.

RTK is installed through `Brewfile`; its Claude hook and Claude/Codex
instructions are stowed from this repository, so `make` restores its
integration. RTK history, tee logs, and telemetry consent stay local to each
machine.

After a Ponytail change, Codex `/hooks` requires user review.
