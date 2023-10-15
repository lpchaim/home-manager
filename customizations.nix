{ config, pkgs, ... }:
{
  imports = [
    ./editors/module.nix
    ./essentials/module.nix
    ./git/module.nix
    ./nushell/module.nix
    ./starship/module.nix
    ./tealdeer/module.nix
    ./zsh/module.nix
  ];
}
