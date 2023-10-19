{ config, pkgs, ... }:
{

  programs = {
    direnv.nix-direnv.enable = true;
    tmux = {
      enable = true;
      clock24 = true;
      mouse = true;
      newSession = true;
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        sensible
        tmux-fzf
        tmux-thumbs
        resurrect
      ];
      tmuxinator.enable = true;
    };
    zsh.oh-my-zsh.plugins = [ "tmux" ];
  };
}
