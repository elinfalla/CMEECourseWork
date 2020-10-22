#!usr/bin/env python3

"""Script that reads a csv file and both prints it to the console and writes select data to a new file."""

__appname__ = 'Basic_csv.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'


# Imports #
import csv

# Read a file containing:
# 'Species','Infraorder','Family','Distribution','Body mass male (kg)'
f = open('../Data/Testcsv.csv', 'r')

csvread = csv.reader(f)
temp = []
for row in csvread:
    temp.append(tuple(row))
    print(row)
    print("The species is", row[0])

f.close()

# Write a file containing only species name and body mass
f = open('../Data/Testcsv.csv', 'r')
g = open('../Data/Bodymass.csv', 'w')

csvread = csv.reader(f)
csvwrite = csv.writer(g)
for row in csvread:
    print(row)
    csvwrite.writerow([row[0], row[4]])

f.close()
g.close()
