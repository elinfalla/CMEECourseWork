#!/bin/bash

# Author: Elin Falla ()ef16@ic.ac.uk, Ioan Evans (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)

# Script: run_Vectorize.sh

# Desc: runs the R and Python versions of Vectorize1 and Vectorize2 and outputs to console

# Arguments: none

# Date: Jan 2021

echo "------ VECTORIZE1.R OUTPUT ------"
Rscript Vectorize1.R

echo "------ VECTORIZE2.R OUTPUT ------"
Rscript ./Vectorize2.R

echo "------ VECTORIZE1.PY OUTPUT ------"
python3 ./Vectorize1.py

echo "------ VECTORIZE2.PY OUTPUT ------"
python3 ./Vectorize2.py

echo "run_Vectorize.sh complete!"
