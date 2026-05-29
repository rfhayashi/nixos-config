{ pkgs, ... }:
let
  makeTheme =
    placeholder:
    pkgs.writeText "rofi-theme-${pkgs.lib.strings.sanitizeDerivationName placeholder}.rasi" ''
      @theme "${./zenburn.rasi}"

      entry {
        placeholder: "${placeholder}";
      }
    '';

  drunTheme = makeTheme "Search applications";
  applicationsLauncher = pkgs.writeShellApplication {
    name = "app-launcher";
    runtimeInputs = [ pkgs.rofi ];
    text = ''
      exec rofi -show drun -show-icons -theme ${drunTheme} "$@"
    '';
  };
in
{
  home.packages = [
    applicationsLauncher
  ];
}
