#ifdef _WIN32
    #include <Windows.h>
#endif
#include "catch2/catch.hpp"
#include "lib1.h"
#include "my-header.h"

TEST_CASE("lib1 test1", "[test1]")
{
    lib1_f(4);
    REQUIRE(1 == 1);
}

TEST_CASE("lib1 test2", "[test2]")
{
    REQUIRE(some_val == 5);
}