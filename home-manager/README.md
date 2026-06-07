# home-manager/

ユーザーランドの設定。NixOS module として統合する（スタンドアロン版は使わない）。

## 構成

```
home-manager/
├── common/        # 複数マシン共通の設定（シェル・エディタ・Git 等）
│   ├── cli/
│   │   ├── default.nix   # bat, fzf, zoxide, btop, eza, fd, ripgrep, jq, duf, dust
│   │   ├── ssh/          # SSH クライアント設定（1Password SSH エージェント）
│   │   └── gpg/          # GPG エージェント（pinentry-qt）
│   ├── editor/
│   │   └── vscode/       # VSCode 設定
│   ├── git/              # git 設定
│   ├── nix/              # direnv + nix-direnv
│   └── shell/
│       ├── starship/     # starship プロンプト（Tokyo Night）
│       ├── tmux/         # tmux（vi モード・C-a prefix）
│       └── zsh/          # zsh + vi-mode + fzf-tab + fuzzy 履歴
├── linux/         # Linux 固有の設定（XDG 等）
├── desktop/       # デスクトップアプリ固有の設定
└── profiles/      # マシンごとのユーザー設定
    └── <hostname>/
        └── default.nix  # common/ + linux/ + desktop/ を import して組み立てる
```

## 設計方針

- 共通設定は `common/` に切り出し、`profiles/` 側から import する
- `profiles/<hostname>/default.nix` にはマシン固有の差分だけ書く
- `flake.nix` の `specialArgs` 経由で `username` を受け取る
