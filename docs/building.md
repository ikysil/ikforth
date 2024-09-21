# ikforth Build Instructions

## Pre-requisites

* SConstruct 4.3+
* flat assembler version 1.73+
  * Linux version for Linux environment
  * Windows version for Windows and Cygwin environments
  * `listing` utility built from sources provided with flat assembler package
* GCC (Linux)
* cygwin32-gcc (Cygwin64)
* mingw32 (Linux/Windows)
  * symbolic link `/usr/local/bin/mingw32-g++` -> `/usr/bin/i686-w64-mingw32-g++`
  * symbolic link `/usr/local/bin/mingw32-gcc` -> `/usr/bin/i686-w64-mingw32-gcc`
* wine 32 bits (Linux)
* 32 bit packages (Linux):
  * lib32readline8 (Ubuntu 19.10+)
  * readline.i686 (CentOS 7+)

## Dockerized build environment with Docker

```bash
docker build --rm -f docker/fedora-40/Dockerfile --build-arg RUNUID=$UID -t ikforth-build:latest .
docker run --rm -it -v $PWD:/opt/ikforth --userns=host ikforth-build:latest -c "scons -c && scons all"
```

## Dockerized run environment with Docker

```bash
docker run --rm -it -v $PWD:/opt/ikforth --userns=host ikforth-build:latest
```

## Dockerized build environment with Podman

```bash
podman build --rm -f docker/fedora-40/Dockerfile --build-arg RUNUID=$UID -t ikforth-build:latest .
podman run --rm -it -v $PWD:/opt/ikforth --userns=keep-id ikforth-build:latest -c "scons -c && scons all"
```

## Dockerized run environment with Podman

```bash
podman run --rm -it -v $PWD:/opt/ikforth --userns=keep-id ikforth-build:latest
```

## Targets

### `all`
### `ansitest`
### `bootdict`
### `bootdict-listing`
### `debug`
### `dtc`
### `fptest`
### `ikforth`
### `itc`
### `linconst`
### `loader`
### `run`
### `term`
### `win32`
### `winconst`

## Build Environment Matrix

### CentOS 7 - OK

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.8.5/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
    --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
    --enable-shared --enable-threads=posix --enable-checking=release
    --with-system-zlib --enable-__cxa_atexit
    --disable-libunwind-exceptions --enable-gnu-unique-object
    --enable-linker-build-id --with-linker-hash-style=gnu
    --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto
    --enable-plugin --enable-initfini-array --disable-libgcj
    --with-isl=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/isl-install
    --with-cloog=/builddir/build/BUILD/gcc-4.8.5-20150702/obj-x86_64-redhat-linux/cloog-install
    --enable-gnu-indirect-function --with-tune=generic
    --with-arch_32=x86-64 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC)
```

### CentOS 8 - EOL

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/8/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-redhat-linux
Configured with: ../configure --enable-bootstrap
    --enable-languages=c,c++,fortran,lto
    --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info
    --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared
    --enable-threads=posix --enable-checking=release --enable-multilib
    --with-system-zlib --enable-__cxa_atexit
    --disable-libunwind-exceptions --enable-gnu-unique-object
    --enable-linker-build-id --with-gcc-major-version-only
    --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array
    --with-isl --disable-libmpx --enable-offload-targets=nvptx-none
    --without-cuda-driver --enable-gnu-indirect-function --enable-cet
    --with-tune=generic --with-arch_32=x86-64 --build=x86_64-redhat-linux
Thread model: posix
gcc version 8.3.1 20190507 (Red Hat 8.3.1-4) (GCC)
```

