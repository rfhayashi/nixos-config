{ pkgs, local-pkgs, ...}:
{
  rfhayashi.desktopItems = [
    {
      name = "poweroff";
      exec = pkgs.writeShellScript "poweroff" ''
        ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to power off?' -B 'Yes, power off' 'poweroff'  
      '';
      desktopName = "Power off";
      icon = "${./icons/system-shutdown-svgrepo-com.svg}";
    }
    {
      name = "reboot";
      exec = pkgs.writeShellScript "reboot" ''
        ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to reboot?' -B 'Yes, reboot' 'reboot'
      '';
      desktopName = "Reboot";
      icon = "${./icons/system-reboot-svgrepo-com.svg}";
    }
    {
      name = "logout";
      exec = pkgs.writeShellScript "logout" ''
        ${pkgs.i3}/bin/i3-nagbar -t warning -m 'Do you really want to logout?' -B 'Yes, logout' 'logout'
      '';
      desktopName = "Logout";
      icon = "${./icons/logout-svgrepo-com.svg}";
    }
    {
      name = "suspend";
      exec = local-pkgs.suspend;
      desktopName = "Suspend";
      icon = "${./icons/screen-suspend-svgrepo-com.svg}";
    }
  ];
}
