#!/bin/bash --login

export CI_SITE_NAME="GitHub Actions"
if [ "${GITHUB_EVENT_NAME}" = "pull_request" ]
then
  GH_PR_NUMBER=$(expr "${GITHUB_REF}" : 'refs/pull/\([^/]*\)')
  export CI_BUILD_NAME="pr${GH_PR_NUMBER}_${GITHUB_HEAD_REF}_${GH_YML_JOBNAME}"
else
  export CI_BUILD_NAME="${GITHUB_HEAD_REF}_${GH_YML_JOBNAME}"
fi
if [[ "${GH_YML_OS}" =~ "Windows" ]]
then
  export CI_ROOT_DIR="${GITHUB_WORKSPACE//\\//}/.."
  export CI_SOURCE_DIR="${GITHUB_WORKSPACE//\\//}"
else
  export CI_ROOT_DIR="${GITHUB_WORKSPACE}/.."
  export CI_SOURCE_DIR="${GITHUB_WORKSPACE}"
fi
export CI_BIN_DIR="${CI_ROOT_DIR}/${GH_YML_JOBNAME}"

STEP=$1
CTEST_SCRIPT=ci_scripts/ci/cmake/gh-${GH_YML_JOBNAME}.cmake

# Update and Test steps enable an extra step
CTEST_STEP_ARGS=""
case ${STEP} in
  test) CTEST_STEP_ARGS="${CTEST_STEP_ARGS} -Ddashboard_do_end=ON" ;;
esac
CTEST_STEP_ARGS="${CTEST_STEP_ARGS} -Ddashboard_do_${STEP}=ON"

CTEST=$(which ctest)

# OpenMPI on OSX can have issues with over-long paths
#     https://github.com/open-mpi/ompi/issues/5798
#     https://www.open-mpi.org/faq/?category=osx
export TMPDIR=/tmp

# Where did HomeBrew install vtk?
config_full_path=$(find /usr/local/Cellar | grep -i vtkconfig\\.cmake)

if [ -z "${config_full_path}" ]; then
    echo "Unable to find VTKConfig.cmake, please run 'brew install vtk' and try again"
    exit 1
fi

export VTK_DIR=$(dirname "${config_full_path}")
echo "Using VTK_DIR=${VTK_DIR}"

echo "**********CTest Begin**********"
${CTEST} --version
echo ${CTEST} -VV -S ${CTEST_SCRIPT} -Ddashboard_full=OFF ${CTEST_STEP_ARGS}
${CTEST} -VV -S ${CTEST_SCRIPT} -Ddashboard_full=OFF ${CTEST_STEP_ARGS}
RET=$?
echo "**********CTest End************"

exit ${RET}
