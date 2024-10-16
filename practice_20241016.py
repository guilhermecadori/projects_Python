# Ex 1
'''
    Complete the function that accepts a string parameter, 
    and reverses each word in the string. 
    All spaces in the string should be retained.
    
    Examples
        "This is an example!" ==> "sihT si na !elpmaxe"
        "double  spaces"      ==> "elbuod  secaps"
'''
import re

def my_reverse_wrds(text):
    
    word_list = re.findall(r'\S+|\s+', text)
    reverse_words = []
    
    for word in word_list:
        # The reversed() function returns a reversed object, not a string
        # When you print it, it displays the object's memory location rather than the reversed text
        # Convert the reversed object into a string
        reverse_word = ''.join(reversed(word))
        reverse_words.append(reverse_word)

    reverse_words_string = ''.join(reverse_words)
    
    return reverse_words_string


# Testing function
words = ['This is an example!', 'double  spaces']

for word in words:
    print(my_reverse_wrds(word))


