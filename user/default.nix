{ pkgs, metadata, local-pkgs, ... }:

{
  home.username = metadata.username;
  home.homeDirectory = metadata.home-dir;

  home.stateVersion = "24.05";

  imports = [ ./modules ./config ];

  programs.home-manager.enable = true;
  
  home.packages = with pkgs; [
    local-pkgs.gcap
    discord
    zoom-us
    nyxt
  ];

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
}
