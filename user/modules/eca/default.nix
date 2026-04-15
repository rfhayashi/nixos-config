{
  home.file.".config/eca/config.json".text = builtins.toJSON {
    defaultProvider = "github-copilot";
    defaultModel = "github-copilot/claude-opus-4.6";
    rewrite.model = "github-copilot/claude-sonnet-4.6";
    plugins.install = [
      "caveman"
    ];
  };
}
