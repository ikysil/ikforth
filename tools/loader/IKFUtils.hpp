#ifndef _IKFUtils_
#define _IKFUtils_

#include "IKFCommon.hpp"
#include "IKFunc.hpp"
#include "args.hpp"

void ShowLastError(char const * where);

int StartForth(const parsed_args * args, char const * envp[]);

#endif
