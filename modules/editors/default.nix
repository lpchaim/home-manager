{ config, lib, pkgs, ... }:

let
  common = import ../common.nix;
  namespace = common.namespace ++ [ "editors" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "custom modules";
    kakoune.enable = lib.mkEnableOption "kakoune";
    vim.enable = lib.mkEnableOption "vim";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      programs = {
        kakoune.enable = cfg.kakoune.enable;
        vim.enable = cfg.vim.enable;
      };
    };
  
  imports = [
    ./helix.nix
    ./neovim.nix
  ];
}
