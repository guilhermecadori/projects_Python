# Ex 2
'''
    Check to see if a string has the same amount of 'x's 
    and 'o's. The method must return a boolean and be case insensitive. 
    The string can contain any char.

    Examples input/output:

        XO("ooxx") => true
        XO("xooxx") => false
        XO("ooxXm") => true
        XO("zpzpzpp") => true // when no 'x' and 'o' is present should return true
        XO("zzoo") => false
'''

def xo(s):
    
    s = s.lower()
    
    x_counter = 0
    o_counter = 0
    
    for i in s:
        if i == 'x':
            x_counter += 1
        elif i == 'o':
            o_counter += 1
    
    if (x_counter != o_counter) and (o_counter == 0):
        return False   
    
    return x_counter == o_counter
    
# Test
words = ['ooxx', 'xooxx', 'ooxXm', 'zpzpzpp', 'zzoo']

for word in words:
    print(xo(word))