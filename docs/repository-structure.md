# ikforth Repository Structure

*Note*: The structure below is Work In Progress.

* /application
   * /base - basic interactive system configuration, Forth
   * /developer - developer's interactive configuration, Forth
   * etc...
* /blocks - root filesystem for BLOCK wordset implementations
* /docs - system documentation
* /extension
   * /* - extensions, Forth
   * *.4th
* /host
   * /bootdict - Bootstrap dictionary, Flat Assembler sources
   * /lincon - LINux CONstants dynamic library, C sources
   * /loader - Loader for dictionaries, C/C++ sources
* /system
   * /linux - Linux-specific definitions, Forth
   * /term - terminal integration, Forth
   * /win32 - Windows-specific definitions, Forth
   * *.4th
