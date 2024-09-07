{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ulauncher ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };
}
