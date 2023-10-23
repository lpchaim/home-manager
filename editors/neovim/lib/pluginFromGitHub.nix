{ repo, ref ? "HEAD" }:

let
  pkgs = import <nixpkgs> {};
in
with pkgs.lib;
pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = lib.cleanSource (
      builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        inherit ref;
      }
    );
  }