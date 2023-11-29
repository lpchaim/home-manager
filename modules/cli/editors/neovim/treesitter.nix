{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        incrementalSelection = {
          enable = true;
          # keymaps = {
          #   initSelection = "<A-o>";
          #   nodeDecremental = "<A-i>";
          #   nodeIncremental = "<A-o>";
          # };
        };
        moduleConfig = {
          node_movement = {
            enable = true;
            keymaps = {
              move_up = "<a-o>";
              move_down = "<a-i>";
              move_left = "<a-u>";
              move_right = "<a-p>";
              # swap_left = "<s-a-h>"; # will only swap when one of "swappable_textobjects" is selected
              # swap_right = "<s-a-l>";
              # select_current_node = "<leader><Cr>";
            };
            # swappable_textobjects = {'@function.outer', '@parameter.inner', '@statement.outer'};
            allow_switch_parents = true; # more craziness by switching parents while staying on the same level, false prevents you from accidentally jumping out of a function
            allow_next_parent = true; # more craziness by going up one level if next node does not have children
          };
        };
      };
      # treesitter-context.enable = true;
      # treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; with pkgs.vimUtils; [
      (buildVimPlugin {
        pname = "crazy-node-movement";
        version = "2023-09-02";
        src = pkgs.fetchFromGitHub {
          owner = "theHamsta";
          repo = "crazy-node-movement";
          rev = "d5cf01cc44c5715501d3d6fe439af7c8b7fa5df2";
          sha256 = "sha256-hQcQEp39zFN2zphMfcr97yRVcuHhBsSkzKO7XNloDpQ=";
        };
        meta.homepage = "https://github.com/theHamsta/crazy-node-movement";
      })
    ];
  };
}
