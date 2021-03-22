#ifdef _WIN32
    #include <Windows.h>
#endif
#include "catch2/catch.hpp"

TEST_CASE("lib1 test1", "[test1]")
{
    REQUIRE(1 == 1);
}