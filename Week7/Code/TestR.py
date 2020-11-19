#!/usr/bin/env python3

"""Demonstrate basic use of subprocess - run an R script and save stdout and stderr to files"""

# packages
import subprocess

subprocess.Popen("Rscript --verbose TestR.R > ../Results/TestR.Rout 2> ../Results/TestR_errFile.Rout",
                 shell = True).wait()