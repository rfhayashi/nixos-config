{ pkgs, ... }:
let
  poweroff-script = pkgs.writeShellScriptBin "poweroff" ''
    ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to power off?' -B 'Yes, power off' 'poweroff'  
  '';
in
rec {
  helpers = (import ./helpers.nix) { inherit pkgs; };

  gcap = pkgs.callPackage ./gcap {};

  poweroff = helpers.desktopItem {
    name = "poweroff";
    exec = "${poweroff-script}/bin/poweroff";
    desktopName = "Power off";
  };

  switch-keyboard-layout = pkgs.writeScriptBin "switch-keyboard-layout" ''
    #!${pkgs.babashka}/bin/bb

    (let [output (:out (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" "-query"))
          [_ layout] (re-find #"layout: *(\w+)\n" output)
          new-layout (case layout "br" "us" "br")]
      (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" new-layout))
  '';

}
