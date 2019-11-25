#
# To build this image, change into .circleci/images directory:
#
#     $ cd <sensei-dir>/.circleci/images
#
# Then run the docker build command as follows:
#
#     $ docker build --rm -f ./ubuntu18.04/Dockerfile -t pv-v5.7.0-for-sensei .
#

FROM ubuntu:18.04

# Get ParaView and Sensei dependencies from system packages
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        environment-modules \
        freeglut3-dev \
        git \
        libexpat1-dev \
        libmpich-dev \
        llvm-dev \
        mesa-common-dev \
        mesa-utils \
        meson \
        mpich \
        pkg-config \
        python3-dev \
        python3-pip \
        python3-setuptools \
        swig \
        tcl \
        vim \
        zlib1g-dev && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    pip3 install \
        mako \
        mpi4py \
        numpy

# Copy any modulefiles into place
COPY ./modulefiles/paraview /usr/share/modules/modulefiles/paraview
COPY ./modulefiles/sensei /usr/share/modules/modulefiles/sensei

# Create a non-root user
RUN groupadd sensei && \
    useradd -g sensei -d /home/sensei sensei && \
    mkdir /home/sensei && chown -R sensei:sensei /home/sensei

# Do everything else as the non-priveleged user
USER sensei

# Get OSMesa and build it, since we need newer than system provides
RUN mkdir -p /home/sensei/sensei_insitu/software/mesa/builds && \
    cd /home/sensei/sensei_insitu/software/mesa/builds && \
    curl -OL https://www.paraview.org/files/dependencies/mesa-18.2.2.tar.xz && \
    tar -xvf mesa-18.2.2.tar.xz && \
    cd mesa-18.2.2 && \
    ./configure --prefix=/home/sensei/sensei_insitu/software/mesa/18.2.2 \
        --disable-osmesa \
        --enable-gallium-osmesa \
        --disable-glx \
        --with-platforms= \
        --with-swr-archs=avx,avx2 \
        --enable-opengl \
        --disable-gles1 \
        --disable-gles2 \
        --disable-va \
        --disable-gbm \
        --disable-xvmc \
        --disable-vdpau \
        --disable-shared-glapi \
        --disable-dri \
        --with-dri-drivers= \
        --enable-llvm \
        --with-gallium-drivers=swrast \
        --disable-egl \
        --disable-gbm \
        --enable-shared \
        --disable-static && \
    make -j${nproc} install

# Clone, configure, and build ParaView
RUN mkdir -p /home/sensei/sensei_insitu/software/paraview/builds/for_sensei_ci && \
    cd /home/sensei/sensei_insitu/software/paraview && \
    git clone --recursive https://gitlab.kitware.com/paraview/paraview.git src && \
    cd src && \
    git checkout v5.7.0 && git submodule update --recursive --init && \
    cd ../builds/for_sensei_ci && \
    cmake -G"Unix Makefiles" \
        -DCMAKE_INSTALL_PREFIX:PATH=/home/sensei/sensei_insitu/software/paraview/5.7.0 \
        -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON \
        -DPARAVIEW_BUILD_QT_GUI:BOOL=OFF \
        -DPARAVIEW_ENABLE_CATALYST:BOOL=ON \
        -DPARAVIEW_ENABLE_PYTHON:BOOL=ON \
        -DPARAVIEW_USE_MPI:BOOL=ON \
        -DVTK_OPENGL_HAS_OSMESA:BOOL=ON \
        -DOSMESA_INCLUDE_DIR:PATH=/home/sensei/sensei_insitu/software/mesa/18.2.2/include \
        -DOSMESA_LIBRARY:FILEPATH=/home/sensei/sensei_insitu/software/mesa/18.2.2/lib/libOSMesa.so \
        -DVTK_DEFAULT_RENDER_WINDOW_HEADLESS:BOOL=ON \
        -DVTK_USE_X:BOOL=OFF \
        -DVTKm_ENABLE_MPI:BOOL=ON \
        ../../src && \
    make -j$(nproc) && \
    make install && \
    ls /home/sensei/sensei_insitu/software/paraview/builds/for_sensei_ci/ | grep -v CMakeCache.txt | xargs rm -rf
