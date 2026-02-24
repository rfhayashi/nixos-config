{ pkgs, ...}:

{
  home.packages = with pkgs; [
    devenv
    nil
    nixfmt-classic
    claude-code
    codex
    inetutils
  ];

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };
}
