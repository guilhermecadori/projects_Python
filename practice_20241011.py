# Ex 1
'''
    This time no story, no theory. The examples below show you how to write function accum:
    Examples:

    accum("abcd") -> "A-Bb-Ccc-Dddd"
    accum("RqaEzty") -> "R-Qq-Aaa-Eeee-Zzzzz-Tttttt-Yyyyyyy"
    accum("cwAt") -> "C-Ww-Aaa-Tttt"

    The parameter of accum is a string which includes only letters from a..z and A..Z.

'''

def accum(string):
    
    string_split = list(string)
    
    string_out = ''
    
    for idx, letter in enumerate(string):
        string_out += letter.upper() + (idx * (letter).lower()) + '-'
    
    string_out = string_out[:-1]
    
    return string_out


# Test
strings = ['ZpglnRxqenU', 'abcd', 'RqaEzty', 'cwAt']

for string in strings:
    print(accum(string))

    