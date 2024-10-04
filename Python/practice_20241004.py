'''

    In this kata you will create a function that takes a list of non-negative integers 
    and strings and returns a new list with the strings filtered out.
    
    Example:
    filter_list([1,2,'a','b']) == [1,2]
    filter_list([1,'a','b',0,15]) == [1,0,15]
    filter_list([1,2,'aasf','1','123',123]) == [1,2,123]

'''
# Ex 1
def filter_list(full_list):

    filtered_list = []
    
    for item in full_list:
        if type(item) == int:
            filtered_list.append(item)
    
    return filtered_list

       
# Ex 2
'''
    You ask a small girl,"How old are you?" She always says, "x years old", where x is a random number between 0 and 9.

    Write a program that returns the girl's age (0-9) as an integer.

    Assume the test input string is always a valid string. 
    For example, the test input may be "1 year old" or "5 years old". 
    The first character in the string is always a number.

'''
def get_age(age):
    
    age_num = None
    age_items = age.split()
    
    for item in age_items:
        if len(item) > 1:
            pass
        else:
            age_num = int(item)
        
    return age_num

# Test
age = "2 years old"
get_age(age)


# Ex 3
'''
    After a hard quarter in the office you decide to get some rest on a vacation. 
    So you will book a flight for you and your girlfriend and try to leave all the mess behind you.

    You will need a rental car in order for you to get around in your vacation. 
    The manager of the car rental makes you some good offers.

    Every day you rent the car costs $40. If you rent the car for 7 or more days, you get $50 off your total. 
    Alternatively, if you rent the car for 3 or more days, you get $20 off your total.

    Write a code that gives out the total amount for different days(d).
    
'''

def rental_car_cost(d):
    
    cost = 40
        
    if d < 3:
        total_cost = d * cost
    elif d >= 7:
        total_cost = (d * cost) - 50
    else:
        total_cost = (d * cost) - 20

    return total_cost

# Test
days = [2, 3, 4, 8]

for day in days:
    print(rental_car_cost(day))