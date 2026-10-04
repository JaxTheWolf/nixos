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

      "dalaptop" = {
        User = "jax";
        HostName = "192.168.0.141";
      };

      "pipa" = {
        User = "jax";
        HostName = "192.168.0.58";
      };

      "epiquev2" = {
        User = "jax";
        HostName = "192.168.0.109";
      };

      "gt.awruff.fun" = {
        Port = 2220;
      };

      "BW" = {
        User = "root";
        HostName = "194.163.134.27";
      };

      "TM" = {
        User = "jax";
        HostName = "10.2.0.2";
      };

      "vojta-vm" = {
        User = "jax";
        HostName = "10.1.0.11";
      };
    };
  };
}
