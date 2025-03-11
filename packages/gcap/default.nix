{ stdenv, fetchzip, makeDesktopItem, copyDesktopItems, openjdk, bash, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcap2025";
  version = "1.1";

  src = fetchzip {
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/2025/gcap/GCAP2025v${finalAttrs.version}.zip";
    sha256 = "sha256-PrtHEwfmAbRyQ7DedB3MLH7mN7tH9eoJSELjvge8rak=";
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
      desktopName = "GCAP 2025";
      genericName = "GCAP 2025";
      icon = ./Logo_Receita_Federal_do_Brasil.svg;
    })
  ];

})
