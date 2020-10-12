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

# Substitute tabs for commas then transfer it to a file with a csv extention
cat $1 | tr -s "\t" "," >> $(basename "$1" .txt).csv #basename removes extensions - in this case txt
echo "Done!"

exit 0