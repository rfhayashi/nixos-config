{ stdenv, fetchzip, makeDesktopItem, copyDesktopItems, openjdk, bash, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcap2024";
  version = "1.2";

  src = fetchzip {
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/2024/gcap/GCAP2024v${finalAttrs.version}.zip";
    sha256 = "sha256-c6JzAnm/fRF9ppc/FYrJCv4zq9mhqln97vf/aTi3scU=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R * $out
    cat <<EOF > $out/bin/gcap
    #! ${bash}/bin/bash
    ${openjdk}/bin/java -Xmx2048M -jar $out/GCAP.jar
    EOF
    chmod +x $out/bin/gcap
    copyDesktopItems
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gcap";
      exec = "gcap";
      desktopName = "GCAP 2024";
      genericName = "GCAP 2024";
    })
  ];

})
