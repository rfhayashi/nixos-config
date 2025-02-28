{ pkgs, ... }:
let
  suspend-script = pkgs.writeShellScript "suspend" ''
    systemctl suspend
  '';
in
{
  gcap = pkgs.callPackage ./gcap {};

  poweroff-desktop-item = pkgs.makeDesktopItem {
    name = "poweroff";
    exec = pkgs.writeShellScript "poweroff" ''
      ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to power off?' -B 'Yes, power off' 'poweroff'  
    '';
    desktopName = "Power off";
    icon = "${./icons/system-shutdown-svgrepo-com.svg}";
  };

  reboot-desktop-item = pkgs.makeDesktopItem {
    name = "reboot";
    exec = pkgs.writeShellScript "reboot" ''
      ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to reboot?' -B 'Yes, reboot' 'reboot'
    '';
    desktopName = "Reboot";
    icon = "${./icons/system-reboot-svgrepo-com.svg}";
  };

  logout-desktop-item = pkgs.makeDesktopItem {
    name = "logout";
    exec = pkgs.writeShellScript "logout" ''
      ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to logout?' -B 'Yes, logout' 'logout'
    '';
    desktopName = "Logout";
    icon = "${./icons/logout-svgrepo-com.svg}";
  };

  suspend = suspend-script;

  suspend-desktop-item = pkgs.makeDesktopItem {
    name = "suspend";
    exec = suspend-script;
    desktopName = "Suspend";
    icon = "${./icons/screen-suspend-svgrepo-com.svg}";
  };

  switch-keyboard-layout = pkgs.writeScriptBin "switch-keyboard-layout" ''
    #!${pkgs.babashka}/bin/bb

    (let [output (:out (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" "-query"))
          [_ layout] (re-find #"layout: *(\w+)\n" output)
          new-layout (case layout "br" "us" "br")]
      (shell/sh "${pkgs.xorg.setxkbmap}/bin/setxkbmap" new-layout))
  '';

}
