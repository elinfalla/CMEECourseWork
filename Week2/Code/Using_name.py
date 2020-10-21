#!usr/bin/env python3

"""Script that demonstrates how (__name__ == "__main"__) works."""

__appname__ = 'Using_name.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'
# Filename: using_name.py

if __name__ == '__main__':
    print("This program is being run by itself")
else:
    print("I am being imported from another module")

print("This module's name is: " + __name__)
