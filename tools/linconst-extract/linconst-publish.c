#include "linconst.h"

#define CONSTANT(x)      {#x, (int)x},

typedef struct _Entry {
   char *name;
   int value;
} Entry ;

Entry entry[] = {
#include "linconst-extract.E2"
   {NULL,0}
};

int main() {
    printf("BASE @ HEX\n");
    for (int i = 0; entry[i].name; i++) {
        printf("%08X CONSTANT %s\n", entry[i].value, entry[i].name);
    }
    printf("BASE !\n");
    return 0;
}
