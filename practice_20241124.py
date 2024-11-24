# Ex 1
'''
    Complete function sale_hotdogs, 
    function accepts 1 parameter:n, n is the number of hotdogs a customer will buy, 
    different numbers have different prices (refer to the following table), 
    return how much money will the customer spend to buy that number of hotdogs.
   
        number of hotdogs 	price per unit (cents)
            n < 5 	                    100
            n >= 5 and n < 10 	         95
            n >= 10 	                 90
'''
def sale_hotdog(n):
    
    if n < 5:
        cost = n * 100
    elif n >= 5 and n < 10:
        cost = n * 95
    else:
        cost = n * 90
        
    return cost
