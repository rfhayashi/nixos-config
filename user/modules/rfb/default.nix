{ local-pkgs, metadata, ... }:
{
  home.packages = [ local-pkgs.rfb.gcap local-pkgs.rfb.irpf ];

  services.git-sync = {
    enable = true;
    repositories.rfb = {
      path = "${metadata.home-dir}/ProgramasRFB";
      uri = "git+ssh://git@github.com:/rfhayashi/ProgramasRFB.git";
    };
  };
}
