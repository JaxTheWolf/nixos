{
  inputs,
  self,
}: let
  specialArgs = {
    inherit inputs self;
  };
  lib = inputs.nixpkgs.lib;
in {
  mkNixos = {
    name,
    username ? "jax",
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit specialArgs;
      modules =
        [
          ../hosts/${name}

          {
            virtualisation.vmVariant = {
              imports = [
                inputs.home-manager.nixosModules.home-manager
              ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;

                users.${username} = {
                  imports =
                    [
                      ../hosts/common/modules/home
                      ../hosts/${name}/modules/home
                    ]
                    ++ lib.optionals (!lib.strings.hasInfix "server" name) [
                      ../hosts/common/modules/home/gui
                    ];
                };
              };

              swapDevices = lib.mkForce [];
              boot.resumeDevice = lib.mkForce "";

              users.users.jax.password = "nixos";
              services.displayManager.autoLogin = {
                enable = true;
                user = "jax";
              };

              virtualisation = {
                memorySize = 8192;
                cores = 4;
                graphics = true;
                diskSize = 20 * 1024;
                qemu.options = [
                  "-device virtio-vga-gl"
                  "-display gtk,gl=on"
                  "-cpu host"
                ];
              };
            };
          }
        ]
        ++ extraModules;
    };

  mkHome = {
    name,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    stringParts = inputs.nixpkgs.lib.strings.splitString "@" name;

    fallbackUser = builtins.elemAt stringParts 0;
    hostName = builtins.elemAt stringParts 1;

    hasNixosConfig = self.nixosConfigurations ? ${hostName};

    username = fallbackUser;

    pkgs =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.pkgs
      else
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [inputs.filefinder.overlays.default];
        };

    osConfig =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.config
      else {
        networking.hostName = hostName;
        nixpkgs.hostPlatform = system;
      };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs =
        specialArgs
        // {
          inherit osConfig;
        };

      modules =
        [
          ../hosts/common/modules/home
          ../hosts/${hostName}/modules/home

          {
            home = {
              inherit username;
              homeDirectory =
                if username == "root"
                then "/root"
                else "/home/${username}";
            };
          }
        ]
        ++ lib.optionals (!lib.strings.hasInfix "server" hostName) [../hosts/common/modules/home/gui]
        ++ extraModules;
    };
}
