# ikforth

**ikforth** is an idiomatic Forth implementation written from scratch.

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

# Build Instructions

## Pre-requisites

* SConstruct 2.4
* flat assembler version 1.71.51
  * `listing` utility built from sources provided with flat assembler package
* GCC (Linux)
* mingw32 (Linux/Windows)
  * symbolic link `mingw32-g++` -> `/usr/bin/i686-w64-mingw32-g++`
* wine 32 bits (Linux)

## Targets

### `all`
### `ansitest`
### `debug`
### `dtc`
### `image`
### `itc`
### `loader`
### `run`
### `term`
### `win32`
