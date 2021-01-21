## Week 7 Content

We covered:

- Numerical computing in Python
- Regular expression in Python
- Using Python to build workflows

**Language(s):** Python - version 3.6.3

**Dependencies:**
- numpy
- scipy
- matplotlib
- urllib3

**Installation:**

- **numpy**
  - `pip3 install numpy`
- **scipy**
  - `pip3 install scipy`
- **matplotlib**
  - `pip3 install matplotlib`
- **urllib3**
  - `pip3 install urllib3`


### Project structure

4 directories:
- **Code** - python scripts (see 'File descriptions' section)
- **Data** - data that some scripts are run on
- **Results** - results eg. data manipulation outputs/graphs (note: empty until code is run)
- (Local repo also contains **Sandbox** with test files)

### File descriptions

- **Blackbirds.py** - Uses regular expressions to extract Kingdom, Phylum and Species names of blackbird species
- **Fmr.R** - Script that's run by Run_fmr_R.py - reads in a dataset and saves a plot as a pdf
- **LV1.py** - Script that runs the Lotka-Volterra model and plots 2 demonstrative graphs
- **LV2.py** - Script that runs the Lotka-Volterra model with density dependence, taking parameter values from command line
- **Profileme.py** - Functions demonstrating use of profiling to test code speed
- **Profileme2.py** - Faster versions of Profileme.py functions - demonstrating use of profiling to test code speed
- **Regexs.py** - Demonstrates some uses of re module for regex
- **Run_fmr_R.py** - Runs Fmr.R, and print its output to screen along with message of success or failure
- **Run_LV_old.py** - Runs LV1.py and LV2.py and profiles them (called _old because newer version created during groupwork - see below)
- **Test_R.py** - Demonstrate basic use of subprocess module - run an R script and save stdout and stderr to files
- **Timeitme.py** - Compares speed of list comprehensions vs loops and loops vs join method for strings using timeit module
- **Using_os.py** - Find specific files in a directory using os.walk()
- **Vectorize.py** - Demonstrates vectorisation using entry-wise product of two arrays

#### Groupwork
- **LV3.py** - Runs a discrete-time version of the Lotka-Volterra model
- **LV4.py** - Runs a discrete-time version of the Lotka-Volterra model with Gaussian fluctuation of resource growth rate (r)
- **LV5.py** - Runs a discrete-time version of the Lotka-Volterra model, with Gaussian fluctuations of both the resource and consumer populations
- **Run_LV.py** - Imports LV1.py, LV2.py, LV3.py, LV4.py and LV5.py and profiles them
