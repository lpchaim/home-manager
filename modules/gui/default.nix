{ config, lib, ... }:

with lib;
let
  namespace = [ "my" "modules" "gui" ];
  cfg = getAttrFromPath namespace config;
in
{
  options = setAttrByPath namespace {
    enable = mkEnableOption "gui apps";
  };

  config = mkIf cfg.enable (setAttrByPath namespace
    {
      firefox.enable = mkDefault true;
    } // {
    xdg.mime.enable = true;
    xdg.systemDirs.data = [
      "${config.home.homeDirectory}/.nix-profile/share/applications"
    ];
  });

  imports = [
    ./firefox.nix
  ];
}
