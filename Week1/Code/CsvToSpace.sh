#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: CsvToSpace.sh

# Desc: turns a comma separated values (csv) file into a space separated one.

# Arguments: 1 -> a csv file

# Date: Oct 2020

#If no valid file is given, print error message and exit
if [[ ! -e $1 ]]; #-e: file
    then echo "No file given. Please give CSV file as argument.";
    exit 1

#If the user inputs two or more files, print error message and exit
elif [[ -e $2 ]];
    then echo "Please give only one CSV file as an argument (with relative filepath if different from current directory).";
    exit 2

#If the user doesn't input a .csv file, print error message and exit
elif [[ $1 != *.csv ]];
    then echo "Please input CSV file with .csv extension as an argument.";
    exit 3
fi

echo "Creating a space separated version of $1 ..."

# Substitute commas for spaces, transfer it to a file with a csv extention, move to Data directory
cat $1 | tr -s "," " " >> ../Data/$(basename "$1" .csv).txt #basename removes extensions - in this case csv
echo "Complete!"

exit 0
