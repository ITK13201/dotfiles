{ pkgs, ... }:

{
  xdg.configFile."autostart/1password.desktop".source =
    "${pkgs._1password-gui}/share/applications/1password.desktop";
}
