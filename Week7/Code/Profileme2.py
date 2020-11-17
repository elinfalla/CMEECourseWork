#!/usr/bin/env python3

"""Faster versions of Profileme.py functions - demonstrating use of profiling to test code speed."""

# packages
# import numpy as np


def my_squares(iters):
    """Squares array of numbers from 1 to len(iters)"""

    out = [i ** 2 for i in range(iters)]
    return out

# def my_squares_numpy(iters):
#     """Squares array of numbers using numpy"""
#
#     out = np.array(range(iters))
#     for i in range(iters):
#         out[i] = i ** 2
#     return out


def my_join(iters, string):
    """Creates comma separated string: string repeated iter times"""

    out = ""
    for i in range(iters):
        out += ", " + string
    return out


def run_my_funcs(x, y):
    """Runs my_squares and my_join functions"""

    print(x, y)
    my_squares(x)
    # my_squares_numpy(x)
    my_join(x, y)
    return 0


run_my_funcs(10000000, "My string")
