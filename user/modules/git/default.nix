{ config, ... }: {
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = { };
  sops.secrets."git/sign_ssh_key" = { };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      HostName = "github.com";
      IdentityFile = config.sops.secrets."git/ssh_key".path;
      IdentitiesOnly = true;
      User = "git";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = config.metadata.email;
        name = config.metadata.fullname;
      };
      gpg.format = "ssh";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
    signing = {
      signByDefault = true;
      key = config.sops.secrets."git/sign_ssh_key".path;
    };
  };
}
