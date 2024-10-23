# Ex 1
'''
    Given an integer as input, can you round it to the next (meaning, "greater than or equal") multiple of 5?

    Examples:
        input:    output:
        0    ->   0
        2    ->   5
        3    ->   5
        12   ->   15
        21   ->   25
        30   ->   30
        -2   ->   0
        -5   ->   -5
        etc.

    Input may be any positive or negative integer (including 0).

    You can assume that all inputs are valid integers.

'''
# Function
def round_to_next5(n):
    if n % 5 == 0:
        return n
    else:
        return n + (5 - n % 5)
# Test
nums = [0, 2, 3, 12, 21, 30, -2, -5, -17, -1]

for num in nums:
    print(round_to_next5(num))