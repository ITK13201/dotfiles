{ ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../../../overlays;
  };
}
