#!/usr/bin/env python3

"""Compares speed of list comprehensions vs loops and loops vs join method for strings using timeit module"""


# Compare speed of list comprehensions to loops
iters = 10000000

import timeit
from Profileme import my_squares as my_squares_loops
from Profileme2 import my_squares as my_squares_lc

# Compare speed of loops to join method for strings

mystring = 'my string'

from Profileme import my_join as my_join_join
from Profileme2 import my_join as my_join

# then after importing, in ipython console do eg. %timeit my_squares_loops(iters) for each function


# alternative way to do it
import time
start = time.time()
my_squares_loops(iters)
print("my_squares_loops takes %f s to run" % (time.time() - start))

start = time.time()
my_squares_lc(iters)
print("my_squares_lc takes %f s to run" % (time.time() - start))



