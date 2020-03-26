FROM centos:7
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /tmp

RUN yum -y install \
        epel-release \
        && \
    yum -y install \
        wget \
        gcc-c++ \
        mingw32-gcc mingw32-gcc-c++ \
        scons \
        glibc-devel.i686 libgcc.i686 libstdc++.i686 readline.i686 \
        glibc-devel libgcc libstdc++ readline \
        && \
    yum clean all

RUN ln -s /usr/bin/i686-w64-mingw32-g++ /usr/local/bin/mingw32-g++

RUN wget http://flatassembler.net/fasm-1.73.21.tgz && \
    tar xf fasm-1.73.21.tgz && \
    mv /tmp/fasm /opt/fasm-1.73.21 && \
    ln -s /opt/fasm-1.73.21/fasm /usr/local/bin/fasm

WORKDIR /opt/fasm-1.73.21/tools/libc

RUN fasm listing.asm && \
    gcc -m32 -o ../../listing listing.o && \
    chmod +x ../../listing && \
    ln -s $PWD/../../listing /usr/local/bin/listing

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
