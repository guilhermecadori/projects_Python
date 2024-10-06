#include <iostream>
#include <string>

int main(){
    
    int age;
    float height;
    std::string name;
    std::string areaOfStudy;
    std::string livingState;

    std::cout << "Provide first name: " << std::endl; 
    std::cin >> name;  // Requests input in the terminal 

    std::cout << "Provide age and height (m): " << std::endl;
    std::cin >> age >> height;  // Requesting age and height in a single line

    std::cout << "Provide area of study: " << std::endl;
    std::cin.ignore();  // Clear the newline left by std::cin
    std::getline(std::cin, areaOfStudy);  // Using getline for areaOfStudy

    std::cout << "Provide the State you live in: " << std::endl;
    std::getline(std::cin, livingState);  // Using getline for multi-word input

    std::cout << "Hello, " << name << "!" << std::endl;
    std::cout << "You're " << age << " years old and you're " << height << " m tall." << std::endl;
    std::cout << "Currently, you're studying " << areaOfStudy << "." << std::endl;
    std::cout << "You live in the State of " << livingState << "." << std::endl;
    
    /* New Line Issue:
    
        The "new line" you encountered is due to how input works with std::cin. Let's break down why this happens:
        What Happens with std::cin >>:

        When you use std::cin >>, it reads input up to the first whitespace (like spaces, tabs, or newlines). After it reads the input, it leaves behind the newline character (\n) in the input buffer. This newline character comes from the user pressing the Enter key after entering their input.

        For example, when you enter a value like this:

        text:
        Provide area of study
        ComputerScience <Enter>

        The user presses Enter after typing ComputerScience, which produces the newline character \n. This newline remains in the input buffer after std::cin >>.
        
        Why the Newline Affects std::getline():
            std::cin >> (for variables like areaOfStudy) reads up to the first space or newline, but it doesn't consume the newline character itself.
            When you then use std::getline() for the next input (in your case, for livingState), it sees that leftover newline (\n) in the input buffer, interprets it as an immediate input, and doesn't wait for the user to type anything new. As a result, livingState appears to be empty.

        Why This Happens:
            std::cin reads characters up to the newline but leaves the newline in the buffer.
            std::getline() reads the entire line, including spaces, until it finds a newline. If the newline is already in the buffer (from previous input), it will consider the input as completed without waiting for the user.

        Example of What Happens:
        If you enter ComputerScience for areaOfStudy and then press Enter, the input buffer contains:

        text:
        ComputerScience\n

        std::cin >> areaOfStudy reads ComputerScience and leaves \n in the buffer. When you call std::getline() for livingState, it immediately consumes the leftover \n, which causes the function to "end" before it actually gets any meaningful input from the user.
        
        Solutions:
        To fix this, you either:

            Ignore the newline (with std::cin.ignore()).
            Use std::getline() consistently to avoid leaving behind extra characters in the buffer.

        The newline is a result of pressing the Enter key, and std::cin >> leaves it in the input buffer, affecting subsequent input operations.

    */


    return 0;
}
