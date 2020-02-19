#!/bin/bash

# FIXME: After moving target of PR to kitware/sensei on github, change to:
#     API_BASE="https://api.github.com/repos/kitware/sensei"
API_BASE="https://api.github.com/repos/scottwittenburg/sensei"
PYTHON_EXECUTABLE=python3

# Whether this is a PR from a fork or the main repo, we need to figure out the
# real branch name and pr number.
get_real_branch_name() {
  REALBRANCH="${CIRCLE_BRANCH}"
  if [ -n "${CIRCLE_PR_NUMBER}" ]
  then
    REALPRNUMBER="${CIRCLE_PR_NUMBER}"
    APIURL="${API_BASE}/pulls/${CIRCLE_PR_NUMBER}"
    RESULT="$(curl -s ${APIURL} | ${PYTHON_EXECUTABLE} -c "import sys, json; print(json.load(sys.stdin)['head']['ref'])" 2> /dev/null)"
    if [ $? -eq 0 ]
    then
      REALBRANCH="${RESULT}"
    fi
  else
    REALPRNUMBER="$(${PYTHON_EXECUTABLE} -c "import re; print(re.search('/pull/([\d]+$)', \"${CIRCLE_PULL_REQUEST}\").group(1))")"
  fi
}

check_var() {
  if [ -z "${!1}" ]
  then
    echo "Error: The $1 environment variable is undefined"
    exit 1
  fi
}

check_var CIRCLE_WORKING_DIRECTORY
check_var CIRCLE_BRANCH
check_var CIRCLE_JOB
check_var CIRCLE_BUILD_NUM

if [ ! "${CUSTOM_BUILD_NAME}" ]
then
  get_real_branch_name

  LINETOSAVE="export CUSTOM_BUILD_NAME=pr${REALPRNUMBER}_${REALBRANCH}_${CIRCLE_BUILD_NUM}_${CIRCLE_JOB}"

  # Set the custom build name for this step
  eval $LINETOSAVE

  # Also make sure it will get set for the following steps
  echo "${LINETOSAVE}" >> $BASH_ENV
fi

SOURCE_DIR=${CIRCLE_WORKING_DIRECTORY}/source
CTEST_SCRIPT="${SOURCE_DIR}/ci_scripts/ci/cmake/circle_${CIRCLE_JOB}.cmake"

if [ ! -f "${CTEST_SCRIPT}" ]
then
  echo "Unable to find CTest script $(basename ${CTEST_SCRIPT})"
  exit 2
fi

case "$1" in
  update|configure|build|test)
    STEP=$1
    ;;
  *)
    echo "Usage: $0 (update|configure|build|test)"
    exit 3
    ;;
esac

# Manually source the bash env setup, freeing up $BASH_ENV used by circleci
. /etc/profile >/dev/null

CTEST=ctest

${CTEST} -VV -S ${CTEST_SCRIPT} -Ddashboard_full=OFF -Ddashboard_do_${STEP}=TRUE -DCTEST_BUILD_NAME=${CUSTOM_BUILD_NAME}
