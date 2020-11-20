#!usr/bin/env python3

"""Runs LV1.py and LV2.py and profiles them"""

__appname__ = "Run_LV.py"
__author__ = 'Elin Falla (ef16@ic.ac.uk)'
__version__ = '0.0.1'

# Imports #
# Packages
import cProfile
import pstats

# Scripts
import LV2
import LV1

scripts = (LV1, LV2)

for script in scripts:
    # opens profile
    pr = cProfile.Profile()

    # enables profile
    pr.enable()

    # runs script within profile
    script.main([])  # main takes argv which is a list so put in empty list

    # disables profile
    pr.disable()

    # create stats based on the profile
    ps = pstats.Stats(pr)

    # sort stats by cumulative time then print first 20 lines to get only largest cumtimes
    ps.sort_stats('cumtime').print_stats(20)





