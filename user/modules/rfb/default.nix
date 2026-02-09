{ pkgs, config, ... }:
{
  home.packages = [ pkgs.rfb.gcap2025 pkgs.rfb.gcap2026 pkgs.rfb.irpf ];

  services.git-sync = {
    enable = true;
    repositories.rfb = {
      path = "${config.metadata.homeDir}/ProgramasRFB";
      uri = "git+ssh://git@github.com:/rfhayashi/ProgramasRFB.git";
    };
  };
}
