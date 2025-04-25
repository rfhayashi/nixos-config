{
  imports =
    builtins.map
    (name: ./. + "/${name}")
    (builtins.filter (name: name != "default.nix") (builtins.attrNames (builtins.readDir ./.)));
}
