# ikforth hacking

## Code Conventions

* Forth source files MUST use `.4th` extension (if produced by IKForth contributors)
* File paths for `INCLUDED` (and family) MUST be relative to repository root
* File paths MUST use `/` (forward slash) as file separator

## Repository Structure

*Note*: The structure below is Work In Progress.

* `/application`
   * `/base` - basic interactive system configuration, Forth
   * `/developer` - developer's interactive configuration, Forth
   * etc...
* `/blocks` - filesystem root for `BLOCK` wordset implementations
* `/bootdict` - Bootstrap dictionary, Flat Assembler sources
   * `/tc` - Forth VM threaded code
   * `/x86` - native x86 code
   * `/x86-dtc` - native x86 code, DTC specifics
   * `/x86-itc` - native x86 code, ITC specifics
   * `bootdict-x86.asm` - main module for x86
* `/build` - build artifacts and temporary files
* `/docs` - system documentation
* `/extension`
   * `/*` - extensions, Forth
   * `*.4th`
* `/lincon` - LINux CONstants dynamic library, C sources
* `/loader` - Loader for dictionaries, C/C++ sources
* `/sysdict` - system dictionary, Forth
   * `/term` - terminal integration, Forth
   * `/x86` - x86-specific primitives, Forth
   * `/x86-linux` - Linux-specific definitions, Forth
   * `/x86-windows` - Windows-specific definitions, Forth
   * `*.4th`
* `/test`
   * `/*` - tests, Forth
   * `*.4th`
