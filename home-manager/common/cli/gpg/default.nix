{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-qt;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    extraConfig = ''
      allow-preset-passphrase
    '';
  };

  # GnuPG 2.4+ の keyboxd 設定
  home.file.".gnupg/common.conf".text = ''
    use-keyboxd
  '';
}
