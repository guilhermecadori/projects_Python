## Lista I: Python
## 20/04/2023
## Guilherme Cadori

## Ex 1) Sum of the First n Positive Integers 
"""
       Write a program that reads a positive integer, n, from the user and then displays 
       the sum of all of the integers from 1 to n. The sum of the first n positive integers
       can be computed using the formula: (n + 1) * n / 2.
"""

# Creating the function
def sumPositiveInt(n = 0):
    
    if n < 1:
        print("The value of 'n' must be greater than zero")
        return
    elif type(n) != int:
        print("The value of 'n' must be an integer")
        return
    else:
        sumPositiveInt =  (n + 1) * n / 2
    return print("The sum of positive integers from 1 to", n, "is", sumPositiveInt)

# Testing the function
print ("Question 1: Testing the function")
print ("---------------")

# Testing the function - Test 1
sumPositiveInt(5)

# Output:
# The sum of integer positives from 1 to 5 is 15.0

# Testing the function - Test 2
sumPositiveInt(2)

# Output:
# The sum of integer positives from 1 to 2 is 3.0

# Testing the function - Test 3    
sumPositiveInt(0)

# Output:
# The value of 'n' must be greater than zero

# Testing the function - Test 4
sumPositiveInt(-1)

# Output:
# The value of 'n' must be greater than zero

# Testing the function - Test 4
sumPositiveInt(4.8)

# Output:
# The value of 'n' must be integer

print ("---------------")


## Ex 2) Widgets and Gizmos
"""
        An online retailer sells two products: widgets and gizmos. Each widget weighs 75 grams.
        Each gizmo weighs 112 grams. Write a program that reads the number of widgets and the
        number of gizmos in an order from the user. Then your program should compute and display 
        the total weight of the order. 
"""

# Creating the function
def orderWeight(qtyWidgets = 0, qtyGizmos = 0):
    
    if (type(qtyWidgets) or type(qtyGizmos)) != int:
        print("Quantity ordered must be integer")
        return
    elif (qtyWidgets or qtyGizmos) < 0:
        print("Please indicate a valid order amount")
        return
    else:
        weightWidget = (75 * qtyWidgets) / 1000
        
        weightGizmo = (112 * qtyGizmos) / 1000
        
        orderWeight = sum([weightWidget, weightGizmo])
    
    return print("Total order weight is:", orderWeight, "kg")


# Testing the function
print ("Question 2: Testing the function")
print ("---------------")

# Testing the function - Test 1
orderWeight(20, 10)

# Output:
# Total order weight is: 2.62 kg

# Testing the function - Test 2
orderWeight(10)

# Output:
# Total order weight is: 0.75 kg

# Testing the function - Test 3
orderWeight(0, 10)

# Output:
# Total order weight is: 1.12 kg

# Testing the function - Test 4
orderWeight()

# Output:
# Total order weight is: 0.0 kg

# Testing the function - Test 5
orderWeight(4.2)

# Output:
# Quantity ordered must be integer

# Testing the function - Test 6
orderWeight(-1)

# Output:
# Please indicate a valid order amount

print ("---------------")


## Ex 3) Compound Interest 
"""
        (19 Lines) Pretend you have just opened a new savings account earning 4 percent interest 
        per year. The interest you earn is paid at the end of the year and added to the balance 
        of the savings account. Write a program that begins by reading the amount of money 
        deposited into the account from the user. Then your program should compute and display 
        the amount in the savings account after 1, 2, and 3 years. Display each amount so that 
        it is rounded to 2 decimal places.
"""

# Creating the function
def futureValue(PV = 0, rate = 0.04, n = 3):
    
    for i in range(n):
        futureValue = PV * (1 + rate)**i
        print("Value at period", i, ": R$", round(futureValue, 2))
    return


# Testing the function
print ("Question 3: Testing the function")
print ("---------------")

# Testing the function
futureValue(15000, n = 3)

# Output:
# Value at period 0 : R$ 15000.0
# Value at period 1 : R$ 15600.0
# Value at period 2 : R$ 16224.0

print ("---------------")


## Ex 4) Arithmetic
"""
        Create a program that reads two integers, a and b, from the user. Your program should 
        compute and display: 
            •	The sum of a and b
            •	The difference when b is subtracted from a 
            •	The product of a and b 
            •	The quotient when a is divided by b 
            •	The remainder when a is divided by b 
            •	The result of log10 a 
            •	The result of a^b 

"""

# Creating the function
def arithmOps(a, b):
    import math
    
    sumOps = a + b
    
    diffOps = a - b
    
    prodOps = a * b
    
    quotOps = a // b
    
    remaindOps = a % b
    
    log10Ops = round(math.log10(a), 4)
    
    exponOps = a**b
    
    print("Sum =", sumOps, "\nDifference =", diffOps, "\nProduct =", prodOps, 
          "\nQuotient =", quotOps, "\nRemainder =", remaindOps, "\nLog 10 =", log10Ops,
          "\nExponent =", exponOps)
    
    return


# Testing the function
print ("Question 4: Testing the function")
print ("---------------")

# Testing the function
arithmOps(2, 2)

# Output:
# Sum = 4 
# Difference = 0 
# Product = 4 
# Quotient = 1 
# Remainder = 0 
# Log 10 = 0.3 
# Exponent = 4

print ("---------------")


## Ex 5) Temperature Conversion Table 
"""
        Write a program displaying a temperature conversion table for degrees Celsius and 
        Fahrenheit. The table should include rows for all temperatures between 0 and 100 
        degrees Celsius that are multiples of 10 degrees Celsius. Include appropriate headings 
        on your columns. The formula for converting between degrees Celsius and degrees 
        Fahrenheit can be found on the internet. 
"""

# Creating the function
def tempConversion():
    print("{:^15} {:^15}".format("Celsius (oC)", "Fahrenheit (oF)"))
    print("-" * 30)
    
    for celsius in range(0, 101, 10):
        fahrenheit = celsius * 9/5 + 32
        print("{:^15} {:^15}".format(celsius, round(fahrenheit, 2)))


# Testing the function
print ("Question 5: Testing the function")
print ("---------------")


# Testing the function
tempConversion()

# Output:
#  Celsius (oC)   Fahrenheit (oF)
# ------------------------------
#        0             32.0      
#       10             50.0      
#       20             68.0      
#       30             86.0      
#       40             104.0     
#       50             122.0     
#       60             140.0     
#       70             158.0     
#       80             176.0     
#       90             194.0     
#       100            212.0

print ("---------------")


################################# END #################################
