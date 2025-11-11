{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
      keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
      extensions = [
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.vspacecode.whichkey
        pkgs.vscode-extensions.vspacecode.vspacecode
	pkgs.vscode-marketplace.shadowndacorner.vscode-easymotion
      ];
    };
  };
}
