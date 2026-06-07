{ pkgs, ... }:

{
  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  home.packages = with pkgs; [
    eza
    fd
    ripgrep
    jq
    duf
    dust
    fastfetch
  ];
}
