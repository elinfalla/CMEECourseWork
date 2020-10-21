#!usr/bin/ env python3

""" An intentionally buggy function that demonstrates use of try and except."""

__appname__ = 'Debugme.py'
__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"


def buggyfunc(x):
    y = x
    for i in range(x):
        try:
            y = y - 1
            z = x / y
        except:
            print(f"This didn't work; x = {x}; y = {y}")
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
