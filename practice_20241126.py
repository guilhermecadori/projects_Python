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
def count_divisors(n):
    # Array for capturing divisors
    divisors = []
    
    # Starting potential divisors
    pontential_divisor = 1
    
    # Checking divisors
    while pontential_divisor < n + 1:
        if n % pontential_divisor == 0:
            divisors.append(pontential_divisor)
        pontential_divisor += 1
    
    return len(divisors)

# Test
test_inputs = [4, 5, 12, 30]

for input in test_inputs:
    print(count_divisors(input))
    

# Ex 2 kyu 6