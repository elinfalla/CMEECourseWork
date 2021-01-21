#!/usr/bin/env py

"""Script that calculates tree heights given a file containing distance of each tree
    from its base and angle to its top. Outputs to csv called INPUT_FILE_NAME_treeheights_py.csv"""

__appname__ = "get_TreeHeight.py"
__author__ = "Elin Falla, ef16@ic.ac.uk, Ioan Evan (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)"
__version__ = "0.0.1"

# Imports #
import numpy as np
import pandas as pd
import re
import sys

# Loading data from command line input

string = sys.argv[1]

# Remove relative path
string = re.sub(r'^.*/', '', string)
# Remove file extension
string = string.split(".")[0]

df = pd.read_csv("../Data/trees.csv")

# Function

def TreeHeight(degrees, distance):
    """Calculates the height of a tree given distance of each tree
        from its base and angle to its top, using the trigonometric formula"""

    radians = np.radians(degrees)
    height = distance * np.tan(radians)
    return height

example = TreeHeight(37, 40)

print(f"The height of a tree with an angle of 37 degrees at distance 40m is {example}")

# Assigning the output of the function to a column

df["Tree.Height.m"] = TreeHeight(df["Angle.degrees"], df["Distance.m"])

# Creating a csv output

df.to_csv(f"../Results/{string}_treeheights_py.csv", index = False)

# Message to state complete

print("get_Treeheight.py complete")