#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CountLines.sh

# Desc: counts lines of a file

# Arguments: 1 -> a file

# Date: Oct 2020


NumLines=`wc -l < $1`
echo "The file $1 has $NumLines lines"
exit

