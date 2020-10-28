# ikforth

**ikforth** is an idiomatic Forth implementation.

[![Build Status](https://travis-ci.com/ikysil/ikforth.svg?branch=master)](https://travis-ci.com/ikysil/ikforth)

A few facts:
* 32 bits code
* Runs on Linux and Windows (tested with Wine)
* Supports Indirect and Direct Threaded Code representations
* Image-based system
* x86 assembler is used to bootstrap image capable of interpreting from files
* Image is NOT relocatable - absolute 32 bits addresses are used in native and threaded code
* CELL size is 32 bits
* CHAR size is 8 bits
* addressable unit - 1 byte (8 bits)

----

* https://forth-standard.org/
* http://www.forth200x.org/
