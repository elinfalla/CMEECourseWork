#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Variables.sh

# Desc: Two sections: one shows use of variables and the other reads multiple values

# Arguments: 3 -> a string, then two integers separated by a space

# Date: Oct 2020


# Shows use of variables
MyVar='some string'
echo 'The current value of the variable is ' $MyVar
echo 'Please enter a new string'
read MyVar #reads user input
echo 'the current value of the variable is' $MyVar


# Reading multiple values
echo 'Enter two numbers separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'
MySum=`expr $a + $b` #expr is useful for simple maths, back ticks (`) can be used instead of $()
echo $MySum
