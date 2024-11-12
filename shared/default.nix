{ metadata, ... }:
{
  rfhayashi.xmonad.enable = true;

  sops = {
    age.keyFile = "${metadata.home-dir}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets.yaml;
  };
}
