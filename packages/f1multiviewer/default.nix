{ lib, pkgs }:
let
  multiviewerZip = pkgs.runCommand "multiviewer" {
    buildInputs = [ pkgs.unzip ];
    zip_file = pkgs.fetchurl {
      url = "https://releases.multiviewer.app/download/490012941/MultiViewer-linux-x64-2.8.3.zip";
      hash = "sha256-Aupaw1q5xXL7f/Mrpivkw8XKkL++3smC/LhyEAzxqkg=";
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
    ${lib.getExe multiviewerEnv} --ozone-platform=x11 "$@"
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
