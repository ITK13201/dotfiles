{ ... }:

{
  imports = [
    ./git
    ./nix
    ./cli/ssh
    ./cli/gpg
    ./shell/zsh
    ./shell/tmux
    ./editor/vscode
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
