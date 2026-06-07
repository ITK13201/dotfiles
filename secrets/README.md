# secrets/

sops-nix で暗号化した秘密情報を管理するディレクトリ。
暗号化済みファイルのみ Git に含める。

## 初期セットアップ

age キーを生成し、公開鍵を `../.sops.yaml` に登録する:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
# 出力された "# public key: age1..." を .sops.yaml の該当箇所に記入
```

## シークレットの追加

```bash
# 新規作成・編集（自動で暗号化される）
sops secrets/secrets.yaml
```

## NixOS 設定からの参照

```nix
# nixos/settings/misc/sops.nix にシークレットを宣言
sops.secrets.my_secret = {};

# 参照先: /run/secrets/my_secret（nixos-rebuild 時に復号される）
config.sops.secrets.my_secret.path
```

## 注意

- `keys.txt`（秘密鍵）は Git に含めない。マシンごとに生成して手動で保管する
- 新しいマシンを追加する場合は `.sops.yaml` にそのマシンの公開鍵を追加し、`sops updatekeys secrets/secrets.yaml` で再暗号化する
