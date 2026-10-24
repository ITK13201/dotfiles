{ ... }:

{
  security = {
    rtkit.enable = true;
    # hyprlock (Home Manager) のパスワード認証用
    pam.services = {
      hyprlock = { };
      # SDDM ログイン時に gnome-keyring をアンロックする
      sddm.enableGnomeKeyring = true;
    };
  };
}
