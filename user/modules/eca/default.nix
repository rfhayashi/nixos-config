{ config, ...}:
{
  sops.secrets."openrouter/api_key" = {};

  home.file.".config/eca/config.json".text = builtins.toJSON {
    defaultProvider = "openai";
    defaultModel = "openai/gpt-6-sol";
    rewrite.model = "openai/gpt-5.5";
    plugins.install = [
      "caveman"
    ];
    providers = {
      openrouter = {
	api = "openai-chat";
	url = "https://openrouter.ai/api/v1";
	key = "\${cmd: cat ${config.sops.secrets."openrouter/api_key".path}}";
      };
    };
  };
}
