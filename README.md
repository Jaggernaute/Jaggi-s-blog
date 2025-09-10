# Jaggi-s-blog

A static blog project written in LaTeX, built using Make and Nix.

## Overview

This blog uses the LaTeX typeseting language to generate the content, Nix for the
easy setup of the toolchain and GNU Make to automate the commands and streamline
the build process.

Under the hood it uses latexmk and make4ht to generate the HTML5 site structure,
and latexmk to generate a PDF version of each blog article.

---

## Structure
**Dev structure :**
```text
├── src/                    # Source files (TeX, content)
    ├── posts/ ...          # Posts content (TeX, Bib)
    └── preamble/           # global config
│       ├── style.css       # global CSS style
│       └── preamble.tex    # global LaTeX config
├── Makefile                # Build/clean commands wrapper
├── config.cfg              # Configuration settings for make4ht
└──  flake.nix & flake.lock # Nix development environment
```
**Output structure :**

```text
./output
    ├── posts/
    │   └── postX          # example of a post
    │       ├── src/assets # post specific assets
    │       ├── postX.css  # page CSS file
    │       ├── style.css  # global CSS
    │       ├── postX.html # page HTML layout
    │       └── postX.pdf  # PDF version of the article
    ├── src/assets         # global assets files
    └── index.html/css     # landing page
```

---

## Prerequisites

* [Nix](https://nixos.org/) (optional)

If you don't have Nix:

* [GNU Make](https://www.gnu.org/software/make/)
* [TeX Live](https://www.tug.org/texlive/) (full)
* [make4ht](https://www.kodymirus.cz/make4ht.html) — may be provided by your TeX Live distribution
* [Inkscape](https://inkscape.org)

---

## Building the Blog

```bash
make
```
This should generate compiled outputs—PDFs, HTML, etc.

The makefile supports manual targets, by commenting out the `PDF_TARGETS` you don't want to build.

---

## Cleaning Build Artifacts

```bash
make clean
```
This command removes generated files.
