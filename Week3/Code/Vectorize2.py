#!/usr/bin/env python3

""""Stochastic implementation of the Ricker model and a vectorised version"""

__appname__ = "Vectorise2.py"
__author__ = "Elin Falla (ef16@ic.ac.uk), Ioan Evans (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)"
__version__ = "0.0.4"

# Imports #
import numpy as np
import sys
import time


def stochrick(p0=np.random.uniform(.5, 1.5, 1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """"Runs the stochastic Ricker equation with Gaussian fluctuations"""

    N = np.zeros((numyears, len(p0)))  # initialize empty matrix with numyears rows and len(p0) columns

    N[0] = p0

    for pop in range(len(p0)):  # loop through the populations

        for yr in range(1, numyears):  # for each pop, loop through the years

            # note: adds fluctuation from normal distribution at end of line
            N[yr, pop] = N[yr - 1, pop] * np.exp(r * (1 - N[yr - 1, pop] / K) + np.random.normal(0, sigma, 1))

    return N


# Now write another function called stochrickvect that vectorizes the above
# to the extent possible, with improved performance:


def stochrickvect(p0=np.random.uniform(.5, 1.5, 1000), r=1.2, K=1, sigma=0.2, numyears=100):
    """"Runs vectorised version of stochastic Ricker equation with Gaussian fluctuations"""

    N = np.zeros((numyears, len(p0)))  # initialize empty matrix

    N[0] = p0

    for yr in range(1, numyears):  # for each pop, loop through the years

        # note: adds fluctuation from normal distribution at end of line
        N[yr] = N[yr - 1] * np.exp(r * (1 - N[yr - 1] / K) + np.random.normal(0, sigma, len(p0)))

    return N


def main(argv):
    """"Main function: times stochrick and stockrickvect and outputs result to console"""

    start = time.time()
    T = stochrick()
    end = time.time()
    print("Non-vectorized Stochastic Ricker takes:")
    print(end - start)

    start = time.time()
    T = stochrickvect()
    end = time.time()
    print("Vectorized Stochastic Ricker takes:")
    print(end - start)

    print("Vectorize2.py done!")

    return 0


if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)