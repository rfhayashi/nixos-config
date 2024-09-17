{ config, pkgs, ... }:

let
  username = "rfhayashi";
  homeDir = "/home/" + username;
  gcap = pkgs.callPackage ./gcap.nix { };
  portalVersion = "0.57.2";
in
{
  home.username = username;
  home.homeDirectory = homeDir;

  home.stateVersion = "24.05";

  imports = [ ./utils.nix ./xmonad.nix ];

  programs.home-manager.enable = true;
  programs.gh.enable = true;

  programs.git = {
    enable = true;
    userName = "Rui Fernando Hayashi";
    userEmail = "rfhayashi@gmail.com";
    signing = {
      signByDefault = true;
      key = "rfhayashi@gmail.com";
    };
  };

  programs.emacs = {
    enable = true;
  };

  home.packages = with pkgs; [
    direnv
    devenv
    megacmd
    gcap
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
    (("default" . ((user-emacs-directory . "${homeDir}/dev/emacs.d")
                   (straight-p . t))))
  '';

  home.file.".megaCmd/excluded".text = ''
    Thumbs.db
    desktop.ini
    ~.*
  '';

  home.file.".clojure/injections".source = ./clojure/injections;

  home.file.".clojure/deps.edn".text = ''
    {
      :aliases {:user {:extra-deps {global/user {:local/root "${homeDir}/.clojure/injections"}
                                    djblue/portal {:mvn/version "${portalVersion}"}}}}
    }
  '';

  home.file.".lein/profiles.clj".text = ''
    {:user {:dependencies [[djblue/portal "${portalVersion}"]]
            :injections [(load-file "${homeDir}/.clojure/injections/src/tap.clj")
                         (alter-var-root #'default-data-readers
                                         (fn [v]
                                           (-> v
                                               (assoc 'tap #'tap/>-reader)
                                               (assoc 'tapd #'tap/d-reader))))
                         (require 'portal.api)
                         (portal.api/tap)]}}
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
