### How to use this template

This template is set up so that

-   The development environment is hermetic using Nix flakes.
-   VSCode is used for editing and building the document.
-   One can use a "mega-bibliography" (e.g. all of one's Zotero references in a
    `.bib` file).
    A smaller `.bib` file is created with paper-specific references.

The mega-bibliography is not version controlled.
This means it can't be seen by the flake, or by `nix build` for example.
To get around this impurity, I currently use the following ugly system:

-   First, I create a link `my_library.bib` to my mega-bibliography in the root directory.
-   VSCode builds into `result_dev/`
-   Running `update_paper_bib.sh` takes the compiled `.bcf` file of references from the `result_dev/` build and creates a BibTeX file `document_biber.bib` that is version controlled and used by `nix build`.
