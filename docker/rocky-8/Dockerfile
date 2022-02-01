FROM rockylinux:8
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=C.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=C.UTF-8

RUN dnf -y install \
        epel-release \
        && \
    dnf -y install \
        git \
        wget \
        gcc-c++ \
        glibc-devel.i686 libgcc.i686 libstdc++.i686 readline.i686 \
        glibc-devel libgcc libstdc++ readline \
        python3 python3-pip \
        && \
    dnf clean all

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
