{ config, pkgs, metadata, local-pkgs, ... }:

{
  home.username = metadata.username;
  home.homeDirectory = metadata.home-dir;

  home.stateVersion = "24.05";

  imports = [ ./utils.nix ./modules ../shared ];

  programs.home-manager.enable = true;
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = metadata.fullname;
    userEmail = metadata.email;
    signing = {
      signByDefault = true;
      key = metadata.email;
    };
  };

  programs.emacs = {
    enable = true;
  };

  home.packages = with pkgs; [
    local-pkgs.gcap
    direnv
    devenv
    megacmd
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

  home.file.".emacs.d".source = pkgs.chemacs2 + "/share/site-lisp/chemacs2";

  home.file.".emacs-profiles.el".text = ''
    (("default" . ((user-emacs-directory . "${metadata.home-dir}/dev/emacs.d")
                   (straight-p . t))))
  '';

  home.file.".megaCmd/excluded".text = ''
    Thumbs.db
    desktop.ini
    ~.*
  '';
  
  home.file.".config/alacritty/alacritty.toml".source = ./alacritty.toml;

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  services.blueman-applet.enable = true;

}
