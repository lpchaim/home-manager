{ config, lib, pkgs, ... }:

let
  namespace = (import ../namespace.nix) ++ [ "editors" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "editors";
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
