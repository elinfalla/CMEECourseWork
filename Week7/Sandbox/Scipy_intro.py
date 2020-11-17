#!/usr/bin/env python3

"""Demonstrates some uses of scipy module"""

import scipy as sc

# one dimensional array
a = sc.array(range(5))
print(a)  # IF DO CTRL + SHIFT + E CAN RUN IN CONSOLE THEN DON'T NEED PRINT FUNC
print(type(a))

a = sc.array(range(5))
a = sc.array(range(5), float)
print(a)
a.dtype

# alternative way to get 1D array
x = sc.arange(5)
print(x)

x = sc.arange(5.)  # specify float
print(x)
x.shape

# convert to and from python lists
b = sc.array([i for i in range(10) if i % 2 == 1])
print(b)

c = b.tolist()
print(c)

# 2D numpy array
mat = sc.array([[0, 1], [2, 3]])
print(mat)
mat.shape

# indexing and accessing arrays
mat[1]  # accessing whole 2nd row, remember indexing starts at 0
mat[:, 1]  # accessing whole second column
mat[0, 0]  # first row and col
mat[1, 0]  # 2nd row first col
mat[0, -1]  # first from end of col (- means count from end)

# manipulating numpy arrays
mat[0, 0] = -1  # replace a single element
print(mat)
mat[:, 0] = [12, 12]  # replace whole column
print(mat)

sc.append(mat, [[12, 12]], axis=0)  # append row
sc.append(mat, [[12], [12]], axis=1)  # append col - NOTE DIFF SQUARE BRACKETS

newRow = [[12, 12]]  # create new row
mat = sc.append(mat, newRow, axis=0)
mat
sc.delete(mat, 2, axis=0)  # delete third row
mat

# concatenation
mat = sc.array([[0, 1], [2, 3]])
mat0 = sc.array([[0, 10], [-1, 3]])
sc.concatenate((mat, mat0), axis=0)

# flattening or reshaping arrays (change array dimensions)
mat.ravel()  # make (unravel) into one row
mat.reshape(4, 1)  # reshape into 4 rows, 1 col
mat.reshape(1, 4)  # reshape to 1 row, but different from ravel, extra set of []
# note: if try reshape(1, 3) will give an error as total elements must remain same

# pre-allocating arrays
sc.ones((4, 2))  # initialise with 1s, numbers are dimensions
sc.zeros((4, 2))  # initialise with 0s

m = sc.identity(4)  # create an identity matrix
m
m.fill(16)  # fill matrix with 16s
m

# numpy matrices
# useful for matrix multiplication

mm = sc.arange(16)  # a 1D array of length 16
mm
mm = mm.reshape(4, 4)
mm

mm.transpose()  # swap rows and cols
mm + mm.transpose()
mm - mm.transpose()
mm * mm.transpose()  # element-wise multiplication
mm // mm.transpose()  # // = integer division
mm // (mm + 1).transpose()  # to avoid dividing by 0
mm * sc.pi  # multiply by pi
mm.dot(mm)  # this is matrix multiplication, or the dot product

mm = sc.matrix(mm)  # convert to scipy/numpy matrix class
mm
print(type(mm))

# this data structure makes matrix multiplication syntactically easier
mm * mm  # rather than mm.dot(mm)
# can do more by importing linalg sub-package: sc.linalg

## PARTICULARLY USEFUL SCIPY PACKAGES ##

# 1 = SCIPY STATS
import scipy.stats  #this should ideally be at the top

scipy.stats.norm.rvs(size=10)  # 10 samples from N(0,1)
scipy.stats.randint.rvs(0, 10, size=7)  # random integers between 0 and 10

# 2 = SCIPY INTEGRATE
import scipy.integrate as integrate


# define a function that returns the growth rate of consumer and resource population
# at a given time step
def dCR_dt(pops, t=0):

    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C
    dCdt = -z * C + e * a * R * C

    return sc.array([dRdt, dCdt])


# assign parameter values
r = 1.
a = 0.1
z = 1.5
e = 0.75

# define time vector
t = sc.linspace(0, 15, 1000)  # note arbitrary time units

# set initial conditions of 2 populations
R0 = 10
C0 = 5
RC0 = sc.array([R0, C0])  # convert to array to match required func input

# numerically integrate this system forward from those starting conditions
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)
pops
infodict  # dictionary with additional information
type(infodict)
infodict.keys()
infodict['message']  # many functionalities including returning message about whether integration successful

# 3 = MATPLOTLIB.PYLAB
import matplotlib.pylab as p

# open an empty figure object
f1 = p.figure()

# plot
p.plot(t, pops[:, 0], 'g-', label="Resource density")
p.plot(t, pops[:, 1], 'b-', label="Consumer density")
p.grid()
p.legend(loc="best")
p.xlabel("Time")
p.ylabel("Population density")
p.title("Consumer-Resource population dynamics")
p.show()  # to display the figure

# save figure as a pdf
f1.savefig("../Results/LV_model.pdf")