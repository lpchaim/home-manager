{ config, pkgs, ... }:
{
  programs = {
    git = {
      delta.enable = true;
      userEmail = "lpchaim@gmail.com";
      userName = "Lucas Chaim";
    };
    lazygit.enable = true;
  };
}
