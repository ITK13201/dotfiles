# home-manager/

ユーザーランドの設定。NixOS module として統合する（スタンドアロン版は使わない）。

## 構成

```
home-manager/
├── common/        # 複数マシン共通の設定（シェル・エディタ・Git 等）
└── profiles/      # マシンごとのユーザー設定
    └── <hostname>/
        └── default.nix  # common/* を import して組み立てる
```

## 設計方針

- 共通設定は `common/` に切り出し、`profiles/` 側から import する
- `profiles/<hostname>/default.nix` にはマシン固有の差分だけ書く
- `flake.nix` の `specialArgs` 経由で `username` を受け取る
