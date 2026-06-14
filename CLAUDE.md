# dotfiles

itk の NixOS 設定。Nix Flakes + Home Manager で管理する。

Home Manager は NixOS 統合モードで動作する (`home-manager switch` は使わない)。
シークレットは sops-nix (age 暗号化) で管理する。詳細は `secrets/README.md` 参照。
`nixpkgs-stable` (26.05) は `pkgs-stable` として `specialArgs` 経由で参照できる。`pkgs-stable` と `system` は NixOS モジュールのみアクセス可能（Home Manager の `extraSpecialArgs` には `inputs` と `username` のみ渡される）。

## Flake Inputs

| input | 用途 |
|---|---|
| `nixpkgs` | NixOS unstable（メイン） |
| `nixpkgs-stable` | 26.05（独立管理） |
| `home-manager` | Home Manager |
| `sops-nix` | シークレット管理 |
| `treefmt-nix` | nixfmt フォーマッター設定 |
| `git-hooks` | pre-commit hook（nixfmt） |
| `disko` | 宣言的ディスク構成（未実装） |

## ドキュメント

各ディレクトリの役割・設計方針は README.md に記載している。

| ディレクトリ | README |
|---|---|
| `profiles/` | [profiles/README.md](profiles/README.md) |
| `nixos/` | [nixos/README.md](nixos/README.md) |
| `home-manager/` | [home-manager/README.md](home-manager/README.md) |
| `secrets/` | [secrets/README.md](secrets/README.md) |
| `config/` | [config/README.md](config/README.md) |
| `overlays/` | [overlays/README.md](overlays/README.md) |

## モジュール分割の原則

`nixos/settings/` 配下のモジュールは以下の原則で分割する。

- **1ファイル = 1つのトップレベルオプション名前空間**
  - `programs.*` だけを扱うファイル、`environment.*` だけを扱うファイル、のように混在させない
  - 例: `security.rtkit` は `pipewire.nix` に書かず `security.nix` に分離する
  - 例: `nixpkgs.config` は `nix.nix` に書かず `nixpkgs.nix` に分離する
- **機能的に密結合していても名前空間が違えば分ける**
  - 「PipeWire に必要だから」という理由で `security.*` を `pipewire.nix` に書かない
  - どのモジュールが何のオプションを担当しているか、ファイルを見ただけで分かるようにする
- **`environment.systemPackages` は `system/environment.nix` に集約する**
  - 各 misc モジュールがパッケージを個別に追加しない

## パッケージの置き場所

| 種別 | 置き場所 |
|---|---|
| CLI ツール | `home-manager/common/cli/default.nix`（`home.packages`） |
| デスクトップアプリ・システムツール | `nixos/settings/system/environment.nix`（`environment.systemPackages`） |
| Nix で管理しない設定ファイル | `config/`（`builtins.readFile` または `xdg.configFile.source` で参照） |

`home.file` に `force = true` が設定されているファイル（例: `~/.claude/`）は `make switch` で上書きされる。変更は `config/claude/` を編集して行う。

## コミット署名

コミットは 1Password SSH エージェント（`op-ssh-sign`）で自動署名される。許可署名者は `config/ssh/allowed_signers` で管理する。

## コミットメッセージ規則

Conventional Commits 形式を使う。

```
<type>: <概要>
```

| type | 用途 |
|---|---|
| `feat` | 新機能・新モジュールの追加 |
| `fix` | 設定ミスや不具合の修正 |
| `chore` | ビルド・ツール・ドキュメントなどの雑務 |
| `refactor` | 機能変更を伴わない構造変更 |
| `docs` | ドキュメントのみの変更 |

## ビルド・デプロイ

```bash
make eval     # 評価のみ（ビルドなし）
make build    # ビルド確認のみ
make switch   # ビルド + 適用
make fmt      # .nix ファイルのフォーマット
make update   # flake inputs を更新
make clean-store  # ガベージコレクション（フル）
make clean-oldgen # ガベージコレクション（旧世代のみ）

# 特定のホスト名を指定する場合
make nixos-eval-<hostname>
make nixos-build-<hostname>
make nixos-<hostname>
```

`nix develop` で devShell に入ると git pre-commit hook が有効化され、コミット時に nixfmt が自動実行される。
