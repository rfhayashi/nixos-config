{ pkgs, ...}:

{
  home.packages = with pkgs; [
    devenv
    nil
    nixfmt-classic
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
