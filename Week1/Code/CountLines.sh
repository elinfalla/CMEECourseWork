#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CountLines.sh

# Desc: counts lines of a file

# Arguments: 1 -> a text file

# Date: Oct 2020

#Error message if too few files are given/arguments are not files
if [[ ! -f $1 ]] #-f = file, $'n' = positional parameters, $0 = actual script, $1, $2 etc = other inputs
    then echo "Please input a file as an argument.";
    exit 1 #non-zero exit means an error occurred

#Error message if too many files given
elif [[ -f $2 ]]
    then echo "Too many files given. Script requires 1 file as argument."
    exit 2
fi

NumLines=`wc -l < $1` #< means do wc-l on $1
echo "The file $1 has $NumLines lines"

exit 0
