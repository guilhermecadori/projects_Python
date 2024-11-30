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
# def isCamelCase(s):
    
#     string = s
#     output_string = ''
    
#     for letter in string:
#         if letter != letter.upper():
#             output_string += letter
#         else:
#             output_string += " " + letter
            
#     return output_string

# # Teset
# strings = ["camelCasing", "identifier"]

# for string in strings:
#     print(isCamelCase(string))
    

# Ex 2
'''
    You live in the city of Cartesia where all roads are laid out in a perfect grid. 
    You arrived ten minutes too early to an appointment, so you decided to take the 
    opportunity to go for a short walk. The city provides its citizens with a 
    Walk Generating App on their phones -- everytime you press the button it sends 
    you an array of one-letter strings representing directions to walk (eg. ['n', 's', 'w', 'e']). 
    You always walk only a single block for each letter (direction) and you know it takes you one 
    minute to traverse one city block, so create a function that will return true if the walk the 
    app gives you will take you exactly ten minutes (you don't want to be early or late!) and will, 
    of course, return you to your starting point. Return false otherwise.

    Note: you will always receive a valid array containing a random assortment of 
    direction letters ('n', 's', 'e', or 'w' only). It will never give you an empty array.
'''

# Function
def is_valid_walk(walk):
    # Check if walk will take 10 minutes
    if len(walk) != 10:
        return False
    
    # Check if walk will bring you back to the starting point
    direction_dict = {}
    for direction in walk:
        direction_dict[direction] = direction_dict.get(direction, 0) + 1
    
    if (direction_dict.get('n', 0) - direction_dict.get('s', 0)) == 0:
        if (direction_dict.get('e', 0) - direction_dict.get('w', 0)) == 0:
            return True

    return False

# Test
walks = [['n', 's', 'e', 'w', 'n', 's', 'e', 'w', 'n', 's'], 
         ['n', 's', 'e', 'w', 'n', 's', 'e', 'w', 'n']]

for walk in walks:
    print(is_valid_walk(walk))
