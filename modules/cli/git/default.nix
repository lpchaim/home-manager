{ config, lib, pkgs, ... }:

let
  namespace = (import ../namespace.nix) ++ [ "git" ];
in
{
  options = lib.setAttrByPath namespace {
    enable = lib.mkEnableOption "git";
    lazygit.enable = lib.mkEnableOption "lazygit";
  };

  config =
    let
      cfg = lib.getAttrFromPath namespace config;
    in
    lib.mkIf cfg.enable {
      programs = {
        git = {
          enable = true;
          delta.enable = true;
          extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = false;
          };
          userEmail = "lpchaim@gmail.com";
          userName = "Lucas Chaim";
        };
        lazygit.enable = lib.mkIf cfg.lazygit.enable true;
      };
    };
}
