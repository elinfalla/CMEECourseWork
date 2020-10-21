#!usr/bin/env python3

"""Script that uses pickle to save an object and reload it."""

__appname__ = 'Basic_io3.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import pickle

######################
# STORING OBJECTS
######################

# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

f = open('../Sandbox/testp.p', 'wb')  # b means accepts binary files
pickle.dump(my_dictionary, f)  # write my_dictionary into the file
f.close()

# Load the data again
f = open('../Sandbox/testp.p', 'rb')  # read, accepts binary files
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
