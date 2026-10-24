{ ... }:

{
  # PAM 設定は nixos/settings/system/security.nix の security.pam.services.hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 64;
          color = "rgba(c0caf5ff)";
          position = "0, 120";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 2;
          outer_color = "rgba(7aa2f7ee)";
          inner_color = "rgba(1a1b26ee)";
          font_color = "rgba(c0caf5ff)";
          placeholder_text = "Password";
          fade_on_empty = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
