{ config, pkgs, ... }:
{
  home.packages = [ pkgs.sops ];

  sops = {
    age.keyFile = "${config.metadata.homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
  };
}
