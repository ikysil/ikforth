#include <stdio.h>

void ShowLastError(char const * where) {
    perror(where);
}
