# ikforth hacking

## Code Conventions

* Forth source files MUST use `.4th` extension (if produced by IKForth contributors)
* File paths for `INCLUDED` (and family) MUST be relative to repository root
* File paths MUST use `/` (forward slash) as file separator

## Repository Structure

*Note*: The structure below is Work In Progress.

* `/blocks` - filesystem root for `BLOCK` wordset implementations
* `/bootdict` - Bootstrap dictionary, Flat Assembler sources
  * `/tc` - Forth VM threaded code
  * `/x86` - native x86 code
  * `/x86-dtc` - native x86 code, DTC specifics
  * `/x86-itc` - native x86 code, ITC specifics
  * `bootdict-x86.asm` - main module for x86
* `/build` - build artifacts and temporary files
* `/contrib`
  * `/*` - contributions, Forth
  * `*.4th`
* `/docs` - system documentation
* `/docker` - definitions for Dockerized build environments
* `/lib` - libraries
* `/product`
  * `ikforth-base-x86` - basic interactive system configuration, Forth
  * `ikforth-dev-x86` - developer's interactive configuration, Forth
* `/src`
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
  * `/forth2012-test-suite` - Gerry Jackson's Test programs for Forth 2012 and ANS Forth
  * `*.4th`
