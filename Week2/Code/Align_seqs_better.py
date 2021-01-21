#!/usr/bin/env python3

"""Finds the best alignment of two DNA sequences (ie. the alignment with the most matched bases) from two inputted
FASTA files. If multiple best matches, it outputs all of them. Writes the alignment(s) and the number of matches to a
file."""

__appname__ = "Align_seqs_better.py"
__author__ = "Elin Falla (ef16@ic.ac.uk), Ioan Evans (ie917@ic.ac.uk), Danica Duan (dd1820@ic.ac.uk)"
__version__ = "0.0.1"

# Imports #
import sys
import os


# Functions #
def fasta_to_string(fastafile):
    """Converts fasta file to a string"""
    # Read fasta file into a string
    sequence = fastafile.read()

    # Remove first line
    sequence = sequence.split("\n", 1)[1]  # split at \n, maxsplit = 1, then selects second element (ie. sequence)

    # Remove newline characters if present
    if "\n" in sequence:
        sequence = sequence.replace("\n", "")

    return sequence


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
    # print("." * startpoint + matched)  # prints '." times whatever number startpoint is set to, then the matched string
    # print("." * startpoint + s2)
    # print(s1)
    # print(score)
    # print(" ")

    return score, matched


def find_best_align(s1, s2, l1, l2):
    """Finds the alignment of two sequences that gives the best match (highest score)"""

    my_best_align = []
    my_best_score = -1
    my_best_match = []

    for i in range(l1):  # Note that you just take the last alignment with the highest score
        z, matched = calculate_score(s1, s2, l1, l2, i)
        if z > my_best_score:
            my_best_align = ["." * i + s2]  # prints number of '.' to get to startpoint (which is i here)
            my_best_score = z
            my_best_match = ["." * i + matched]
        elif z == my_best_score:
            my_best_align.append("." * i + s2)
            my_best_match.append("." * i + matched)
            # print("*********** EQUAL MATCH FOUND *************")
            # print(my_best_align)
            # print(my_best_match)

    # Formatted output
    print("BEST SCORE:", my_best_score)
    print(len(my_best_match), "alignment(s) found with best score:\n")
    #print("\n")
    for i in range(len(my_best_match)):
        print(my_best_match[i])
        print(my_best_align[i])
        print(s1,"\n")






    return my_best_align, my_best_score, my_best_match


def main(argv):
    """Main entry point of the program: reads input file, calculates the best match, and writes it to output file."""

    # If two files not inputted on the command line
    if len(sys.argv) != 3:

        if len(sys.argv) == 2:
            print("Not enough files. Please use 2 fasta files as arguments.")
            return 1

        if len(sys.argv) == 1:  # if no arguments given, use default files
            print("No files given. Using default fasta files...")
            fastafile1 = open("../Data/407228326.fasta", "r")
            fastafile2 = open("../Data/407228412.fasta", "r")

        else:  # else if more than 3
            print("Too many files. Please use 2 fasta files as arguments.")
            return 2

    else:  # if 2 input files given
        fastafile1 = open(sys.argv[1], "r")
        fastafile2 = open(sys.argv[2], "r")

    seq1 = fasta_to_string(fastafile1)
    seq2 = fasta_to_string(fastafile2)

    # Run string_swap to find longer sequence
    s1, s2, l1, l2 = string_swap(seq1, seq2)

    # Run find_best_align to find best alignment of sequences
    my_best_align, my_best_score, my_best_match = find_best_align(s1, s2, l1, l2)

    # Create file name
    base_file_1 = os.path.basename(str(fastafile1))
    name_file_1 = os.path.splitext(base_file_1)[0]

    base_file_2 = os.path.basename(str(fastafile2))
    name_file_2 = os.path.splitext(base_file_2)[0]

    # Write result to an output file named according to input files, and print results to console
    output_file = open(f"../Results/Alignment_{name_file_1}_{name_file_2}.txt", "w+")

    print("Best score:", my_best_score)
    print(len(my_best_match), "alignment(s) found with best score:\n")
    output_file.write(f"BEST SCORE: {str(my_best_score)}\n{str(len(my_best_match))} alignment(s) found with best score:\n\n")

    # for loop to print all the best matches
    for i in range(len(my_best_match)):
        output_file.write(f"------\nAlignment {str(i + 1)}\n------\n\n")

        print(my_best_match[i])
        output_file.write(f"{my_best_match[i]}\n\n")

        print(my_best_align[i])
        output_file.write(f"{my_best_align[i]}\n\n")

        print(s1,"\n")
        output_file.write(f"{s1}\n\n")

    # Close the input and output files
    fastafile1.close()
    fastafile2.close()
    output_file.close()

    return 0


if __name__ == "__main__":
    """Makes sure the 'main' function is called from the command line."""
    status = main(sys.argv)
    sys.exit(status)