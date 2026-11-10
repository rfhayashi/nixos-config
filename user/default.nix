{ pkgs, config, ... }:

let
  themeVersion = (builtins.fromJSON (builtins.readFile ./config/chromium-theme/manifest.json)).version;
  # The checked-in signing key keeps the local theme's extension ID stable.
  zenburnTheme = pkgs.runCommand "zenburn-chromium-theme.crx" {
    nativeBuildInputs = [ pkgs.chromium ];
  } ''
    cp -r ${./config/chromium-theme} theme
    export HOME="$PWD"
    chromium --no-sandbox \
      --user-data-dir="$PWD/profile" \
      --pack-extension="$PWD/theme" \
      --pack-extension-key=${./config/chromium-theme.pem}
    cp theme.crx "$out"
  '';
in
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
    gnome-screenshot
    arandr
    f1multiviewer
    babashka
    difftastic
    calibre
  ];

  programs.chromium = {
    enable = true;
    extensions = [
      {
        id = "eiifhajbejjafpkkgcmihhgajlffjdjc";
        crxPath = zenburnTheme;
        version = themeVersion;
      } # Zenburn browser theme
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
