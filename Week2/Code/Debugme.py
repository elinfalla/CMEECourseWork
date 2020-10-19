#!usr/bin/ env python3

""" A function that doesn't work - tries to divide an integer by 0."""

__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"


def buggyfunc(x):
    y = x
    for i in range(x):
        y = y-1
        z = x/y
    return z

buggyfunc(20)

# Old debugme.py code
# def makeabug(x):
#     y = x**4
#     z = 0.
#     y = y/z
#     return y
#
# makeabug(25)
