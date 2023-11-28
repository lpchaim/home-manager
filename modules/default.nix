{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "customizations";
  };

  config = setAttrByPath namespace (mkIf cfg.enable  {
    cli.enable = true;
    de.flavor = null;
  });

  imports = [
    ./cli/default.nix
    ./de/default.nix
  ];
}
