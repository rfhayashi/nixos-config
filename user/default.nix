{ pkgs, config, ... }:

{
  home.username = config.metadata.username;
  home.homeDirectory = config.metadata.homeDir;

  home.stateVersion = "24.05";

  imports = [ ./modules ./config ];

  home.packages = with pkgs; [
    vlc
    discord
    zoom-us
    nyxt
    google-chrome
    jq
    wget
    unzip
    ripgrep
    tmux
    bubblewrap
  ];

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "ldjkgaaoikpmhmkelcgkgacicjfbofhh"; } # instapaper
      { id = "gfbliohnnapiefjpjlpjnehglfpaknnc"; } # surfingkeys
    ];
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };
}
