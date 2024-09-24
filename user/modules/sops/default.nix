{ metadata, ... }:
{
  sops = {
    age.keyFile = "${metadata.home-dir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../../secrets.yaml;
  };
}
