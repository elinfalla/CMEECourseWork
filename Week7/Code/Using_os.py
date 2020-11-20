#!/usr/bin/env python3

"""Find specific files in a directory using os.walk()"""

# Use the subprocess.os module to get a list of files and directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

#packages
from subprocess import os

#############
## CODE THAT PRINTS DIRECTORIES AND FILES IN 'HOME' (USER) FOLDER NON-RECURSIVELY
# def print_dir_files(path):
#     """Prints and returns directories and files directly within a chosen directory"""
#     list_subfolders = [d.name for d in os.scandir(path) if d.is_dir()]
#     list_files = [f.name for f in os.scandir(path) if not f.is_dir()]
#     print("**** DIRECTORIES ****")
#     for dir in list_subfolders:
#         print(dir)
#     print("\n**** FILES ****")
#     for file in list_files:
#         print(file)
#
#     return list_files, list_subfolders


# home = os.path.expanduser("~")
# list_files, list_subfolders = print_dir_files(home)
##############


def print_all_paths(path):
    """Prints and returns directories and files recursively within a chosen directory"""
    list_subfolders = [d for d in os.walk(path)]
    for item in range(len(list_subfolders)):
        print(list_subfolders[item])
    return list_subfolders


path = "../../"
print_all_paths(path)

#################################
# ~Get a list of files and
# ~directories in your home/ that start with an uppercase 'C'

# # Create a list to store the results.
FilesDirsStartingWithC = []

# # Use a for loop to walk through the home directory.
for root, dirs, files in os.walk(path):
    FilesDirsStartingWithC += [filename for filename in files if filename.startswith("C")]
    FilesDirsStartingWithC += [dirname for dirname in dirs if dirname.startswith("C")]

# Print results
print("***************")  # to separate print from previous results
for item in FilesDirsStartingWithC:
    print(item)

#################################
# Get files and directories in your home/ that start with either an 
# upper or lower case 'C'

# Initialise list
FilesDirsStartingWithAnyC = []

# Walk through, changing each filename/dirname to upper case then checking if it starts with "C"
for root, dirs, files in os.walk(path):
    FilesDirsStartingWithAnyC += [filename for filename in files if filename.upper().startswith("C")]
    FilesDirsStartingWithAnyC += [dirname for dirname in dirs if dirname.upper().startswith("C")]

# Print results
print("***************")  # to separate print from previous results
for item in FilesDirsStartingWithAnyC:
    print(item)

#################################
# Get only directories in your home/ that start with either an upper or 
# ~lower case 'C'

# Initialise list
DirsStartingWithAnyC = []

# Walk through and only add dirs to the list, changing to upper case and checking if starts with "C"
for root, dirs, files in os.walk(path):
    DirsStartingWithAnyC += [dirname for dirname in dirs if dirname.upper().startswith("C")]

# Print results
print("***************")  # to separate print from previous results
for item in DirsStartingWithAnyC:
    print(item)
