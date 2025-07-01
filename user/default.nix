{ pkgs, config, ... }:

{
  home.username = config.metadata.username;
  home.homeDirectory = config.metadata.homeDir;

  home.stateVersion = "24.05";

  imports = [ ./modules ./config ];

  home.packages = with pkgs; [
    discord
    zoom-us
    nyxt
    google-chrome
    jq
    wget
    unzip
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
}
