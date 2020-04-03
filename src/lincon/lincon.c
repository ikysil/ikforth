// lincon.c based on wincon.c by Andrew McKewan, August 1996

#define _BSD_SOURCE
#define _GNU_SOURCE

#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <pthread.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>

// Each entry in the list has a link field, name and value.
typedef struct _Entry {
   struct _Entry *link;
   char *name;
   int value;
} Entry ;

// Add entry to table
#define CONSTANT(x)      {0, #x, (int)x},
#define DEFINE(x,v)      {0, #x, (int)v},
#define SIZEOF(x,v)      DEFINE(x, sizeof(v))
#define OFFSETOF(x,s,f)  DEFINE(x, offsetof(s,f))

// Table of names from generated lincon.i file
Entry entry[] = {
#include "lincon.i"
   {NULL,0}
};

// Create a hash table of the names for quick lookup.
#define HASHSIZE 2003
Entry *hashTable[HASHSIZE];

static int tablesize = 0;

unsigned int hash(char *name) {
   unsigned int h = 0;
   char c;
   while (c = *name++) h += c;
   return h % HASHSIZE;
}

__attribute__((constructor)) void BuildHash() {
   int i;
   for (i = 0; entry[i].name; i++) {
      Entry **bucket = &hashTable[hash(entry[i].name)];
      entry[i].link = *bucket;
      *bucket = &entry[i]; }
   tablesize=i;
}

// Find an entry in the hash table. Return NULL if not found.
Entry *FindHash(char *name) {
   Entry *ep = hashTable[hash(name)];
   while (ep && strcmp(name, ep->name))
      ep = ep->link;
   return ep;
}

// Exported function to find a constant. Return TRUE if found,
// and store the value in *value
int FindConstant(char *addr, int len, int *value) {
   char name[256];
   Entry *ep;

   if (len <= 0 || len > 255)
      return 0;

   memcpy(name, addr, len);
   name[len] = 0;

   ep = FindHash(name);
   if (!ep) return 0;
   *value = ep->value;
   return 1;
}

// Exported function to return next constant, or size of table.
int NextConstant (int num, char **nme, int *sz, int *val) {
   if (num >= tablesize) {*sz = 0; nme = NULL; *val = tablesize; return 1;}
   *sz  = strlen(entry[num].name);
   *nme = entry[num].name;
   *val = entry[num].value;
   return 0;
}

/* EOF */
