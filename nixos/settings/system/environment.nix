{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      vim
      wget
      git
      gh
      google-chrome
      _1password-gui
      _1password-cli
      vscode
      age
      sops
      gnumake
      claude-code
      discord
      obsidian
      gptfdisk
      gparted
      (bottles.override { removeWarningPopup = true; })
      thunderbird
    ];
    variables = {
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      # NVIDIA + Hyprland (Wayland)
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
    };
  };
}
