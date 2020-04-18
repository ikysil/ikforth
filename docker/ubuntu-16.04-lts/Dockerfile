FROM ubuntu:16.04
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

WORKDIR /tmp

RUN dpkg --add-architecture i386 && apt-get update

RUN apt-get -y install --no-install-recommends \
        wget \
        scons \
        libreadline6 libreadline6:i386 \
        libc6-dev libc6-dev:i386 \
        libgcc1 libgcc1:i386 \
        libstdc++-5-dev libstdc++-5-dev:i386 \
        build-essential gcc-multilib g++-multilib \
        && \
    apt-get clean && \
    apt-get autoclean

ADD docker /opt/docker

RUN /opt/docker/install-fasm.sh

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
