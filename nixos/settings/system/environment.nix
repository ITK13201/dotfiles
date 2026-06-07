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
    ];
    variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };
}
