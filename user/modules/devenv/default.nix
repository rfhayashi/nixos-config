{ pkgs, ...}:

{
  home.packages = with pkgs; [
    devenv
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
