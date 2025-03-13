{ lib, config, pkgs, ...}:
let
  inherit (lib) mkOption types;
  cfg = config.rfhayashi;
  #  wmctrl -l -x | mlr --ojson --ifs-regex="\s+" put '$id=$1; $desktop=$2; $class=$3' then cut -f id,desktop,class
  startOrScratchpad = (instance: executable: pkgs.writeScript "start-or-scratchpad" ''
    #!${pkgs.babashka}/bin/bb
    (require '[babashka.process :as process])

    (let [[instance executable] ["${instance}" "${executable}"]]
      (let [win-output (:out (process/shell {:out :string} "wmctrl -l -x"))
            win-lines (str/split-lines win-output)
            win-data (fn [line]
                       (let [[id desktop class] (str/split line #"\s+")]
                         {:id id :desktop desktop :class class}))
            windows (map win-data win-lines)
            window? (fn [{:keys [class]}]
                      (and (re-find (re-pattern instance) class)
                           (re-find #"Chromium-browser" class)))
            [{:keys [id desktop] :as win}] (filter window? windows)]
        (if win
          (if (= desktop = "-1")
            (process/shell "${pkgs.i3}/bin/i3-msg" (format "[id=\"%s\"] scratchpad show" id))
            (process/shell "${pkgs.i3}/bin/i3-msg" (format "[id=\"%s\"] focus" id)))
          (process/shell executable))))
  '');
  chromiumApp = types.submodule {
    options = {
      appHost = mkOption {
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
  appPackage = (id : { appHost, desktopName, icon, ... }:
    let
      executable = pkgs.writeShellScript id ''
       ${pkgs.chromium}/bin/chromium --app="https://${appHost}"
      '';
      exec = startOrScratchpad appHost executable;
      desktopItem = pkgs.makeDesktopItem {
        name = id;
        inherit exec desktopName icon;
      };
    in
      desktopItem);
in
{
  options.rfhayashi.chromiumApps = mkOption {
    type = types.attrsOf chromiumApp;
    default = [];
  };

  config = {
    home.packages = (lib.mapAttrsToList appPackage cfg.chromiumApps);
  };
}
