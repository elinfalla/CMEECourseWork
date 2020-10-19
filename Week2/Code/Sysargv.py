#!usr/bin/env python3

"""Script that demonstrates how to use sys package."""

__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import sys

print("This is the name of the script:", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))
