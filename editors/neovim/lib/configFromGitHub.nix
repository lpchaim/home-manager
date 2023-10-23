let
  pkgs = import <nixpkgs> {};
in
with pkgs.lib;

repo: ref: cleanSource (
  builtins.fetchGit {
    url = "https://github.com/${repo}.git";
    inherit ref;
  }
)