{ config, pkgs, ... }:
{
  home.packages = [ pkgs.powerline ];

  programs = {
    direnv.nix-direnv.enable = true;
    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      extraConfig = ''
        source ${pkgs.powerline}/share/tmux/powerline.conf

        set -g default-terminal 'xterm-256color'
        set -ga terminal-overrides ',xterm-256color:Tc'
      '';
      keyMode = "vi";
      mouse = true;
      newSession = true;
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        resurrect
        sensible
        tmux-fzf
        tmux-thumbs
      ];
      shortcut = "a";
      tmuxinator.enable = true;
    };
    zsh.oh-my-zsh.plugins = [ "tmux" ];
  };
}
