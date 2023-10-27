{ config, pkgs, lib, ... }:
with builtins;
with lib;
let
  defaultClipboard = "clipboard"; # clipboard, primary, secondary
  termBasic = "screen-256color";
  termFull = "xterm-256color";
in
{
  imports = [
    ./tmux-powerline/default.nix
  ];

  home.sessionVariables.TERM = termFull;

  home.packages = with pkgs; [
    xsel
  ];

  programs = {
    fzf.enable = true;
    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      extraConfig =  ''
        # General
        set -g default-terminal '${termBasic}'
        set -ga terminal-overrides ',${termFull}:Tc'
        set -g set-clipboard on

        # Visuals
        set-option -g status-position top

        # Keybinds
        bind-key -n -r C-h select-pane -L
        bind-key -n -r C-j select-pane -D
        bind-key -n -r C-k select-pane -U
        bind-key -n -r C-l select-pane -R

        bind-key -r h resize-pane -L
        bind-key -r j resize-pane -D
        bind-key -r k resize-pane -U
        bind-key -r l resize-pane -R

        bind-key -n M-k next-window
        bind-key -n M-j previous-window

        bind-key v split-window -h
        bind-key s split-window -v

        # Plugins
        bind-key Space thumbs-pick
      '';
      keyMode = "vi";
      mouse = true;
      newSession = true;
      shortcut = "Space";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        better-mouse-mode
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
        (mkTmuxPlugin {
          pluginName = "tmux-powerline";
          version = "v3.0.0";
          rtpFilePath = "main.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "erikw";
            repo = "tmux-powerline";
            rev = "2480e5531e0027e49a90eaf540f973e624443937";
            sha256 = "sha256-25uG7OI8OHkdZ3GrTxG1ETNeDtW1K+sHu2DfJtVHVbk=";
          };
        })
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
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank_action 'copy-pipe' # or 'copy-pipe-and-cancel' for the default
            set -g @yank_selection '${defaultClipboard}'
            set -g @yank_selection_mouse '${defaultClipboard}'
          '';
        }
        {
          plugin = tmux-thumbs;
          extraConfig = let
            pasteCommand = "echo {} | xsel --${defaultClipboard}"; # TODO OS-specific variants, check available tools
          in ''
            bind-key Space thumbs-pick

            set -g @thumbs-command 'tmux set-buffer -- {} && ${pasteCommand} && tmux display-message \"Copied {}\"'
            set -g @thumbs-upcase-command 'tmux set-buffer -- {} && ${pasteCommand} && tmux paste-buffer && tmux display-message \"Copied {}\"'
            set -g @thumbs-osc52 1
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-processes 'hx nano'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
      ];
    };
  };
}
