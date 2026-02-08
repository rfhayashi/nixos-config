{ pkgs }:
let
  rfbProgram = { name, year, version, jarName, url, sha256, desktopName }:
    pkgs.stdenv.mkDerivation {
      pname = "${name}-${year}";
      inherit version;

      src = pkgs.fetchzip {
        inherit url sha256;
      };

      nativeBuildInputs = [ pkgs.copyDesktopItems ];

      installPhase = ''
        runHook preInstall
        mkdir $out
        mkdir $out/bin
        mkdir $out/${name}
        cp -R * $out/${name}
        cat <<EOF > $out/bin/${name}
        #! ${pkgs.bash}/bin/bash
        ${pkgs.jdk17}/bin/java -Xmx2048M -jar $out/${name}/${jarName}.jar
        EOF
        chmod +x $out/bin/${name}
        copyDesktopItems
        runHook postInstall
      '';

      desktopItems = [
        (pkgs.makeDesktopItem {
          inherit name;
          desktopName = "${desktopName} ${year}";
          exec = name;
          icon = ./icons/Logo_Receita_Federal_do_Brasil.svg;
        })
      ];
    };
in
{
  gcap2024 = rfbProgram rec {
    name = "gcap2024";
    year = "2024";
    version = "1.6";
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/gcap/GCAP${year}v${version}.zip";
    sha256 = "sha256-XMFnJhtpAw1KojPI4l2BOsrtXcVygcEgAz37hucxRb4=";
    jarName = "GCAP";
    desktopName = "GCAP";
  };

  gcap2025 = rfbProgram rec {
    name = "gcap2025";
    year = "2025";
    version = "1.4";
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/gcap/GCAP${year}v${version}.zip";
    sha256 = "sha256-PrtHEwfmAbRyQ7DedB3MLH7mN7tH9eoJSELjvge8rak=";
    jarName = "GCAP";
    desktopName = "GCAP";
  };
  
  gcap2026 = rfbProgram rec {
    name = "gcap2026";
    year = "2026";
    version = "1.0";
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/gcap/GCAP${year}v${version}.zip";
    sha256 = "sha256-0HHrj5AYlp2QCSYXrLP6HU1ZX9szMSE+yXfgfm5n1Sc=";
    jarName = "GCAP";
    desktopName = "GCAP";
  };

  irpf = rfbProgram rec {
    name = "irpf";
    year = "2025";
    version = "1.3";
    url = "https://downloadirpf.receita.fazenda.gov.br/irpf/${year}/irpf/arquivos/IRPF${year}-${version}.zip";
    sha256 = "sha256-BWCxnKPvkijVkXfbA1iVbdcgLZqY5SAzASqnzdjXwiw=";
    jarName = name;
    desktopName = "IRPF";
  };
}
