# Ex 1
'''
    Your task is to make a function that can take any non-negative integer 
    as an argument and return it with its digits in descending order. 
    Essentially, rearrange the digits to create the highest possible number.

    Examples:

    Input: 42145 Output: 54421

    Input: 145263 Output: 654321

    Input: 123456789 Output: 987654321
    
'''

def rearrange(num):
    
    string_num = str(num)
    
    num_list = []
    str_list = []
    
    for i in string_num:
        i = int(i)
        num_list.append(i)
        
    num_list.sort(reverse=True)
    
    for j in num_list:
        j = str(j)
        str_list.append(j)
    
    final_num = ''.join(str_list)
    final_num = int(final_num)
    
    return final_num

# Test
num = 12453

rearrange(num)
