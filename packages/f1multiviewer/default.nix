{ lib, pkgs }:
let
  multiviewerZip = pkgs.runCommand "multiviewer" {
    buildInputs = [ pkgs.unzip ];
    zip_file = pkgs.fetchurl {
      url =
        "https://releases.multiviewer.app/download/409384259/MultiViewer-linux-x64-2.7.2.zip";
      hash = "sha256-SuCi/HM+WZAf80kL09ypRalshG32pszhK4sh/o9ZIOw=";

    };

  } ''
    unzip $zip_file
    mv MultiViewer-linux-x64 $out
  '';
  multiviewerEnv = pkgs.buildFHSEnv {
    name = "multiviewer";
    targetPkgs = pkgs: [
      pkgs.glib
      pkgs.nspr
      pkgs.nss
      pkgs.dbus
      pkgs.atk
      pkgs.cups
      pkgs.cairo
      pkgs.gtk3
      pkgs.pango
      pkgs.libx11
      pkgs.libxcomposite
      pkgs.libxdamage
      pkgs.libxext
      pkgs.libxfixes
      pkgs.libxrandr
      pkgs.libgbm
      pkgs.expat
      pkgs.libxcb
      pkgs.libxkbcommon
      pkgs.libudev-zero
      pkgs.alsa-lib
    ];
    runScript = "${multiviewerZip}/multiviewer";
  };
  multiviewer = pkgs.writeShellScript "multiviewer" ''
    ${lib.getExe multiviewerEnv} "$@"
  '';
in pkgs.runCommand "multiviewer" {
  nativeBuildInputs = [ pkgs.copyDesktopItems ];
  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "multiviewer";
      desktopName = "Multiviewer";
      exec = "multiviewer";
      icon = ./icon.png;
    })
  ];
} ''
  mkdir -p $out/bin
  cp ${multiviewer} $out/bin/multiviewer
  copyDesktopItems
''
