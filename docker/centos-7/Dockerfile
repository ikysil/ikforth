FROM centos:7
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
        python2 python2-pip \
        gcc-c++ \
        glibc-devel.i686 libgcc.i686 libstdc++.i686 readline.i686 \
        glibc-devel libgcc libstdc++ readline \
        && \
    yum clean all

RUN pip install --upgrade pip

RUN pip install --prefix=/opt/scons -r /opt/docker/python-requirements.txt

RUN ln -s /opt/scons/bin/scons /usr/local/bin/scons

RUN /opt/docker/install-fasm.sh

ARG RUNUSER=ikforth

ARG RUNUID=1001

RUN useradd ${RUNUSER} --uid ${RUNUID} --user-group

USER ${RUNUSER}

VOLUME ["/opt/ikforth"]

WORKDIR /opt/ikforth

ENTRYPOINT ["/bin/bash"]
