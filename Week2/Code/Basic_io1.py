#!usr/bin/env python3

"""Script that opens and reads a test file, both with and without blank lines."""

__appname__ = 'Basic_io1.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'


#####################
# FILE INPUT
#####################

# Open a file for Reading
f = open('../Data/Test.txt', 'r')

# Use 'implicit' for loop:
# If the object is a file, python will cycle over lines
for line in f:
    print(line)

# Close the file
f.close()

# Same example, skip blank lines
f = open('../Data/Test.txt', 'r')
for line in f:
    if len(line.strip()) > 0:
        print(line)

f.close()
