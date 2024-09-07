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

  imports = [ ./utils.nix ];

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
    "XTerm*Background" = "#232323";
    "XTerm*Foreground" = "#aeadaf";
    "XTerm*Color0" = "#232323";
    "XTerm*Color1" = "#d4823d";
    "XTerm*Color2" = "#8c9e3d";
    "XTerm*Color3" = "#b1942b";
    "XTerm*Color4" = "#6e9cb0";
    "XTerm*Color5" = "#b58d88";
    "XTerm*Color6" = "#6da280";
    "XTerm*Color7" = "#949d9f";
    "XTerm*Color8" = "#312e30";
    "XTerm*Color9" = "#d0913d";
    "XTerm*Color10" = "#96a42d";
    "XTerm*Color11" = "#a8a030";
    "XTerm*Color12" = "#8e9cc0";
    "XTerm*Color13" = "#d58888";
    "XTerm*Color14" = "#7aa880";
    "XTerm*Color15" = "#aeadaf";
    "XTerm*FaceName" = "Source Code Pro:size=11";
  };

}
