{ config, pkgs, metadata, local-pkgs, ... }:

{
  home.username = metadata.username;
  home.homeDirectory = metadata.home-dir;

  home.stateVersion = "24.05";

  imports = [ ./modules ../shared ];

  sops.secrets."github/token" = {};

  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    local-pkgs.gcap
    discord
    zoom-us
    (pkgs.writeShellScriptBin "nixos-update" ''
      NIX_CONFIG="extra-access-tokens = github.com=$(cat ${config.sops.secrets."github/token".path})" nix flake update
    '')
    (pkgs.writeShellScriptBin "nixos-switch" ''
      NIX_CONFIG="extra-access-tokens = github.com=$(cat ${config.sops.secrets."github/token".path})" sudo nixos-rebuild switch --flake ${metadata.home-dir}/dev/nixos-config
    '')
  ];
}
