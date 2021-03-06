#!usr/bin/env python3

"""Script that creates a file and writes a list of numbers to it."""

__appname__ = 'Basic_io2.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'


####################
# FILE OUTPUT
####################

# Save the elements of a list to a file
list_to_save = range(100)

f = open('../Data/Testout.txt', 'w')  # w = write
for i in list_to_save:
    f.write(str(i) + '\n')  # Add a new line at the end

f.close()
