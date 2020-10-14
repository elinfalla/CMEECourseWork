#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Tiff2Png.sh

# Desc: Converts .tif files in directory to .png files

# Arguments: none

# Date: Oct 2020


#If user has inputted a directory to search through then move to that directory
if [[ -d $1 ]]
  then cd $1

#If user has not inputted a valid directory
elif [[ ! -d $1 ]]

#Check if user has attempted to input a directory
  then if [[ $# != 0 ]] # $#: number of arguments
  
  #If this is the case, print error message to user and exit
    then echo "Directory doesn't exist. Please input filepath to directory or \
no argument if you wish to search the current directory."
    exit 1
  fi
fi

# If directory contains no .tif files to convert, print error message to user and exit
if [[ $(ls *.tif | wc -w) -eq 0 ]] #-eq: ==, this does ls on the tif files and uses wc to check it's not 0
    then echo "There are no .tif files to convert in the current directory.";
    exit 2
fi

# For each file in the directory, convert it to a .png and change the extension
for f in *.tif;
    do
        echo "Converting $f"; # $f as it represents a file with a .tif extension
        convert "$f" "$(basename "$f" .tif).png"

        #Move resulting .png file into Data directory
        mv $(basename "$f" .tif).png ../Data;
    done
#After all files converted, let user know process is complete
echo "Complete!"

exit 0
