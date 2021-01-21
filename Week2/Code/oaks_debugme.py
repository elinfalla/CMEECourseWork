#!/usr/bin/env python3

""" Imports genus and species data, and outputs those that are Oaks to JustOaksData.csv"""

__appname__ = "oaks_debugme.py"
__author__ = "Elin Falla, ef16@ic.ac.uk, Ioan Evans (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)"
__version__ = "0.0.1"

# Imports #
import csv
import sys
import doctest


# Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus'
    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('Fraxinus excelsior')
    False
    >>> is_an_oak('Pinus sylvestris')
    False
    >>> is_an_oak('Quercus cerris')
    True
    >>> is_an_oak('Quercus petraea')
    True
    >>> is_an_oak('quercus petraea')
    True
    >>> is_an_oak('quercusss petraea')
    True
    >>> is_an_oak('QuercusPetraea')
    True
    """
    return name.lower().startswith("quercus")  # use startswith() to catch bugs in spelling/spacing


def main(argv):
    """Main function: reads in TestOaksData.csv, and writes the species that are oaks to JustOaksData.csv"""

    f = open('../Data/TestOaksData.csv','r')
    g = open('../Data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    
    csvwrite = csv.writer(g)
    csvwrite.writerow(["Genus", "species"]) 

    next(taxa, None) # skips the header row

    oaks = set()
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])  

    return 0


if __name__ == "__main__":
    status = main(sys.argv)

doctest.testmod()  # runs embedded doctests
