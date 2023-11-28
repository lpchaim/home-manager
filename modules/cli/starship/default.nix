args@{ config, lib, pkgs, ... }:

with lib;
let
  namespace = (import ../namespace.nix) ++ [ "starship" ];
  settings = import ./settings.nix;
  util = import ./util.nix args;
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "starship";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      programs.starship = {
        enable = true;
        settings =
          let
            tomlContents = util.getPresetFiles [ "nerd-font-symbols" ];
            allSettings = (map (fromTOML) tomlContents) ++ [ settings ];
            mergedSettings = builtins.foldl' (l: r: pkgs.lib.recursiveUpdate l r) { } allSettings;
          in
          mergedSettings;
      };
    };
}
