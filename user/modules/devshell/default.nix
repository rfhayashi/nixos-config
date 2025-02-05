{ pkgs, devshell-pkgs, ...}:
{
  home.packages = [ devshell-pkgs.default ];
}
