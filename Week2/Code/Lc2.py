#!usr/bin/env python3

"""Script that contains list comprehensions and for loops to manipulate UK rainfall data to:
(1) create a list of month,rainfall tuples where the amount of rain was >100m
(2) create a list of months where the amount of rain was <50mm."""

__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Data #

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
print("LIST COMPREHENSIONS")

high_rainfall = [month for month in rainfall if month[1] > 100] #month[1] refers to the number in each tuple
print("Months and rainfall values when the amount of rain was greater than \
100mm:\n", high_rainfall)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm.

low_rainfall = [month[0] for month in rainfall if month[1] < 50]
print("Months when the amount of rain was less than 50mm:\n", low_rainfall)

#Print new line between list comprehensions and for loops
print("\n")

# (3) Now do (1) and (2) using conventional loops (you can choose to do
# this before 1 and 2 !).

print("FOR LOOPS")

high_rainfall = []
for month in rainfall:
    if month[1] > 100:
        high_rainfall.append(month)
print("Months and rainfall values when the amount of rain was greater than \
100mm:\n", high_rainfall)

low_rainfall = []
for month in rainfall:
    if month[1] < 50:
        low_rainfall.append(month[0])
print("Months when the amount of rain was less than 50mm:\n", low_rainfall)


# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.
