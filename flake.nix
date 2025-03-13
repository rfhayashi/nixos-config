{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    devshell.url = "github:rfhayashi/devshells?dir=devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    portal = {
      url = "github:djblue/portal";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, devshell, portal, ... }@inputs:
    let
      system = "x86_64-linux";
      base-metadata = (nixpkgs.lib.modules.importTOML ./metadata.toml).config;
      metadata = base-metadata // { home-dir = "/home/${base-metadata.username}"; };
      local-pkgs = (import ./packages) { pkgs = import nixpkgs { inherit system; }; };
      devshell-pkgs = devshell.packages.${system};
    in
      {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./system
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager {
              home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${metadata.username} = import ./user;
              home-manager.extraSpecialArgs = { inherit metadata local-pkgs devshell-pkgs portal; };
            }
          ];
          specialArgs = { inherit metadata local-pkgs; };
        };
      };
}
