{ lib, config, ... }:
with lib;
let
  cfg = config.rfhayashi.i3;
in
{
  options.rfhayashi.i3 = {
    enable = mkEnableOption "i3";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.i3 = {
      enable = true;
    };

    security.pam.services.i3lock.enable = true;
  };
}
