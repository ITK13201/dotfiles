{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      extended = true;
      share = true;
    };

    shellAliases = {
      ls = "eza";
      la = "eza -a";
      ll = "eza -la --git";
      tree = "eza -T";
      ".." = "cd ..";
      "..." = "cd ../..";
      cat = "bat";
      find = "fd";
      rm = "rm -i";
      cp = "cp -i";
      du = "dust";
      df = "duf";
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        function zvm_config() {
          ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
          ZVM_ESCAPE_KEYTIMEOUT=0.4
        }
      '')
      ''
        # Terminal title
        autoload -Uz add-zsh-hook
        function _set_title() {
          print -Pn "\033]0;%n@%m:%1~\007"
        }
        function _set_cmd_title() {
          local cmd=$(echo $2 | awk '{print $1}')
          echo -ne "\033]0;$cmd\007"
        }
        add-zsh-hook precmd _set_title
        add-zsh-hook preexec _set_cmd_title

        # Fuzzy history search (Ctrl+R)
        function _fzf_select_history() {
          BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
          CURSOR=$#BUFFER
          zle reset-prompt
        }
        zle -N _fzf_select_history
        function zvm_after_init() {
          bindkey -M viins "^R" _fzf_select_history
        }

        # Random string generators
        function rand_str() {
          LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c ''${1:-16}; echo
        }
        function rand_hex() {
          LC_ALL=C tr -dc 'a-f0-9' < /dev/urandom | head -c ''${1:-16}; echo
        }
      ''
    ];
  };
}
