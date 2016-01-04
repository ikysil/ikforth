#ifndef _IKFUtils_
#define _IKFUtils_

#include "IKFCommon.hpp"
#include "IKFunc.hpp"

bool CanExit = false;

ImageHeader IHeader;
HANDLE hOut;

void StartForth(char const * ImageFileName, char const * StartFileName);

#endif
