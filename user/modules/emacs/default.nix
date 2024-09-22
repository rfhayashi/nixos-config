{ pkgs, metadata, ... }:
{
  programs.emacs.enable = true;
  
  home.file.".emacs.d".source = pkgs.chemacs2 + "/share/site-lisp/chemacs2";

  home.file.".emacs-profiles.el".text = ''
    (("default" . ((user-emacs-directory . "${metadata.home-dir}/dev/emacs.d")
                   (straight-p . t))))
  '';

}
