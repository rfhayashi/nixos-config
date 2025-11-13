{ inputs, system }:
let metadata = import ./metadata.nix;
in {
  imports = [
    ./modules
    { inherit metadata; }
    {
      nixpkgs.overlays = [
        (self: _: (import ./packages) { pkgs = self; })
        (_: _: { devshell = inputs.devshell.packages.${system}.default; })
        inputs.nix-vscode-extensions.overlays.default
      ];
    }
    ./system
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules = [
        ./modules
        { inherit metadata; }
        inputs.sops-nix.homeManagerModules.sops
        ({ config, ... }: {
          programs.emacs.userDir = "${config.home.homeDirectory}/dev/emacs.d";
        })
        inputs.emacs.lib.home-manager-module
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${metadata.username} = import ./user;
    }
  ];
}
