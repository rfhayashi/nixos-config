{ pkgs, ...}:

{
  home.packages = with pkgs; [
    direnv
    devenv
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
  };
}
