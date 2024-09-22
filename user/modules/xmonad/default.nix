{ lib, config, pkgs, ...}:
with lib;
let
  cfg = config.rfhayashi.xmonad;
in
{
  options.rfhayashi.xmonad = {
    enable = mkEnableOption "xmonad";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dmenu ulauncher eww ];

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    home.file.".config/eww".source = ./eww;
  };
}
