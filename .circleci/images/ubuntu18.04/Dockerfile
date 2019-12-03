#
# To build this image and run it with a shell, first change into the directory
# where this Dockerfile lives, then:
#
# sudo docker build -t pv-sensei-test .
#
# Or, to choose a different version:
#
# sudo docker build --build-arg PARAVIEW_TAG=master --build-arg SUPERBUILD_TAG=master -t pv-master-sensei-test .
#
# These are the supported build options:
#
#   PARAVIEW_TAG
#
#     "master", "v5.6.0", <branch-name>, etc...
#
#   SUPERBUILD_REPO
#
#     allows cloning from a fork
#
#   SUPERBUILD_TAG
#
#     "master", "v5.6.0", <branch-name>, etc...
#
#   PYTHON_VERSION
#
#     2
#     3
#
#     (default is "2")
#
#   BUILD_TYPE
#
#     "Release", "Debug", "RelWithDebInfo", or a supported option (Default: "Release")
#

FROM ubuntu:18.04

ARG PARAVIEW_TAG=v5.7.0
ARG PARAVIEW_REPO=https://gitlab.kitware.com/paraview/paraview.git
ARG SUPERBUILD_TAG=v5.7.0
ARG SUPERBUILD_REPO=https://gitlab.kitware.com/paraview/paraview-superbuild.git
ARG PYTHON_VERSION=2
ARG BUILD_TYPE=Release

# The following environment variables help with the Python 2 vs 3 option while
# we still support both of them.  In order for this approach to work, we need
# the RUN command to use bash instead of sh for variable indirection.
SHELL ["/bin/bash", "-c"]

ENV SYSTEM_PYTHON_2_PIP pip
ENV SYSTEM_PYTHON_3_PIP pip3
ENV SYSTEM_PYTHON_PIP "SYSTEM_PYTHON_${PYTHON_VERSION}_PIP"

RUN apt-get update && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        bzip2 \
        ca-certificates \
        chrpath \
        curl \
        gfortran \
        git \
        libexpat1-dev \
        libtool \
        openssl \
        pkg-config \
        vim \
        wget \
        zlib1g-dev && \
    if [ "${PYTHON_VERSION}" = "2" ]; then apt-get install -y --no-install-recommends python2.7-dev python-numpy python-pip python-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then apt-get install -y --no-install-recommends python3-dev python3-numpy python3-pip python3-setuptools; fi && \
    if [ "${PYTHON_VERSION}" = "3" ]; then update-alternatives --install /usr/bin/python python /usr/bin/python3 1; fi && \
    rm -rf /var/lib/apt/lists/* && \
    ${!SYSTEM_PYTHON_PIP} install mako

# For consistency, let's use the same mpich we'd pick for running at ANL,
# and build it in the same way.  Hence, we disable the addition of the
# RPATH to compiled executables this allows us to override the MPI
# libraries to use those found via LD_LIBRARY_PATH
ENV MPICH_VERSION 3.3

RUN mkdir /mpich && \
    cd /mpich && \
    wget http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz && \
    tar xf mpich-$MPICH_VERSION.tar.gz --strip-components=1 && \
   ./configure --prefix=/mpich/install --disable-wrapper-rpath && \
   make -j 32 install

# Get CMake
RUN mkdir -p /home/pv-user/cmake/3.13.4 && cd /home/pv-user/cmake/3.13.4 && \
    curl -L https://cmake.org/files/v3.13/cmake-3.13.4-Linux-x86_64.tar.gz | tar --strip-components=1 -xzv

# Clone the superbuild
RUN mkdir -p /home/pv-user/pvsb/build && cd /home/pv-user/pvsb && \
    git clone --recursive ${SUPERBUILD_REPO} src && \
    cd src && git checkout ${SUPERBUILD_TAG} && git submodule update

WORKDIR /home/pv-user/pvsb/build

COPY ./pvsb-options.cmake /home/pv-user/pvsb/pvsb-options.cmake

# Configure
RUN export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/mpich/install/lib && \
    export PATH=${PATH}:/mpich/install/bin && \
    /home/pv-user/cmake/3.13.4/bin/cmake -C /home/pv-user/pvsb/pvsb-options.cmake "-GUnix Makefiles" ../src


# Build
RUN make -j"$(nproc)"

# Install
RUN make -j"$(nproc)" install

WORKDIR /opt/paraview
