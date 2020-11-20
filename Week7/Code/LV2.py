#!usr/bin/env python3

"""Script that runs the Lotka-Volterra model with density dependence, taking parameter values from command line"""

__appname__ = "LV2.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys


# Functions #
def main(argv):
    """Main function: define and run function containing LV model using inputs from command line, and plot results"""

    # define a function that returns the growth rate of consumer and resource population
    # at a given time step
    def dCR_dt(pops, t=0):
        """Returns the growth rate of consumer and resource population using the Lotka-Volterra model"""

        R = pops[0]
        C = pops[1]
        dRdt = r * R * (1 - R / K) - a * R * C
        dCdt = -z * C + e * a * R * C

        return sc.array([dRdt, dCdt])

    # assign parameter values
    K = 100

    if len(sys.argv) == 1:
        r = 1.
        a = 0.1
        z = 1.5
        e = 0.75
    else:
        r = float(sys.argv[1])
        a = float(sys.argv[2])
        z = float(sys.argv[3])
        e = float(sys.argv[4])

    # define time vector
    t = sc.linspace(0, 100, 1000)  # note arbitrary time units

    # set initial conditions of 2 populations
    R0 = 10
    C0 = 5
    RC0 = sc.array([R0, C0])  # convert to array to match required func input

    # numerically integrate this system forward from those starting conditions
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

    # print final populations to screen
    print("Final R =", round(pops[-1, 0], 3))
    print("Final C =", round(pops[-1, 1], 3))

    # open an empty figure object
    # define axes as ax to use in text() later
    f1, ax = p.subplots()  # default number of subplots is 1

    # plot
    p.plot(t, pops[:, 0], 'g-', label="Resource density")
    p.plot(t, pops[:, 1], 'b-', label="Consumer density")
    p.grid()
    p.legend(loc="best")
    p.legend()
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


    # save figure as a pdf
    f1.savefig("../Results/LV_model_prac.pdf")

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

    f2.savefig("../Results/LV_model2_prac.pdf")

    return 0


if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)

