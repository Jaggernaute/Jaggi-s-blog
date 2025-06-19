#!/usr/bin/env bash
OUTPUT_DIR="output"

echo "🧹 Cleaning LaTeX temp files..."
rm -f *.aux *.log *.toc *.out *.dvi *.4ct *.4tc *.idv *.lg *.tmp *.xref *.css *.html *.png *.bcf *.xml *.bbl *.blg *.bib

echo "✅ Done!"
