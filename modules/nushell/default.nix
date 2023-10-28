{ config, lib, pkgs, ... }:

let
  namespace = (import ../namespace.nix) ++ [ "nushell" ];
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
