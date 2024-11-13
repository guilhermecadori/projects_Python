# Ex 1
"""
    Count the number of Duplicates

    Write a function that will return the count of distinct case-insensitive alphabetic characters and numeric digits that occur more than once in the input string. The input string can be assumed to contain only alphabets (both uppercase and lowercase) and numeric digits.
    Example
        "abcde" -> 0 # no characters repeats more than once
        "aabbcde" -> 2 # 'a' and 'b'
        "aabBcde" -> 2 # 'a' occurs twice and 'b' twice (`b` and `B`)
        "indivisibility" -> 1 # 'i' occurs six times
        "Indivisibilities" -> 2 # 'i' occurs seven times and 's' occurs twice
        "aA11" -> 2 # 'a' and '1'
        "ABBA" -> 2 # 'A' and 'B' each occur twice
"""

# Function
def countNonUnique(stringInput):

    stringInput = stringInput.lower()
    
    elementDict = {}
    nonUnique = 0
    
    for element in stringInput:
        if element in elementDict:
            elementDict[element] += 1
        else:
            elementDict[element] = 1

    for count in elementDict.values(): 
        if count > 1:
            nonUnique += 1

    # print(elementDict)
    
    return nonUnique

# Test
# Should return: 0, 2, 2, 2
strings = ["abcde", "aabbcde", "Indivisibilities", "aA11"] 

for string in strings:
    print(countNonUnique(string))