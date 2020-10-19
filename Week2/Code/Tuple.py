#!usr/bin/env python3

"""Script that prints the output of 'birds' dataset by species, showing latin name, common name and body mass."""

__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Data #
birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by species
#
# A nice example output is:
#
# Latin name: Passerculus sandwichensis
# Common name: Savannah sparrow
# Mass: 18.7
# ... etc.

# Hints: use the "print" command! You can use list comprehensions!

for row in birds:
    print("Latin name:", row[0],
        "\nCommon name:", row[1],
        "\nMass:", row[2], "\n")

# data = "".join([str("Latin name:%s\nCommon name:%s\nMass:%s\n\n") % (row[0], row[1], row[2]) for row in birds])
# print(data)
