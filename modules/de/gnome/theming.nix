{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" "theming" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "theming tweaks";
    enableGtkTheme = mkEnableOption "custom GTK theme";
    enableIconTheme = mkEnableOption "custom icon theme";
    enableCursorTheme = mkEnableOption "custom cursor theme";
    preferDarkTheme = mkEnableOption "prefer-dark-theme flags";
  };

  config = mkIf cfg.enable {
    gtk = optionalAttrs cfg.enableIconTheme
      {
        theme = mkIf cfg.enableIconTheme {
          name = "colloid-gtk-theme";
          package = pkgs.colloid-gtk-theme;
        };
      } // optionalAttrs cfg.enableCursorTheme {
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
    } // optionalAttrs cfg.preferDarkTheme {
      gtk3.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
      gtk4.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    dconf.settings = optionalAttrs cfg.preferDarkTheme {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
