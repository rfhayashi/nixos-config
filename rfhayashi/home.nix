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
    gnome.gnome-terminal
    blueman
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

  xresources.properties = {
    "XTerm*Background" = "#3a3a3a";
    "XTerm*Foreground" = "#dcdccc";
    "XTerm*Color0" = "#000000";
    "XTerm*Color1" = "#e89393";
    "XTerm*Color2" = "#688060";
    "XTerm*Color3" = "#f0dfaf";
    "XTerm*Color4" = "#93b3a3";
    "XTerm*Color5" = "#bca3a3";
    "XTerm*Color6" = "#93b3a3";
    "XTerm*Color7" = "#cccccc";
    "XTerm*Color8" = "#222222";
    "XTerm*Color9" = "#dca3a3";
    "XTerm*Color10" = "#7f9f7f";
    "XTerm*Color11" = "#efef8f";
    "XTerm*Color12" = "#8cd0d3";
    "XTerm*Color13" = "#c0bed1";
    "XTerm*Color14" = "#8cd0d3";
    "XTerm*Color15" = "#ffffff";
    "XTerm*FaceName" = "Source Code Pro:size=11";
  };

}
