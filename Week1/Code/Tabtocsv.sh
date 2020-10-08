#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Tabtocsv.sh

# Desc: substitute the tabs in files with commas

# Arguments: 1 -> tab delimited file

# Date: Oct 2020

echo "Creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> $1.csv
echo "Done!"
exit