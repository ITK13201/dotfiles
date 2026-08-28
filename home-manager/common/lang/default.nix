{ pkgs, ... }:

let
  pythonTools = with pkgs; [
    (python3.withPackages (
      p: with p; [
        pip
      ]
    ))
  ];

  golangTools = with pkgs; [
    go
    gopls
    go-swag
  ];

  nodeTools = with pkgs; [
    nodejs
    pnpm
  ];
in

{
  home.packages = pythonTools ++ golangTools ++ nodeTools;
}
