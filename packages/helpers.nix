{ pkgs }:
{
  desktopItem = item: pkgs.stdenv.mkDerivation {
    name = item.name;
    src = ./.;
    nativeBuildInputs = [pkgs.copyDesktopItems];
    desktopItems = [
      (pkgs.makeDesktopItem item)
    ];
    installPhase = ''
      copyDesktopItems
    '';
  };
}
