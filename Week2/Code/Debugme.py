#!usr/bin/ env python3

""" An intentionally buggy function that demonstrates use of try and except."""

__appname__ = 'Debugme.py'
__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"


def buggyfunc(x):
    """A function that tries dividing two integers and prints an error message if not possible (ie. dividing by 0)."""
    y = x
    for i in range(x):
        try:
            y = y - 1
            z = x / y
        except:
            print(f"This didn't work; x = {x}; y = {y}")
    return z


buggyfunc(20)

