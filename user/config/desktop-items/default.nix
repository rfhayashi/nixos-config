{ pkgs, local-pkgs, ...}:
let
  confirm = (name: verb: command:
    pkgs.writeShellScript name ''
      ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to ${verb}?' -B 'Yes, ${verb}' '${command}'
    ''
  );
in
{
  rfhayashi.desktopItems = [
    {
      name = "poweroff";
      exec = confirm "poweroff" "power off" "poweroff";
      desktopName = "Power off";
      icon = ./icons/system-shutdown-svgrepo-com.svg;
    }
    {
      name = "reboot";
      exec = confirm "reboot" "reboot" "reboot";
      desktopName = "Reboot";
      icon = ./icons/system-reboot-svgrepo-com.svg;
    }
    {
      name = "logout";
      exec = confirm "logout" "logout" "logout";
      desktopName = "Logout";
      icon = ./icons/logout-svgrepo-com.svg;
    }
    {
      name = "suspend";
      exec = local-pkgs.suspend;
      desktopName = "Suspend";
      icon = ./icons/screen-suspend-svgrepo-com.svg;
    }
    {
      name = "restart-ulauncher";
      exec = pkgs.writeShellScript "restart-ulauncher" ''
        systemctl --user restart ulauncher
      '';
      desktopName = "Restart Ulauncher";
      icon = ./icons/ulauncher.svg;
    }
    {
      name = "screenshot";
      exec = pkgs.writeShellScript "screenshot" ''
        ${pkgs.gnome-screenshot}/bin/gnome-screenshot --interactive
      '';
      desktopName = "Screenshot";
      icon = ./icons/screenshot-svgrepo-com.svg;
    }
  ];
}
