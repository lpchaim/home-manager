{ config, pkgs, ... }:
{
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
