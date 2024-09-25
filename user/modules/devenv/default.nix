{ pkgs, ...}:

{
  home.packages = with pkgs; [
    devenv
    nil
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
