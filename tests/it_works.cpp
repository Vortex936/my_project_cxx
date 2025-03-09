import std;

#include <assert.h>

int it_works(int, char**)
{
    assert(1 == 1);

    std::println(std::cout, "It works!");

    return 0;
}