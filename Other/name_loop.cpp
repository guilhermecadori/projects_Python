#include <iostream>

int main(){
    /*]
        "int main()" function warning: 
        Cannot have more than one script in the same folder
    */
    
    std::cout << "My name 'Guilherme' will be printed 10 times:" << std::endl;
    std::string my_name = "Guilherme";
    int numOfTimes = 10;

    for (int i = 0; i < numOfTimes; i++) {
        std::cout << my_name << std::endl;
    }

    return 0 ; // Often used to make sure the program ran as expected

}