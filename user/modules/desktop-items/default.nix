{ lib, config, pkgs, ...}:
let
  inherit (lib) mkOption types;
  cfg = config.rfhayashi;
in
{
  options.rfhayashi.desktopItems = mkOption {
    type = types.listOf types.attrs;
    default = [];
  };

  config = {
    home.packages = (map (di: pkgs.makeDesktopItem di) cfg.desktopItems); 
  };
}
