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

  outputs = { nixpkgs, sops-nix, home-manager, devshell, ... }@inputs:
    let
      system = "x86_64-linux";
      metadata = import ./metadata.nix;
    in
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./modules
        { inherit metadata; }
        {
          nixpkgs.overlays = [
            (self: _: (import ./packages) { pkgs = self; })
            (_: _: { devshell = devshell.packages.${system}.default; })
            (_: _: { home-manager = home-manager.packages.${system}.home-manager; })
          ];
        }
        ./system
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.sharedModules = [
            ./modules
            { inherit metadata; }
            inputs.sops-nix.homeManagerModules.sops
          ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${metadata.username} = import ./user;
        }
      ];
    };
  };
}
