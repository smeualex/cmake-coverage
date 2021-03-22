#include "lib1.h"
#include "lib2.h"
#include <iostream>

int main(void)
{
    std::cout << "START EXE" << std::endl;
    
    lib1_f(3);
    std::cout << "4 + 5 = " << lib2_sum(4,5) << std::endl;

    std::cout << "END EXE" << std::endl;
    return 0;
}