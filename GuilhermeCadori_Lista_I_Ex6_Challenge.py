## Lista I: Python
## 20/04/2023
## Guilherme Cadori

## Ex 6) Caesar Cipher - Challenge
"""
        One of the first known examples of encryption was used by Julius Caesar. Caesar needed 
        to provide written instructions to his generals, but he didn’t want his enemies to learn 
        his plans if the message slipped into their hands. As a result, he developed what later 
        became known as the Caesar Cipher.The idea behind this cipher is simple (and as a result, 
        it provides no protection against modern code-breaking techniques). Each letter in the 
        original message is shifted by 3 places. As a result, A becomes D, B becomes E, C becomes 
        F, D becomes G, etc. The last three letters in the alphabet are wrapped around the 
        beginning: X becomes A, Y becomes B, and Z becomes C. Non-letter characters are not 
        modified by the cipher. Write a program that implements a Caesar cipher. Allow the user 
        to supply the message and the shift amount and then display the shifted message. 
        Ensure that your program encodes both uppercase and lowercase letters. Your program 
        should also support negative shift values to be used both to encode and decode messages. 

"""

# Creating the function
def caesarCipher(message, shift):
    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    shifted_alphabet = alphabet[shift:] + alphabet[:shift]
    encrypted_message = ''
    for char in message:
        if char.lower() in alphabet:
            shifted_char = shifted_alphabet[alphabet.index(char.lower())]
            encrypted_message += shifted_char.upper() if char.isupper() else shifted_char
        else:
            encrypted_message += char
    
    if shift < 0:
        print("Decrypted message:", encrypted_message)
    else:
        print("Encrypted message:", encrypted_message)
    return


# Testing the function
print ("Question 6: Testing the function")
print ("---------------")


# Testing the function - Test 1: Simple shift
x1 = "abc"

caesarCipher(x1, 3)

# Output: 
# Encrypted message: def


# Testing the function - Test 2: Alphabet end cycle
x2 = "xyz"

caesarCipher(x2, 3)

# Output: 
# Encrypted message: abc

   
# Testing the function - Test 3: Uppercase/lowercase test
x3 = "HeLlO wOrLd!"

caesarCipher(x3, 3)

# Output: 
# Encrypted message: KhOoR zRuOg!


# Testing the function - Test 4: Encrypted message decoding test
x4 = "Khoor zruog!"

caesarCipher(x4, -3)

# Output: 
# Encrypted message: Hello world!


# Testing the function - Test 5: Shift size test
x5 = "ABC DEF"

caesarCipher(x5, 5)

# Output: 
# Encrypted message: FGH IJK

print ("---------------")


################################# END #################################

