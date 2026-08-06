# AI Agent Tooling

この手順は AI が実行する。開始時にリポジトリルートで `repo="$(git rev-parse --show-toplevel)"` を実行する。以後の `$repo` はこの絶対パスを指す。既存のローカル設定、プラグイン、スキルを上書き・削除しない。判断不能な状態や衝突は変更せず報告する。

## 実行順序

- 新規マシン: `make` を実行してから「セットアップ」を実行する。
- 旧レイアウトからの移行: 初回の `make` **より前**、かつ `npx skills` の実行より前に、すべての「移行 preflight」を実行する。その後 `make`、続けて「セットアップ」を実行する。

## 移行 preflight

macOS では `readlink -f` を使わない。リンクと期待パスの両方を次で正規化してから、出力文字列の完全一致を比較する。

```sh
canonical_path() { perl -MCwd=abs_path -e 'my $path = abs_path(shift) // exit 1; print $path, chr 10' "$1"; }
actual="$(canonical_path "$path")"
expected="$(canonical_path "$repo/agents/.claude/skills")"
test "$actual" = "$expected"
```

次だけを変更する。

1. `~/.claude/skills` と `"$repo/agents/.claude/skills"`、`~/.codex/skills` と `"$repo/agents/.codex/skills"` の組を個別に扱う。まず旧ソースディレクトリの子を一覧・確認する。ホーム側の親がシンボリックリンクで解決先が対応する旧ソースと完全一致するときだけ、その**親リンクだけ**を `unlink` する。続けてホーム側に実ディレクトリを作成する。
2. 旧ソースは `$repo` 側のパスで引き続き参照する。子リンクの解決先が `"$repo/agents/.agents/skills"` 配下のものだけを削除する。残る無関係な子は、新しいホーム側実ディレクトリへ移動する。移動先に同名の項目があれば何も上書きせず衝突として報告し、その項目を移動しない。旧ソースディレクトリ自体は、すべての処理後に安全に空であることを確認できた場合だけ削除し、空でなければ残して報告する。
3. `~/.codex/config.toml` がシンボリックリンクで、解決先が `"$repo/codex/.codex/config.toml"` と完全一致する旧リンクだけを移行する。リンクを経由して直接コピーしない。まず `"$repo/codex/.codex/config.toml"` を `~/.codex` 内の一時ファイルへコピーし、成功を確認する。元リンクのターゲットを記録して同じディレクトリに退避リンクを作成してから、検証済みのホーム側リンクだけを `unlink` する。一時ファイルを `~/.codex/config.toml` へ同一ディレクトリ内で原子的に `mv` し、成功後に退避リンクを消す。最後に旧リポジトリ側の設定ファイルを削除する。検証、コピー、`unlink`、`mv` のいずれかが失敗したら、一時ファイルを消去し、`unlink` 済みなら退避リンクから元リンクを復元し、ホーム側リンクと旧ソースを変更前のまま残して報告する。通常ファイル、別のリンク、既存の非旧設定は変更しない。
4. `~/.agents` 自体がシンボリックリンクで、`canonical_path "$HOME/.agents"` が `canonical_path "$repo/agents/.agents"` と完全一致するときだけ移行する。最初に `"$repo/agents/.agents/skills"` の子を一覧し、`git -C "$repo" ls-files -- "agents/.agents/skills"` で追跡済みのソース項目を確認する。Git 追跡済みのローカルスキルは `$repo` 側に残し、Git 管理外の外部スキルだけを移動候補にする。すべての移動先衝突とバックアップ名の未使用を確認してから、元リンクの文字列ターゲットを記録し、同じ `$HOME` 内にそのターゲットを指すバックアップリンクを作る。この作成に失敗したら `~/.agents` を `unlink` しない。次に検証済みのホーム側親リンクだけを `unlink` し、実ディレクトリの `$HOME/.agents/skills` を作成して、衝突のない外部スキルを移動する。mkdir または移動が失敗した場合は、移動済みの項目をソース側へ上書きなしで戻し、新規作成した移動先の項目と空ディレクトリだけを削除して、バックアップリンクを `$HOME/.agents` に戻す。戻せない項目または削除できない新規状態があれば上書き・削除を続けず、バックアップとリポジトリソースを保持して部分移行として報告する。すべて成功した場合だけバックアップリンクを削除する。

