#!/usr/bin/env python3

"""Run Fmr.R"""

# packages
import subprocess

p = subprocess.Popen(["Rscript --verbose ./Fmr.R"],
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE,
                     shell=True)

stdout, stderr = p.communicate()

print("Checking for output file...\n**********")
try:
    f = open("../Results/fmr_plot.pdf")
    print("Output file exists - SUCCESS")
except IOError:
    print("Output file does not exist - ERROR")
finally:
    f.close()

print("---\nPrinting R output to screen...\n**********")
print(stdout.decode())


