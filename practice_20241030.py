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
words = ['aabcdee', 'xyz']

for word in words:
    print(countVowels(word))
    
    