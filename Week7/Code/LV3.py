#!usr/bin/env python3

"""Script that runs a discrete-time version of the Lotka-Volterra model"""

__appname__ = "LV3.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk), Ioan Evans (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)'
__version__ = '0.0.3'

# Imports #
import numpy as np
import sys
import matplotlib.pylab as p


def run_LV(R=10, C=3, r=1., a=0.1, z=1.5, e=0.75, K=100, generations=30):
    """Runs discrete-time Lotka-Volterra model 'generations' times"""

    # initialise pops array with initial R and C
    pops = np.array([(R, C)])
    # square brackets around tuple specifies 2D array (ie. matrix) [[ ]] does the same

    for i in range(generations):

        R = pops[i, 0]
        C = pops[i, 1]

        nextR = R * (1 + r * (1 - (R / K)) - a * C)
        nextC = C * (1 - z + (e * a * R))

        # if a population dies, keep the respective pop at 0 (so doesn't go negative)
        if nextR < 0:
            nextR = 0
        elif nextC < 0:
            nextC = 0

        pops = np.append(pops, [(nextR, nextC)], axis=0)  # append row to pops

    return pops


def main(argv):
    """Main function: runs Lotka-Volterra model and plots results, saving to pdf"""

    # initialise parameters, accepting command line arguments for r, a, z, e
    num_gen = 1000
    timeframe = range(num_gen+1)

    if len(sys.argv) != 1:
        r = float(sys.argv[1])
        a = float(sys.argv[2])
        z = float(sys.argv[3])
        e = float(sys.argv[4])
    else:
        r = 0.05
        a = 0.05
        z = 0.09
        e = 0.1

    pops = run_LV(r=r, a=a, z=z, e=e, generations=num_gen)

    # print final populations
    print("Final R =", round(pops[-1, 0], 3))
    print("Final C =", round(pops[-1, 1], 3))

    # plot populations over time:
    # open an empty figure object
    # define axes as ax to use in text() later
    f1, ax = p.subplots()  # default number of subplots is 1

    p.plot(timeframe, pops[:, 0], 'g-', label="Resource density")
    p.plot(timeframe, pops[:, 1], 'b-', label="Consumer density")
    p.grid()
    p.legend(loc="best")
    p.xlabel("Time")
    p.ylabel("Population density")
    p.title("Consumer-Resource population dynamics")

    # generate text giving values of r, a, z, e
    # first generate a string with contents of text box
    textstr = '\n'.join((
        r'r=%.2f' % r,
        r'a=%.2f' % a,
        r'z=%.2f' % z,
        r'e=%.2f' % e
    ))
    # pass textstr into text. note use of ax to make coords in relation to axes not data points (ie. 0-1)
    p.text(0.87, 0.65, textstr,
           transform=ax.transAxes,
           bbox=dict(facecolor="salmon", alpha=0.5, boxstyle="round")
           )

    #p.show()

    # save figure as a pdf
    f1.savefig("../Results/LV3_timeseries.pdf")

    # plot Consumer density against resource density
    f2, ax = p.subplots()  # default number of subplots is 1

    p.plot(pops[:, 0], pops[:, 1], "-r")
    p.grid()
    p.xlabel("Resource density")
    p.ylabel("Consumer density")
    p.title("Consumer-Resource population dynamics")

    textstr = '\n'.join((
        r'r=%.2f' % r,
        r'a=%.2f' % a,
        r'z=%.2f' % z,
        r'e=%.2f' % e
    ))

    p.text(0.95, 0.95, textstr,
           horizontalalignment="right",
           verticalalignment="top",
           transform=ax.transAxes,
           bbox=dict(facecolor="salmon", alpha=0.5, boxstyle="round")
           )
    #p.show()
    f2.savefig("../Results/LV3_pop_comparison.pdf")

    return 0


if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)