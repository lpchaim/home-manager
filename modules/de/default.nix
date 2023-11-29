{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkOption {
      description = "Whether to enable desktop environment tweaks.";
      type = types.bool;
      default = (flavor != null);
    };
    flavor = mkOption {
      description = "Which desktop environment to apply customizations to.";
      type = types.nullOr (types.enum [ "gtk" "plasma" ]);
      default = null;
    };
  };

  config = setAttrByPath namespace {
    gtk.enable = (cfg.flavor == "gtk");
  };

  imports = [
    ./gtk/default.nix
  ];
}
