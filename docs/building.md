# ikforth Build Instructions

## Pre-requisites

* SConstruct 2.4+
* flat assembler version 1.71.54
  * `listing` utility built from sources provided with flat assembler package
* GCC (Linux)
* mingw32 (Linux/Windows)
  * symbolic link `mingw32-g++` -> `/usr/bin/i686-w64-mingw32-g++`
* wine 32 bits (Linux)

## Dockerized build environment
```bash
docker build --rm -f Dockerfile --build-arg RUNUID=$UID -t ikforth-build:latest .
docker run --rm -it -v $PWD:/opt/ikforth ikforth-build:latest -c "scons -c && scons all"
```

## Dockerized run environment
```
docker run --rm -it -v $PWD:/opt/ikforth ikforth-build:latest
```

## Targets

### `all`
### `ansitest`
### `bootdict`
### `bootdict-x86`
### `debug`
### `dtc`
### `fptest`
### `itc`
### `loader`
### `run`
### `term`
### `win32`
