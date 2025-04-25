{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    devshell.url = "github:rfhayashi/devshells?dir=devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, devshell, ... }@inputs:
    let
      system = "x86_64-linux";
      base-metadata = (nixpkgs.lib.modules.importTOML ./metadata.toml).config;
      metadata-module = {
          options = {
            metadata = nixpkgs.lib.mkOption {
              type = nixpkgs.lib.types.attrs;
            };
          };
          config = {
            metadata = base-metadata // { home-dir = "/home/${base-metadata.username}"; };
          };
        };
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        metadata-module 
        {
          nixpkgs.overlays = [
            (self: _: (import ./packages) { pkgs = self; })
            (_: _: { devshell = devshell.packages.${system}.default; })
          ];
        }
        ./system
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops metadata-module ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${base-metadata.username} = import ./user;
        }
      ];
    };
  };
}
