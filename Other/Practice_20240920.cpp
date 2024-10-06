#include <iostream>

// Variables and data types

int main(){

    std::string number1_str = "15"; // Decimal 
    std::string number2_str = "017"; // Octal representation of decimal 15
    std::string number3_str = "0x0f"; // Hexadecimal representaiton of decimal 15
    std::string number4_str = "0b00001111"; // Binary representation of decimal 15
    int number1 = 15; // Decimal 
    int number2 = 017; // Octal representation of decimal 15
    int number3 = 0x0f; // Hexadecimal representaiton of decimal 15
    int number4 = 0b00001111; // Binary representation of decimal 15

    std::cout << "Representation of 15 in different number systems" << std::endl;
    std::cout << "Decimal System: " << number1 << " is " << number1_str << "." << std::endl;
    std::cout << "Octal System: " << number2 << " is " << number2_str << "." << std::endl;
    std::cout << "Hexadecimal System: " << number3 << " is " <<number3_str << "." << std::endl;
    std::cout << "Binary System: " << number4 << " is " << number4_str << "." << std::endl;

    return 0;
}

