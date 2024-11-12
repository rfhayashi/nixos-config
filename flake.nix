{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    xclj.url = "github:rfhayashi/xclj/flake";
    xclj.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, sops-nix, home-manager, xclj, ... }@inputs:
    let
      system = "x86_64-linux";
      base-metadata = (nixpkgs.lib.modules.importTOML ./metadata.toml).config;
      metadata = base-metadata // { home-dir = "/home/${base-metadata.username}"; };
      xclj-pkgs = xclj.packages."${system}";
      local-pkgs = (import ./packages) { pkgs = import nixpkgs { inherit system; }; };
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./system
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${metadata.username} = import ./user;
          home-manager.extraSpecialArgs = { inherit metadata local-pkgs; };
        }
      ];
      specialArgs = { inherit metadata local-pkgs xclj-pkgs; };
    };
  };
}
