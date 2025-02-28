{ pkgs, ... }:
{
  gcap = pkgs.callPackage ./gcap {};

  suspend = pkgs.writeShellScript "suspend" ''
    systemctl suspend
  '';

  switch-keyboard-layout = pkgs.writeScriptBin "switch-keyboard-layout" ''
    #!${pkgs.babashka}/bin/bb

    (let [output (:out (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" "-query"))
          [_ layout] (re-find #"layout: *(\w+)\n" output)
          new-layout (case layout "br" "us" "br")]
      (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" new-layout))
  '';

}
