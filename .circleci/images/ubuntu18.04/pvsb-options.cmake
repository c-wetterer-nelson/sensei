
# Where should ParaView get installed
set(CMAKE_INSTALL_PREFIX "/opt/paraview" CACHE PATH "")

# Where will superbuild download its source tarballs
set(superbuild_download_location "/home/pv-user/pvsb/downloads" CACHE PATH "")

# How do we get ParaView
message("Using paraview git tag: $ENV{PARAVIEW_TAG}")
set(paraview_FROM_GIT ON CACHE BOOL "")
set(paraview_GIT_TAG $ENV{PARAVIEW_TAG} CACHE STRING "")
set(paraview_SOURCE_SELECTION git CACHE STRING "")
set(paraview_GIT_REPOSITORY $ENV{PARAVIEW_REPO} CACHE STRING "")

message('Builing with OSMESA rendering')
set(ENABLE_osmesa ON CACHE BOOL "")
set(mesa_USE_SWR ON CACHE BOOL "")

# General rendering/graphics options
set(ENABLE_mesa OFF CACHE BOOL "")
set(PARAVIEW_DEFAULT_SYSTEM_GL OFF CACHE BOOL "")

# Some general options
set(BUILD_SHARED_LIBS ON CACHE BOOL "")
set(CMAKE_BUILD_TYPE $ENV{BUILD_TYPE} CACHE STRING "")
set(BUILD_TESTING OFF CACHE BOOL "")

# ParaView related
set(ENABLE_paraview ON CACHE BOOL "")
set(ENABLE_paraviewgettingstartedguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorial OFF CACHE BOOL "")
set(ENABLE_paraviewusersguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorialdata OFF CACHE BOOL "")

set(extra_pv_opts "")
set(extra_pv_opts "${extra_pv_opts} -DOpenGL_GL_PREFERENCE:STRING=GLVND")
set(extra_pv_opts "${extra_pv_opts} -DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo")
set(extra_pv_opts "${extra_pv_opts} -DPARAVIEW_ENABLE_CATALYST:BOOL=ON")
# set(extra_pv_opts "${extra_pv_opts} -DVTK_OPENGL_HAS_OSMESA:BOOL=ON")
# set(extra_pv_opts "${extra_pv_opts} -DVTK_DEFAULT_RENDER_WINDOW_HEADLESS:BOOL=ON")
set(extra_pv_opts "${extra_pv_opts} -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=ON")
set(extra_pv_opts "${extra_pv_opts} -DVTKm_ENABLE_MPI:BOOL=ON")
set(extra_pv_opts "${extra_pv_opts} -DPARAVIEW_BUILD_QT_GUI:BOOL=OFF")
# set(extra_pv_opts "${extra_pv_opts} -DPARAVIEW_BUILD_QT_GUI:BOOL=OFF")
set(extra_pv_opts "${extra_pv_opts} -D-DVTKm_ENABLE_MPI:BOOL=ON")
# set(extra_pv_opts "${extra_pv_opts} -D")
set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS "-D${extra_pv_opts}" CACHE STRING "")

# Python related
set(ENABLE_python ON CACHE BOOL "")
if("$ENV{PYTHON_VERSION}" STREQUAL "2")
  set(ENABLE_python2 ON CACHE BOOL "")
  set(USE_SYSTEM_python2 ON CACHE BOOL "")
  set(ENABLE_python3 OFF CACHE BOOL "")
  set(USE_SYSTEM_python3 OFF CACHE BOOL "")
else()
  set(ENABLE_python2 OFF CACHE BOOL "")
  set(USE_SYSTEM_python2 OFF CACHE BOOL "")
  set(ENABLE_python3 ON CACHE BOOL "")
  set(USE_SYSTEM_python3 ON CACHE BOOL "")
endif()
set(USE_SYSTEM_pythonsetuptools ON CACHE BOOL "")
set(ENABLE_matplotlib ON CACHE BOOL "")
set(ENABLE_scipy ON CACHE BOOL "")

# VTK-m related
set(ENABLE_vtkm ON CACHE BOOL "")
set(vtkm_SOURCE_SELECTION for-git CACHE STRING "")

# Other options
set(ENABLE_fortran ON CACHE BOOL "")
set(ENABLE_llvm ON CACHE BOOL "")

set(ENABLE_mpi ON CACHE BOOL "")
set(USE_SYSTEM_mpi ON CACHE BOOL "")
# set(CMAKE_CXX_COMPILER:PATH=/mpich/install/bin/mpicxx)
# set(CMAKE_C_COMPILER:PATH=/mpich/install/bin/mpicc)
# set(CMAKE_FORTRAN_COMPILER:PATH=/mpich/install/bin/mpifort)

set(USE_SYSTEM_zlib ON CACHE BOOL "")

# Disable things that will get in the way
set(ENABLE_vrpn OFF CACHE BOOL "")
set(ENABLE_boxlib OFF CACHE BOOL "")
set(ENABLE_vortexfinder2 OFF CACHE BOOL "")
set(ENABLE_ospray OFF CACHE BOOL "")
set(ENABLE_qt5 OFF CACHE BOOL "")
set(USE_SYSTEM_qt5 OFF CACHE BOOL "")

# set(CTEST_USE_LAUNCHERS TRUE CACHE BOOL "")
