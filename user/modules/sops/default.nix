{ config, ... }:
{
  sops = {
    age.keyFile = "${config.metadata.homeDir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
  };
}
