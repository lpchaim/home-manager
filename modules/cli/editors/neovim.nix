{ config, lib, pkgs, ... }:

let
  namespace = [ "modules" "cli" "editors" "neovim" ];
  cfg = lib.getAttrFromPath namespace config;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    };
  };
}
