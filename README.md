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

`codex/.codex/config.toml` is local-only because Codex writes machine-specific
paths and state into it. Shared defaults live in
`codex/.codex/config.toml.example`; `make` copies it on first setup.

## AI Agent Skills

エージェントスキルは [npx skills](https://skills.sh) で管理しています。

### スキルの追加

```sh
cd ~
npx skills add <source>
```

### スキルの削除

```sh
cd ~
npx skills remove <name>
```
