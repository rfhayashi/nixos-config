{ pkgs, ...}:
let
  # TODO move this to github:rfhayashi/devshells
  devshell = pkgs.writeShellScriptBin "devshell" ''
    if [ ! -f .envrc ]; then
      echo "use flake \"github:rfhayashi/devshells?dir=$1\"" >> .envrc
      direnv allow
      echo ".direnv/" >> .git/info/exclude
      echo ".envrc" >> .git/info/exclude
    else
      echo ".envrc already exists"
      exit 1
    fi
  '';
in
{
  home.packages = [ devshell ];
}
