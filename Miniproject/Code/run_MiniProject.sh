#!/bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: run_MiniProject.sh

# Desc: compiles and runs all MiniProject code, including write up in LaTex

# Arguments: none

# Date: Nov 2020

echo "---- PREPARING DATA ----"
Rscript Data_prep.R
echo "---- complete! ----"

echo "---- FITTING MODELS ----"
Rscript Model_fitting.R
echo "---- complete! ----"

echo "---- ANALYSING FITS ----"
Rscript Plotting+analysis.R
echo "---- complete! ----"

bash CompileLatex.sh Write_up.tex
