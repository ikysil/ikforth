FROM centos:8
LABEL maintainer="Illya Kysil <ikysil@ikysil.name>"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ADD docker /opt/docker

RUN yum -y install \
        epel-release \
        && \
    yum -y install \
        git \
        wget \
        gcc-c++ \
        glibc-devel.i686 libgcc.i686 libstdc++.i686 readline.i686 \
        glibc-devel libgcc libstdc++ readline \
        python3 \
        && \
    yum clean all

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install scons==3.1.2

RUN /opt/docker/install-fasm.sh

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
