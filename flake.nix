# Based on https://flyx.org/nix-flakes-latex/
{
  description = "LaTeX Document Demo";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small 
          
          latex-uni8 # replaces fontenc I think
          # textcomp

          newtx
          cabin
          inconsolata
          babel
          mathtools # amsmath
          geometry
          mathalpha

          # sans math as text
          libertine
          libertinus-type1
          libgreek
          mathastext
          # Resolving "No file LGRcmr.fd."
          # https://github.com/tud-cd/tudscr/issues/41
          babel-greek
          greek-fontenc
          cbfonts

          latex-bin 
          latexmk

          # manual dependencies

          fontaxes
          xkeyval
          etoolbox
          xstring
          fontspec
          microtype
          blindtext
          upquote
          metafont
          tex-gyre # missing tfm
          txfonts # missing tfm
          times # missing utmri8a.pfb

          # own
          enumitem
          biblatex
          caption
          titlesec # section styling
          xcolor # for TO DOs
          # graphicx # already included
          ;
      };
    in rec {
      packages = {
        document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-demo-document";
          src = self;
          buildInputs = [ pkgs.coreutils tex pkgs.biber pkgs.kile ];
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            # Trick from here:
            # https://brianbuccola.com/use-biblatex-biber-to-create-a-new-subdatabase-based-on-an-auxiliary-file/
            # allows only tracking the needed bibliography
            cp document_biber.bib my_library.bib
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              # latexmk -interaction=nonstopmode -pdf -lualatex \ 
              ## issue here with font metric building 
              ## described in https://tex.stackexchange.com/questions/287312/font-not-loadable-metric-data-not-found-or-bad
              ##
              ## Needed to adjust VSCode LaTex plugin to handle this.
            latexmk -interaction=nonstopmode -pdf -pdflatex \
              document.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp document.* $out/
          '';
        };
      };
      defaultPackage = packages.document;
    });
}
