{ inputs, system }:
let
  metadata = import ./metadata.nix;
in
{
  imports = [
    ./modules
    { inherit metadata; }
    (
      { lib, ... }:
      {
        nixpkgs.overlays = [
          (
            self: _:
            (import ./packages) {
              pkgs = self;
              inherit lib;
            }
          )
          (
            final: prev:
            let
              babashka-unwrapped = prev.babashka-unwrapped.overrideAttrs (_: rec {
                version = "1.12.218";
                src = prev.fetchurl {
                  url = "https://github.com/babashka/babashka/releases/download/v${version}/babashka-${version}-standalone.jar";
                  sha256 = "sha256-CEApb2noPYfRYRDTo1RBLOZELvEuxGO4HW1CB//bky8=";
                };
              });
              clojureToolsBabashka = prev.babashka.clojure-tools.overrideAttrs (old: rec {
                version = "1.12.4.1618";
                src = prev.fetchurl {
                  url = "https://github.com/clojure/brew-install/releases/download/${version}/clojure-tools-${version}.tar.gz";
                  sha256 = "sha256-E3adptY6mN6yAkN4rhpk5O4hGsEDU0DfynppRMQc3iE=";
                };
              });
            in
            {
              inherit babashka-unwrapped;
              babashka = prev.babashka.override {
                inherit babashka-unwrapped clojureToolsBabashka;
              };
            }
          )
          (_: _: { devshell = inputs.devshell.packages.${system}.default; })
          inputs.nix-vscode-extensions.overlays.default
        ];
      }
    )
    ./system
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules = [
        ./modules
        { inherit metadata; }
        inputs.sops-nix.homeManagerModules.sops
        (
          { config, ... }:
          {
            programs.emacs.userDir = "${config.home.homeDirectory}/dev/emacs.d";
          }
        )
        inputs.emacs.lib.home-manager-module
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${metadata.username} = import ./user;
    }
  ];
}
