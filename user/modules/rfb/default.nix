{ local-pkgs, metadata, ... }:
{
  home.packages = [ local-pkgs.gcap ];

  services.git-sync = {
    enable = true;
    repositories.rfb = {
      path = "${metadata.home-dir}/ProgramasRFB";
      uri = "git+ssh://git@github.com:/rfhayashi/ProgramasRFB.git";
    };
  };
}
