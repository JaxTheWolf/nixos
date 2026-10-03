_: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ServerAliveInterval = 300;
        ServerAliveCountMax = 2;
      };

      "lenovo-server" = {
        User = "jax";
        HostName = "192.168.0.10";
      };

      "laptop" = {
        User = "jax";
        HostName = "192.168.0.141";
      };

      "oracle" = {
        User = "ubuntu";
        HostName = "141.147.56.107";
      };

      "BW" = {
        User = "root";
        HostName = "194.163.134.27";
      };

      "gt.awruff.fun" = {
        Port = 2220;
      };

      "TM" = {
        User = "jax";
        HostName = "10.2.0.2";
      };

      "pipa" = {
        User = "jax";
        HostName = "192.168.0.58";
      };

      "vojta-vm" = {
        User = "jax";
        HostName = "10.1.0.11";
      };
    };
  };
}
