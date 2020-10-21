#!/usr/bin/env python3

""" Some for and while loops that print various numerical/list manipulations."""

__appname__ = 'Loops.py'
__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"


# FOR loops in python #

# Prints 0-4
for i in range(5):
    print(i)

# Prints out list
my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

# Prints 0, 1, 12, 123, 1234
total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

# WHILE loops in python #

# Prints all numbers from 1 to 100
z = 0
while z < 100:
    z = z + 1
    print(z)

# Creates infinite while loop
b = True
while b:
    print("GERONIMO! infinite loop!")
