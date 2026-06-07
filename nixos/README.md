# nixos/

マシン非依存の再利用可能な NixOS モジュール群。
`profiles/<hostname>/default.nix` から必要なものを import して使う。

## settings/ の構成

| ディレクトリ | 役割 |
|---|---|
| `boot/` | ブートローダー設定（systemd-boot, LUKS, Secure Boot 等） |
| `system/` | OS 基盤（ロケール・タイムゾーン・日本語入力・ネットワーク） |
| `nix/` | Nix デーモン設定（experimental-features, GC, allowUnfree） |
| `desktop/` | デスクトップ環境（KDE Plasma, Hyprland, PipeWire 等） |
| `display/` | ディスプレイマネージャー（SDDM, GDM 等） |
| `misc/` | その他ツール・サービス（1Password, cups, SSH 等） |

## モジュールの追加方針

- 1 ファイル = 1 機能を原則とする
- `specialArgs` 経由で `username`, `system` を受け取れる
- マシン固有の値（ホスト名等）はモジュールに書かず `profiles/` 側に置く
