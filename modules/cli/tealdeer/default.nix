{ config, lib, pkgs, ... }:

let
  namespace = (import ../namespace.nix) ++ [ "tealdeer" ];
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
      home.packages = [ pkgs.tealdeer ];
      home.file.".config/tealdeer/config.toml".source = ./config.toml;
    };
}
