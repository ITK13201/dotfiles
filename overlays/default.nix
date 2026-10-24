# nixpkgs オーバーレイ
# nixos/settings/nix/nixpkgs.nix の nixpkgs.overlays で読み込む
[
  (import ./1password-gui.nix)
]
