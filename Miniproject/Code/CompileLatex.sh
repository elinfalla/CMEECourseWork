#!/bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CompileLatex.sh

# Desc: compiles a LaTex pdf from a .tex file

# Arguments: 1 -> a .tex document

# Date: Oct 2020

if [[ ! $1 ]]
  then
    echo "Please give .tex file (with extension) to compile as argument.";
  exit 1
fi

#Remove existing pdf
if [ -s $(basename "$1" .tex).pdf ];
then
  rm $(basename "$1" .tex).pdf #use of basename to get file without .tex extension
fi

#Compile pdf multiple times, and bibtex
pdflatex -halt-on-error -output-directory . -synctex=1 $1
pdflatex -halt-on-error -output-directory . -synctex=1 $1
bibtex $(basename "$1" .tex)
pdflatex -halt-on-error -output-directory . -synctex=1 $1
pdflatex -halt-on-error -output-directory . -synctex=1 $1
#options include: '-output-directory' and '-synctex=1'

#Open pdf if file exists and isn't empty
if [ -s $(basename "$1" .tex).pdf ];
then
  evince $(basename "$1" .tex).pdf & #opens the pdf
else
  echo "Pdf is empty";
fi

## Cleanup (-f: don't ask confirmation)
rm -f {*~,*.aux,*.blg,*.bcf,*.nav,*.vrb,*.bbl,*.lot,*.dvi,*.log,\
*.lof,*.nav,*.out,*.snm,*.toc,*.fdb,*.fls,*.synctex.*,*.cut} #no spaces is important

#Move pdf to Results directory
#mv $(basename "$1" .tex).pdf ../Results/
