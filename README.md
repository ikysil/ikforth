# ikforth

**ikforth** is an idiomatic Forth implementation written from scratch.

A few facts:
* 32 bits code
* Supports Indirect and Direct Threaded Code representations
* Image-based system
* x86 assembler is used to bootstrap image capable of interpreting from files
* Image is NOT relocatable - absolute 32 bits addresses are used in native and threaded code
* CELL size is 32 bits
* CHAR size is 8 bits
