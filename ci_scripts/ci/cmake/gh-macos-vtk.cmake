# Client maintainer: scott.wittenburg@kitware.com

set(CTEST_TEST_ARGS PARALLEL_LEVEL 4)

set(dashboard_binary_name "build_make")

set(ENV{CC}  clang)
set(ENV{CXX} clang++)

set(dashboard_cache "
VTK_DIR:PATH=${VTK_DIR}
BUILD_TESTING:BOOL=ON
ENABLE_PYTHON:BOOL=ON
SENSEI_PYTHON_VERSION:STRING=3
TEST_NP:STRING=2
")

set(ENV{MACOSX_DEPLOYMENT_TARGET} "10.14")
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")

macro(dashboard_hook_test)
  message("dashboard_hook_test")
  message("Using sensei build tree dir: $ENV{CI_BIN_DIR}")
  set(ENV{DYLD_LIBRARY_PATH} "$ENV{CI_BIN_DIR}/lib:$ENV{DYLD_LIBRARY_PATH}")
  set(ENV{PYTHONPATH} "$ENV{CI_BIN_DIR}/lib:$ENV{PYTHONPATH}")
  set(ENV{PATH} "$ENV{CI_BIN_DIR}/bin:$ENV{PATH}")
endmacro()

include(${CMAKE_CURRENT_LIST_DIR}/ci-common.cmake)
