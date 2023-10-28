{ config, pkgs, ... }:
{
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
      };
      userEmail = "lpchaim@gmail.com";
      userName = "Lucas Chaim";
    };
    lazygit.enable = true;
  };
}
