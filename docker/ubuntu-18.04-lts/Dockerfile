FROM ubuntu:18.04
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

RUN yes | ( dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get upgrade && \
    apt-get dist-upgrade && \
    apt-get clean && \
    apt-get autoclean )

RUN yes | ( apt-get install --no-install-recommends \
        git \
        wget \
        python3 python3-pip \
        libreadline7 libreadline7:i386 \
        libc6-dev libc6-dev-i386 libc6-i386 \
        libgcc1 lib32gcc1 \
        libstdc++-8-dev lib32stdc++-8-dev \
        build-essential gcc-multilib g++-multilib \
        && \
    apt-get clean && \
    apt-get autoclean )

ADD docker /opt/docker

RUN /opt/docker/install-scons.sh

RUN /opt/docker/install-fasm.sh

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
