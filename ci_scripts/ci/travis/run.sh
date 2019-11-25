#!/usr/bin/env bash

export CI_SITE_NAME="Travis"
export TRAVIS_JOBNAME="macos-vtk"
export CI_SOURCE_DIR=${TRAVIS_BUILD_DIR}
export CI_ROOT_DIR="${CI_SOURCE_DIR}/.."
export CI_BIN_DIR="${CI_ROOT_DIR}/${TRAVIS_JOBNAME}"
# export COMMIT_RANGE="${TRAVIS_COMMIT_RANGE/.../ }"

if [ -n "${TRAVIS_PULL_REQUEST_BRANCH}" ]
then
  export CI_BUILD_NAME="pr${TRAVIS_PULL_REQUEST}_${TRAVIS_PULL_REQUEST_BRANCH}_${TRAVIS_BUILD_NUMBER}_${TRAVIS_JOBNAME}"
else
  export CI_BUILD_NAME="${TRAVIS_BRANCH}_${TRAVIS_BUILD_NUMBER}_${TRAVIS_JOBNAME}"
fi

CTEST_SCRIPT=ci_scripts/ci/cmake/travis-macos-vtk.cmake

CTEST=$(which ctest)

# Where did HomeBrew install vtk?
config_full_path=$(find /usr/local/Cellar | grep -i vtkconfig\\.cmake)

if [ -z "${config_full_path}" ]; then
    echo "Unable to find VTKConfig.cmake, please run 'brew install vtk' and try again"
    exit 1
fi

export VTK_DIR=$(dirname "${config_full_path}")
echo "Using VTK_DIR=${VTK_DIR}"

export TMPDIR=/tmp

echo "**********CTest Begin**********"
${CTEST} --version

# Define dashboard steps
declare -a steps=("update" "configure" "build" "test")

# Loop through steps
for step in "${steps[@]}"
do
    CTEST_STEP_ARGS=""
    case ${step} in
      test) CTEST_STEP_ARGS="${CTEST_STEP_ARGS} -Ddashboard_do_end=ON" ;;
    esac
    CTEST_STEP_ARGS="${CTEST_STEP_ARGS} -Ddashboard_do_${step}=ON"
    echo ${CTEST} -VV -S ${CTEST_SCRIPT} -Ddashboard_full=OFF ${CTEST_STEP_ARGS}
    ${CTEST} -VV -S ${CTEST_SCRIPT} -Ddashboard_full=OFF ${CTEST_STEP_ARGS}
    RET=$?
    if [ "$RET" -ne 0 ];then
        echo "Dashboard step ${step} failed"
        exit ${RET}
    fi
done

echo "**********CTest End************"

exit 0
