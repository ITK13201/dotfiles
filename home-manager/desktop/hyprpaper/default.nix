{ pkgs, ... }:

let
  wallpaper = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      # monitor を空にすると全モニターに適用される (個別指定のモニターを除く)
      wallpaper = [
        {
          # 縦向きモニターはキーバインドのチートシート付き壁紙
          monitor = "HDMI-A-2";
          path = "${../../../config/hypr/wallpapers/cheatsheet-portrait.jpg}";
          fit_mode = "cover";
        }
        {
          monitor = "";
          path = wallpaper;
          fit_mode = "cover";
        }
      ];
    };
  };
}
