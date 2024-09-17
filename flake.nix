{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      base-metadata = (nixpkgs.lib.modules.importTOML ./metadata.toml).config;
      metadata = base-metadata // { home-dir = "/home/${base-metadata.username}"; };
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${metadata.username} = import ./${metadata.username}/home.nix;
          home-manager.extraSpecialArgs = { inherit metadata; };
        }
      ];
      specialArgs = { inherit metadata ; };
    };
  };
}
