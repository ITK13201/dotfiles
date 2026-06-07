{ ... }:

{
  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-label/NIX-SHARED";
    fsType = "exfat";
    options = [
      "uid=1000"
      "gid=1000"
      "umask=0022"
    ];
  };
}
