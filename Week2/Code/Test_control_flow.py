#!usr/bin/env python3

"""A function exemplifying the use of 'doctest' package'"""

__appname__ = 'Test_control_flow.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import sys
import doctest  # Import doctest module


# Functions #
def even_or_odd(x=0):  # if not specified, x should take value 0 (prevent error message)
    """Find whether a number x is even or odd.

    >>> even_or_odd(10)
    '10 is Even!'

    >>> even_or_odd(5)
    '5 is Odd!'

    whenever a float is provided, use closest integer:
    >>> even_or_odd(3.2)
    '3 is Odd!'

    in case of negatives, the positive is taken:
    >>> even_or_odd(-2)
    '-2 is Even!'
    """

    # Define function to be tested
    if x % 2 == 0:
        return "%d is Even!" % x
    return "%d is Odd!" % x


def main(argv):
    """Main entry point of the program"""
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0


if __name__ == "__main__":
    """Makes sure the "main" function is called from command line"""
    status = main(sys.argv)
    sys.exit(status)

doctest.testmod() #To run with embedded tests



