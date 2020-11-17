#!/usr/bin/env python3

"""Functions demonstrating use of profiling to test code speed."""

def my_squares(iters):
    """Squares array of numbers from 1 to len(iters)"""

    out = []
    for i in range(iters):
        out.append(i ** 2)
    return out


def my_join(iters, string):
    """Creates comma separated string: string repeated iter times"""

    out = ""
    for i in range(iters):
        out += string.join(", ")
    return out


def run_my_funcs(x, y):
    """Runs my_squares and my_join functions"""

    print(x, y)
    my_squares(x)
    my_join(x, y)
    return 0


run_my_funcs(10000000, "My string")

