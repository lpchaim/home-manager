with import <nixpkgs> {};
mkShell {
  packages = [
    nixd
    nixpkgs-fmt
  ];
}
