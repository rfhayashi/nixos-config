{ lib, config, ... }:
let inherit (lib) mkOption types;
in {
  options = {
    metadata = mkOption {
      type = types.submodule {
        options = {
          username = mkOption { type = types.str; };
          password = mkOption {
            type = types.str;
            default = "";
          };
          homeDir = mkOption {
            default = "/home/${config.metadata.username}";
            type = types.str;
          };
          fullname = mkOption { type = types.str; };
          email = mkOption { type = types.str; };
          clojurePortal = mkOption {
            type = types.submodule {
              options = { version = mkOption { type = types.str; }; };
            };
          };
        };
      };
    };
  };
}
