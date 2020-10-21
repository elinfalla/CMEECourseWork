#!usr/bin/env python3

"""Basic boilerplate script demonstrating use of "main" function"""

__appname__ = 'Boilerplate.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'
__license__ = 'License for this code/program'

# Imports #
import sys  # module to interface our program with operating system

# Constants #

# Put global constants here


# Functions #
def main(argv):
    """Main entry point of the program"""
    print("This is a boilerplate")
    return 0


if __name__ == "__main__":
    """Makes sure the "main" function is called from command line"""
    status = main(sys.argv)
    sys.exit(status)
