{ config, ... }: {
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = { };
  sops.secrets."git/sign_ssh_key" = { };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
    settings = {
      user = {
        email = config.metadata.fullname;
        name = config.metadata.email;
      };
      gpg.format = "ssh";
      push.autoSetupRemote = true;
    };
    signing = {
      signByDefault = true;
      key = config.sops.secrets."git/sign_ssh_key".path;
    };
  };

}
