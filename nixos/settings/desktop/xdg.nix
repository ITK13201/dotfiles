{ pkgs, ... }:

{
  # ファイル選択ダイアログ等 (xdg-desktop-portal-hyprland が対応しないもの) を GTK portal で補う
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
