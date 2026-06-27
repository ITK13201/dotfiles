{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Takumi Ikeda";
        email = "57588603+ITK13201@users.noreply.github.com";
      };
      init.defaultBranch = "main";
      core.editor = "vim";
      pull.rebase = false;
      commit.gpgsign = true;
      gpg.format = "ssh";
      "gpg \"ssh\"" = {
        program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        allowedSignersFile = "~/.ssh/allowed_signers";
      };
      user.signingKey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5OuP0niFKvUFCumg5VjlzGMOMsDPHiVYmx71/yINJU";
    };
  };

  home.file.".ssh/allowed_signers".source = ../../../config/ssh/allowed_signers;
}
