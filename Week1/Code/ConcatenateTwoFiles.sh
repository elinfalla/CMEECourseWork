#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: ConcatenateTwoFiles.sh

# Desc: Overwrites and concatenates files

# Arguments: 3 -> 3 text files

# Date: Oct 2020


#Error message if too few files are given/arguments are not files
if [[ ! -f $1 || ! -f $2 || ! -f $3 ]]; #-f = file, -r = readable, -w = writable, $'n' = positional parameters, $0 = actual script, $1, $2 etc = other inputs
    then echo "Not enough files given. Script requires 3 files as arguments."; 
    exit 1 #non-zero exit means an error occurred
fi

#Error message if too many files given
if [[ -f $4 ]]
    then echo "Too many files given. Script requires 3 files as arguments."
    exit 2
fi


cat $1 > $3
cat $2 >> $3
echo "Merged file is:"
cat $3

exit 0 #exit 0 indicates correct output, no errors