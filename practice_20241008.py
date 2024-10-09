# Ex 1
def double_integer(i):
    
    return i * 2

# Ex 2
'''
Debugging sayHello function

The starship Enterprise has run into some problem when creating a program 
to greet everyone as they come aboard. It is your job to fix the code and 
get the program working again!

    Example output:

        Hello, Mr. Spock

'''
def say_hello(name):
    
    return f'Hello, {name}'

# Ex 3
'''
Description:

Implement a function that accepts 3 integer values a, b, c. 
The function should return true if a triangle can be built with the sides of 
given length and false in any other case.

(In this case, all triangles must have surface greater than 0 to be accepted).

    Examples:
        Input -> Output
        1,2,2 -> true
        4,2,3 -> true
        2,2,2 -> true
        1,2,3 -> false
        -5,1,3 -> false
        0,2,3 -> false
        1,2,9 -> false 

GC: This requires knowledge of Triangle Inequality Theorem

    A triangle can be formed if the sum of the lengths of any 
    two sides is greater than the length of the third side. 
    This gives you three conditions to check: (a + b > c and a + c > b and b + c > a)
    
'''
def is_triangle(a, b, c):
    
    if (a + b > c and a + c > b and b + c > a):
        return True
    else:
        return False
        
    return
