#!usr/bin/env python3

"""Demonstrates vectorisation using entry-wise product of two arrays"""

__appname__ = "Vectorize.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import scipy as sc
import timeit
import matplotlib.pylab as p


# Functions #
def loop_product(a, b):
    """Entry-wise product of a and b using for loop"""

    N = len(a)
    c = sc.zeros(N)
    for i in range(N):
        c[i] = a[i] * b[i]
    return c


def vect_product(a, b):
    """Entry-wise product of a and b using vectorisation"""

    return sc.multiply(a, b)


array_lengths = [1, 100, 10000, 1000000, 10000000]
t_loop = []
t_vect = []

for N in array_lengths:
    print("\nSet N=%d" % N)

    # randomly generate our 1D arrays of length N
    a = sc.random.rand(N)
    b = sc.random.rand(N)

    # time loop_product 3 times and save the mean execution time
    timer = timeit.repeat("loop_product(a, b)", globals=globals().copy(), number=3)
    t_loop.append(1000 * sc.mean(timer)) # times 1000 so it's in milliseconds
    print("Loop method took %d ms on average." % t_loop[-1])

    timer = timeit.repeat("vect_product(a, b)", globals=globals().copy(), number=3)
    t_vect.append(1000 * sc.mean(timer))
    print("Vectorized method took %d ms on average." % t_vect[-1])


# compare timings on a plot
p.figure()
p.plot(array_lengths, t_loop, label="loop method")
p.plot(array_lengths, t_vect, label="vect method")
p.xlabel("Array length")
p.ylabel("Execution time (ms)")
p.legend()
p.show()

# vectorisation won't work if problem is too large as there won't be sufficient computer memory
# N = 1000000000
#
# a = sc.random.rand(N)
# b = sc.random.rand(N)
# c = vect_product(a, b)
