# dotfiles

itk の NixOS 設定。Nix Flakes + Home Manager で管理する。

## 構成

```
dotfiles/
├── flake.nix              # Flake エントリーポイント
├── Makefile               # ビルド・デプロイショートカット
├── profiles/              # マシンごとの設定エントリーポイント
├── nixos/                 # NixOS モジュール群
├── home-manager/          # Home Manager モジュール群
├── config/                # Nix で管理しない設定ファイル（starship 等）
├── overlays/              # nixpkgs オーバーレイ
└── secrets/               # sops-nix 暗号化シークレット
```

各ディレクトリの詳細は配下の README.md を参照。

## ビルド・デプロイ

```bash
make build    # ビルド確認
make switch   # 適用

make update   # flake inputs を最新に更新
```

## 新規セットアップ

### 1. Nix のインストール

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. リポジトリのクローン

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
```

### 3. age キーの生成（sops-nix）

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
# 公開鍵を .sops.yaml に記入する
```

### 4. 1Password のセットアップ

1. 1Password をインストール・サインイン
2. **設定 → セキュリティ → SSH エージェントを使用** をオン
3. SSH 鍵を 1Password の「SSH Keys」カテゴリに登録

### 5. GPG 鍵のインポート（任意）

```bash
# バックアップから復元する場合
gpg --import gpg-public.asc
gpg --import gpg-secret.asc
```

### 6. 適用

```bash
make switch
```

## 開発環境（複数バージョン管理）

グローバルには Python・Go・Node.js のデフォルトバージョンのみインストールされている。
プロジェクトごとに異なるバージョンを使いたい場合は `devenv` + `direnv` を使う。

### セットアップ

```bash
cd ~/your-project
devenv init        # devenv.nix と .envrc を生成
echo "use devenv" > .envrc
direnv allow       # 以降は cd するだけで自動的に環境が切り替わる
```

### devenv.nix の例

```nix
{ pkgs, ... }: {
  languages.python = {
    enable = true;
    version = "3.11";
  };
  languages.go = {
    enable = true;
    version = "1.21";
  };
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
  };
}
```
