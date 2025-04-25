{ pkgs, config, ... }:
{
  home.packages = [ pkgs.rfb.gcap2024 pkgs.rfb.gcap pkgs.rfb.irpf ];

  services.git-sync = {
    enable = true;
    repositories.rfb = {
      path = "${config.metadata.homeDir}/ProgramasRFB";
      uri = "git+ssh://git@github.com:/rfhayashi/ProgramasRFB.git";
    };
  };
}
