#!usr/bin/env python3

"""Description of this program or application.
    You can use several lines """

__appname__ = '[application name here]'
__author__ = 'Your name (your@email.address.com)'
__version__ = '0.0.1'
__license__ = 'License for this code/program'

## Imports ##
import sys #module to interface our program with operating system

## Constants ##

#Put global constants here

## Functions ##
def main(argv):
    """Main entry point of the program"""
    print("This is a boilerplate") #NOTE: indented using two tabs
    return 0

if __name__ == "__main__":
    """Makes sure the "main" function is called from command line"""
    status = main(sys.argv) #NOTE: indented using two tabs
    sys.exit(status)
