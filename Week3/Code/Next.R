#!/usr/bin/env R

#### Script that demonstrates a simple for loop - prints only odd numbers

# delete everything
rm(list=ls(all=TRUE))

for (i in 1:10) {
  if ((i %% 2) == 0) #check if number is even
    next #pass to next iteration if even
  print(i)
}

