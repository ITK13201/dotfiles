{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Takumi Ikeda";
        email = "57588603+ITK13201@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
