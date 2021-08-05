#include <new_project_header_zero_prefixed_version.h>
#include <string.h>
#include <stdio.h>

#define intcheck(macro,val) \
    if (macro != val) { \
        printf(#macro " was %d instead of %d", macro, val); \
        return 1; \
    }
#define strcheck(macro,val) \
    if (strcmp(macro,val) != 0) { \
        printf(#macro " was %s instead of %s", macro, val); \
        return 1; \
    }

int main()
{
    intcheck(new_project_header_zero_prefixed_version_VERSION_MAJOR,8)
    intcheck(new_project_header_zero_prefixed_version_VERSION_MINOR,9)
    intcheck(new_project_header_zero_prefixed_version_VERSION_PATCH,7)
    intcheck(new_project_header_zero_prefixed_version_VERSION,((8 << 16) + (9 << 8) + 7))
    strcheck(new_project_header_zero_prefixed_version_VERSION_STRING,"08.09.07")
    return 0;
}