親リンク、子リンク、設定リンクのいずれも、上記の解決先に一致しなければ変更しない。移行した項目、未変更の項目、衝突を報告する。

## セットアップ

リポジトリの `$repo/agents/.agents/skills` はローカル管理スキルのソースであり、Stow で配布しない。`$HOME/.agents/skills` だけが `npx skills` の管理するマシンローカルの外部スキル内容である。`$repo/agents/skills-lock.json` は追跡済みの宣言 lockfile であり、`make` が Stow を通じて `~/skills-lock.json` として配布する。

1. `~/.codex/config.toml` が存在せず、かつリンクでもない場合だけ、次を実行する。存在する場合はコピーしない。

   ```sh
   cp "$repo/codex/.codex/config.toml.example" "$HOME/.codex/config.toml"
   ```
2. `make` 後に Stow が配布した `~/skills-lock.json` を使い、ホームディレクトリで mise 管理の Node により外部スキルを導入する。

   ```sh
   (cd "$HOME" && mise exec -- npx skills experimental_install --yes)
   ```

3. ローカルリンクの前に `~/.claude/skills` と `~/.codex/skills` を個別に確認する。パスがない場合だけ `mkdir "$HOME/.claude/skills"` または `mkdir "$HOME/.codex/skills"` を実行する。実ディレクトリなら続行する。シンボリックリンクまたは非ディレクトリなら報告して停止する。
4. `$repo/agents/.agents/skills/*/SKILL.md` を探索する。各 `<name>` について `~/.claude/skills/<name>` と `~/.codex/skills/<name>` を確認し、存在しない場合だけターゲット `"$repo/agents/.agents/skills/<name>"` のリンクを作成する。既存のリンクは `actual="$(canonical_path "$path")"` と `expected="$(canonical_path "$repo/agents/.agents/skills/<name>")"` が完全一致する場合だけ維持する。したがって、同じ先を指す絶対リンクや別の相対リンクも維持する。既存の非リンクまたは解決先が異なるリンクは置換しないで報告する。
5. Ponytail の現在の marketplace とプラグイン状態を、変更前に読取専用で確認する。

   ```sh
   claude plugin marketplace list --json
   claude plugin list --json
   codex plugin marketplace list --json
   codex plugin list --json
   ```

   未登録なら `DietrichGebert/ponytail` を marketplace に追加し、未導入なら `ponytail@ponytail` を導入し、有効であることを確認する。必要な場合だけ次を実行する。

   ```sh
   claude plugin marketplace add DietrichGebert/ponytail
   claude plugin install ponytail@ponytail
   claude plugin enable ponytail@ponytail

   codex plugin marketplace add DietrichGebert/ponytail
   codex plugin add ponytail@ponytail
   ```

   `claude plugin enable` は無効時だけ実行する。Codex は `codex plugin add` で導入済みかつ利用可能であることを `codex plugin list` で確認する。Ponytail を初回導入または更新した後は Codex を起動し、`/hooks` をユーザーにレビュー・承認してもらう。承認を代行しない。
6. RTK は Brewfile と Stow が所有する。再導入や再設定をせず、`rtk` が利用可能であり、stow 済みの Claude/Codex の RTK 指示とネイティブ Claude hook 設定が存在することだけを確認する。

## 更新

外部スキルは必要時に次を実行する。更新により宣言済みの `$repo/agents/skills-lock.json`（Stow 配布先は `~/skills-lock.json`）が変わることを確認し、その差分を報告する。

```sh
(cd "$HOME" && mise exec -- npx skills update --yes)
claude plugin update ponytail@ponytail
codex plugin marketplace upgrade ponytail
codex plugin add ponytail@ponytail
```

更新後も Codex の `/hooks` はユーザーに再レビューしてもらう。

## 検証

```sh
command -v rtk
test -f ~/.claude/RTK.md
test -f ~/.codex/RTK.md
rg -F '"command": "rtk hook claude"' ~/.claude/settings.json
rg -F '@RTK.md' ~/.claude/CLAUDE.md ~/.codex/AGENTS.md
find "$repo/agents/.agents/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print
claude plugin list
codex plugin marketplace list
codex plugin list
git diff --check
```

各ローカルスキルのリンク先、設定の非上書き、移行時の衝突、Ponytail の状態、Codex `/hooks` のレビュー待ちを最終報告に含める。
