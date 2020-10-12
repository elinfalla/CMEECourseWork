#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CsvToSpace.sh

# Desc: turns a comma separated values (csv) file into a space separated one.

# Arguments: 1 -> a csv file

# Date: Oct 2020

if [[ ! -f $1 ]];
    then echo "No file given. Please give CSV file as argument.";
    exit 1

fi

if [[ -f $2 ]];
    then echo "Please give only one CSV file as an argument.";
    exit 2
fi

if [[ $1 != *.csv ]];
    then echo "Please input CSV file with .csv extension.";
    exit 3
fi

echo "Creating a space separated version of $1 ..."

# Substitute commas for spaces then transfer it to a file with a csv extention
cat $1 | tr -s "," " " >> $(basename "$1" .csv).txt #basename removes extensions - in this case csv
echo "Complete!"

exit 0
