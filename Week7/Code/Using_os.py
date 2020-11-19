#!/usr/bin/env python3

"""Find specific files in a directory"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess

def print_dir_files(path):

    list_subfolders = [d.name for d in subprocess.os.scandir(path) if d.is_dir()]
    list_files = [f.name for f in subprocess.os.scandir(path) if not f.is_dir()]
    print("**** DIRECTORIES ****")
    for dir in list_subfolders:
        print(dir)
    print("\n**** FILES ****")
    for file in list_files:
        print(file)

    return list_files, list_subfolders

home = subprocess.os.path.expanduser("~")
list_files, list_subfolders = print_dir_files(home)


#################################
#~Get a list of files and 
#~directories in your home/ that start with an uppercase 'C'

# Type your code here:

# # Get the user's home directory.
# home = subprocess.os.path.expanduser("~")
#
# # Create a list to store the results.
# FilesDirsStartingWithC = []
#
# # Use a for loop to walk through the home directory.
# for (dir, subdir, files) in subprocess.os.walk(home):
#     for filename in files:
#         if filename.startswith("C"):

list_subfolders_C = [d.name for d in subprocess.os.scandir(home) if d.endswith("C")]
for dir in list_subfolders_C:
    print(list_subfolders_C)
#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Type your code here:

#################################
# Get only directories in your home/ that start with either an upper or 
#~lower case 'C' 

# Type your code here:
