{ ... }:

{
  services.fwupd.enable = true;

  # 自動メタデータ更新は認証エラーになるため無効化
  systemd.timers.fwupd-refresh.enable = false;
}
