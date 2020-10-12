#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Tabtocsv.sh

# Desc: substitute the tabs in files with commas

# Arguments: 1 -> a tab delimited file

# Date: Oct 2020

if [[ ! -f $1 ]];
    then echo "No file given. Please give tab delimted file as argument.";
    exit 1
fi

if [[ -f $2 ]];
    then echo "Please give only one tab delimted file as an argument.";
    exit 2
fi

echo "Creating a comma delimited version of $1 ..."

# Use string manipulations to extract base name of file (no extension)
path=$1 #$1 is the filepath of the inputted file
file=${path##*/} # ${variable%%pattern} trims the longest match from start of string (#-shortest) so */ removes all directories, leaving just the filename and extension
base=${file%%.*} # ${variable%%pattern} trims the longest match from end of string (%=shortest) so .* removes any extension

# Substitute tabs for commas then transfer it to a file with a csv extention
cat $1 | tr -s "\t" "," >> $base.csv
echo "Done!"

exit 0
