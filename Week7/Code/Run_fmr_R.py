#!usr/bin/env python3

"""Runs Fmr.R, and print its output to screen along with message of success or failure"""

__appname__ = "Run_fmr_R.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import subprocess

# Use subprocess to run Fmr.R, piping output so can access it
p = subprocess.Popen(["Rscript --verbose ./Fmr.R"],
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE,
                     shell=True)

# Extract stdout and stderr
stdout, stderr = p.communicate()

# Decide if success or failure by trying to open output file
print("Checking for output file...\n**********")
try:
    f = open("../Results/fmr_plot.pdf")
    print("Output file exists - SUCCESS")
except IOError:
    print("Output file does not exist - ERROR")
finally:
    f.close()

# Print contents of stdout to console
print("---\nPrinting R output to screen...\n**********")
print(stdout.decode())


