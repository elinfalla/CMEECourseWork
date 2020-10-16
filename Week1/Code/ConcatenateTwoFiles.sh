#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: ConcatenateTwoFiles.sh

# Desc: Overwrites and concatenates files

# Arguments: 3 -> 3 text files

# Date: Oct 2020


#Error message if too few files are given/arguments are not files
if [[ ! -e $1 || ! -e $2 || ! -e $3 ]]; #-e = file, $'n' = positional parameters
    then echo "Not enough files given. Script requires 3 files as arguments: 2 to concatenate and an output file.";
    exit 1 #non-zero exit means an error occurred
fi

#Error message if too many files given
if [[ -f $4 ]]
    then echo "Too many files given. Script requires 3 files as arguments: 2 to concatenate and an output file."
    exit 2
fi

#Overwrite the contents of 3 with 1
cat $1 > $3
#Concatenate the contents of 2 into 3 (ie. put 1 and 2 into 3)
cat $2 >> $3
echo "Merged file is:"
cat $3

#Move resulting concatenated file into Data directory
mv $3 ../Data

exit 0 #exit 0 indicates correct output, no errors
