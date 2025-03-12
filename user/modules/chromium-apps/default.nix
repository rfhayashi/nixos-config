{ lib, config, pkgs, ...}:
let
  inherit (lib) mkOption types;
  cfg = config.rfhayashi;
  chromiumApp = types.submodule {
    options = {
      url = mkOption {
        type = types.str;
      };
      desktopName = mkOption {
        type = types.str;
      };
      icon = mkOption {
        type = types.path;
      };
    };
  };
  appPackages = (id : { url, desktopName, icon, ... }:
    let
      package = pkgs.writeShellScriptBin id ''
       ${pkgs.chromium}/bin/chromium --app="${url}"
      '';
      desktopItem = pkgs.makeDesktopItem {
        name = id;
        exec = "${package}/bin/${id}";
        inherit desktopName icon;
      };
    in
      [ package desktopItem ]);
in
{
  options.rfhayashi.chromiumApps = mkOption {
    type = types.attrsOf chromiumApp;
    default = [];
  };

  config = {
    home.packages = lib.flatten (lib.mapAttrsToList appPackages cfg.chromiumApps);
  };
}
