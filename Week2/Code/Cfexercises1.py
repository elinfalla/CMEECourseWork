#!/usr/bin/env python3

''' Some functions that sort or manipulate number inputs'''

__author__ = "Elin Falla (ekf16@ic.ac.uk)"
__version__ = "0.0.1"

import sys

def foo_1(x=9): #if not specified, x will take the value 9
    '''Raises a number to the power of 0.5'''
    return x ** 0.5

def foo_2(x=5, y=4):
    '''Returns the larger of two number inputs'''
    if x > y:
        return x
    return y

def foo_3(x=4, y=10, z=5):
    '''Puts the 3 numbers in size order, starting with the smallest (unless
    the smallest number is at the end, in which case it just moves the
    largest to the end)'''
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x,y,z]


def foo_4(x=5):
    '''Calculates factorial of a number (using for loop)'''
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result


def foo_5(x=5):
    '''Recursive function that calculates factorial of a number '''
    if x == 1:
        return 1
    return x * foo_5(x - 1)


def foo_6(x=5):
    '''Calculates factorial of a number (using while loop)'''
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    print(foo_1(15))
    print(foo_2(7,11))
    print(foo_3(25,30,1))
    print(foo_3(30,25,1))
    print(foo_3(30,1,25))
    print(foo_4(8))
    print(foo_5(10))
    print(foo_6(3))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)
