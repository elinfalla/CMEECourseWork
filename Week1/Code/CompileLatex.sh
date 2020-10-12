#!/bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CompileLatex.sh

# Desc: compiles a LaTex pdf from a .tex file

# Arguments: 1 -> a csv file

# Date: Oct 2020

rm $(basename "$1" .tex).pdf #remove existing pdf

pdflatex -halt-on-error -output-directory . -synctex=1 $1
pdflatex -halt-on-error -output-directory . -synctex=1 $1
bibtex $(basename "$1" .tex)
pdflatex -halt-on-error -output-directory . -synctex=1 $1
pdflatex -halt-on-error -output-directory . -synctex=1 $1

#Open pdf if file exists and isn't empty
if [ -s $(basename "$1" .tex).pdf]
then
  evince $(basename "$1" .tex).pdf & #opens the pdf
else
  echo "$1.pdf is empty!"
fi

## Cleanup
rm {*~,*.aux,*.blg,*.bcf,*.nav,*.vrb,*.bbl,*.lot,*.dvi,*.log,\
*.lof,*.nav,*.out,*.snm,*.toc,*.fdb,*.fls,*.synctex,*.cut}
