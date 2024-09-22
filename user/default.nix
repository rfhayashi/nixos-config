{ config, pkgs, metadata, ... }:

let
  localPkgs = (import ../packages) { inherit pkgs; };
in
{
  home.username = metadata.username;
  home.homeDirectory = metadata.home-dir;

  home.stateVersion = "24.05";

  imports = [ ./utils.nix ../modules/user ../shared ];

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
    localPkgs.gcap
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

  home.file.".clojure/injections".source = ./clojure/injections;

  home.file.".clojure/deps.edn".text = ''
    {
      :aliases {:user {:extra-deps {global/user {:local/root "${metadata.home-dir}/.clojure/injections"}
                                    djblue/portal {:mvn/version "${metadata.clojure-portal.version}"}}}}
    }
  '';

  home.file.".lein/profiles.clj".text = ''
    {:user {:dependencies [[djblue/portal "${metadata.clojure-portal.version}"]]
            :injections [(load-file "${metadata.home-dir}/.clojure/injections/src/tap.clj")
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
