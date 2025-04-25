{ config, ... }:
{
  sops = {
    age.keyFile = "${config.metadata.home-dir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
  };
}
