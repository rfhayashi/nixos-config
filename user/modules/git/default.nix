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

  systemd.user.services = {
    import-git-gpg-key = {
      Unit = {
        After = ["sops-nix.service"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.gnupg}/bin/gpg --batch --import ${config.sops.secrets."git/gpg_key".path}
        '';
      };
      Install.WantedBy = ["default.target"];
    };
  };

  home.activation = {
    import-git-gpg-key = lib.hm.dag.entryAfter ["reloadSystemd"] ''
      ${config.systemd.user.systemctlPath} --user restart import-git-gpg-key 
    '';
  };

}
