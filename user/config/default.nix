{ ... }:
{
  imports =
    builtins.map
    (name: ./. + "/${name}")
    (builtins.filter
      (name:
        (builtins.readDir ./.).${name} == "directory"
        && builtins.pathExists (./. + "/${name}/default.nix"))
      (builtins.attrNames (builtins.readDir ./.)));
}
