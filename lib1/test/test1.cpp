#ifdef _WIN32
    #include <Windows.h>
#endif
#include "catch2/catch.hpp"
#include "lib1.h"

TEST_CASE("lib1 test1", "[test1]")
{
    lib1_f(4);
    REQUIRE(1 == 1);
}