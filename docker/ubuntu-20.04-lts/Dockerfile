FROM ubuntu:20.04
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

ADD docker /opt/docker

RUN dpkg --add-architecture i386 && apt-get update

RUN apt-get -y install --no-install-recommends \
        git \
        wget \
        python3 python3-pip python-is-python3 \
        libreadline8 libreadline8:i386 \
        libc6-dev libc6-dev-i386 \
        libgcc1 \
        libstdc++-9-dev libstdc++-9-dev:i386 \
        linux-libc-dev linux-libc-dev:i386 \
        gcc-multilib g++-multilib \
        build-essential \
        && \
    apt-get clean && \
    apt-get autoclean

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
