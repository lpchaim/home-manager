{ config, pkgs, lib, ... }:

with builtins;
with lib;
{
  home.packages = [ pkgs.powerline ];

  programs = {
    fzf.enable = true;
    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      extraConfig =  ''
        source ${pkgs.powerline}/share/tmux/powerline.conf

        set -g default-terminal 'xterm-256color'
        set -ga terminal-overrides ',xterm-256color:Tc'

        bind-key space next-window
        bind-key bspace previous-window
        bind-key enter next-layout

        bind-key v split-window -h
        bind-key s split-window -v
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R
      '';
      keyMode = "vi";
      mouse = true;
      newSession = true;
      shortcut = "a";
      tmuxinator.enable = true;
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
          '';
        }
        resurrect
        sensible
        tmux-fzf
        (mkTmuxPlugin {
          pluginName = "tmux-menus";
          version = "unstable-2023-10-20";
          rtpFilePath = "menus.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "jaclu";
            repo = "tmux-menus";
            rev = "764ac9cd6bbad199e042419b8074eda18e9d8b2d";
            sha256 = "sha256-tPUUaMASG/DtqxyN2VwCKPivYZkwVKjIScI99k6CJv8=";
          };
        })
        tmux-thumbs
        {
          plugin = vim-tmux-navigator;
          extraConfig = ''
            # Smart pane switching with awareness of Vim splits.
            # See: https://github.com/christoomey/vim-tmux-navigator
            is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
                | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
            bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
            bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
            bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
            tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
            if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
            if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
                "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

            bind-key -T copy-mode-vi 'C-h' select-pane -L
            bind-key -T copy-mode-vi 'C-j' select-pane -D
            bind-key -T copy-mode-vi 'C-k' select-pane -U
            bind-key -T copy-mode-vi 'C-l' select-pane -R
            bind-key -T copy-mode-vi 'C-\' select-pane -l
          '';
        }
        yank
      ];
    };
  };
}
