{ config, pkgs, metadata, local-pkgs, ... }:

{
  home.username = metadata.username;
  home.homeDirectory = metadata.home-dir;

  home.stateVersion = "24.05";

  imports = [ ./utils.nix ./modules ../shared ];

  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    local-pkgs.gcap
    direnv
    devenv
    discord
    blueman
    xlockmore
    zoom-us
    alsa-utils
    scrot
    notify-osd
    libnotify
    alacritty
    networkmanagerapplet
    cbatticon
    acpi
  ];

  home.file.".bashrc".source = ./bashrc;

  home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.blueman-applet.enable = true;

}
