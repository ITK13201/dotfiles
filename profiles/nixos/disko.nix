# ディスク設定 (disko)
# 再インストール時のパーティション構成を宣言的に管理する。
#
# 現在の構成 (/dev/sdb, 931.5G HDD):
#   sdb1  1G   vfat  /boot (EFI)
#   sdb2  80G  ext4  /
#   sdb3  800G ext4  /home
#   sdb4  50G  (未使用)
#
# 再インストール手順:
#   sudo nix run 'github:nix-community/disko/latest#disko-install' -- \
#     --flake '.#nixos' --disk main /dev/sdb
{ ... }:

{
  # 既存システムの fileSystems は hardware-configuration.nix で管理するため無効化
  disko.enableConfig = false;

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            root = {
              size = "80G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            home = {
              size = "800G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
            # sdb4 相当: 残り ~50G は未割り当てのまま
          };
        };
      };
    };
  };
}
