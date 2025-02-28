{ lib, config, pkgs, metadata, ...}:
let
  import-git-gpg-key = pkgs.writeShellScriptBin "import" ''
    ${pkgs.sops}/bin/sops --decrypt ${../../../secrets.yaml} \
       | ${pkgs.yq}/bin/yq -r .git.gpg_key \
       | ${pkgs.gnupg}/bin/gpg --batch --import
  '';
in
{
  programs.gh.enable = true;

  sops.secrets."git/ssh_key" = {};

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
    import-git-gpg-key = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${import-git-gpg-key}/bin/import
    '';
  };

}
