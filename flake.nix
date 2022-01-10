{
  description = "Preliminary research paper to fulfill UMD physics PhD requirement.";

  inputs = {
    nixpkgs-pointer.url = "github:yipengsun/nixpkgs-pointer";
    nixpkgs.follows = "nixpkgs-pointer/nixpkgs";
    flake-utils.follows = "nixpkgs-pointer/flake-utils";
  };

  outputs = { self, nixpkgs-pointer, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; } {
          name = "umd_phd_candidacy_paper";
          buildInputs = [
            (pkgs.texlive.combine {
              inherit (pkgs.texlive)
                scheme-basic
                # Explicit dependencies
                latexmk
                biber
                geometry
                fontspec
                microtype
                siunitx
                float
                titlesec
                textcase
                booktabs
                placeins
                cleveref
                biblatex
                preprint  # <- authblk
                ;
            })
          ];

          shellHook = ''
            export TEXMFHOME=.cache
            export TEXMFVAR=.cache/texmf-var

            # Fix date problem for LuaLaTeX
            export SOURCE_DATE_EPOCH=$(date -d "2019-09-24" +%s)
          '';
        };
      });
}
