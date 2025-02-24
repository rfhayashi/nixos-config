{ lib, config, pkgs, local-pkgs, ...}:
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
      rofi
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
      blueman
    ] ++
    [
      local-pkgs.switch-keyboard-layout
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

    home.file.".config/rofi/config.rasi".text = ''
      configuration {
      }
      @theme "arthur"
    '';

    home.file.".config/eww".source = ./eww;
  };
}
