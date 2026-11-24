{ config, pkgs, ... }:
let
  sshDirectory = "${config.home.homeDirectory}/.ssh";
  authenticationKey = "${sshDirectory}/git-authentication.pub";
  signingKey = "${sshDirectory}/git-signing.pub";
in
{
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = { };
  sops.secrets."git/sign_ssh_key" = { };

  services.ssh-agent.enable = true;

  # Graphical applications launched by the user systemd manager need the socket too.
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/ssh-agent";

  systemd.user.services.git-ssh-keys = {
    Unit = {
      Description = "Load Git SSH keys into ssh-agent";
      Requires = [
        "ssh-agent.service"
        "sops-nix.service"
      ];
      After = [
        "ssh-agent.service"
        "sops-nix.service"
      ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "load-git-ssh-keys" ''
        set -eu
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"
        ${pkgs.coreutils}/bin/install -d -m 700 "${sshDirectory}"
        ${pkgs.openssh}/bin/ssh-keygen -y -f ${
          config.sops.secrets."git/ssh_key".path
        } > "${authenticationKey}"
        ${pkgs.openssh}/bin/ssh-keygen -y -f ${
          config.sops.secrets."git/sign_ssh_key".path
        } > "${signingKey}"
        ${pkgs.openssh}/bin/ssh-add ${config.sops.secrets."git/ssh_key".path} ${
          config.sops.secrets."git/sign_ssh_key".path
        }
      '';
    };
    Install.WantedBy = [ "default.target" ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com" = {
      HostName = "github.com";
      IdentityAgent = "SSH_AUTH_SOCK";
      IdentityFile = authenticationKey;
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
      init.defaultBranch = "main";
    };
    signing = {
      signByDefault = true;
      key = signingKey;
    };
  };
}
