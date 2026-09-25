{
  home.file.".config/eca/config.json".text = builtins.toJSON {
    defaultProvider = "openai";
    defaultModel = "openai/gpt-6-sol";
    rewrite.model = "openai/gpt-5.5";
    plugins.install = [
      "caveman"
    ];
  };
}
