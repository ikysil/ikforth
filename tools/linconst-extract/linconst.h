#define _DEFAULT_SOURCE
#define _GNU_SOURCE

#include <sys/mman.h>
#include <sys/procfs.h>
#include <sys/resource.h>
#include <sys/select.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <dlfcn.h>
#include <errno.h>
#include <elf.h>
#include <fcntl.h>
#include <fts.h>
#include <limits.h>
#include <poll.h>
#include <pthread.h>
#include <regex.h>
#include <resolv.h>
#include <signal.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <syscall.h>
#include <sysexits.h>
#include <termios.h>
#include <unistd.h>
