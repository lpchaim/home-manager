{ config, lib, pkgs, ... }:

let
  namespace = import ./namespace.nix;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "custom modules";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      modules.custom = {
        editors = {
          enable = lib.mkDefault true;
          helix.enable = lib.mkDefault true;
          kakoune.enable = lib.mkDefault true;
          neovim.enable = lib.mkDefault true;
          vim.enable = lib.mkDefault true;
        };
        essentials.enable = lib.mkDefault true;
        git = {
          enable = lib.mkDefault true;
          lazygit.enable = lib.mkDefault true;
        };
        nushell.enable = lib.mkDefault true;
        starship.enable = lib.mkDefault true;
        tealdeer.enable = lib.mkDefault true;
        tmux.enable = lib.mkDefault true;
        zsh.enable = lib.mkDefault true;
      };
    };

  imports = [
    ./editors/default.nix
    ./essentials/default.nix
    ./git/default.nix
    ./nushell/default.nix
    ./starship/default.nix
    ./tealdeer/default.nix
    ./tmux/default.nix
    ./zsh/default.nix
  ];
}
