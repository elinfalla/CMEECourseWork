######################
## STORING OBJECTS
######################
#To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

import pickle

f = open('../Sandbox/testp.p', 'wb') #b means accepts binary files
pickle.dump(my_dictionary, f) #write my_dicionary into the file
f.close()

#Load the data again
f = open('../Sandbox/testp.p', 'rb') #read, accepts binary files
another_dictionary = pickle.load(f)
f.close()

print(another_dictionary)
