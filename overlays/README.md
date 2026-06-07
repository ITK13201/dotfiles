# overlays/

nixpkgs オーバーレイを管理する。

## 使い方

`default.nix` はオーバーレイのリストを返す。`flake.nix` の `nixpkgs.overlays` に渡す。

```nix
nixpkgs.overlays = import ./overlays;
```

## 構成

現在はオーバーレイなし（空リスト）。パッケージのカスタマイズが必要になったらここに追加する。
