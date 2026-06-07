{ username, ... }:

{
  imports = [
    ../../common
    ../../linux
    ../../desktop
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
