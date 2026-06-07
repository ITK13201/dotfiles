# ディスク設定 (disko)
# 再インストール時のパーティション構成を宣言的に管理する。
#
# 現在の構成 (/dev/sdb, 931.5G HDD):
#   sdb1  1G   vfat  /boot        (LABEL: NIX-BOOT)
#   sdb2  80G  ext4  /            (LABEL: NIX-ROOT)
#   sdb3  800G ext4  /home        (LABEL: NIX-HOME)
#   sdb4  50G  exfat /mnt/shared  (LABEL: NIX-SHARED)
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
                extraArgs = [
                  "-n"
                  "NIX-BOOT"
                ];
              };
            };
            root = {
              size = "80G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [
                  "-L"
                  "NIX-ROOT"
                ];
              };
            };
            home = {
              size = "800G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
                extraArgs = [
                  "-L"
                  "NIX-HOME"
                ];
              };
            };
            extra = {
              size = "50G";
              content = {
                type = "filesystem";
                format = "exfat";
                mountpoint = "/mnt/shared";
                extraArgs = [
                  "-L"
                  "NIX-SHARED"
                ];
              };
            };
          };
        };
      };
    };
  };
}
