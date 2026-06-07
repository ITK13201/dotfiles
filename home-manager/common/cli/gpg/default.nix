{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
