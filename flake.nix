{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      base-metadata = (nixpkgs.lib.modules.importTOML ./metadata.toml).config;
      metadata = base-metadata // { home-dir = "/home/${base-metadata.username}"; };
      local-pkgs = (import ./packages) { pkgs = import nixpkgs { inherit system; }; };
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./system
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${metadata.username} = import ./user;
          home-manager.extraSpecialArgs = { inherit metadata local-pkgs; };
        }
      ];
      specialArgs = { inherit metadata local-pkgs; };
    };
  };
}
