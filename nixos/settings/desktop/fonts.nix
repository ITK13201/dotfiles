{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      plemoljp
      plemoljp-nf
      plemoljp-hs
      ibm-plex
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.hack
      nerd-fonts.symbols-only
      biz-ud-gothic
    ];

    fontDir.enable = true;

    fontconfig = {
      hinting = {
        enable = true;
        style = "slight";
        autohint = false;
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "Hack Nerd Font Mono"
          "PlemolJP HS"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
