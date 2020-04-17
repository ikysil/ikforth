#ifndef _args_
#define _args_

#include "IKFCommon.hpp"
#include "IKFunc.hpp"

typedef struct parsed_args_t {
    CELL            dictionary_size;
    CELL            data_stack_size;
    CELL            return_stack_size;
    CELL            user_data_area_size;
    char const *    image_file;
    char const *    forth_file;
    int             forth_argc;
    char const **   forth_argv;
} parsed_args;

parsed_args * init_parsed_args(int const argc, char const ** argv);

void free_parsed_args(parsed_args * args);

#endif
