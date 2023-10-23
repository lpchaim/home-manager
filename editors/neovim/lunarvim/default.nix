{ config, pkgs, ... }:
let
  # configFromGitHub = import ../lib/configFromGitHub.nix;
  # pluginFromGitHub = import ../lib/pluginFromGitHub.nix;
in {
  home.file."${config.xdg.configHome}/nvim" = {
    source = ./config;
    recursive = true;
  };
  home.file."${config.xdg.configHome}/nvim/lua/config/options.lua".text = ''
    config.performance.reset_packpath = false
  '';
}