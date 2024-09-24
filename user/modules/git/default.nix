{ lib, config, pkgs, metadata, ...}:
{
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = {};
  sops.secrets."git/gpg_key" = {};

  programs.ssh = {
    enable = true;
    matchBlocks.github = {
      host = "github.com";
      hostname = "github.com";
      identityFile = config.sops.secrets."git/ssh_key".path;
      identitiesOnly = true;
      user = "git";
    };
  };

  programs.git = {
    enable = true;
    userName = metadata.fullname;
    userEmail = metadata.email;
    signing = {
      signByDefault = true;
      key = metadata.email;
    };
  };

  home.activation = {
    importGitGpgKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.gnupg}/bin/gpg --batch --import ${config.sops.secrets."git/gpg_key".path}
    '';
  };

}
