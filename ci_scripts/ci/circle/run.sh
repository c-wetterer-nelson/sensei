#!/bin/bash

# FIXME: transition
API_BASE="https://api.github.com/repos/scottwittenburg/sensei"
COMMIT=${CIRCLE_SHA1}
CDASH_STATUS_CONTEXT="cdash"
PYTHON_EXECUTABLE=python3

###
### The following methods are used to post a status check into the PR which
### provides a link to a CDash page containing all latest build results for
### the PR (whether on Travis, CircleCI, or GitHub Actions)
###
### build_status_body: generates a link which queries CDash for build results
### based on the commit SHA
###
### check_and_post_status: determines whether the status check has already
### been updated, and if not, makes a POST request to GitHub api to create
### the "CDash" link in the PR status checks.
###

build_status_body() {
  cat <<EOF
{
  "state": "success",
  "target_url": "https://cdash.nersc.gov/index.php?compare1=61&filtercount=1&field1=revision&project=sensei&showfilters=0&limit=100&value1=${COMMIT}&showfeed=0",
  "description": "Build and test results available on CDash",
  "context": "${CDASH_STATUS_CONTEXT}"
}
EOF
}

check_and_post_status() {
  PYTHON_SCRIPT="${SOURCE_DIR}/ci_scripts/ci/circle/findStatus.py"
  curl -u "${STATUS_ROBOT_NAME}:${STATUS_ROBOT_KEY}" "${API_BASE}/commits/${COMMIT}/statuses" | ${PYTHON_EXECUTABLE} ${PYTHON_SCRIPT} --context ${CDASH_STATUS_CONTEXT}
  if [ $? -ne 0 ]
  then
    echo "Need to post a status for context ${CDASH_STATUS_CONTEXT}"
    postBody="$(build_status_body)"
    postUrl="${API_BASE}/statuses/${COMMIT}"
    curl -u "${STATUS_ROBOT_NAME}:${STATUS_ROBOT_KEY}" "${postUrl}" -H "Content-Type: application/json" -H "Accept: application/vnd.github.v3+json" -d "${postBody}"
  fi
}

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
    if [ "$STEP" == "update" ]
    then
      ### The call below (as well as the "build_status_body" and
      ### "check_and_post_status" methods) can be removed once CDash has
      ### released version 3 and NERSC has updated it's CDash instance to that
      ### version.  See the blog post below for information on how to make the
      ### change:
      ###
      ###     https://blog.kitware.com/github-checks-and-statuses-from-cdash
      ###
      check_and_post_status
    fi
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
