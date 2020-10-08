#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: ConcatenateTwoFiles.sh

# Desc: simple boilerplate for shell scripts

# Arguments: 3 -> 3 files

# Date: Oct 2020

cat $1 > $3
cat $2 >> $3
echo "Merged file is:"
cat $3