with import <nixpkgs> { };
mkShell {
  buildInputs = [
    nil
    nixd
    nixpkgs-fmt
    pre-commit
    rnix-lsp
  ];
  shellHook = ''
    export LC_ALL="C.UTF-8"
    pre-commit
  '';
}
