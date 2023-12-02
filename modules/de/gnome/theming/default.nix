{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" "theming" ];
  cfg = getAttrFromPath namespace config;
  toTitle = str: "${lib.toUpper (lib.substring 0 1 str)}${lib.substring 1 (lib.stringLength str) str}";
  catppuccin = {
    variant = "mocha";
    accent = "blue";
  };
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "theming tweaks";
    enableGtkTheme = mkEnableOption "custom GTK theme";
    enableGnomeShellTheme = mkEnableOption "custom GNOME Shell theme";
    enableIconTheme = mkEnableOption "custom icon theme";
    enableCursorTheme = mkEnableOption "custom cursor theme";
    preferDarkTheme = mkEnableOption "prefer-dark-theme flags";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ]
      ++ optional cfg.enableGnomeShellTheme (catppuccin-gtk.override {
      variant = catppuccin.variant;
      accents = [ catppuccin.accent ];
      tweaks = [ "normal" ];
      size = "standard";
    });

    gtk = optionalAttrs cfg.enableGtkTheme
      {
        theme = {
          name = "Catppuccin-${toTitle catppuccin.variant}-Standard-${toTitle catppuccin.accent}-Dark";
          package = pkgs.catppuccin-gtk;
        };
      } // optionalAttrs cfg.enableIconTheme {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    } // optionalAttrs cfg.enableCursorTheme {
      cursorTheme = {
        name = "Catppuccin-Latte-Light-Cursors";
        package = pkgs.catppuccin-cursors.latteLight;
      };
    } // optionalAttrs cfg.preferDarkTheme {
      gtk3.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
      gtk4.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    dconf.settings = optionalAttrs cfg.preferDarkTheme
      {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      } // optionalAttrs cfg.enableGnomeShellTheme {
      "org/gnome/shell/extensions/user-theme" = {
        name = "Catppuccin-${toTitle catppuccin.variant}-Standard-${toTitle catppuccin.accent}-Dark";
      };
    };
  };
}
