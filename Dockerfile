FROM centos:7
MAINTAINER Illya Kysil <ikysil@ikysil.name>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /tmp

RUN yum -y install epel-release wget

RUN yum -y install gcc-c++

RUN yum -y install mingw32-gcc mingw32-gcc-c++

RUN yum -y install scons

RUN wget http://flatassembler.net/fasm-1.71.54.tgz && \
    tar xf fasm-1.71.54.tgz && \
    mv /tmp/fasm /opt/fasm-1.71.54 && \
    ln -s /opt/fasm-1.71.54/fasm /usr/local/bin/fasm

RUN yum -y install glibc-devel.i686 libgcc.i686 libstdc++.i686 readline.i686

WORKDIR /opt/fasm-1.71.54/tools/libc

RUN fasm listing.asm && \
    gcc -m32 -o ../../listing listing.o && \
    chmod +x ../../listing && \
    ln -s $PWD/../../listing /usr/local/bin/listing

RUN ln -s /usr/bin/i686-w64-mingw32-g++ /usr/local/bin/mingw32-g++

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
