{ pkgs, ... }:
let mkt-pkgs = pkgs.vscode-marketplace;
in {
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
      extensions = [
        mkt-pkgs.ryanolsonx.zenburn
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.vspacecode.whichkey
        pkgs.vscode-extensions.vspacecode.vspacecode
        mkt-pkgs.shadowndacorner.vscode-easymotion
        mkt-pkgs.kahole.magit
        mkt-pkgs.jnoortheen.nix-ide
      ];
    };
  };
}
