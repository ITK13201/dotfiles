{ username, ... }:

{
  imports = [
    ../../common
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };
}
