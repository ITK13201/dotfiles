{ pkgs, ... }:

{
  xdg.configFile."hypr/hyprland.lua".source = ../../../config/hypr/hyprland.lua;

  # プラグインの .so は Nix ストアパスになるため Lua モジュールとして生成し、hyprland.lua から require する
  xdg.configFile."hypr/plugins.lua".text = ''
    return {
        hyprbars = "${pkgs.hyprlandPlugins.hyprbars}/lib/libhyprbars.so",
    }
  '';
}
