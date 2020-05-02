FROM ubuntu:18.04
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ADD docker /opt/docker

RUN dpkg --add-architecture i386 && apt-get update

RUN apt-get -y install --no-install-recommends \
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
    apt-get autoclean

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install --prefix=/opt/scons -r /opt/docker/python-requirements.txt

RUN ln -s /opt/scons/bin/scons /usr/local/bin/scons

RUN /opt/docker/install-fasm.sh

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
