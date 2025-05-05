{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    devshell.url = "github:rfhayashi/devshells?dir=devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:rfhayashi/emacs.d";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      baseSystem = { extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./system.nix { inherit inputs system; }) ]
            ++ extraModules;
        };
      pkgs = import nixpkgs { inherit system; };
      runTestVm = pkgs.writeShellScript "runTestVm" ''
        	nix build #nixosConfigurations.testVm.config.system.build.vm
                result/bin/run-nixos-vm
      '';
    in {
      nixosConfigurations = {
        nixos = baseSystem { };
        testVm = baseSystem {
          extraModules = [
            {
              virtualisation.vmVariant = {
                virtualisation = {
                  memorySize = 4096; # Use 4096MiB memory.
                  cores = 2;
                  graphics = true;
                };
              };
            }
            { metadata.password = "test"; }
          ];
        };
      };
      apps.${system}.runTestVm = {
        type = "app";
        program = "${runTestVm}";
      };
    };
}
