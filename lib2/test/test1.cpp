#ifdef _WIN32
    #include <Windows.h>
#endif
#include "catch2/catch.hpp"
#include "lib2.h"

TEST_CASE("lib1 test1", "[test1]")
{
    auto sum = lib2_sum(4, 5);
    REQUIRE(9 == sum);
}