# Ex 1
'''
    Complete the solution so that the function will break up camel casing, 
    using a space between words.
    Example:
        "camelCasing"  =>  "camel Casing"
        "identifier"   =>  "identifier"
        ""             =>  ""
'''

# Function
def isCamelCase(s):
    
    string = s
    output_string = ''
    
    for letter in string:
        if letter != letter.upper():
            output_string += letter
        else:
            output_string += " " + letter
            
    return output_string

# Teset
strings = ["camelCasing", "identifier"]

for string in strings:
    print(isCamelCase(string))