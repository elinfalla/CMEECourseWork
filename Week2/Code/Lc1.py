#!usr/bin/env python3

"""Script that contains list comprehensions and for loops to create separate lists containing the latin names,
common names, and body masses of birds from a birds database."""

__appname__ = 'Lc1.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Data #
birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

# (1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively.

print("LIST COMPREHENSIONS")

# Print latin names of species in birds database (list comprehension)
latin_names = [row[0] for row in birds]
print("Latin names:\n", latin_names)

# Print common names of species in birds database (list comprehension)
common_names = [row[1] for row in birds]
print("Common names:\n", common_names)

# Print mean body masses of species in birds database (list comprehension)
body_masses = [row[2] for row in birds]
print("Mean body masses:\n", body_masses)

# Print new line to separate list comprehensions and for loops
print("\n")

#############################

# (2) Now do the same using conventional loops (you can choose to do this
# before 1 !).

print("FOR LOOPS")

# Print latin names of species in birds database (for loop)
latin_names = []
for row in birds:
    latin_names.append(row[0])
print("Latin names:\n", latin_names)

# Print common names of species in birds database (for loop)
common_names = []
for row in birds:
  common_names.append(row[1])
print("Common names:\n", common_names)

# Print mean body masses of species in birds database (for loop)
body_masses = []
for row in birds:
    body_masses.append(row[2])
print("Mean body masses:\n", body_masses)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
