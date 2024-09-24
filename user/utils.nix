{ config, pkgs, metadata, ... }:

let
  # TODO delete existing key
  gen-ssh-key = pkgs.writeShellScriptBin "gen-ssh-key" ''
    set -e
    ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -C "${metadata.email}" -f ${metadata.home-dir}/.ssh/id_ed25519 -q -N ""
    if ! ${pkgs.gh}/bin/gh auth status; then
      ${pkgs.gh}/bin/gh auth login
    fi
    ${pkgs.gh}/bin/gh auth refresh -h github.com -s admin:public_key
    ${pkgs.gh}/bin/gh ssh-key add ${metadata.home-dir}/.ssh/id_ed25519.pub -t latitude
  '';
  gpg-script = pkgs.writeTextFile {
    name = "gpg-script";
    text = ''
      Key-Type: 1
      Key-Length: 2048
      Subkey-Type: 1
      Subkey-Length: 2048
      Name-Real: ${metadata.fullname}
      Name-Email: ${metadata.email}
      Expire-Date: 0
    '';
  };
  find-gpg-key-bb = pkgs.writeTextFile {
    name = "find-gpg-key";
    text = ''
     (if-let [key-id (->> (shell/sh "${pkgs.gnupg}/bin/gpg" "--list-keys")
                          :out
                          (re-find #"\w{40}"))]
       (print key-id)
       (System/exit 1))
    '';
  };
  find-gpg-key = pkgs.writeShellScriptBin "find-gpg-key" ''
    ${pkgs.babashka}/bin/bb ${find-gpg-key-bb}
  '';
  # TODO delete existing key
  gen-gpg-key = pkgs.writeShellScriptBin "gen-gpg-key" ''
    set -e
    if ${find-gpg-key}/bin/find-gpg-key > /dev/null; then
      echo "Delete the current key before generating a new one"
      exit 1
    fi
    ${pkgs.gnupg}/bin/gpg --batch --gen-key ${gpg-script}
    temp_file=$(${pkgs.coreutils}/bin/mktemp)
    gpg --armor --export $(${find-gpg-key}/bin/find-gpg-key) > $temp_file
    if ! ${pkgs.gh}/bin/gh auth status; then
      ${pkgs.gh}/bin/gh auth login
    fi
    ${pkgs.gh}/bin/gh auth refresh -h github.com -s write:gpg_key
    ${pkgs.gh}/bin/gh gpg-key add $temp_file -t latitude
  '';
  in
{
  home.packages = [ gen-ssh-key gen-gpg-key switch-keyboard-layout ];
}
