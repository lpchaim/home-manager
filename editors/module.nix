{ config, pkgs, ... }:
{
  imports = [
    ./helix.nix
    ./neovim/default.nix
  ];

  programs = {
    kakoune.enable = true;
    vim.enable = true;
  };
}
