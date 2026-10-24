# config/

Nix で直接管理しない設定ファイルを置く。
Home Manager の `builtins.readFile` や `xdg.configFile.source` で参照する。

## 構成

```
config/
├── hypr/
│   ├── hyprland.lua    # Hyprland 設定（Lua）
│   └── wallpapers/
│       └── cheatsheet-portrait.jpg  # 縦向きモニター用壁紙（キーバインド一覧付き）
├── starship/
│   └── starship.toml   # starship プロンプト設定
└── waybar/
    └── style.css       # waybar スタイル（Tokyo Night）
```

## 方針

- このディレクトリ配下のファイルを編集するだけで設定を変更できる（`make switch` 不要な場合あり）
- ただし `builtins.readFile` 経由の場合は `make switch` が必要
