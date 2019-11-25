# Client maintainer: scott.wittenburg@kitware.com

set(CTEST_SITE "CircleCI")
set(CTEST_BUILD_CONFIGURATION Debug)
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_BUILD_FLAGS "-k -j4")
set(CTEST_TEST_ARGS PARALLEL_LEVEL 4)

set(dashboard_model Continuous)
set(dashboard_binary_name "build_$ENV{CIRCLE_JOB}")
set(dashboard_track "Experimental")

set(CTEST_GIT_COMMAND "/usr/bin/git")
set(CTEST_UPDATE_VERSION_ONLY TRUE)
set(CTEST_SOURCE_DIRECTORY "$ENV{CIRCLE_WORKING_DIRECTORY}/source")
set(CTEST_DASHBOARD_ROOT "$ENV{CIRCLE_WORKING_DIRECTORY}")

set(ENV{CC}  gcc)
set(ENV{CXX} g++)
set(ENV{CFLAGS} -fPIC -Wall -Wextra -O3 -march=x86-64 -mtune=generic)
set(ENV{CXXFLAGS} -fPIC -std=c++11 -Wall -Wextra -O3 -march=x86-64 -mtune=generic)

set(PARAVIEW_ROOT_DIR "/home/sensei/sensei_insitu/software/paraview/5.7.0")
set(SENSEI_BUILD_DIR "$ENV{CIRCLE_WORKING_DIRECTORY}/build_$ENV{CIRCLE_JOB}")

set(dashboard_cache "
BUILD_TESTING:BOOL=ON
ENABLE_PYTHON=ON
SENSEI_PYTHON_VERSION=3
ENABLE_CATALYST=ON
ENABLE_CATALYST_PYTHON=ON
ParaView_DIR=${PARAVIEW_ROOT_DIR}/lib/cmake/paraview-5.7
ENABLE_VTK_IO=ON
ENABLE_VTK_MPI=ON
CMAKE_INSTALL_PREFIX=/home/sensei/sensei_insitu/software/sensei/3.0.0-catalyst-shared-ci
PYTHON_EXECUTABLE=/usr/bin/python
OSMESA_INCLUDE_DIR:PATH=/home/sensei/sensei_insitu/software/mesa/18.2.2/include
OSMESA_LIBRARY:FILEPATH=/home/sensei/sensei_insitu/software/mesa/18.2.2/lib/libOSMesa.so
")

macro(dashboard_hook_test)
  message("dashboard_hook_test (pre): PATH=$ENV{PATH}, PYTHONPATH=$ENV{PYTHONPATH}, LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}")
  set(ENV{LD_LIBRARY_PATH} "${PARAVIEW_ROOT_DIR}/lib:${SENSEI_BUILD_DIR}/lib:$ENV{LD_LIBRARY_PATH}")
  set(ENV{PYTHONPATH} "${PARAVIEW_ROOT_DIR}/lib/python3.6:${PARAVIEW_ROOT_DIR}/lib/python3.6/site-packages:${SENSEI_BUILD_DIR}/lib:$ENV{PYTHONPATH}")
  set(ENV{PATH} "${PARAVIEW_ROOT_DIR}/bin:${SENSEI_BUILD_DIR}/bin:$ENV{PATH}")
  message("dashboard_hook_test (post): PATH=$ENV{PATH}, PYTHONPATH=$ENV{PYTHONPATH}, LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}")
endmacro()

include(${CMAKE_CURRENT_LIST_DIR}/ci-common.cmake)
