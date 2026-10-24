{ pkgs, lib, ... }:

let

  # dock にピン留めするアプリ (左から順に表示)
  pinnedApps = [
    {
      name = "chrome";
      icon = "google-chrome";
      command = "google-chrome-stable";
    }
    {
      name = "kitty";
      icon = "kitty";
      command = "kitty";
    }
    {
      name = "thunar";
      icon = "org.xfce.thunar";
      command = "thunar";
    }
    {
      name = "1password";
      icon = "1password";
      command = "1password";
    }
    {
      name = "discord";
      icon = "discord";
      command = "discord";
    }
    {
      name = "vscode";
      icon = "vscode";
      command = "code";
    }
  ];

  # waybar の image モジュールは SVG を読み込めずバー全体が描画されなくなるため、PNG に変換して使う
  iconSize = 32;
  pinnedIcons = pkgs.runCommand "waybar-dock-icons" { nativeBuildInputs = [ pkgs.librsvg ]; } (
    ''
      mkdir -p $out
    ''
    + lib.concatMapStrings (app: ''
      rsvg-convert -w ${toString (iconSize * 2)} -h ${toString (iconSize * 2)} \
        ${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/64x64/apps/${app.icon}.svg \
        -o $out/${app.name}.png
    '') pinnedApps
  );

  pinnedModules = lib.listToAttrs (
    map (app: {
      name = "image#${app.name}";
      value = {
        path = "${pinnedIcons}/${app.name}.png";
        size = iconSize;
        # interval 未指定だと image モジュールが 5 個以上でバー全体が描画されなくなる
        interval = 86400;
        tooltip = false;
        on-click = "uwsm app -- ${app.command}";
      };
    }) pinnedApps
  );
in
{
  programs.waybar = {
    enable = true;
    # graphical-session.target に紐付けて自動起動する（UWSM 前提）
    systemd.enable = true;
    style = builtins.readFile ../../../config/waybar/style.css;
    settings.mainBar = {
      name = "main";
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [
        "custom/launcher"
        "hyprland/workspaces"
      ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "pulseaudio"
        "cpu"
        "memory"
        "tray"
        "clock"
      ];

      "custom/launcher" = {
        format = "";
        tooltip = false;
        on-click = "uwsm app -- wofi --show drun";
      };
      "hyprland/workspaces" = {
        format = "{id}";
        on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e-1\" })'";
        on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({ workspace = \"e+1\" })'";
      };
      "hyprland/window" = {
        max-length = 60;
        separate-outputs = true;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons.default = [
          ""
          ""
          ""
        ];
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "uwsm app -- pavucontrol";
      };
      cpu = {
        format = " {usage}%";
        interval = 5;
      };
      memory = {
        format = "󰍛 {percentage}%";
        interval = 5;
      };
      tray.spacing = 8;
      clock = {
        format = "{:%m/%d (%a) %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };
    };

    settings.dock = {
      name = "dock";
      layer = "top";
      position = "left";
      width = 48;
      margin-left = 6;
      # group モジュールに image を入れるとバー全体が描画されなくなるため、直接並べる
      modules-center = map (app: "image#${app.name}") pinnedApps ++ [ "wlr/taskbar" ];

      "wlr/taskbar" = {
        icon-size = iconSize;
        icon-theme = "Papirus-Dark";
        tooltip-format = "{title}";
        on-click = "activate";
        on-click-middle = "close";
      };
    }
    // pinnedModules;
  };
}
