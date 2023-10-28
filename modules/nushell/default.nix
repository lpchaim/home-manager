{ config, lib, pkgs, ... }:

let
  common = import ../common.nix;
  namespace = common.namespace ++ [ "nushell" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "nushell";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      programs.nushell = {
        enable = true;
        configFile.text = "";
        envFile.text = "";
        extraConfig = (builtins.readFile ./config.nu);
        extraEnv = (builtins.readFile ./env.nu);
      };
    };
}