### Fedora 31 - OK

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/9/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-redhat-linux
Configured with: ../configure --enable-bootstrap
    --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,d,lto --prefix=/usr
    --mandir=/usr/share/man --infodir=/usr/share/info
    --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared
    --enable-threads=posix --enable-checking=release --enable-multilib
    --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions
    --enable-gnu-unique-object --enable-linker-build-id
    --with-gcc-major-version-only --with-linker-hash-style=gnu
    --enable-plugin --enable-initfini-array --with-isl
    --enable-offload-targets=nvptx-none --without-cuda-driver
    --enable-gnu-indirect-function --enable-cet --with-tune=generic
    --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 9.3.1 20200317 (Red Hat 9.3.1-1) (GCC)
```

### Ubuntu 18.04 - OK

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/7/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 7.5.0-3ubuntu1~18.04'
    --with-bugurl=file:///usr/share/doc/gcc-7/README.Bugs
    --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++
    --prefix=/usr --with-gcc-major-version-only --program-suffix=-7
    --program-prefix=x86_64-linux-gnu- --enable-shared
    --enable-linker-build-id --libexecdir=/usr/lib
    --without-included-gettext --enable-threads=posix --libdir=/usr/lib
    --enable-nls --enable-bootstrap --enable-clocale=gnu
    --enable-libstdcxx-debug --enable-libstdcxx-time=yes
    --with-default-libstdcxx-abi=new --enable-gnu-unique-object
    --disable-vtable-verify --enable-libmpx --enable-plugin
    --enable-default-pie --with-system-zlib --with-target-system-zlib
    --enable-objc-gc=auto --enable-multiarch --disable-werror
    --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32
    --enable-multilib --with-tune=generic
    --enable-offload-targets=nvptx-none --without-cuda-driver
    --enable-checking=release --build=x86_64-linux-gnu
    --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)
```

### Ubuntu 19.10 - EOL

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/9/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:hsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 9.2.1-9ubuntu2'
    --with-bugurl=file:///usr/share/doc/gcc-9/README.Bugs
    --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++,gm2
    --prefix=/usr --with-gcc-major-version-only --program-suffix=-9
    --program-prefix=x86_64-linux-gnu- --enable-shared
    --enable-linker-build-id --libexecdir=/usr/lib
    --without-included-gettext --enable-threads=posix --libdir=/usr/lib
    --enable-nls --enable-bootstrap --enable-clocale=gnu
    --enable-libstdcxx-debug --enable-libstdcxx-time=yes
    --with-default-libstdcxx-abi=new --enable-gnu-unique-object
    --disable-vtable-verify --enable-plugin --enable-default-pie
    --with-system-zlib --with-target-system-zlib=auto --enable-multiarch
    --disable-werror --with-arch-32=i686 --with-abi=m64
    --with-multilib-list=m32,m64,mx32 --enable-multilib
    --with-tune=generic --enable-offload-targets=nvptx-none,hsa
    --without-cuda-driver --enable-checking=release
    --build=x86_64-linux-gnu --host=x86_64-linux-gnu
    --target=x86_64-linux-gnu
Thread model: posix
gcc version 9.2.1 20191008 (Ubuntu 9.2.1-9ubuntu2)
```

### Ubuntu 20.04 - OK

```plain
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/9/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:hsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 9.3.0-10ubuntu2'
    --with-bugurl=file:///usr/share/doc/gcc-9/README.Bugs
    --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++,gm2 --prefix=/usr
    --with-gcc-major-version-only --program-suffix=-9 --program-prefix=x86_64-linux-gnu-
    --enable-shared --enable-linker-build-id --libexecdir=/usr/lib
    --without-included-gettext --enable-threads=posix --libdir=/usr/lib
    --enable-nls --enable-clocale=gnu --enable-libstdcxx-debug
    --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new
    --enable-gnu-unique-object --disable-vtable-verify --enable-plugin
    --enable-default-pie --with-system-zlib --with-target-system-zlib=auto
    --enable-objc-gc=auto --enable-multiarch --disable-werror --with-arch-32=i686
    --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic
    --enable-offload-targets=nvptx-none,hsa --without-cuda-driver --enable-checking=release
    --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 9.3.0 (Ubuntu 9.3.0-10ubuntu2)
```
