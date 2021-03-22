#include "lib1.h"
#include <iostream>

void lib1_f(int i)
{
    if(i%2)
        std::cout << "Number is odd" << std::endl;
    else
        std::cout << "Number is even" << std::endl;
}