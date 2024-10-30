# Ex 1
"""
    Return the number (count) of vowels in the given string.

    We will consider a, e, i, o, u as vowels for this Kata (but not y).

    The input string will only consist of lower case letters and/or spaces.

"""

# Function
def countVowels(string):
    
    vowels = ['a', 'e', 'i', 'o', 'u']
    vowel_counter = 0
    
    for letter in string:
        if letter in vowels:
            vowel_counter += 1
            
    return vowel_counter


# Test
print('Ex 1')
words = ['aabcdee', 'xyz']

for word in words:
    print(countVowels(word))
    

# Ex 2
"""
    Task

    Your task is to write a function which returns the n-th term of the following series, 
    which is the sum of the first n terms of the sequence (n is the input parameter).

    You will need to figure out the rule of the series to complete this.
    Rules
        - You need to round the answer to 2 decimal places and return it as String.
        - If the given value is 0 then it should return "0.00".
        - You will only be given Natural Numbers as arguments.

    Examples (Input --> Output)
        n
        1 --> 1 --> "1.00"
        2 --> 1 + 1/4 --> "1.25"
        5 --> 1 + 1/4 + 1/7 + 1/10 + 1/13 --> "1.57"
        
"""
    
"""
    Scratch
    n
    0 --> 0 --> "0.00"
    1 --> 1 --> "1.00"
    2 --> 1 + 1/4 --> "1.25"
    3 --> 1 + 1/4 + 1/7
    4 --> 1 + 1/4 + 1/7 + 1/10
    5 --> 1 + 1/4 + 1/7 + 1/10 + 1/13 --> "1.57"
        
"""
# Function
def sum_series(n):

    # Initialize support variables
    sum_of_terms = 0
    denominator = 1
    
    # Summing series
    for i in range(n):
        term = 1/(denominator)
        sum_of_terms += term
        denominator += 3 
    
    sum_of_terms = str('{:.2f}'.format(sum_of_terms))
    
    return sum_of_terms

    
# Test
print('\nEx 2')
series = [0, 1, 2, 3, 4, 5]

for n in series:
    print(sum_series(n))