#!/usr/bin/env python3

"""Finds the best alignment of two DNA sequences (ie. the alignment with the most matched bases) from two inputted
FASTA files. Writes the alignment and the number of matches to a file."""

__appname__ = 'Align_seqs_fasta.py'
__author__ = 'Ioan Evans (ie917@ic.ac.uk), Elin Falla (ef16@ic.ac.uk), Danica Duan (d.duan20@imperial.ac.uk), Eesha Rangani (eesha_rangani@yahoo.com)'
__version__ = '0.0.1'

# Imports

import os
import sys


def to_string(fasta):
    """Convert the sequence data in the fasta file to a string"""

    # remove header
    fasta_nh = fasta.readlines()[1:]

    # make into single string
    fasta_str = ''.join(fasta_nh)

    # remove newline characters
    seq = fasta_str.replace("\n", "")

    return seq


def string_swap(seq1, seq2):
    """Assign the longer sequence to s1, and the shorter to s2.
    Calculate l1 and l2: l1 is length of the longer sequence, l2 that of the shorter"""

    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:  # If l1 is already longer than l2, no need to swap strings
        s1 = seq1
        s2 = seq2
    else:  # If l2 is longer than l1, swap the strings and the lengths
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1  # swaps the two lengths

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

    return score


def find_best_align(s1, s2, l1, l2):
    """Finds the alignment of two sequences that gives the best match (highest score)"""

    my_best_align = None
    my_best_score = -1

    for i in range(l1):  # Note that you just take the last alignment with the highest score
        z = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = "." * i + s2  # prints number of '.' to get to startpoint (which is i here)
            my_best_score = z

    # Formatted output
    print(my_best_align)
    print(s1)
    print("Best score:", my_best_score)

    return my_best_align, my_best_score


def output_file(a, b, my_best_align, my_best_score, s1):
    """Finds basename of input files to create output file; writes best alignment to it"""

    # Convert fastafiles to strings
    a = str(a)
    b = str(b)

    # Get basenames of fasta filepaths
    base_a = os.path.basename(a)
    name_a = os.path.splitext(base_a)[0]
    base_b = os.path.basename(b)
    name_b = os.path.splitext(base_b)[0]

    # Write alignment output to file (named using basenames)
    g = open(f'../Results/fasta_{name_a}+{name_b}.txt', 'w')
    g.write('My best alignment is: ' + '\n' + str(my_best_align) + '\n' + str(s1) + '\n')
    g.write('My best score is ' + str(my_best_score) + '\n')

    return


def main(argv):
    """Main entry point of the program: reads input files, calculates the best match, and writes it to output file"""

    # If two files not inputted on the command line
    if len(sys.argv) != 3:

        if len(sys.argv) == 2:
            print("Not enough files. Please use 2 fasta files as arguments.")
            return 1

        elif len(sys.argv) == 1:  # if no arguments given, use default files
            print("No files given. Using default fasta files...")
            fastafile1 = open("../Data/407228326.fasta", "r")
            fastafile2 = open("../Data/407228412.fasta", "r")

        else:  # else if more than 3
            print("Too many files. Please use 2 fasta files as arguments.")
            return 2

    else:  # if 2 input files given
        fastafile1 = open(sys.argv[1], "r")
        fastafile2 = open(sys.argv[2], "r")

    # Prepare the fasta files
    seq1 = to_string(fastafile1)
    seq2 = to_string(fastafile2)

    # Run string_swap to find longer sequence
    s1, s2, l1, l2 = string_swap(seq1, seq2)

    # Run find_best_align to find best alignment of sequences
    my_best_align, my_best_score = find_best_align(s1, s2, l1, l2)

    # Output file
    output_file(fastafile1, fastafile2, my_best_align, my_best_score, s1)

    return 0


if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)


