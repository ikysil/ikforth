#include <stdio.h>
#include <string.h>

#include "FKernel.hpp"
#include "args.hpp"

bool CanExit = false;

ImageHeader IHeader;

int main(int const argc, char const ** argv, char const ** envp) {
    parsed_args * args = init_parsed_args(argc, argv);
    int returnCode = StartForth(args, envp);
    free_parsed_args(args);
    return returnCode;
}
