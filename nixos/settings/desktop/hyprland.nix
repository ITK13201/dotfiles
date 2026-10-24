{ ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # graphical-session.target を有効にし、Home Manager の systemd user サービスを起動させる
    withUWSM = true;
  };
}
