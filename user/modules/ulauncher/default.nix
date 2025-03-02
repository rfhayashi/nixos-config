{ pkgs, ... }:
let
  adwaita-darkish = pkgs.fetchFromGitHub {
    owner = "shepda";
    repo = "ulauncher-adwaita-darkish";
    rev = "bac72db6c23eea1f9beaf2186c7cd537fee9cbe6";
    sha256 = "sha256-iN2vTFU+ytCzHlj8p3UU0N4VUypMIc68+gKP1Qcj7/w=";
  };
in
{
  home.file.".config/ulauncher/user-themes/ulauncher-adwaita-darkish/manifest.json".source = adwaita-darkish + "/manifest.json";
  home.file.".config/ulauncher/user-themes/ulauncher-adwaita-darkish/theme.css".source = adwaita-darkish + "/theme.css";
  home.file.".config/ulauncher/user-themes/ulauncher-adwaita-darkish/theme-gtk-3.20.css".source = adwaita-darkish + "/theme-gtk-3.20.css";
  home.file.".config/ulauncher/settings.json".text = ''
    {
      "clear-previous-query": true,
      "disable-desktop-filters": false,
      "grab-mouse-pointer": false,
      "hotkey-show-app": "<Alt>p",
      "render-on-screen": "mouse-pointer-monitor",
      "show-indicator-icon": true,
      "show-recent-apps": "0",
      "terminal-command": "",
      "theme-name": "Adwaita Darkish"
    }
  '';

  systemd.user.services = {
    ulauncher = {
      Unit = {
        Description = "Ulauncher service";
        Documentation = ["https://ulauncher.io/"];
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      };
    };
  };
}
