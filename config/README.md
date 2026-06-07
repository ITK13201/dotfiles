# config/

Nix で直接管理しない設定ファイルを置く。
Home Manager の `builtins.readFile` や `xdg.configFile.source` で参照する。

## 構成

```
config/
└── starship/
    └── starship.toml   # starship プロンプト設定
```

## 方針

- このディレクトリ配下のファイルを編集するだけで設定を変更できる（`make switch` 不要な場合あり）
- ただし `builtins.readFile` 経由の場合は `make switch` が必要
