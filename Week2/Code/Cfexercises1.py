#What does each of foo_x do?

#Raises an integer to the power of 0.5
def foo_1(x):
    return x ** 0.5

#Returns the larger of two number inputs
def foo_2(x, y):
    if x > y:
        return x
    return y

#Puts 3 numbers in size order, starting with the smallest
def foo_3(x, y, z):
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x,y,z]

#Calculates factorial of a number x (using for loop)
def foo_4(x):
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

#Recursive function that calculates factorial of number x
def foo_5(x):
    if x == 1:
        return 1
    return x * foo5(x - 1)

#Calculates factorial of number x (using while loop)
def foo_6(x):
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto
