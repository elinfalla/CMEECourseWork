#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Tiff2Png.sh

# Desc: Converts .tif files in directory to .png files

# Arguments: none

# Date: Oct 2020

if [[ $1 ]]
    then echo "No arguments required. Tiff2Png.sh will find .tif files from current directory.";
    exit 1
fi

if [[ $(ls *.tif | wc -w) == 0 ]]
    then echo "No .tif files in current directory.";
    exit 2
fi

for f in *.tif;
    do
        echo "Converting $f"; # $f rather than $1 as it's not an argument
        convert "$f" "$(basename "$f" .tif).png";

    done

exit 0