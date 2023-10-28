{ config, lib, pkgs, ... }:

let
  namespace = (import ../namespace.nix) ++ [ "editors" "neovim" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "neovim";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      programs.neovim = {
        enable = true;
      };
    };
}
