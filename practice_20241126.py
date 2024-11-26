# Ex 1 - kyu 7
""" 
    Count the number of divisors of a positive integer n.

    Random tests go up to n = 500000, but fixed tests go higher.
    Examples (input --> output)

    4 --> 3 // we have 3 divisors - 1, 2 and 4
    5 --> 2 // we have 2 divisors - 1 and 5
    12 --> 6 // we have 6 divisors - 1, 2, 3, 4, 6 and 12
    30 --> 8 // we have 8 divisors - 1, 2, 3, 5, 6, 10, 15 and 30

    Note you should only return a number, the count of divisors. 
    The numbers between parentheses are shown only for you to see which numbers are counted in each case.
"""

# Function
# def count_divisors(n):
#     # Array for capturing divisors
#     divisors = []
    
#     # Starting potential divisors
#     pontential_divisor = 1
    
#     # Checking divisors
#     while pontential_divisor < n + 1:
#         if n % pontential_divisor == 0:
#             divisors.append(pontential_divisor)
#         pontential_divisor += 1
    
#     return len(divisors)

# # Test
# test_inputs = [4, 5, 12, 30]

# for input in test_inputs:
#     print(count_divisors(input))
    

# Ex 2 kyu 6
"""
    Jamie is a programmer, and James' girlfriend. 
    She likes diamonds, and wants a diamond string from James. 
    Since James doesn't know how to make this happen, he needs your help.

    You need to return a string that looks like a diamond shape when printed 
    on the screen, using asterisk (*) characters. 
    Trailing spaces should be removed, and every line must be terminated 
    with a newline character.

    Return null/nil/None/... if the input is an even number or negative, 
    as it is not possible to print a diamond of even or negative size.
    
    Examples
        A size 3 diamond:
         *
        ***
         *
         
        Which would appear as a string: " *\n***\n *\n"
        
        A size 5 diamond:
          *
         ***
        *****
         ***
          *
        
        That is: "  *\n ***\n*****\n ***\n  *\n"

"""

# Function
def create_diamond(n):
    # Checking input
    if n % 2 == 0 or n < 1:
        return None
    
    diamond = []
    mid_section = n // 2

    # Top half
    for i in range(mid_section + 1):
        spaces = " " * (mid_section - i)
        stars = "*" * (2 * i + 1)
        diamond.append(spaces + stars)

    # Bottom half
    for i in range(mid_section-1, -1, -1):
            spaces = " " * (mid_section - i)
            stars = "*" * (2 * i + 1)
            diamond.append(spaces + stars)
    
    # Adding a final newline (\n) character at the end of the diamond string
    # Without this, some applications might not properly handle the last line
    return "\n".join(diamond) + "\n"

# Test
n_list = [3, 5, 7, -5, 0]

for n_size in n_list:
    print(create_diamond(n_size))
