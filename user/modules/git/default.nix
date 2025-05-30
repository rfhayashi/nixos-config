{ lib, config, ...}:
{
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = {};
  sops.secrets."git/sign_ssh_key" = {};

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
    userName = config.metadata.fullname;
    userEmail = config.metadata.email;
    extraConfig = {
      gpg.format = "ssh";
      push.autoSetupRemote = true;
    };
    signing = {
      signByDefault = true;
      key = config.sops.secrets."git/sign_ssh_key".path;
    };
  };

}
