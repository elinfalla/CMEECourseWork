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

#Calculate word count and pipe to file (that .tex uses)
texcount -template={1} $1 > $(basename "$1" .tex).sum

#Compile pdf multiple times, and bibtex
echo "---- COMPILING LATEX ----"
pdflatex -halt-on-error -interaction=batchmode -output-directory . -synctex=1 $1
pdflatex -halt-on-error -interaction=batchmode -output-directory . -synctex=1 $1

echo "---- COMPILING BIBTEX ----"
bibtex $(basename "$1" .tex)

echo "---- COMPILING LATEX ----"
pdflatex -halt-on-error -interaction=batchmode -output-directory . -synctex=1 $1
pdflatex -halt-on-error -interaction=batchmode -output-directory . -synctex=1 $1
echo "---- COMPILE COMPLETE ----"

#Open pdf if file exists and isn't empty
if [ -s $(basename "$1" .tex).pdf ];
then
  echo " ---- OPENING COMPILED PDF ----"
  evince $(basename "$1" .tex).pdf & #opens the pdf
else
  echo "ERROR: Pdf is empty";
fi

## Cleanup (-f: don't ask confirmation)
rm -f {*~,*.aux,*.blg,*.bcf,*.nav,*.vrb,*.bbl,*.lot,*.dvi,*.log,\
*.lof,*.nav,*.out,*.snm,*.toc,*.fdb,*.fls,*.synctex.*,*.cut,*.bak,*.fdb_latexmk} #no spaces is important

#Move pdf to Results directory
#mv $(basename "$1" .tex).pdf ../Results/
