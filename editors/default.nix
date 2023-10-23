{ config, pkgs, ... }:
{
  imports = [
    ./helix.nix
    ./neovim.nix
  ];

  programs = {
    kakoune.enable = true;
    vim.enable = true;
  };
}
