{ ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    shortcut = "a";
    escapeTime = 0;
  };
}
