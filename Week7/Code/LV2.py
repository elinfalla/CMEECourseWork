#!/usr/bin/env python3

"""Script that runs the Lotka-Volterra model with density dependence, taking parameter values from command line"""

# packages
import scipy as sc
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys


# define a function that returns the growth rate of consumer and resource population
# at a given time step

def main(argv):
    """Main function"""

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
    t = sc.linspace(0, 200, 1000)  # note arbitrary time units

    # set initial conditions of 2 populations
    R0 = 10
    C0 = 5
    RC0 = sc.array([R0, C0])  # convert to array to match required func input

    # numerically integrate this system forward from those starting conditions
    pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

    # print final populations to screen
    print("Final R =", pops[-1, 0])
    print("Final C =", pops[-1, 1])

    # open an empty figure object
    f1 = p.figure(figsize=(7, 6))

    # plot
    p.plot(t, pops[:, 0], 'g-', label="Resource density")
    p.plot(t, pops[:, 1], 'b-', label="Consumer density")
    p.grid()
    p.legend(loc="best")
    p.legend()
    p.xlabel("Time\nr = %r, a = %r, z = %r, e = %r" % (r, a, z, e))
    p.ylabel("Population density")
    p.title("Consumer-Resource population dynamics")

    # save figure as a pdf
    f1.savefig("../Results/LV_model_prac.pdf")

    # plot Consumer density against resource density
    f2 = p.figure(figsize=(7, 6))

    p.plot(pops[:, 0], pops[:, 1], "-r")
    p.grid()
    p.xlabel("Resource density\nr = %r, a = %r, z = %r, e = %r" % (r, a, z, e))
    p.ylabel("Consumer density")
    p.title("Consumer-Resource population dynamics")

    f2.savefig("../Results/LV_model2_prac.pdf")

    return 0


if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)

