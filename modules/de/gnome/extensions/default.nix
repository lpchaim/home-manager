{ config, lib, pkgs, ... }:

with lib;
let
  namespace = [ "my" "modules" "de" "gnome" "extensions" ];
  cfg = getAttrFromPath namespace config;
  pre43 = versionOlder pkgs.gnome.gnome-shell.version "43";
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "GNOME Shell extensions";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.gnomeExtensions; [
      dash-to-dock
      tray-icons-reloaded
      user-themes
      vitals
    ] ++ optionals pre43 [
      sound-output-device-chooser
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
          "trayIconsReloaded@selfmade.pl"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "Vitals@CoreCoding.com"
        ] ++ optionals pre43 [
          "sound-output-device-chooser@kgshank.net"
        ];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-fixed = false;
        dock-position = "BOTTOM";
        multi-monitor = true;
        show-apps-at-top = true;
        scroll-action = "cycle-windows";
        custom-theme-shrink = true;
        disable-overview-on-startup = true;
      };
      "org/gnome/shell/extensions/vitals" = {
        show-storage = false;
        show-voltage = false;
        show-memory = false;
        show-fan = false;
        show-temperature = false;
        show-processor = false;
        show-network = false;
      };
    };
  };

  imports = [
    ./dash-to-panel.nix
  ];
}
