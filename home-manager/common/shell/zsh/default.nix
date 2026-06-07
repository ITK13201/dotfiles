{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };
    shellAliases = {
      ls = "eza";
      la = "eza -a";
      ll = "eza -la --git";
      ".." = "cd ..";
      "..." = "cd ../..";
      cat = "bat";
      find = "fd";
    };
  };
}
