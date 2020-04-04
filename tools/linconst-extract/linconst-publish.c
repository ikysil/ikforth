#include "linconst.h"

// Add entry to table
#define CONSTANT(x)      {#x, (int)x},
#define DEFINE(x,v)      {#x, (int)v},
#define SIZEOF(x,v)      DEFINE(x, sizeof(v))
#define OFFSETOF(x,s,f)  DEFINE(x, offsetof(s,f))

typedef struct _Entry {
   char *name;
   int value;
} Entry ;

Entry entry[] = {
#include "linconst-extract.E2"
#include "linconst-publish.i"
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
