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
    home.packages = with pkgs; [
      dmenu
      ulauncher
      eww
      xlockmore
      scrot
      notify-osd
      libnotify
      networkmanagerapplet
      cbatticon
      acpi
      alsa-utils
      alacritty
    ];

    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = ./xmonad.hs;
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = [ "graphical-session-pre.target" ];
      };
    };

    services.blueman-applet.enable = true;

    home.file.".config/eww".source = ./eww;

    home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;
  };
}
