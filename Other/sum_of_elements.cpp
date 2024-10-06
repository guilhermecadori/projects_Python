#include <iostream>

// Creating a function
// After being created, this function can be called anywhere
int sumOfElements_function (int num1, int num2){
    int sumOfElements_func = num1 + num2;
    return sumOfElements_func;
}

int main(int argc, char **argv){

    int firstNumber = 10;
    int secondeNumber = 8;

    int sumOfelements = firstNumber + secondeNumber;
    int newSum_func = sumOfElements_function(firstNumber, secondeNumber);

    std::cout << "Sum of elements is: " << sumOfelements << std::endl;
    std::cout << "Sum of elements using a function : " << newSum_func << std::endl;

    return 0;

}
