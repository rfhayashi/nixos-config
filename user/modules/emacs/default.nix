{ pkgs, config, ... }:
{
  programs.emacs.enable = true;
  
  home.file.".emacs.d".source = pkgs.chemacs2 + "/share/site-lisp/chemacs2";

  home.file.".emacs-profiles.el".text = ''
    (("default" . ((user-emacs-directory . "${config.metadata.homeDir}/dev/emacs.d")
                   (straight-p . t))))
  '';

}
