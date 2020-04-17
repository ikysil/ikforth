#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "args.hpp"

void help(const char * exec_name) {
    printf("Usage: %s [LOADER OPTIONS...] [-- APPLICATION OPTIONS...]\n", exec_name);
    printf("\t-h\t--help\tShow this message.\n");
    printf("\t-i\t--image\tImage file to load.\n");
    printf("\t-f\t--file\tForth source to run.\n");
    printf("\t-d\t--dict-size\t<size>\tDictionary space size, number with suffix [KkMmGg].\n");
    // printf("\t-r\t--rstack-size\t<size>\tReturn stack size, number with suffix K, M, or G.\n");
    // printf("\t-s\t--dstack-size\t<size>\tData stack size, number with suffix K, M, or G.\n");
    // printf("\t-u\t--user-size\t<size>\tUser area size, number with suffix K, M, or G.\n");
}

CELL parse_size(const char * s) {
    char * tail = nullptr;
    CELL value = strtoul(s, &tail, 10);
    if ((*tail == 'K') || (*tail == 'k')) {
        value *= 1024;
        tail++;
    }
    if ((*tail == 'M') || (*tail == 'm')) {
        value *= 1024 * 1024;
        tail++;
    }
    if ((*tail == 'G') || (*tail == 'g')) {
        value *= 1024 * 1024 * 1024;
        tail++;
    }
    if (*(tail++) != 0) {
        printf("Wrong parameter: %s", s);
        exit(2);
    }
    return value;
}

void replace_after_last_dot(char * s, char const * suffix) {
    char * dIndex = strrchr(s, '.');
    char * sIndex = strrchr(s, '\\');
    if (sIndex == NULL) {
        sIndex = strrchr(s, '/');
    }
    if (dIndex > sIndex) {
        *dIndex = '\0';
    }
    strcat(s, suffix);
}

void apply_defaults(parsed_args * args, const char * exec_name) {
    if (args->image_file == nullptr) {
        char * file = (char *)fAlloc(MAX_FILE_PATH);
        strcpy(file, exec_name);
        replace_after_last_dot(file, ".img");
        args->image_file = file;
    }
    if (args->forth_file == nullptr) {
        char * file = (char *)fAlloc(MAX_FILE_PATH);
        strcpy(file, exec_name);
        replace_after_last_dot(file, ".4th");
        args->forth_file = file;
    }
}

parsed_args * init_parsed_args(int const argc, char const ** argv) {
    parsed_args * args = (parsed_args *) fAlloc(sizeof(parsed_args_t));
    args->forth_argv = (char const **) fAlloc(sizeof(char *) * argc);
    args->forth_argv[0] = argv[0];
    bool forth_args = false;
    int forth_argc = 1;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--") == 0) {
            forth_args = true;
            continue;
        }
        if (forth_args) {
            args->forth_argv[forth_argc++] = argv[i];
            continue;
        }
        if ((strcmp(argv[i], "-h") == 0) || (strcmp(argv[i], "--help") == 0)) {
            help(argv[0]);
            free_parsed_args(args);
            exit(1);
        }
        if ((strcmp(argv[i], "-i") == 0) || (strcmp(argv[i], "--image") == 0)) {
            char * file = (char *)fAlloc(MAX_FILE_PATH);
            strcpy(file, argv[++i]);
            args->image_file = file;
        }
        if ((strcmp(argv[i], "-f") == 0) || (strcmp(argv[i], "--file") == 0)) {
            char * file = (char *)fAlloc(MAX_FILE_PATH);
            strcpy(file, argv[++i]);
            args->forth_file = file;
        }
        if ((strcmp(argv[i], "-d") == 0) || (strcmp(argv[i], "--dict-size") == 0)) {
            args->dictionary_size = parse_size(argv[++i]);
        }
    }
    args->forth_argc = forth_argc;
    apply_defaults(args, argv[0]);
    return args;
}

void free_parsed_args(parsed_args * args) {
    if (args == nullptr) {
        return;
    }
    if (args->image_file != nullptr) {
        fFree((void *) args->image_file);
    }
    if (args->forth_file != nullptr) {
        fFree((void *) args->forth_file);
    }
    fFree(args);
}
