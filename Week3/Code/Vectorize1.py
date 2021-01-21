#!/usr/bin/env python3

"""Script demonstrating speed of using vectorisation when manipulating matrices"""

__appname__ = 'Vectorize1.py'
__author__ = 'Ioan Evans, Elin Falla, Danica Duan'
__email__ = 'ie917@ic.ac.uk, ef16@ic.ac.uk, dd1820@ic.ac.uk'
__version__ = '0.0.1'
__license__ = "License for this code/program"

# Imports #
import numpy as np
import time

# create 1000 by 1000 matrix of random numbers
M = np.random.rand(1000, 1000)

def SumAllElements(M):
    """Manually sum all elements of a given matrix M"""
    Dimensions = M.shape
    Tot = 0
    for i in range(0, Dimensions[0]):
        for j in range(0, Dimensions[1]):
            Tot = Tot + M[i, j]
    return Tot

start = time.time()
T = SumAllElements(M)
end = time.time()
print("Using loops, the time taken is:")
print(end - start)

start = time.time()
T = np.sum(M)
end = time.time()
print("Using the in-built vectorized function, the time taken is:")
print(end - start)

print("Vectorize1.py done!")