{
  pkgs,
  inputs,
  username,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/settings/boot
    ../../nixos/settings/system/networking.nix
    ../../nixos/settings/system/security.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/nix/nix.nix
    ../../nixos/settings/nix/nixpkgs.nix
    ../../nixos/settings/desktop/fonts.nix
    ../../nixos/settings/desktop/plasma.nix
    ../../nixos/settings/desktop/pipewire.nix
    ../../nixos/settings/display/sddm.nix
    ../../nixos/settings/misc/cups.nix
    ../../nixos/settings/misc/fwupd.nix
    ../../nixos/settings/misc/1password.nix
    ../../nixos/settings/misc/programs.nix
    ../../nixos/settings/misc/sops.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = import ../../home-manager/profiles/nixos;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Takumi Ikeda";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  system.stateVersion = "26.05";
}
