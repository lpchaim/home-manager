{ config, lib, pkgs, ... }:

let
  common = import ../common.nix;
  namespace = common.namespace ++ [ "editors" "neovim" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "helix";
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
