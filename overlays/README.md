# overlays/

nixpkgs オーバーレイを管理する。

## 使い方

`default.nix` はオーバーレイのリストを返す。`nixos/settings/nix/nixpkgs.nix` の `nixpkgs.overlays` で読み込む。

```nix
nixpkgs.overlays = import ../../../overlays;
```

## 構成

| ファイル | 内容 |
|---|---|
| `1password-gui.nix` | 同梱の `chrome_crashpad_handler` に glib の rpath を設定（nixpkgs のパッケージングの漏れの回避策） |
