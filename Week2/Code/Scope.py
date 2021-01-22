#!usr/bin/env python3

"""Functions that demonstrate the scope of global and local variables in different contexts."""

__appname__ = 'Scope.py'
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import sys


# Functions #
def a_function1():
    """Manipulates global variables and sets local variables for testing scope"""
    _a_global = 5  # a local variable

    if _a_global >= 5:
        _b_global = _a_global + 5  # also a local variable

    _a_local = 4

    print("Inside a_function1, the value of _a_global is ", _a_global)
    print("Inside a_function1, the value of _b_global is ", _b_global)
    print("Inside a_function1, the value of _a_local is ", _a_local)

    return None


def a_function2():
    """Sets a local variable for testing scope"""
    _a_local = 4

    print("Inside a_function2, the value _a_local is ", _a_local)
    print("Inside a_function2, the value of _a_global is ", _a_global)

    return None


def a_function3():
    """Defines a global variable and local variable for testing scope."""
    global _a_global
    _a_global = 5
    _a_local = 4

    print("Inside a_function3, the value of _a_global is ", _a_global)
    print("Inside a_function3, the value _a_local is ", _a_local)

    return None


def a_function4():
    """Sets local variable and defines and runs nested function to test variable scope in nested functions."""
    _a_global = 10

    def _a_function_nested1():
        """Defines a global and local variable to be run within a_function4()."""
        global _a_global
        _a_global = 20

    print("Before calling a_function4, value of _a_global is ", _a_global)

    _a_function_nested1()

    print("After calling _a_function_nested1, value of _a_global is ", _a_global)

    return None


def a_function5():
    """Defines and runs nested function to test variable scope in neste functions."""

    def _a_function_nested2():
        """Defines a global and local variable to be run within a_function5()."""
        global _a_global
        _a_global = 20

    print("Before calling a_function5, value of _a_global is ", _a_global)

    _a_function_nested2()

    print("After calling _a_function_nested2, value of _a_global is ", _a_global)

    return None


def main(argv):
    """Main entry point of program: runs defined functions and defines global environment for each"""

    # Global constants #
    global _a_global  # a global variable

    # a_function1() environment #
    _a_global = 10
    if _a_global >= 5:
        _b_global = _a_global + 5  # also a global variable
    a_function1()
    print("Outside a_function1, the value of _a_global is ", _a_global)
    print("Outside a_function1, the value of _b_global is ", _b_global)

    print("\n")

    # a_function2() environment #
    _a_global = 10
    a_function2()
    print("Outside a_function2, the value of _a_global is", _a_global)

    print("\n")

    # a_function3() environment #
    _a_global = 10
    print("Outside a_function3, the value of _a_global is", _a_global)
    a_function3()
    print("Outside a_function3, the value of _a_global now is", _a_global)

    print("\n")

    # a_function4() environment #
    a_function4()
    print("The value of a_global in main workspace / namespace of a_function4 is ", _a_global)

    print("\n")

    # a_function5() environment #
    _a_global = 10
    a_function5()
    print("The value of a_global in main workspace / namespace of a_function5 is ", _a_global)

    return 0


if __name__ == "__main__":
    """Ensures main function is called from command line"""
    status = main(sys.argv)
    sys.exit(status)
