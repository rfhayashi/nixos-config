{ lib, config, ...}:
with lib;
let
  cfg = config.rfhayashi.xmonad;
in
{
  options.rfhayashi.xmonad = {
    enable = mkEnableOption "xmonad";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };
}
