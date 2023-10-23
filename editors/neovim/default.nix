{ config, pkgs, ... }:

{
  imports = [
    ./lunarvim/default.nix
  ];

  programs = {
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        plenary-nvim
        mini-nvim
        # (fromGitHub "HEAD" "elihunter173/dirbuf.nvim")
      ];
    };
  };
}
