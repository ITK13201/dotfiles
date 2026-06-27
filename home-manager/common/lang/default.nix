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
    swag
  ];

  nodeTools = with pkgs; [
    nodejs
  ];
in

{
  home.packages = pythonTools ++ golangTools ++ nodeTools;
}
