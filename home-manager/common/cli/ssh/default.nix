{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      AddKeysToAgent = "yes";
      IdentityAgent = "~/.1password/agent.sock";
    };

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        port = 22;
        extraOptions = {
          TCPKeepAlive = "yes";
          IdentitiesOnly = "yes";
        };
      };

      "rpi" = {
        hostname = "192.168.1.110";
        user = "ubuntu";
      };

      "vpn gate" = {
        hostname = "45.32.131.230";
        user = "linuxuser";
        extraOptions.IdentitiesOnly = "yes";
      };

      "pve.i-tk.dev" = {
        hostname = "192.168.1.130";
        user = "root";
      };

      "k8s-cp01" = {
        hostname = "192.168.1.200";
        user = "k8s";
      };

      "k8s-worker01" = {
        hostname = "192.168.1.201";
        user = "k8s";
      };
    };
  };
}
