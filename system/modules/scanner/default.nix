{ config, pkgs, ... }:
let
  scan-image = pkgs.writeShellApplication {
    name = "scan-image";
    text = ''
      scanimage -d pixma:04A9180B_145D39 --format jpeg
    '';
  };
in {
  hardware.sane.enable = true;

  users.users.${config.metadata.username}.extraGroups = [ "scanner" "lp" ];

  services.ipp-usb.enable = true;

  environment.systemPackages = [ pkgs.xsane pkgs.simple-scan scan-image ];
}
