{
  home.file.".config/eca/config.json".text = builtins.toJSON {
    defaultProvider = "github-copilot";
    defaultModel = "github-copilot/gpt-5.3-codex";
    rewrite.model = "github-copilot/gpt-5.3-codex";
    plugins.install = [
      "caveman"
    ];
  };
}
