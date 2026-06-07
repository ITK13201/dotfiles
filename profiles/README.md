# profiles/

マシンごとの NixOS 設定エントリーポイント。

## 構成

```
profiles/
└── <hostname>/
    ├── default.nix                 # nixos/settings/* を import して組み立てる
    └── hardware-configuration.nix  # nixos-generate-config で自動生成
```

## 設計方針

- マシン固有の設定（ホスト名・ユーザー・stateVersion など）のみここに書く
- 再利用可能な設定は `nixos/settings/` のモジュールに切り出して import する

## hardware-configuration.nix

手書きしない。以下のコマンドで再生成する:

```bash
nixos-generate-config --show-hardware-config > profiles/<hostname>/hardware-configuration.nix
```

## 新しいマシンを追加する

1. `flake.nix` の `nixosConfigurations` に新エントリを追加
2. `profiles/<新hostname>/` を作成し `hardware-configuration.nix` を生成
3. `profiles/<新hostname>/default.nix` に必要なモジュールを import

## 現在のマシン

| hostname | 用途 | system |
|---|---|---|
| nixos | メイン PC (Intel, KDE Plasma 6) | x86_64-linux |
