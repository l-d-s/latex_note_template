### How to use this template

This template is set up so that

-   The development environment is hermetic using Nix flakes.
-   One can use a "mega-bibliography" (e.g. all of one's Zotero references in a
    `.bib` file).
    A smaller `.bib` file is created with paper-specific references.

How does it work?

-   First, create a link `my_library.bib` to your bibliography in the root directory.

    This should not be managed by version control. [But how does Nix know about it?]
