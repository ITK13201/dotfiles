{ ... }:

{
  imports = [
    ./git
    ./nix
    ./cli
    ./cli/ssh
    ./cli/gpg
    ./cli/claude
    ./shell/zsh
    ./shell/tmux
    ./shell/starship
    ./editor/vscode
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "26.05";
}
