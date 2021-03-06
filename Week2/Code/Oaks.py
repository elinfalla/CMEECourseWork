#!/usr/bin/env python3

""" Defines a function that finds oak species from a dataset and uses for loops and list comprehensions to
 print them in a list"""

__appname__ = 'Oaks.py'
__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"


# Data #
taxa = [ 'Quercus robur',
        'Fraxinus excelsior',
        'Pinus sylvestris',
        'Quercus cerris',
        'Quercus petraea']


# Functions #
def is_an_oak(name):
    """Finds just those taxa that are oak trees from a list of species"""
    return name.lower().startswith('quercus')


# Using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

# Using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

# Get names in UPPER CASE using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())  # .upper() sets to uppercase
print(oaks_loops)

# Get names in UPPER CASE using list comprehensions
oaks_lc = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc)
