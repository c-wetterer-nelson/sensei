###
### To build this image, change into the .circleci/images directory and run:
###
###     $ docker build --file ./centos7/Dockerfile -t sensei-builder .
###

ARG BASE_IMAGE=centos:7
FROM ${BASE_IMAGE}
MAINTAINER Scott Wittenburg <scott.wittenburg@kitware.com>

ARG PARAVIEW_TAG=v5.7.0
ARG SUPERBUILD_TAG=v5.7.0
ARG SUPERBUILD_REPO=https://gitlab.kitware.com/paraview/paraview-superbuild.git

# Install some tools and libraries
RUN yum -y update && yum install -y \
        autoconf \
        automake \
        bzip2 \
        ca-certificates \
        chrpath \
        curl \
        file \
        gcc \
        gcc-c++ \
        gcc-gfortran \
        git \
        gzip \
        libomp-dev \
        libtbb-dev \
        libtool \
        openssh-client \
        openssh-server \
        openssl \
        pkg-config \
        python3-devel \
        python3-pip \
        python3-setuptools \
        scons \
        tar \
        vim \
        wget \
        xz && \
    yum clean all && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    pip3 install mako

# Get CMake
RUN mkdir -p /home/pv-user/cmake/3.13.4 && cd /home/pv-user/cmake/3.13.4 && \
    curl -L https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz | tar --strip-components=1 -xzv

RUN mkdir -p /home/pv-user/pvsb/build

COPY ./cmake/pvsb.cmake /home/pv-user/pvsb/pvsb.cmake

# Clone the superbuild
RUN mkdir -p /home/pv-user/pvsb/build && cd /home/pv-user/pvsb && \
    git clone --recursive ${SUPERBUILD_REPO} src && \
    cd src && git checkout ${SUPERBUILD_TAG} && git submodule update

WORKDIR /home/pv-user/pvsb/build

# Configure
RUN /home/pv-user/cmake/3.13.4/bin/cmake -C /home/pv-user/pvsb/pvsb.cmake "-GUnix Makefiles" ../src

# Build
RUN make -j"$(nproc)"

# Install
RUN make -j"$(nproc)" install

WORKDIR /opt/paraview
