#!/usr/bin/env python3

""" Some functions that sort or manipulate number inputs"""

__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"

# Imports #
import sys


# Functions #
def foo_1(x=9):  # if not specified, x will take the value 9
    """Raises a number to the power of 0.5"""
    y = x ** 0.5
    return "The square root of %d is %f" % (x, y)


def foo_2(x=5, y=4):
    """Returns the larger of two number inputs"""
    if x > y:
        return "%d is larger than %d" % (x, y)
    return "%d is larger than %d" % (y, x)


def foo_3(x=4, y=10, z=5):
    """Puts the 3 numbers in size order, starting with the smallest (unless
    the smallest number is at the end, in which case it just moves the
    largest to the end)"""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return "%d, %d < %d" % (x, y, z)


def foo_4(x=5):
    """Calculates factorial of a number (using for loop)"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return "The factorial of %d is %d" % (x, result)


def foo_5(x=5):
    """Recursive function that calculates factorial of a number"""
    if x == 1:
        return 1
    return x * foo_5(x - 1)


def foo_6(x=5):
    """Calculates factorial of a number (using while loop)"""
    facto = 1
    foo_6_input = x
    while x >= 1:
        facto = facto * x
        x = x - 1
    return "The factorial of %d is %d" % (foo_6_input, facto)


def main(argv):
    """Main entry point of the program: runs all the foo functions."""
    print(foo_1(15))
    print(foo_2(7, 11))
    print(foo_3(25, 30, 1))
    print(foo_3(30, 25, 1))
    print(foo_3(30, 1, 25))
    print(foo_4(8))

    # For recursive function, print command is outside the function as have no way of knowing result inside function
    foo_5_input = 10
    foo_5_output = foo_5(foo_5_input)
    print("The factorial of %d is %d" % (foo_5_input, foo_5_output))

    print(foo_6(3))

    return 0


if __name__ == "__main__":
    """Makes sure the 'main' function is called from the command line."""
    status = main(sys.argv)
    sys.exit(status)
