{ ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      extraEntries = {
        "windows.conf" = ''
          title   Windows Boot Manager
          efi     /EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
    efi.canTouchEfiVariables = true;
    timeout = 5;
  };
}
