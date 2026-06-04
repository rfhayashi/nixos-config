{
  home.file.".config/eca/config.json".text = builtins.toJSON {
    defaultProvider = "openai";
    defaultModel = "openai/gpt-5.5";
    rewrite.model = "openai/gpt-5.5";
    plugins.install = [
      "caveman"
    ];
  };
}
