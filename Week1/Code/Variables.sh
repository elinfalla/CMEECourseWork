#!bin/bash

# Author: Elin Falla - ef16@ic.ac.uk

# Script: Variables.sh

# Desc: Two sections: one shows use of variables and the other reads multiple values

# Arguments: 3 -> MyVar (a string), a, b (both numbers)

# Date: Oct 2020


# Shows use of variables
# MyVar='some string'
# echo 'the current value of the variable is ' $MyVar
# echo 'Please enter a new string'
# read MyVar
# echo 'the current value of the variable is' $MyVar


# Reading multiple values

echo 'Enter two numbrs separated by space(s)'
read a b
echo 'you entered' $a 'and' $b '. Their sum is:'
MySum=`expr $a + $b`
echo $MySum
