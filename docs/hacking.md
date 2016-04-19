# ikforth hacking

## Code Conventions

* Forth source files use `.4th` extension
* File paths for `INCLUDED` (and family) MUST be relative to repository root
* File paths MUST use `/` (forward slash) as file separator

## Repository Structure

*Note*: The structure below is Work In Progress.

* `/application`
   * `/base` - basic interactive system configuration, Forth
   * `/developer` - developer's interactive configuration, Forth
   * etc...
* `/blocks` - filesystem root for `BLOCK` wordset implementations
* `/docs` - system documentation
* `/extension`
   * `/*` - extensions, Forth
   * `*.4th`
* `/host`
   * `/bootdict` - Bootstrap dictionary, Flat Assembler sources
   * `/lincon` - LINux CONstants dynamic library, C sources
   * `/loader` - Loader for dictionaries, C/C++ sources
* `/system`
   * `/linux` - Linux-specific definitions, Forth
   * `/term` - terminal integration, Forth
   * `/win32` - Windows-specific definitions, Forth
   * `*.4th`
* `/test`
   * `/*` - tests, Forth
   * `*.4th`
