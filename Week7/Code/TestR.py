#!usr/bin/env python3

"""Demonstrate basic use of subprocess module - run an R script and save stdout and stderr to files"""

__appname__ = "TestR.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout",
                 shell = True).wait()