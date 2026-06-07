# dotfiles

itk の NixOS 設定。Nix Flakes + Home Manager で管理する。

## ドキュメント

各ディレクトリの役割・設計方針は README.md に記載している。

| ディレクトリ | README |
|---|---|
| `profiles/` | [profiles/README.md](profiles/README.md) |
| `nixos/` | [nixos/README.md](nixos/README.md) |
| `home-manager/` | [home-manager/README.md](home-manager/README.md) |
| `secrets/` | [secrets/README.md](secrets/README.md) |

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
# ビルド確認のみ
sudo nixos-rebuild build --flake ".#<hostname>"

# 適用
sudo nixos-rebuild switch --flake ".#<hostname>"
```
