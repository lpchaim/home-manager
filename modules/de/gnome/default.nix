{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "GTK/GNOME Shell customizations";
    enableTheming = mkOption {
      description = "Whether to enable theming tweaks.";
      type = types.bool;
      default = true;
    };
    enableTheme = mkOption {
      description = "Whether to set custom theme.";
      type = types.bool;
      default = cfg.enableTheming;
    };
    enableIconTheme = mkOption {
      description = "Whether to set custom icon theme.";
      type = types.bool;
      default = cfg.enableTheming;
    };
    enableCursorTheme = mkOption {
      description = "Whether to set custom cursor theme.";
      type = types.bool;
      default = cfg.enableTheming;
    };
    preferDarkTheme = mkOption {
      description = "Set prefer-dark-theme flag.";
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = mkIf cfg.enableTheme {
        name = "colloid-gtk-theme";
        package = pkgs.colloid-gtk-theme;
      };
      iconTheme = mkIf cfg.enableIconTheme {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = mkIf cfg.enableCursorTheme {
        name = "Breeze_Snow";
        package = pkgs.libsForQt5.breeze-icons;
      };
      gtk3.extraConfig = mkIf cfg.preferDarkTheme {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = mkIf cfg.preferDarkTheme {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
