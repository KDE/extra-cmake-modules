#include "testhelper.h"

int main()
{
    make_test_file("test14.txt");
    int var = TEST_DEF;
    return var == 1 ? 0 : 1;
}

