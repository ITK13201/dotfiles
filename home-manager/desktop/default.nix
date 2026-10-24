{ osConfig, ... }:

{
  imports = [
    ./theme
    ./hyprland
    ./hyprlock
    ./hypridle
    ./hyprpolkitagent
    ./hyprshot
    ./hyprsunset
    ./cliphist
    ./kitty
    ./wofi
    ./waybar
    ./dunst
    ./hyprpaper
  ];

  # NixOS 側 (programs._1password-gui) と同じパッケージを参照する
  xdg.configFile."autostart/1password.desktop".source =
    "${osConfig.programs._1password-gui.package}/share/applications/com.onepassword.OnePassword.desktop";
}
