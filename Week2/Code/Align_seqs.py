#!/usr/bin/env python3

"""Finds the best alignment of two DNA sequences - ie. the alignment with the most matched bases. Writes the
alignment and the number of matches to a file called Alignment_output.txt."""

__appname__ = "Align_seqs.py"
__author__ = "Elin Falla, ef16@ic.ac.uk"
__version__ = "0.0.1"

# Imports #
import pandas as pd
import sys


# Functions #
def string_swap(seq1, seq2):
    """Assign the longer sequence to s1, and the shorter to s2.
    Calculate l1 and l2: l1 is length of the longer sequence, l2 that of the shorter."""
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:  # If l1 is already longer than l2, no need to swap strings
        s1 = seq1
        s2 = seq2
    else:  # If l2 is longer than l1, swap the strings and the lengths
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1 # swaps the two lengths
    return s1, s2, l1, l2


def calculate_score(s1, s2, l1, l2, startpoint):
    """Calculates a score by returning the number of matches starting
    from arbitrary start point in the sequence (chosen by user)"""
    matched = ""  # to hold string displaying alignments
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]:  # if the bases match
                matched = matched + "*"  # * indicates a match
                score = score + 1
            else:
                matched = matched + "-"  # - indicates no match

    # Formatted output
    print("." * startpoint + matched)  # prints '." times whatever number startpoint is set to, then the matched string
    print("." * startpoint + s2)
    print(s1)
    print(score)
    print(" ")

    return score, matched


def find_best_align(s1, s2, l1, l2):
    """Finds the alignment of two sequences that gives the best match (highest score)"""

    my_best_align = None
    my_best_score = -1
    my_best_match = None

    for i in range(l1):  # Note that you just take the last alignment with the highest score
        z, matched = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2  # prints number of '.' to get to startpoint (which is i here)
            my_best_score = z
            my_best_match = "." * i + matched

    print(my_best_match)
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)

    return my_best_align, my_best_score, my_best_match


def main(argv):
    """Main entry point of the program: reads input file, calculates the best match, and writes it to output file."""

    # Open the csv file with the DNA sequences
    sequences = open("../Data/Sequences.csv", "r")

    # Split the csv file by lines and assign the 2 sequences to variables
    seqs = sequences.read().splitlines()
    seq1 = seqs[0]
    seq2 = seqs[1]

    # Run string_swap to find longer sequence
    s1, s2, l1, l2 = string_swap(seq1, seq2)

    # Run find_best_align to find best alignment of sequences
    my_best_align, my_best_score, my_best_match = find_best_align(s1, s2, l1, l2)

    # Write result to an output file called 'Alignment_output.txt'
    output_file = open("../Results/Alignment_output.txt", "w+")
    output_file.write("%s\n%s\n%s\nBest score: %s\n" % (my_best_match, my_best_align, s1, my_best_score))

    # Close the input and output files
    sequences.close()
    output_file.close()

    return 0


if __name__ == "__main__":
    """Makes sure the 'main' function is called from the command line."""
    status = main(sys.argv)
    sys.exit(status)

# TODO FOR GROUP EXERCISE
# function that turns fasta input into string
# function that takes in two dna seqs and outputs (my_best_align, s1, my_best_score)
# main that reads files and outputs resulting file
# Have error message for if 0 or 1 files given, if 0 use default
