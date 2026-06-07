{ inputs, username, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age = {
      # age キーは nixos-rebuild 前に手動で生成する:
      # age-keygen -o ~/.config/sops/age/keys.txt
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
  };
}
