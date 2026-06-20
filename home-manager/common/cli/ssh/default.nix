{ ... }:

{
  xdg.configFile."1Password/ssh/agent.toml" = {
    source = ../../../../config/1password/ssh/agent.toml;
    force = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
        IdentityAgent = "~/.1password/agent.sock";
      };

      "github.com" = {
        HostName = "github.com";
        User = "git";
        Port = 22;
        TCPKeepAlive = "yes";
      };

      "rpi" = {
        HostName = "192.168.1.110";
        User = "ubuntu";
      };

      "vpn gate" = {
        HostName = "45.32.131.230";
        User = "linuxuser";
      };

      "pve.i-tk.dev" = {
        HostName = "192.168.1.130";
        User = "root";
      };

      "k8s-cp01" = {
        HostName = "192.168.1.200";
        User = "k8s";
      };

      "k8s-worker01" = {
        HostName = "192.168.1.201";
        User = "k8s";
      };
    };
  };
}
