{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ ulauncher eww ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    config = ./xmonad.hs;
  };

  home.file.".config/eww".source = ./eww;
}
