#!/bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: run_MiniProject.sh

# Desc: compiles and runs all MiniProject code, including write up in LaTex

# Arguments: none

# Date: Nov 2020

Rscript Data_prep.R
Rscript Model_fitting.R
Rscript Plotting+analysis.R

bash CompileLatex.sh Write_up.tex
