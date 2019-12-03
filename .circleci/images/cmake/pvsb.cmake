
# Where should ParaView get installed
set(CMAKE_INSTALL_PREFIX "/opt/paraview" CACHE PATH "")

# Where will superbuild download its source tarballs
set(superbuild_download_location "/home/pv-user/pvsb/downloads" CACHE PATH "")

# How do we get ParaView
message("Using paraview git tag: $ENV{PARAVIEW_TAG}")
set(paraview_FROM_GIT ON CACHE BOOL "")
set(paraview_GIT_TAG $ENV{PARAVIEW_TAG} CACHE STRING "")
set(paraview_SOURCE_SELECTION git CACHE STRING "")

message('Builing with OSMESA rendering')
set(ENABLE_osmesa ON CACHE BOOL "")
set(mesa_USE_SWR ON CACHE BOOL "")


### Extra paraview cmake options we need...
# -DBUILD_PHASTA_ADAPTOR:BOOL=ON \
# -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
# -DCMAKE_INSTALL_PREFIX:PATH=/phasta/ins \
# -DOpenGL_GL_PREFERENCE:STRING=GLVND \
# -DPARAVIEW_BUILD_CATALYST_ADAPTORS:BOOL=ON \
# -DPARAVIEW_BUILD_QT_GUI:BOOL=OFF \
# -DPARAVIEW_ENABLE_CATALYST:BOOL=ON \
# -DPARAVIEW_ENABLE_PYTHON:BOOL=ON \
# -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON \
# -DPARAVIEW_USE_MPI:BOOL=ON \
# -DVTK_OPENGL_HAS_OSMESA:BOOL=ON \
# -DOSMESA_INCLUDE_DIR=/phasta/bld/pv-superbuild/install/include \
# -DOSMESA_LIBRARY=/phasta/bld/pv-superbuild/install/lib/libOSMesa.so \
# -DVTK_DEFAULT_RENDER_WINDOW_HEADLESS:BOOL=ON \
# -DVTK_USE_X:BOOL=OFF \
# -DVTKm_ENABLE_MPI:BOOL=ON \
# ${SINGULARITY_ROOTFS}/phasta/src/paraview

set(PARAVIEW_CMAKE_ARGS "-DBUILD_PHASTA_ADAPTOR:BOOL=ON")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DOpenGL_GL_PREFERENCE:STRING=GLVND")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DPARAVIEW_BUILD_CATALYST_ADAPTORS:BOOL=ON")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DPARAVIEW_ENABLE_CATALYST:BOOL=ON")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON")
set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "-DVTKm_ENABLE_MPI:BOOL=ON")
# set(PARAVIEW_CMAKE_ARGS "${PARAVIEW_CMAKE_ARGS} " "")


set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS "${PARAVIEW_CMAKE_ARGS}" CACHE STRING "")

# General rendering/graphics options
set(ENABLE_mesa OFF CACHE BOOL "")
set(PARAVIEW_DEFAULT_SYSTEM_GL OFF CACHE BOOL "")

# Some general options
set(BUILD_SHARED_LIBS ON CACHE BOOL "")
set(CMAKE_BUILD_TYPE $ENV{BUILD_TYPE} CACHE STRING "")
set(BUILD_TESTING ON CACHE BOOL "")

# ParaView related
set(ENABLE_paraview ON CACHE BOOL "")
set(ENABLE_paraviewweb ON CACHE BOOL "")
set(ENABLE_paraviewgettingstartedguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorial OFF CACHE BOOL "")
set(ENABLE_paraviewusersguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorialdata OFF CACHE BOOL "")

# Python related
set(ENABLE_python ON CACHE BOOL "")

set(ENABLE_python2 OFF CACHE BOOL "")
set(USE_SYSTEM_python2 OFF CACHE BOOL "")
set(ENABLE_python3 ON CACHE BOOL "")
set(USE_SYSTEM_python3 ON CACHE BOOL "")

set(USE_SYSTEM_pythonsetuptools ON CACHE BOOL "")
set(ENABLE_matplotlib ON CACHE BOOL "")
set(ENABLE_scipy ON CACHE BOOL "")

# VTK-m related
set(ENABLE_vtkm ON CACHE BOOL "")
set(vtkm_SOURCE_SELECTION for-git CACHE STRING "")

# Disable Qt5 stuff
set(ENABLE_qt5 OFF CACHE BOOL "")
set(USE_SYSTEM_qt5 OFF CACHE BOOL "")

# Other options
set(ENABLE_ospray ON CACHE BOOL "")
set(ENABLE_netcdf OFF CACHE BOOL "")
set(ENABLE_hdf5 ON CACHE BOOL "")
set(ENABLE_szip ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_ffmpeg ON CACHE BOOL "")
set(ENABLE_vistrails ON CACHE BOOL "")
set(ENABLE_mpi ON CACHE BOOL "")
set(ENABLE_silo ON CACHE BOOL "")
set(ENABLE_xdmf3 ON CACHE BOOL "")
set(ENABLE_h5py ON CACHE BOOL "")
set(ENABLE_numpy ON CACHE BOOL "")
set(ENABLE_cosmotools ON CACHE BOOL "")
set(DIY_SKIP_SVN ON CACHE BOOL "")
set(ENABLE_glu ON CACHE BOOL "")
set(ENABLE_tbb ON CACHE BOOL "")
set(ENABLE_boost ON CACHE BOOL "")
set(ENABLE_vortexfinder2 OFF CACHE BOOL "")
set(USE_NONFREE_COMPONENTS ON CACHE BOOL "")
set(ENABLE_las ON CACHE BOOL "")
set(ENABLE_acusolve ON CACHE BOOL "")
set(ENABLE_fontconfig ON CACHE BOOL "")

# FIXME: We should be able to have these, but they didn't work at some point
set(ENABLE_vrpn OFF CACHE BOOL "")
set(ENABLE_boxlib OFF CACHE BOOL "")

set(CTEST_USE_LAUNCHERS TRUE CACHE BOOL "")
